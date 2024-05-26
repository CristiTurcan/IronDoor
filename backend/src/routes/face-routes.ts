import { Router } from 'express';
import faceController from '../controllers/face-controller';

const router = Router();

router.post('/enroll', faceController.enrollUser);
router.post('/recognize', faceController.recognizeUser);

export default router;
