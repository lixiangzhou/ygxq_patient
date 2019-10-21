//
//  HealthDataECGPicShowController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGPicShowController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "心电图报告"
        setUI()
    }

    // MARK: - Public Property
    let imageView = UIImageView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGPicShowController {
    override func setUI() {
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinAction)))
        imageView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationAction)))
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))
        
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(UIScreen.zz_navHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension HealthDataECGPicShowController {
    @objc private func pinAction(_ ges: UIPinchGestureRecognizer) {
        guard let view = ges.view else { return }
        
        switch ges.state {
        case .began, .changed:
            view.transform = view.transform.scaledBy(x: ges.scale, y: ges.scale)
            ges.scale = 1
        default:
            break
        }
    }
    
    @objc private func panAction(_ ges: UIPanGestureRecognizer) {
        guard let view = ges.view else { return }
        
        switch ges.state {
        case .began, .changed:
            let point = ges.translation(in: view)
            view.transform = view.transform.translatedBy(x: point.x, y: point.y)
            ges.setTranslation(.zero, in: view)
        default:
            break
        }
    }
    
    @objc private func rotationAction(_ ges: UIRotationGestureRecognizer) {
        guard let view = ges.view else { return }
        
        switch ges.state {
        case .began, .changed:
            view.transform = view.transform.rotated(by: ges.rotation)
            ges.rotation = 0
        default:
            break
        }
    }
}
