//
//  ControllerExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension UIViewController {
    func push(_ controller: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}

// MARK: - 打开相册和相机（有相册和相机权限验证）
extension UIImagePickerController {
    /// 打开相册和相机（有相册和相机权限验证） 
    /// controller UIImagePickerControllerDelegate & UINavigationControllerDelegate
    static func showPicker(sourceType: UIImagePickerController.SourceType, from controller: UIViewController, allowsEditing: Bool = true) {
        if sourceType == .camera {  // 相机
            let auth = AVCaptureDevice.authorizationStatus(for: .video)
            switch auth {
            case .notDetermined, .restricted:
                attemptAccessVideo {
                    showCamera(sourceType: sourceType, from: controller, allowsEditing: allowsEditing)
                }
            case .authorized:
                showCamera(sourceType: sourceType, from: controller)
            case .denied:
                deniedProcess(for: .camera, from: controller)
            @unknown default:
                break
            }
        } else {    // 相册
            let auth = PHPhotoLibrary.authorizationStatus()
            switch auth {
            case .notDetermined, .restricted:
                attemptAccessPhoto {
                    showCamera(sourceType: sourceType, from: controller, allowsEditing: allowsEditing)
                }
            case .authorized:
                showCamera(sourceType: sourceType, from: controller)
            case .denied:
                deniedProcess(for: .camera, from: controller)
            @unknown default:
                break
            }
        }
    }
    
    private static func deniedProcess(for sourceType: UIImagePickerController.SourceType, from controller: UIViewController) {
        let msg = "访问\(sourceType == .camera ? "相机" : "相册")需要您的权限"
        UIAlertController.zz_show(fromController: controller, style: .alert, message: msg, actions: [UIAlertAction(title: "同意", style: .default, handler: { (_) in
            DispatchQueue.main.zz_after(0.2) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }), UIAlertAction(title: "取消", style: .cancel, handler: nil)], completion: nil)
    }
    
    private static func showCamera(sourceType: UIImagePickerController.SourceType, from controller: UIViewController, allowsEditing: Bool = true) {
        let picker = UIImagePickerController()
        picker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = sourceType
        picker.allowsEditing = allowsEditing
        controller.present(picker, animated: true, completion: nil)
    }
    
    private static func attemptAccessVideo(success:@escaping () -> Void) {
        let session: AVCaptureDevice.DiscoverySession
        if #available(iOS 10.0, *) {
            if #available(iOS 10.2, *) {
                session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            } else {
                session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDuoCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            }
            if !session.devices.isEmpty {
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted {
                        success()
                    }
                }
            }
        } else {
            if !AVCaptureDevice.devices(for: .video).isEmpty {
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted {
                        success()
                    }
                }
            }
        }
    }
    
    private static func attemptAccessPhoto(success:@escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                success()
            }
        }
    }
}

extension UIAlertController {
    /// 显示 sheet：拍照/从相册选择/取消 controller: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    static func showCameraPhotoSheet(from controller: UIViewController, completion:((UIImagePickerController.SourceType) -> Void)? = nil) {
        let action1 = UIAlertAction(title: "拍照", style: .default) { (_) in
            UIImagePickerController.showPicker(sourceType: .camera, from: controller)
            completion?(.camera)
        }
        let action2 = UIAlertAction(title: "从相册选择", style: .default) { (_) in
            UIImagePickerController.showPicker(sourceType: .photoLibrary, from: controller)
            completion?(.photoLibrary)
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        UIAlertController.zz_show(fromController: controller, style: .actionSheet, actions: [action1, action2, action3], completion: nil)
    }
}

