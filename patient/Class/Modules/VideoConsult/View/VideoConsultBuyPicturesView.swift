//
//  VideoConsultBuyPicturesView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultBuyPicturesView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    let pictureSelectView = PictureSelectView()
    
    let heightProperty = MutableProperty<CGFloat>(0)
}

// MARK: - UI
extension VideoConsultBuyPicturesView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "上传图片资料"
        addSubview(titleView)
        
        let config = PictureSelectView.Config.defaultConfig()
        pictureSelectView.config = config
        addSubview(pictureSelectView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }

        pictureSelectView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.height.equalTo(config.itemSize)
            make.width.equalTo(config.width)
            make.bottom.equalTo(-15)
        }
    }
    
    private func setBinding() {
        pictureSelectView.viewModel.dataSourceProperty.signal.map { [weak self] (values) -> CGFloat in
            guard let self = self, let config = self.pictureSelectView.config else { return 0 }
            let row = ceil(CGFloat(values.count) / CGFloat(config.rowItemCount))
            return config.itemSize.height * row + (row - 1) * config.ySpacing
            }.skipRepeats().observeValues { [weak self] (height) in
                self?.pictureSelectView.snp.updateConstraints { (make) in
                    make.height.equalTo(height)
                }
                self?.heightProperty.value = height + 45 + 30
        }
    }
}
