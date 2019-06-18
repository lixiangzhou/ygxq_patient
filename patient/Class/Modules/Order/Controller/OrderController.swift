//
//  OrderController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class OrderController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的订单"
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension OrderController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "开发票", style: .plain, target: self, action: #selector(getTicketAction))
        
        
        
    }
}

// MARK: - Action
extension OrderController {
    @objc private func getTicketAction() {
        
    }
}

// MARK: - Network
extension OrderController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension OrderController {
    
}

// MARK: - Other
extension OrderController {
    
}

// MARK: - Public
extension OrderController {
    
}

