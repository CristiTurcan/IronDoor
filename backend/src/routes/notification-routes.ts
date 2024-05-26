import { Router } from 'express';
import notificationController from '../controllers/notification-controller';

const router = Router();

router.post('/', notificationController.createNotification);
router.get('/', notificationController.getAllNotifications);

export default router;
