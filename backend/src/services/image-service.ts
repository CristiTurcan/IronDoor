import Enrollment from '../database/enrollment';
import Recognition from '../database/recognition';

class ImageService {
  async saveEnrollment(name: string, images: Buffer[]): Promise<void> {
    const imageBase64Array = images.map(image => image.toString('base64'));
    for (const imageBase64 of imageBase64Array) {
      await Enrollment.query().insert({ name, imageBase64 });
    }
  }

  async saveRecognition(image: Buffer): Promise<void> {
    const imageBase64 = image.toString('base64');
    await Recognition.query().insert({ imageBase64 });
  }
}

export default new ImageService();
