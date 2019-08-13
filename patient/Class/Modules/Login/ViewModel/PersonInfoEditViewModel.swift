//
//  PersonInfoEditViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class PersonInfoEditViewModel: BaseViewModel {
    
    let sexDataSource = CommonPicker.DataSouce.one(["男", "女"])
    let heightDataSource: CommonPicker.DataSouce
    let weightDataSource: CommonPicker.DataSouce
    let diseasesProperty = MutableProperty<[DiseaseModel]>([])
    var diseasesDataSource = CommonPicker.DataSouce.one([])
    
    let nameAttributeString: NSAttributedString
    var imgUrl = ""
    
    override init() {
        var heightDS = [GroupModel<String>]()
        for idx in 50...250 {
            heightDS.append(GroupModel(title: idx.description, list: ["cm"]))
        }
        heightDataSource = CommonPicker.DataSouce.two(heightDS)
        
        
        var weightDS = [GroupModel<String>]()
        for idx in 20...250 {
            weightDS.append(GroupModel(title: idx.description, list: ["kg"]))
        }
        weightDataSource = CommonPicker.DataSouce.two(weightDS)
        
        let nameAttr = NSMutableAttributedString(string: "真实姓名")
        nameAttr.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
        nameAttributeString = nameAttr
        
        super.init()
        
        diseasesProperty.signal.observeValues { [weak self] (results) in
            if !results.isEmpty {
                var array = [String]()
                for disease in results {
                    array.append(disease.diseaseDesc)
                }
                self?.diseasesDataSource = .one(array)
            }
        }
    }

    var inputConfig: TextLeftRightFieldViewConfig {
        return TextLeftRightFieldViewConfig(leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightWidth: 200, rightLimit: 20)
    }
    
    var arrowConfig: LeftRightConfigViewConfig {
        return LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightPaddingLeft: 5)
    }
    
    
    func saveInfo(_ params: [String: Any]) -> SignalProducer<BoolString, NoError> {
        return UserApi.updateInfo(params: params).rac_response(String.self).map { BoolString($0) }
    }
    
    func selectDiseaseCodeFrom(_ disease: String?) -> String? {
        for model in diseasesProperty.value {
            if model.diseaseDesc == disease {
                return model.diseaseCode
            }
        }
        return nil
    }
    
    func getDisease() {
        if diseasesProperty.value.isEmpty {
            DiseaseApi.diseasetypes.rac_responseModel([DiseaseModel].self).startWithValues { [weak self] in
                self?.diseasesProperty.value = $0 ?? []
            }
        }
    }
}