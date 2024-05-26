#include <Arduino.h>
#include <SoftwareSerial.h>
#include <Adafruit_Fingerprint.h>

#define PIR_SENSOR_PIN 4
#define REED_SWITCH_1_PIN 5 // handle
#define REED_SWITCH_2_PIN 6 // frame

SoftwareSerial mySerial(10, 11); // RX, TX for communication with ESP32
SoftwareSerial fingerSerial(2, 3); // RX, TX for fingerprint sensor

Adafruit_Fingerprint finger = Adafruit_Fingerprint(&fingerSerial);

bool pirState = LOW;
bool reedSwitch1State = HIGH;
bool reedSwitch2State = HIGH;

uint8_t getFingerprintID();

void setup() {
  Serial.begin(115200); // For debugging
  mySerial.begin(9600);
  fingerSerial.begin(57600);

  pinMode(PIR_SENSOR_PIN, INPUT);
  pinMode(REED_SWITCH_1_PIN, INPUT_PULLUP);
  pinMode(REED_SWITCH_2_PIN, INPUT_PULLUP);

  // Initialize the fingerprint sensor
  while (!Serial);  // For Yun/Leo/Micro/Zero/...
  delay(100);
  Serial.println("\n\nAdafruit finger detect test");

  finger.begin(57600);
  delay(5);
  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
  }

  Serial.println(F("Reading sensor parameters"));
  finger.getParameters();
  Serial.print(F("Status: 0x")); Serial.println(finger.status_reg, HEX);
  Serial.print(F("Sys ID: 0x")); Serial.println(finger.system_id, HEX);
  Serial.print(F("Capacity: ")); Serial.println(finger.capacity);
  Serial.print(F("Security level: ")); Serial.println(finger.security_level);
  Serial.print(F("Device address: ")); Serial.println(finger.device_addr, HEX);
  Serial.print(F("Packet len: ")); Serial.println(finger.packet_len);
  Serial.print(F("Baud rate: ")); Serial.println(finger.baud_rate);

  finger.getTemplateCount();

  if (finger.templateCount == 0) {
    Serial.print("Sensor doesn't contain any fingerprint data. Please run the 'enroll' example.");
  } else {
    Serial.println("Waiting for valid finger...");
    Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  }

  // Sending mock data to the ESP32
  mySerial.println("Nano-ESP32 serial comm test 1");
  delay(1000);
  mySerial.println("Nano-ESP32 serial comm test 2");
  delay(1000);
  mySerial.println("Nano-ESP32 serial comm test 3");
  delay(1000);
  mySerial.println("Nano-ESP32 serial comm test 4");
}

void loop() {
  // Read PIR sensor every 7.5 seconds
  static unsigned long lastPIRReadTime = 0;
  unsigned long currentMillis = millis();
  if (currentMillis - lastPIRReadTime >= 7500) {
    lastPIRReadTime = currentMillis;
    bool pirCurrentState = digitalRead(PIR_SENSOR_PIN);
    if (pirCurrentState != pirState) {
      pirState = pirCurrentState;
      if (pirState == HIGH) {
        // In testing env, this gets triggered constantly
        // So we'll just print a message instead of sending it to the ESP32
        //mySerial.println("pirDetected"); 
        Serial.println("PIR sensor triggered");
      }
    }
  }

  // Read Reed Switch 1
  bool reedSwitch1CurrentState = digitalRead(REED_SWITCH_1_PIN);
  if (reedSwitch1CurrentState != reedSwitch1State) {
    reedSwitch1State = reedSwitch1CurrentState;
    if (reedSwitch1State == LOW) { // Reed switch is triggered when the state is LOW
      mySerial.println("reedSwitchHandle");
      Serial.println("Reed switch handle triggered");
    }
  }

  // Read Reed Switch 2
  bool reedSwitch2CurrentState = digitalRead(REED_SWITCH_2_PIN);
  if (reedSwitch2CurrentState != reedSwitch2State) {
    reedSwitch2State = reedSwitch2CurrentState;
    if (reedSwitch2State == LOW) { // Reed switch is triggered when the state is LOW
      mySerial.println("reedSwitchFrame");
      Serial.println("Reed switch frame triggered");
    }
  }

  // Check the fingerprint sensor
  getFingerprintID();
  delay(50);  //don't need to run this at full speed.
}

uint8_t getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK success!
  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");
    mySerial.println("fingerprintMatched");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");
    mySerial.println("fingerprintWrong");
  } else {
    Serial.println("Unknown error");
  }

  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID);
  Serial.print(" with confidence of "); Serial.println(finger.confidence);

  return finger.fingerID;
}
