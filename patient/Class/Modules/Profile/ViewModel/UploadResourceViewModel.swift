//
//  UploadResourceViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class UploadResourceViewModel: BaseViewModel {
    var selectedModelsProperty = MutableProperty<NSMutableArray>(NSMutableArray())
    var selectedImagesProperty = MutableProperty<[UIImage]>([UIImage]())
    var uploadStatusProperty = MutableProperty<Bool>(false)
    
    func removeAt(index: Int) {
        var value = selectedImagesProperty.value
        value.remove(at: index)
        selectedImagesProperty.value = value
        selectedModelsProperty.value.removeObject(at: index)
    }
}

extension UploadResourceViewModel {
    func uploadImages() {
        HUD.showLoding()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var datas = [FileData]()
        for (idx, img) in selectedImagesProperty.value.enumerated() {
            datas.append(FileData(data: img.jpegData(compressionQuality: 1)!, name: "img\(idx).jpg"))
        }
        
        UploadApi.upload(datas: datas).rac_response([String].self).startWithValues { (resp) in
            HUD.showError(BoolString(resp))
            if resp.isSuccess, let urls = resp.content, !urls.isEmpty {
                
                HLRApi.addRecord(pid: patientId, id: 0, urls: urls).rac_response(None.self).startWithValues { [weak self] (resp) in
                    HUD.hideLoding()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    HUD.show(BoolString(resp))
                    self?.uploadStatusProperty.value = resp.isSuccess
                }
                
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.hideLoding()
            }
        }
    }
}
