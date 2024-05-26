#include <Arduino.h>
#include <ArduinoJson.h>
#include <ESPAsyncWebServer.h>
#include <HTTPClient.h>
#include <SPIFFS.h>
#include <WiFi.h>
#include <Wire.h>
#include <base64.h>
#include <esp_camera.h>
#include <esp_task_wdt.h>
#include <soc/rtc_cntl_reg.h>  // Disable brownout problems
#include <soc/soc.h>           // Disable brownout problems

#include "camera.h"

#define SERVER_ADDRESS "http://172.20.10.3:3001"

/*
ESP32CAM BOARD, AI THINKER
*/

void IRAM_ATTR handleInterrupt();
void handleButtonPress();
void createNotification(String title, String message);
String captureImageBase64();

volatile bool buttonPressed = false;

// GPIO
#define LED_BUILTIN 33  // it's on the back of the board, next to RST
#define FLASHLIGHT 4    // used for camera, works weird when using SD card(lights up on transfers)
#define SOLENOID 2     // used to trigger the solenoid, unlocking the door
#define BUTTON 13       // used to trigger face recognition

// SERVER
AsyncWebServer server(80);

// Software Serial
#define RXD2 14
#define TXD2 15

void IRAM_ATTR handleInterrupt() { buttonPressed = true; }

void handleButtonPress() {
  String imageBase64 = captureImageBase64();
  if (imageBase64 == "") {
    Serial.println("Failed to capture image");
    return;
  }

  // Prepare JSON payload
  String jsonPayload = "{\"imageBase64\":\"" + imageBase64 + "\"}";

  // Send HTTP POST request
  HTTPClient http;
  http.begin(SERVER_ADDRESS "/face/recognize");
  Serial.println("Sending POST request to " + String(SERVER_ADDRESS "/face/recognize"));
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.POST(jsonPayload);
  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("HTTP Response code: " + String(httpResponseCode));
    Serial.println("Response: " + response);

    // Parse the JSON response
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, response);
    bool authorized = doc["authorized"];
    if (authorized) {
      digitalWrite(SOLENOID, HIGH);
      delay(2500);
      digitalWrite(SOLENOID, LOW);
    }
  } else {
    Serial.println("Error on sending POST: " + String(httpResponseCode));
  }
  http.end();
}

void setupPinModes() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(FLASHLIGHT, OUTPUT);
  pinMode(SOLENOID, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BUTTON), handleInterrupt, FALLING);
}

void setupSPIFFS() {
  if (!SPIFFS.begin(true)) {
    Serial.println("An Error has occurred while mounting SPIFFS");
    ESP.restart();
  } else {
    delay(500);
    Serial.println("SPIFFS mounted successfully");
  }
}

void startWifiConnection() {
  WiFi.begin("faur", "kakamaka");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
}

void startWifiAP() {
  WiFi.softAP("bomboclat", "123456789");
  Serial.println("Access Point mode enabled");
  Serial.println("IP address: " + WiFi.softAPIP().toString());
}

// misc functions
void checkForPSRAM() {
  if (!psramFound()) {
    Serial.println("\r\nFatal Error; Halting");
    while (true) {
      Serial.println(
          "No PSRAM found; camera cannot be initialised: Please check the "
          "board config for your module.");
      delay(5000);
    }
  }
}

void startApiServer() {
  // ---------------------------------------------------------------------------
  // config endpoint to test connection
  server.on("/blinker", HTTP_POST, [](AsyncWebServerRequest *request) {
    for (int i = 0; i < 10; i++) {
      digitalWrite(FLASHLIGHT, HIGH);
      delay(200);
      digitalWrite(FLASHLIGHT, LOW);
      delay(200);
    }
    request->send(200, "text/plain", "wassup gangsta");
  });

  // ---------------------------------------------------------------------------
  // config endpoint to take picture and send it
  server.on("/take-picture", HTTP_GET, [](AsyncWebServerRequest *request) {
    Serial.println("Taking picture...");
    digitalWrite(FLASHLIGHT, HIGH);
    camera_fb_t *fb = NULL;

    // take the picture
    fb = NULL;
    fb = esp_camera_fb_get();
    Serial.println("Picture taken");
    if (!fb) {
      request->send(500, "text/plain", "Camera capture failed");
      return;
    }

    Serial.println("Sending picture... Size is " + String(fb->len) + " bytes");
    request->send_P(200, "image/jpeg", fb->buf, fb->len);
    Serial.println("Picture sent");
    esp_camera_fb_return(fb);
    digitalWrite(FLASHLIGHT, LOW);
    Serial.println("Picture buffer returned");
  });

  // ---------------------------------------------------------------------------
  // config endpoint to unlock the door
  server.on("/unlock", HTTP_POST, [](AsyncWebServerRequest *request) {
    digitalWrite(SOLENOID, HIGH);
    delay(2500);
    digitalWrite(SOLENOID, LOW);
    request->send(200, "text/plain", "Door unlocked");
  });

  // ---------------------------------------------------------------------------
  // Start the server
  server.begin();
}

String captureImageBase64() {
  camera_fb_t *fb = esp_camera_fb_get();
  if (!fb) {
    Serial.println("Camera capture failed");
    return "";
  }

  String imageBase64 = base64::encode(fb->buf, fb->len);
  esp_camera_fb_return(fb);
  return imageBase64;
}

void createNotification(String title, String message) {
  String imageBase64 = captureImageBase64();
  if (imageBase64 == "") {
    Serial.println("Failed to capture image for notification");
    return;
  }

  //we must add "data:image/jpeg;base64," to the beginning of the imageBase64 string
  imageBase64 = "data:image/jpeg;base64," + imageBase64;


  // Prepare JSON payload
  DynamicJsonDocument doc(1024);
  doc["name"] = title;
  doc["message"] = message;
  doc["hasImage"] = true;
  doc["imageBase64"] = imageBase64;

  String jsonPayload;
  serializeJson(doc, jsonPayload);

  // Send HTTP POST request
  HTTPClient http;
  http.begin(SERVER_ADDRESS "/notifications");
  Serial.println("Sending POST request to " + String(SERVER_ADDRESS "/notifications"));
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.POST(jsonPayload);
  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("HTTP Response code: " + String(httpResponseCode));
    // Serial.println("Response: " + response);
  } else {
    Serial.println("Error on sending POST: " + String(httpResponseCode));
  }
  http.end();
}

void handleSerialData() {
  if (Serial2.available() > 0) {
    String message = Serial2.readStringUntil('\n');
    message.trim();
    if (message == "pirDetected") {
      Serial.println("PIR sensor triggered");
      createNotification("Sensor PIR", "PIR sensor triggered at time " + String(millis()));
    } else if (message == "fingerprintMatched") {
      // noInterrupts();
      Serial.println("Fingerprint matched");
      digitalWrite(SOLENOID, HIGH);
      delay(2500);
      digitalWrite(SOLENOID, LOW);
      // interrupts();
      // createNotification("Sensor Fingerprint", "Fingerprint matched at time " + String(millis()));
    } else if (message == "reedSwitchFrame") {
      Serial.println("Reed switch frame triggered");
      createNotification("Sensor Reed Frame", "Reed switch frame triggered at time " + String(millis()));
    } else if (message == "reedSwitchHandle") {
      Serial.println("Reed switch handle triggered");
      createNotification("Sensor Reed Handle", "Reed switch handle triggered at time " + String(millis()));
    } else if (message == "fingerprintWrong") {
      Serial.println("Fingerprint not matched");
      createNotification("Sensor Fingerprint", "Fingerprint not matched at time " + String(millis()));
    } else {
      Serial.println("Unknown message: " + message);
    }
  }
}

// ---------------------------------------------------------------------------
void setup() {
  Serial.begin(115200);
  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);

  setupPinModes();

  Serial.println("Initializing board...");

  // setup SPIFFS
  setupSPIFFS();

  checkForPSRAM();  // warn if PSRAM disabled(aka some config error) because
                    // camera performance is bad without it

  // start camera
  Serial.println("Starting camera...");
  StartCamera();

  // setup wifi
  Serial.println("Setting up wifi...");
  // only keep one of these enabled
  // AP is recommended when router is far away and you want to test, but lacks
  // internet access Internal antenna is not that good, hence the tinfoil hat ;)
  // startWifiAP();
  startWifiConnection();
  WiFi.setSleep(false);  // disable wifi sleep mode to improve performance
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: " + WiFi.localIP().toString());

  Serial.println("Starting API server...");
  startApiServer();
  Serial.println("API Server startup complete");
}

// ---------------------------------------------------------------------------
void loop() {
  if (buttonPressed) {
    buttonPressed = false;
    handleButtonPress();
  }
  handleSerialData();
}
