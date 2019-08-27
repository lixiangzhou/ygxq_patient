//
//  ImageTitleView.swift
//  sphr-doctor-iOS
//
//  Created by lixiangzhou on 2019/8/22.
//Copyright © 2019 qingsong. All rights reserved.
//

import UIKit

class ImageTitleView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let imgView = UIImageView()
    let titleLabel = UILabel()
    
    var config: Config? {
        didSet {
            guard let config = config else { return }
            
            titleLabel.textColor = config.titleColor
            titleLabel.font = config.titleFont
            
            if config.imageInTop {
                imgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(config.verticalHeight1)
                    make.size.equalTo(config.imageSize)
                    make.centerX.equalToSuperview()
                }
                
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(imgView.snp.bottom).offset(config.verticalHeight2)
                    make.left.equalTo(config.titleLeft)
                    make.right.equalTo(-config.titleRight)
                }
            } else {
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(config.verticalHeight1)
                    make.left.equalTo(config.titleLeft)
                    make.right.equalTo(-config.titleRight)
                }
                
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(config.verticalHeight2)
                    make.size.equalTo(config.imageSize)
                    make.centerX.equalToSuperview()
                }
            }
        }
    }
    // MARK: - Private Property
    
}

// MARK: - UI
extension ImageTitleView {
    private func setUI() {
        titleLabel.textAlignment = .center
        addSubview(imgView)
        addSubview(titleLabel)
    }
}

// MARK: - Public
extension ImageTitleView {
    struct Config {
        var imageInTop: Bool
        var imageSize: CGSize
        var verticalHeight1: CGFloat
        var verticalHeight2: CGFloat
        var titleLeft: CGFloat
        var titleRight: CGFloat
        var titleFont: UIFont
        var titleColor: UIColor
        
        init(imageInTop: Bool = true,
             imageSize: CGSize = CGSize(width: 50, height: 50),
             verticalHeight1: CGFloat = 10,
             verticalHeight2: CGFloat = 10,
             titleLeft: CGFloat = 0,
             titleRight: CGFloat = 0,
             titleFont: UIFont = .size(14),
             titleColor: UIColor = .c3) {
            
            self.imageInTop = imageInTop
            self.imageSize = imageSize
            self.verticalHeight1 = verticalHeight1
            self.verticalHeight2 = verticalHeight2
            self.titleLeft = titleLeft
            self.titleRight = titleRight
            self.titleFont = titleFont
            self.titleColor = titleColor
        }
    }
    
}
