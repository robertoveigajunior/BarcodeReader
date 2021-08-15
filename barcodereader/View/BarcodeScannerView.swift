//
//  BarcodeScannerView.swift
//  barcodereader
//
//  Created by Roberto Luiz Veiga Junior on 14/08/21.
//
import Foundation
import UIKit
import AVFoundation

protocol BarcodeScannerViewDelegate: AnyObject {
    func barcodeScanningDidFail()
    func barcodeScanningSucceededWithCode(_ str: String?)
    func barcodeScanningDidStop()
}

class BarcodeScannerView: UIView {
    weak var delegate: BarcodeScannerViewDelegate?
    var captureSession: AVCaptureSession?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doSetup()
    }
    
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}

extension BarcodeScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.barcodeScanningDidStop()
    }

    private func doSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code128,
                                                  .code39,
                                                  .upce,
                                                  .code39Mod43,
                                                  .pdf417,
                                                  .ean13,
                                                  .ean8,
                                                  .interleaved2of5,
                                                  .itf14]
        } else {
            scanningDidFail()
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    func scanningDidFail() {
        delegate?.barcodeScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.barcodeScanningSucceededWithCode(code)
    }
    
}

extension BarcodeScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}

