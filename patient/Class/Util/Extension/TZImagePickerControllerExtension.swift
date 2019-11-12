//
//  TZImagePickerControllerExtension.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import TZImagePickerController

extension TZImagePickerController {
    static func commonPresent(from controller: UIViewController?, maxCount: Int, selectedModels:  NSMutableArray?, delegate: TZImagePickerControllerDelegate?) {
        let vc = TZImagePickerController(maxImagesCount: maxCount, delegate: delegate)!
        vc.showPhotoCannotSelectLayer = true
        vc.allowTakeVideo = false
        vc.allowPickingVideo = false
        vc.photoPreviewPageUIConfigBlock = { _, _, _, _, _, _, originalPhotoButton, originalPhotoLabel, _, _, _ in
            originalPhotoButton?.alpha = 0
        }
        vc.photoPickerPageUIConfigBlock = { _, _, previewButton, originalPhotoButton, originalPhotoLabel, _ , _, _, _ in
            previewButton?.isHidden = true
            originalPhotoButton?.isHidden = true
            originalPhotoLabel?.isHidden = true
        }
//        vc.selectedModels = selectedModels
        controller?.present(vc)
    }
}
