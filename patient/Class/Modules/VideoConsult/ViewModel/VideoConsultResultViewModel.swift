//
//  VideoConsultResultViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class VideoConsultResultViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Model]>([Model.docinfo(model: DoctorInfoModel())])
    
    var did = 0
    var vid = 0
    
    let showBottomProperty = MutableProperty<Bool>(false)
    
    func getDocData() {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.removeAll(where: { model in
                if case Model.docinfo = model {
                    return true
                } else {
                    return false
                }
            })
            
            models.insert(Model.docinfo(model: docModel ?? DoctorInfoModel()), at: 0)
            self.dataSourceProperty.value = models
        }
    }
    
    func getVideoData() {
        ConsultApi.getVideoConsult(id: vid).rac_responseModel(VideoConsultModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.removeAll(where: { model in
                if case Model.docinfo = model {
                    return false
                } else {
                    return true
                }
            })
            
            models.append(Model.patient(model: model.serConsultVideo))
            
            if !model.serConsultVideo.consultContent.isEmpty {
                models.append(Model.disease(disease: model.serConsultVideo.consultContent))
            }
            
            if !model.medias.isEmpty {
                models.append(Model.picture(pics: model.medias))
            }
            
            models.append(Model.time(model: model))
            
            self.dataSourceProperty.value = models
            
            self.showBottomProperty.value = model.serConsultVideo.clientConsultStatus == "SER_CST_S_ING" && model.serConsultVideo.appointTime != 0 && model.leftSeconds > 0
        }
    }
}

extension VideoConsultResultViewModel {
    enum Model {
        case docinfo(model: DoctorInfoModel)
        case patient(model: VideoConsultSerModel)
        case disease(disease: String)
        case picture(pics: [ImageModel])
        case time(model: VideoConsultModel)
    }
}
