//
//  VideoCapture.swift
//  grayscale-1channel-sample
//
//  Created by What on 2018/12/21.
//  Copyright © 2018 dumbass. All rights reserved.
//

import UIKit.UIView
import AVFoundation.AVCaptureDevice

class VideoCapture:
    NSObject,
    AVCapturePhotoCaptureDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate {
    
    init(preview: UIView) throws {
        
        if let device = AVCaptureDevice.default(for: .video) {
            self.device = device
        } else {
            fatalError("")
        }
        
        let input = try AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspect
        preview.layer.insertSublayer(previewLayer, at: 0)
        
        super.init()
        
        self.session.sessionPreset = .hd1280x720
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.dumbass.video-capture-queue"))
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        if self.session.canAddOutput(videoOutput) {
            self.session.addOutput(videoOutput)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        didOutputSampleBuffer?(output, sampleBuffer, connection)
    }
    
    func start() {
        session.startRunning()
    }
    
    func stop() {
        session.stopRunning()
    }
    
    var didOutputSampleBuffer: ((AVCaptureOutput , CMSampleBuffer, AVCaptureConnection) -> Void)?
    let session = AVCaptureSession()
    let previewLayer: AVCaptureVideoPreviewLayer
    let device: AVCaptureDevice
}

