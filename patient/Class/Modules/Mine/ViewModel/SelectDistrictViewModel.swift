//
//  SelectDistrictViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class SelectDistrictViewModel: BaseViewModel {
    let provincesProperty = MutableProperty([AreaModel]())
    let citysProperty = MutableProperty([AreaModel]())
    let districtsProperty = MutableProperty([AreaModel]())
    
    let selectProvinceProperty: MutableProperty<AreaModel?> = MutableProperty(nil)
    let selectCityProperty: MutableProperty<AreaModel?> = MutableProperty(nil)
    let selectDistrictProperty: MutableProperty<AreaModel?> = MutableProperty(nil)
    
    let contentSizeProperty = MutableProperty(CGSize(width: UIScreen.zz_width, height: 0))
    
    func getProvinces() {
        AddressApi.provinces.rac_responseModel([AreaModel].self).skipNil().startWithValues { [unowned self] in
            self.provincesProperty.value = $0
        }
    }
    
    func getCitys(id: Int) {
        AddressApi.areasByFid(id: id).rac_responseModel([AreaModel].self).skipNil().startWithValues { [unowned self] in
            self.citysProperty.value = $0
        }
    }
    
    func getDistricts(id: Int) {
        AddressApi.areasByFid(id: id).rac_responseModel([AreaModel].self).skipNil().startWithValues { [unowned self] in
            self.districtsProperty.value = $0
        }
    }
    
    func getModel(type: Int, indexPath: IndexPath) -> AreaModel {
        return getModels(type: type)[indexPath.row]
    }
    
    @discardableResult
    func selectModel(type: Int, indexPath: IndexPath) -> AreaModel {
        let models = getModels(type: type)
        let model = models[indexPath.row]
        
        let viewType = SelectDistrictView.ViewType(rawValue: type)!
        switch viewType {
        case .province:
            selectProvinceProperty.value = model
            getCitys(id: model.id)
        case .city:
            selectCityProperty.value = model
            getDistricts(id: model.id)
        case .district:
            selectDistrictProperty.value = model
        }
        
        for (idx, model) in models.enumerated() {
            model.isSelect = idx == indexPath.row
        }
        
        refresh(type: type, with: models)
        return model
    }
    
    func getModels(type: Int) -> [AreaModel] {
        let viewType = SelectDistrictView.ViewType(rawValue: type)!
        var models = [AreaModel]()
        switch viewType {
        case .province:
            models = provincesProperty.value
        case .city:
            models = citysProperty.value
        case .district:
            models = districtsProperty.value
        }
        return models
    }
    
    func refresh(type: Int, with models: [AreaModel]) {
        let viewType = SelectDistrictView.ViewType(rawValue: type)!
        switch viewType {
        case .province:
            provincesProperty.value = models
        case .city:
            citysProperty.value = models
        case .district:
            districtsProperty.value = models
        }
    }
    
}
