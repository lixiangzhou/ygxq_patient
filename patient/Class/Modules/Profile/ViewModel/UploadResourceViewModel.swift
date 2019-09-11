//
//  UploadResourceViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class UploadResourceViewModel: BaseViewModel {
    var selectedModelsProperty = MutableProperty<NSMutableArray>(NSMutableArray())
    var selectedImagesProperty = MutableProperty<[UIImage]>([UIImage]())
    var uploadStatusProperty = MutableProperty<Bool>(false)
    
    var canPopProperty = MutableProperty<Bool>(false)
    
    var type: UploadType = .default
    
    override init() {
        super.init()
        
        uploadStatusProperty.signal.observeValues { [weak self] (uploaded) in
            guard let self = self else { return }
            if uploaded {
                CommonApi.updateTaskState(id: self.type.id).rac_response(String.self).startWithValues { (_) in
                    self.canPopProperty.value = true
                }
            }
        }
    }
    
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
        
        UploadApi.upload(datas: datas).rac_response([String].self).startWithValues { [weak self] (resp) in
            HUD.showError(BoolString(resp))
            
            if resp.isSuccess, let urls = resp.content, !urls.isEmpty, let self = self {
                switch self.type {
                case .default:
                    HLRApi.addRecord(pid: patientId, id: 0, urls: urls).rac_response(None.self).startWithValues { [weak self] (resp) in
                        HUD.hideLoding()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        HUD.show(BoolString(resp))
                        self?.uploadStatusProperty.value = resp.isSuccess
                    }
                case .sunnyDrug:
                    SunnyDrugApi.addResources(id: self.type.linkId, imgs: urls).rac_response(None.self).startWithValues { [weak self] (resp) in
                        HUD.hideLoding()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        HUD.show(BoolString(resp))
                        self?.uploadStatusProperty.value = resp.isSuccess
                    }
                case .video:
                    ConsultApi.addResources(id: self.type.linkId, imgs: urls).rac_response(None.self).startWithValues { [weak self] (resp) in
                        HUD.hideLoding()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        HUD.show(BoolString(resp))
                        self?.uploadStatusProperty.value = resp.isSuccess
                    }
                }
                
                
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.hideLoding()
            }
        }
    }
}

extension UploadResourceViewModel {
    enum UploadType {
        case `default`
        case video(id: Int, linkId: Int)
        case sunnyDrug(id: Int, linkId: Int)
        
        
        var id: Int {
            switch self {
            case let .video(id: id, linkId: _):
                return id
            case let .sunnyDrug(id: id, linkId: _):
                return id
            default:
                return 0
            }
        }
        
        var linkId: Int {
            switch self {
            case let .video(id: _, linkId: linkId):
                return linkId
            case let .sunnyDrug(id: _, linkId: linkId):
                return linkId
            default:
                return 0
            }
        }
    }
}
