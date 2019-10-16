//
//  QRCodeScanController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "扫医生"
        setUI()
        requestAuth()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private var imgView: UIImageView!
    
    private var tipLabel: UILabel!
    
    private var session = AVCaptureSession()
    
    private var continueScan = true
}

// MARK: - UI
extension QRCodeScanController {
    override func setUI() {
        setRightBarItem(title: "相册", action: #selector(photosAction))
        
        let paddingX: CGFloat = 80
        let wh = view.bounds.width - paddingX * 2
        
        imgView = UIImageView(frame: CGRect(x: paddingX, y: 200, width: wh, height: wh))
        imgView.layer.borderColor = UIColor.cf.cgColor
        imgView.layer.borderWidth = 1
        view.addSubview(imgView)
        
        addImgAnimation()
        
        addEffectViews()
        
        tipLabel = UILabel(text: "请扫描医生提供的二维码，进行绑定", font: .size(14), textColor: .cf, textAlignment: .center)
        tipLabel.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(tipLabel)
        tipLabel.sizeToFit()
        tipLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imgView.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(tipLabel.zz_width + 8)
            make.height.equalTo(tipLabel.zz_height + 6)
        }
    }
    
    private func addEffectViews() {
        addEffect(rect: CGRect(x: 0, y: 0, width: view.zz_width, height: imgView.zz_y))
        addEffect(rect: CGRect(x: 0, y: imgView.zz_y, width: imgView.zz_x, height: imgView.zz_height))
        addEffect(rect: CGRect(x: imgView.zz_maxX, y: imgView.zz_y, width: view.zz_width - imgView.zz_maxX, height: imgView.zz_height))
        addEffect(rect: CGRect(x: 0, y: imgView.zz_maxY, width: view.zz_width, height: view.zz_height - imgView.zz_maxY))
    }
    
    private func addImgAnimation() {
        let line = UIImageView(frame: CGRect(x: 0, y: 0, width: imgView.zz_width, height: 6))
        line.image = UIImage(named: "scan_line")
        imgView.addSubview(line)
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = imgView.zz_height
        animation.repeatCount = Float(Int.max)
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        line.layer.add(animation, forKey: nil)
    }
    
    private func addEffect(rect: CGRect) {
        let effectView = UIView()
        effectView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        effectView.frame = rect
        view.addSubview(effectView)
    }
}

extension QRCodeScanController {
    @objc private func photosAction() {
        UIImagePickerController.showPicker(sourceType: .photoLibrary, from: self, delegate: self)
        
    }
}

// MARK: - Delegate Internal

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeScanController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if !continueScan {
            return
        }
        
        continueScan = false
        
        for item in metadataObjects {
            let prefix = "cn.com.lightheart://code="
            if let txt = (item as? AVMetadataMachineReadableCodeObject)?.stringValue, txt.count > prefix.count {
                let code = txt.zz_substring(range: NSRange(location: prefix.count, length: txt.count - prefix.count))
                HUD.showLoding()
                PatientApi.bindingDoctor(code: code, puid: patientId).rac_response(String.self).map { BoolString($0) }.startWithValues { [weak self] (result) in
                    HUD.hideLoding()
                    if result.isSuccess {
                        HUD.show(toast: "您的申请已提交，请耐心等待医生同意")
                    } else {
                        HUD.show(result)
                    }
                    DispatchQueue.main.zz_after(0.5) {
                        self?.pop()
                    }
                }
            } else {
                HUD.show(toast: "扫描失败")
                continueScan = true
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension QRCodeScanController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            guard let img = info[.originalImage] as? UIImage,
                let ciimg = CIImage(image: img) else { return }
    
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            guard let feature = detector?.features(in: ciimg).first as? CIQRCodeFeature else { return }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigation(navigationController, style: .default)
    }
}

// MARK: - Helper
extension QRCodeScanController {
    func requestAuth() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            scan()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self?.scan()
                    }
                }
            })
        default:
            let alertVC = UIAlertController(title: "", message: "请到设置界面开启摄像功能", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func scan() {
        // 获取摄像头
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        // 把摄像头作为输入设备
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        // 输出设置
        let output = AVCaptureMetadataOutput()
        output.connection(with: .metadata)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if session.canAddInput(input) == false && session.canAddOutput(output) == false { return }
        
        session.addInput(input)
        session.addOutput(output)
        
        output.metadataObjectTypes = [.qr]
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        let x = imgView.frame.origin.x / width
        let y = imgView.frame.origin.y / height
        let w = imgView.frame.size.width / width
        let h = imgView.frame.size.height / height
        
        // 测试出来的 rectOfInterest 的算法
        output.rectOfInterest = CGRect(x: y, y: 1-x-w, width: h, height: w)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = view.layer.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(layer, at: 0)
        session.startRunning()
    }
    
}
