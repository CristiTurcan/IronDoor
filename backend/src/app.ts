import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors'; // Import cors

import bodyParser from 'body-parser';
import notificationRoutes from './routes/notification-routes';
import embeddedRoutes from './routes/embedded-routes';
import faceRoutes from './routes/face-routes';
import faceService from './services/face-service';

require('@tensorflow/tfjs-node');

dotenv.config();

const app = express();
const port = process.env.PORT || 3001;

// Configure CORS
app.use(cors({
  origin: '*', // Allow all origins
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allowed methods
  allowedHeaders: ['Content-Type', 'Authorization'] // Allowed headers
}));

app.use(bodyParser.json({ limit: '50mb' }));

app.use('/notifications', notificationRoutes);
app.use('/face', faceRoutes);
app.use('/embedded', embeddedRoutes);

app.get('/', (req, res) => {
    res.send('Server is alive and well!');
});

const startServer = async () => {
  try {
    await faceService.loadModels();
    console.log('Models loaded successfully');
    app.listen(Number(port), '0.0.0.0', () => {
      console.log(`Server is running on port ${port}`);
    });
  } catch (error) {
    console.error('Failed to load models:', error);
  }
};

startServer();

export default app;
