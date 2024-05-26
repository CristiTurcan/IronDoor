const fs = require('fs');
const path = require('path');
const tf = require('@tensorflow/tfjs-node'); // Use '@tensorflow/tfjs-node-gpu' if you have CUDA extensions
const Human = require('@vladmandic/human').default; // points to @vladmandic/human/dist/human.node.js
const { Canvas, Image, ImageData, loadImage } = require('canvas');
const sharp = require('sharp');
import FaceDescriptor from '../database/face-descriptor';

// Configure Human with correct model paths
const humanConfig = {
  modelBasePath: 'file://' + path.join(__dirname, '../models/'),
  debug: true,
  async: true,
  // filter: {
  //   enabled: true,
  //   flip: true,
  // },
  canvas: { 
    Canvas: Canvas, 
    Image: Image, 
    ImageData: ImageData 
  },
  face: {
    enabled: true,
    detector: { 
      modelPath: 'blazeface.json',
      minConfidence: -10,
    },
  },
};

const human = new Human(humanConfig);

class FaceService {
  constructor() {
    this.labeledFaceDescriptors = [];
  }

  async loadModels() {
    try {
      await tf.ready();
      console.log('Loading models...');
      await human.load();
      console.log('Models loaded successfully');
      await this.loadFaceDescriptors();
    } catch (error) {
      console.error('Error loading models:', error);
      throw error;
    }
  }

  async loadFaceDescriptors() {
    try {
      const faceDescriptors = await FaceDescriptor.query().select();
      this.labeledFaceDescriptors = faceDescriptors.map((fd) => {
        const descriptors = JSON.parse(fd.descriptors).map((d) => new Float32Array(d));
        return { label: fd.name, descriptors };
      });
      console.log('Face descriptors loaded successfully');
    } catch (error) {
      console.error('Error loading face descriptors:', error);
      throw error;
    }
  }

  async enrollUser(name, images) {
    try {
      const descriptors = await Promise.all(
        images.map(async (imgBuffer) => {
          try {
            const img = await this.loadImage(imgBuffer);
            const tensor = this.imageToTensor(img);
            const result = await human.detect(tensor);
            const face = result.face;
            if (!face.length) {
              throw new Error('No faces detected in one of the images.');
            }
            return face[0].embedding;
          } catch (error) {
            console.error('Error processing image:', error);
            throw error;
          }
        })
      );

      this.labeledFaceDescriptors.push({ label: name, descriptors });
      await FaceDescriptor.query().insert({
        name,
        descriptors: JSON.stringify(descriptors.map((d) => Array.from(d))),
      });
      console.log('User enrolled and face descriptors saved successfully');
    } catch (error) {
      console.error('Error enrolling user:', error);
      throw error;
    }
  }

  async recognizeUser(imageBuffer) {
    try {
      console.log('Recognizing user...');
      const img = await this.loadImage(imageBuffer);
      const tensor = this.imageToTensor(img);
      const result = await human.detect(tensor);
      const face = result.face;
      if (!face.length) {
        return { authorized: false };
      }

      const inputDescriptor = face[0].embedding;
      const bestMatch = this.findBestMatch(inputDescriptor);

      console.log(`Best match: ${bestMatch.label}, Certainty: ${(1 - bestMatch.distance).toFixed(4)}`);

      console.log("distance", bestMatch.distance)

      if (bestMatch.distance > 10.5) {
        return { authorized: false };
      }

      return { authorized: bestMatch.label !== 'unknown', label: bestMatch.label, certainty: (1 - bestMatch.distance).toFixed(4) };
    } catch (error) {
      console.error('Error recognizing user:', error);
      throw error;
    }
  }

  async loadImage(imageBuffer) {
    const processedImage = await sharp(imageBuffer).toFormat('png').toBuffer();
    return processedImage;
  }

  imageToTensor(image) {
    return tf.tidy(() => {
      const decode = tf.node.decodeImage(image, 3);
      let expand;
      if (decode.shape[2] === 4) { // input is in rgba format, need to convert to rgb
        const channels = tf.split(decode, 4, 2); // split rgba to channels
        const rgb = tf.stack([channels[0], channels[1], channels[2]], 2); // stack channels back to rgb and ignore alpha
        expand = tf.reshape(rgb, [1, decode.shape[0], decode.shape[1], 3]); // move extra dim from the end of tensor and use it as batch number instead
      } else {
        expand = tf.expandDims(decode, 0);
      }
      return tf.cast(expand, 'float32');
    });
  }

  findBestMatch(inputDescriptor) {
    let bestMatch = { label: 'unknown', distance: Infinity };
    this.labeledFaceDescriptors.forEach(({ label, descriptors }) => {
      descriptors.forEach((descriptor) => {
        const distance = this.computeDistance(inputDescriptor, descriptor);
        if (distance < bestMatch.distance) {
          bestMatch = { label, distance };
        }
      });
    });
    return bestMatch;
  }

  computeDistance(descriptor1, descriptor2) {
    let sum = 0;
    for (let i = 0; i < descriptor1.length; i++) {
      const diff = descriptor1[i] - descriptor2[i];
      sum += diff * diff;
    }
    return Math.sqrt(sum);
  }
}

export default new FaceService();
