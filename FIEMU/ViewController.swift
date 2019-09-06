//
//  ViewController.swift
//  FIEMU
//  Created by Ryan Kerr on 3/20/19.
//  Copyright © 2019 FIEMU. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.2, *) {
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                captureSession?.sessionPreset = .medium
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                self.videoPreviewLayer?.frame = self.cameraView.bounds
            }
            catch {
                print("Error: cannot load camera.")
            }
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)

    }

    @IBAction func imageCapture(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func flashButton(_ sender: Any) {
    }
    
}

extension ViewController : AVCapturePhotoCaptureDelegate {
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
            let imageData = photo.fileDataRepresentation() else {
                print("Error")
                return
        }
        
        let capturedImage = UIImage.init(data: imageData, scale: 1.0)
        
        if let image = capturedImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}


