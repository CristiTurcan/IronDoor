import { Request, Response } from 'express';
import embeddedService from '../services/embedded-service';

class EmbeddedController {
  async unlock(req: Request, res: Response) {
    try {
      await embeddedService.unlock();
      res.status(200).json({ message: 'Unlock command sent to ESP32' });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}

export default new EmbeddedController();
