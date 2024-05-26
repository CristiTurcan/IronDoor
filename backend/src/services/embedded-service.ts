import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

const ESP32_IP = process.env.ESP32_IP;
const ESP32_UNLOCK_URL = `http://${ESP32_IP}/unlock`;

class EmbeddedService {
  async unlock(): Promise<void> {
    try {
      await axios.post(ESP32_UNLOCK_URL);
      console.log('Unlock command sent to ESP32');
    } catch (error) {
      console.error('Error sending unlock command to ESP32:', error);
      throw new Error('Error communicating with ESP32');
    }
  }
}

export default new EmbeddedService();
