//
//  UIImageViewExtension.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

extension UIImageView {
    static func defaultRightArrow() -> UIImageView {
        return UIImageView(image: UIImage(named: "common_arrow_right"))
    }
    
    func setImage(with url: URL?, placeholder: String = "service_placeholder", neterror: String = "service_neterror") {
        contentMode = .scaleAspectFit
        kf.setImage(with: url, placeholder: UIImage(named: placeholder)) { (result) in
            switch result {
            case .failure:
                self.contentMode = .scaleAspectFit
                self.image = UIImage(named: neterror)
            case .success:
                self.contentMode = .scaleToFill
            }
        }
    }
}
