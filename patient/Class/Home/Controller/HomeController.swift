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

class HomeController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        UserApi.login(mobile: "1340000003", password: "123456").response { (_) in
//
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
        
//        let producer = SignalProducer<Int, NoError> { (observer, _) in
//            observer.send(value: 3)
//            observer.send(value: 5)
//        }
//        
////        producer.startWithValues { print($0) }
////
////        producer.startWithValues { print($0) }
//        
//        producer.startWithSignal { (signal, _) -> Result<Int, NoError> in
//            signal.observe { print($0, "ddd") }
//            return Result.init(value: 3)
//        }
//        
//        producer.startWithValues { print($0) }
    }

}
