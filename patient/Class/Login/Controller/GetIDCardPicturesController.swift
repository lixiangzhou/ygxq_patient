//
//  GetIDCardPicturesController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class GetIDCardPicturesController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "上传身份证"
        setUI()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private var frontImgView: UIImageView!
    private var reverseImgView: UIImageView!
}

// MARK: - UI
extension GetIDCardPicturesController {
    private func setUI() {
        let (frontView, frontImgView) = getView(text: "请上传您的身份证正面照片")
        let (reverseView, reverseImgView) = getView(text: "请上传您的身份证反面照片")
        
        self.frontImgView = frontImgView
        self.reverseImgView = reverseImgView
        
        
        frontView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        
        reverseView.snp.makeConstraints { (make) in
            make.top.equalTo(frontView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(frontView)
        }
    }
    
    private func getView(text: String) -> (UIView, UIImageView) {
        let panelView = UIView()
        view.addSubview(panelView)
        
        let topView = panelView.zz_add(subview: UIView())
        topView.backgroundColor = .c9
        let label = topView.zz_add(subview: UILabel(text: text, font: .size(15), textColor: .c3))
        
        let picPanelView = panelView.zz_add(subview: UIView())
        let picBgView = picPanelView.zz_add(subview: UIImageView(image: UIImage(named: "")))
        let picView = picBgView.zz_add(subview: UIImageView()) as! UIImageView
        
        picBgView.backgroundColor = .yellow
        picView.backgroundColor = .orange
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.bottom.equalToSuperview()
        }
        
        picPanelView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        picBgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(155)
        }
        
        picView.snp.makeConstraints { (make) in
            make.top.left.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        return (panelView, picView)
    }
}

// MARK: - Action
extension GetIDCardPicturesController {
    
}

// MARK: - Network
extension GetIDCardPicturesController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension GetIDCardPicturesController {
    
}

// MARK: - Other
extension GetIDCardPicturesController {
    
}

// MARK: - Public
extension GetIDCardPicturesController {
    
}

