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
    
    /// 视频咨询
    var vid = 0
    /// 电话咨询
    var telId = 0
    
    let showBottomProperty = MutableProperty<Bool>(false)
    
    func getDocData(_ did: Int) {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.insert(Model.docinfo(model: docModel ?? DoctorInfoModel()), at: 0)
            self.dataSourceProperty.value = models
        }
    }
    
    func getData() {
        if vid > 0 {
            getVideoData()
        } else if telId > 0 {
            getTelData()
        }
    }
    
    func getTelData() {
        TelApi.serConsultTelDetail(tid: telId).rac_responseModel(TelConsultModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = [Model]()
            
            self.getDocData(model.duid)
            self.examAndPics()
            
            models.append(.patient(name: model.realName, mobile: model.telNum, idCardNo: model.idCardNo))
            
            if !model.consultContent.isEmpty {
                models.append(Model.disease(disease: model.consultContent))
            }
            
            if !model.medias.isEmpty {
                models.append(Model.picture(pics: model.medias))
            }
            
            models.append(.time(status: model.consultStatus, appointTime: model.appointTime, talkTime: model.talkTime))
            
            self.dataSourceProperty.value = models
            
            self.showBottomProperty.value = model.consultStatus == "SER_CST_S_ING" && model.appointTime != 0 && model.talkTime == 0
        }
    }
    
    func getVideoData() {
        ConsultApi.getVideoConsult(id: vid).rac_responseModel(VideoConsultModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = [Model]()
            
            self.getDocData(model.serConsultVideo.duid)
            self.examAndPics()
            
            models.append(.patient(name: model.serConsultVideo.realName, mobile: model.serConsultVideo.mobile, idCardNo: model.serConsultVideo.idCardNo))
            
            if !model.serConsultVideo.consultContent.isEmpty {
                models.append(Model.disease(disease: model.serConsultVideo.consultContent))
            }
            
            if !model.medias.isEmpty {
                models.append(Model.picture(pics: model.medias))
            }
            
            models.append(.time(status: model.serConsultVideo.clientConsultStatus, appointTime: model.serConsultVideo.appointTime, talkTime: model.serConsultVideo.talkTime))
            
            self.dataSourceProperty.value = models
            
            self.showBottomProperty.value = model.serConsultVideo.clientConsultStatus == "SER_CST_S_ING" && model.serConsultVideo.appointTime != 0 && model.leftSeconds > 0
        }
    }
    
    func examAndPics() {
        if vid > 0 {
            CommonApi.videoExamAndPics(linkId: vid, puid: patientId).rac_responseModel(ExamPicModel.self).skipNil().startWithValues { [weak self] (model) in
                self?.processExamAndPics(model: model)
            }
        } else if telId > 0 {
            CommonApi.telExamAndPics(linkId: telId, puid: patientId).rac_responseModel(ExamPicModel.self).skipNil().startWithValues { [weak self] (model) in
                self?.processExamAndPics(model: model)
            }
        }
        
    }
    
    func processExamAndPics(model: ExamPicModel) {
        var models = dataSourceProperty.value
        
        var temps = [Model]()
        
        if model.showTidyInfo {
            temps.append(.lookPics)
        }
        
        if model.showExams {
            temps.append(.exam)
        }
        
        models.insert(contentsOf: temps, at: models.count - 1)
        dataSourceProperty.value = models
    }
    
    func remindDoctor() {
        if vid > 0 {
            ConsultApi.remindDoctor(id: vid).rac_response(String.self).map { BoolString($0) }.startWithValues { (result) in
                HUD.showError(result)
                if result.isSuccess {
                    HUD.show(toast: "医生已收到您的提醒，请耐心等待", duration: 2)
                }
            }
        } else if telId > 0 {
            TelApi.remindDoctorFaceTime(id: telId).rac_response(String.self).map { BoolString($0) }.startWithValues { (result) in
                HUD.showError(result)
                if result.isSuccess {
                    HUD.show(toast: "医生已收到您的提醒，请耐心等待", duration: 2)
                }
            }
        }
    }
}

extension VideoConsultResultViewModel {
    var title: String? {
        if vid > 0 {
            return "视频咨询"
        } else if telId > 0 {
            return "电话咨询"
        } else {
            return nil
        }
    }
    
    var timeTitle: String? {
        if vid > 0 {
            return "视频通话时间"
        } else if telId > 0 {
            return "电话咨询预约时间"
        } else {
            return nil
        }
    }
    
    var serType: String {
        if vid > 0 {
            return "UTOPIA15"
        } else if telId > 0 {
            return "UTOPIA10"
        } else {
            return ""
        }
    }
    
    var id: Int {
        if vid > 0 {
            return vid
        } else if telId > 0 {
            return telId
        } else {
            return 0
        }
    }
}

extension VideoConsultResultViewModel {
    enum Model {
        case docinfo(model: DoctorInfoModel)
//        case patient(model: VideoConsultSerModel)
        case patient(name: String, mobile: String, idCardNo: String)
        case disease(disease: String)
        case picture(pics: [ImageModel])
        case time(status: String, appointTime: TimeInterval, talkTime: TimeInterval)
//        case time(model: VideoConsultModel)
        case lookPics   // 完善资料
        case exam   // 问卷
    }
}
