//
//  QRScanModel.swift
//  Funseum
//
//  Created by SonPT on 2021-12-07.
//

import Foundation
import AVFoundation
import SwiftUI

class ScannerViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "Qr-code goes here"
    @Published var finishScan: Bool = false
    @Published var songLink: String = ""
    
    
    func onFoundQrCode(_ code: String) {
        booking (qrcode:code) {
            response in
            if (response.status == 200) {self.lastQrCode = "API Call Finished!\n Debug code: " + code}
        }
    }
    
    func booking(qrcode: String, completionBlock: @escaping (apiResponse) -> Void) -> Void {
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "userId")
        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/fm/qr")!
        let session = URLSession.shared
        let parameterDictionary = [
            "UserId" : userId,
            "QrCode" : qrcode,
        ] as [String : Any]
        var request = URLRequest(url: url)
        var qrResponse = apiResponse (status:0)
        
        request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
        
        //fetch data
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

           do {
            print("call api done")
            guard let qrJson = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error when parse json")
                            return
                        }
    
            print("finish json")
            
            qrResponse.status = qrJson["statusCode"] as! Int
            self.songLink = qrJson["songUrl"] as! String
            completionBlock(qrResponse)
 
           } catch let error {
             print(error.localizedDescription)
           }
        })
        task.resume()
       
    }
}

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (String) -> Void = { _  in }
    var mockData: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "Simulated QR-code result.")
    }
    
    func foundBarcode(_ stringValue: String) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            self.onResult(stringValue)
        }
    }
}

class CameraPreview: UIView {
    
    private var label:UILabel?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    weak var delegate: QrCodeCameraDelegate?
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.session = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSimulatorView(delegate: QrCodeCameraDelegate){
        self.delegate = delegate
        self.backgroundColor = UIColor.black
        label = UILabel(frame: self.bounds)
        label?.numberOfLines = 4
        label?.text = "Click here to simulate scan"
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func onClick(){
        delegate?.onSimulateScanning()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
    }
}
