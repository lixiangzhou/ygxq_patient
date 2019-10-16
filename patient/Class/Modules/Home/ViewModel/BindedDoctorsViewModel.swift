//
//  BindedDoctorsViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class BindedDoctorsViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[DoctorInfoModel]>([DoctorInfoModel]())
    
    func getData() {
        PatientApi.bindedDoctors(puid: patientId).rac_responseModel([DoctorInfoModel].self).startWithValues { [weak self] (result) in
            guard let self = self else { return }
            self.dataSourceProperty.value = result ?? []
        }
    }
    
    func getServices(model: DoctorInfoModel) -> NSAttributedString {
        let text = NSMutableAttributedString()
        let font = UIFont.size(14)
        for ser in model.doctorSers {
            let serTxt = NSMutableAttributedString(string: ser.serName)
            serTxt.yy_insertString("   ", at: 0)
            serTxt.yy_appendString("   ")
            serTxt.yy_font = font
            serTxt.yy_color = .cf
            serTxt.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: serTxt.yy_rangeOfAll())
            
            let border = YYTextBorder()
            border.strokeWidth = 1.5
            border.strokeColor = .c407cec
            border.fillColor = .ce5eeff
            border.cornerRadius = 12.5
            border.lineJoin = .bevel
            border.insets = UIEdgeInsets(top: -2, left: -5.5, bottom: -2, right: -8)
            
            serTxt.yy_setTextBackgroundBorder(border, range: serTxt.string.zz_ns.range(of: ser.serName))
            
            text.append(serTxt)
        }
        return text
    }
}
