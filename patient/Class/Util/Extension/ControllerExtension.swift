//
//  ControllerExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

private var navigationBarEffectViewKey: Void?

extension UIViewController {
    func push(_ controller: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
