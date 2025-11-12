# Object Detection for Accessibility — YOLOv8 Vision System  

This project implements a YOLOv8-based computer vision system for **real-time object detection**, designed to support **accessibility and assistive technologies**.  

## Overview  
The goal of this work is to develop an AI-powered vision tool capable of recognising and localising multiple objects in real time. Such systems can be integrated into **assistive devices for visually impaired users** or applied in **automated inventory and robotics tasks**.  

## Methodology  
The project covers the complete computer vision pipeline:  
- **Dataset Preprocessing & Annotation** — image labelling and augmentation for balanced training sets.  
- **Model Architecture** — YOLOv8 (Ultralytics) implemented in **PyTorch**, fine-tuned for accessibility-related object categories.  
- **Training & Validation** — GPU-based training with data augmentation, early stopping, and mAP/F1 monitoring.  
- **Evaluation Metrics & Visualisation** — performance assessed through precision–recall, confusion matrix, and visual bounding-box overlays.  

## Technologies  
`Python` · `PyTorch` · `YOLOv8` · `OpenCV` · `NumPy` · `Matplotlib`  

## Results  
- Achieved high detection accuracy and consistent performance across multiple validation sets.  
- Produced interpretable visual outputs highlighting detected objects with class-specific confidence scores.  

## Author  
**Nikita Chevokin**  
MSc Artificial Intelligence, University of Bologna  
