import { Router } from 'express';
import embeddedController from '../controllers/embedded-controller';

const router = Router();

router.post('/unlock', embeddedController.unlock);

export default router;
