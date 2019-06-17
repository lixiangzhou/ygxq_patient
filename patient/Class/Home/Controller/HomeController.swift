//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import Alamofire

class HomeController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        GetRealNameTipView().show()
        test()
    }

    func test() {
//        present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
        
//        print(PatientManager.shared.patientInfoModel)
//        RCManager.shared.connect()
        push(GetIDCardPicturesController())
    }
}
