//
//  GetIDCardPicturesController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//  Copyright © 2019 sphr. All rights reserved.
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
    private var backImgView: UIImageView!
    private var currentImageType: ImageType = .front
}

// MARK: - UI
extension GetIDCardPicturesController {
    override func setUI() {
        view.backgroundColor = .white
        let (frontView, frontImgView) = getView(text: "请上传您的身份证正面照片")
        let (backView, backImgView) = getView(text: "请上传您的身份证反面照片")
        
        frontImgView.tag = ImageType.front.rawValue
        backImgView.tag = ImageType.back.rawValue
        
        self.frontImgView = frontImgView
        self.backImgView = backImgView
        
        let btn = UIButton(title: "签字及同意《\(appService)》", font: .size(15), titleColor: .c3, imageName: "", selectedImageName: "", target: self, action: #selector(showPanelAction))
        view.addSubview(btn)
        
        frontView.snp.makeConstraints { (make) in
            make.topOffsetFrom(self)
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(frontView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(frontView)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(backView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func getView(text: String) -> (UIView, UIImageView) {
        let panelView = UIView()
        view.addSubview(panelView)
        
        let topView = panelView.zz_add(subview: UIView())
        topView.backgroundColor = .cf0efef
        let label = topView.zz_add(subview: UILabel(text: text, font: .size(15), textColor: .c6))
        
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
            make.left.equalTo(15)
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
        
        picBgView.isUserInteractionEnabled = true
        picView.isUserInteractionEnabled = true
        picView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPicSourceAction)))
        
        return (panelView, picView)
    }
}

// MARK: - Action
extension GetIDCardPicturesController {
    @objc private func showPanelAction() {
        let tip = SignNameTipView()
        
        tip.show()
    }
    
    @objc private func selectPicSourceAction(_ tap: UITapGestureRecognizer) {
        currentImageType = ImageType(rawValue: tap.view!.tag)!
        UIAlertController.showCameraPhotoSheet(from: self, delegate: self)
    }
}

// MARK: - Network
extension GetIDCardPicturesController {
    
}

// MARK: - Delegate Internal

// MARK: -
extension GetIDCardPicturesController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        if currentImageType == .front {
            frontImgView.image = image
        } else {
            backImgView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension GetIDCardPicturesController {
    
}

// MARK: - Other
extension GetIDCardPicturesController {
    enum ImageType: Int {
        case front = 1
        case back
    }
}

// MARK: - Public
extension GetIDCardPicturesController {
    
}

