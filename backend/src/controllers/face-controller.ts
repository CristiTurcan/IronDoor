import { Request, Response } from 'express';
import faceService from '../services/face-service';
import imageService from '../services/image-service';
import { Buffer } from 'buffer';

class FaceController {
  async enrollUser(req: Request, res: Response) {
    console.log("enrollUser");
      try {
          //print the whole request body
        console.log(req.body)
        console.log('trying to save enrollment for user' + req.body.name)
        const { name } = req.body;
        const images: Buffer[] = req.body.images.map((imgBase64: string) => Buffer.from(imgBase64.split(',')[1], 'base64'));
        console.log('trying to save enrollment for user:' + 'with' + images.length + 'images')
      await imageService.saveEnrollment(name, images); // Save images to DB
      await faceService.enrollUser(name, images);
      res.status(200).json({ message: 'User enrolled successfully' });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async recognizeUser(req: Request, res: Response) {
    console.log("recognizeUser");
      try {
          console.log('request received: ' + req.body.imageBase64)
      const { imageBase64 } = req.body;
          //   const imageBuffer = Buffer.from(imageBase64.split(',')[1], 'base64');
            const imageBuffer = Buffer.from(imageBase64, 'base64');
      await imageService.saveRecognition(imageBuffer); // Save image to DB
      const result = await faceService.recognizeUser(imageBuffer);
      res.status(200).json(result);
      } catch (error: any) {
          console.log('error: ' + error)
      res.status(500).json({ error: error.message });
    }
  }
}

export default new FaceController();
