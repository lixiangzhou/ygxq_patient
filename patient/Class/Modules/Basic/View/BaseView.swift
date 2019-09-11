//
//  BaseView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/10.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT => \(self.classForCoder)")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension BaseView {
    private func setUI() {
        
    }
}
