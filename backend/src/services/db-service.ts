import Notification from '../database/notification';

class DBService {
    async createNotification(data: any) {
        return await Notification.query().insert(data);
    }

    async getAllNotifications() {
        return await Notification.query().select();
    }
}

export default new DBService();
