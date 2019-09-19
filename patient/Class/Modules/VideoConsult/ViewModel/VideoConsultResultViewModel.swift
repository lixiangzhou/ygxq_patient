//
//  VideoConsultResultViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultResultViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Model]>([Model.docinfo(model: DoctorInfoModel())])
    
    var vid = 0
    
    let showBottomProperty = MutableProperty<Bool>(false)
    
    func getDocData(_ did: Int) {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.insert(Model.docinfo(model: docModel ?? DoctorInfoModel()), at: 0)
            self.dataSourceProperty.value = models
        }
    }
    
    func getVideoData() {
        ConsultApi.getVideoConsult(id: vid).rac_responseModel(VideoConsultModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = [Model]()
            
            self.getDocData(model.serConsultVideo.duid)
            self.examAndPics()
            
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
    
    func examAndPics() {
        CommonApi.videoExamAndPics(linkId: vid, puid: patientId).rac_responseModel(ExamPicModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            
            var temps = [Model]()
            if model.showExams {
                temps.append(.exam)
            }
            if model.showTidyInfo {
                temps.append(.lookPics)
            }
            
            models.insert(contentsOf: temps, at: models.count - 1)
            self.dataSourceProperty.value = models
        }
    }
    
    func remindDoctor() {
        ConsultApi.remindDoctor(id: vid).rac_response(String.self).map { BoolString($0) }.startWithValues { (result) in
            HUD.showError(result)
            if result.isSuccess {
                HUD.show(toast: "医生已收到您的提醒，请耐心等待", duration: 2)
            }
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
        case lookPics   // 完善资料
        case exam   // 问卷
    }
}
