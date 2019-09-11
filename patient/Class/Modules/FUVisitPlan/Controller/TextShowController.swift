//
//  TextShowController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class TextShowController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    // MARK: - Public Property
    let textView = UITextView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension TextShowController {
    override func setUI() {
        textView.font = .size(15)
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .cf
        view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
