import { Request, Response } from 'express';
import dbService from '../services/db-service';

class NotificationController {
    async createNotification(req: Request, res: Response) {
        console.log('createNotification');
        try {
            const { name, message, hasImage, imageBase64 } = req.body;
            const newNotification = await dbService.createNotification({ name, message, hasImage, imageBase64 });
            res.status(201).json(newNotification);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async getAllNotifications(req: Request, res: Response) {
        console.log('getAllNotifications');
        try {
            const notifications = await dbService.getAllNotifications();
            res.status(200).json(notifications);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}

export default new NotificationController();
