//
//  VideoConsultBuyDiseaseView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultBuyDiseaseView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let txtView = NextGrowingTextView()
    
    // MARK: - Private Property
    let heightProperty = MutableProperty<CGFloat>(0)
    
}

// MARK: - UI
extension VideoConsultBuyDiseaseView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.attributedText = "病情描述".needed(with: .boldSize(16), color: .c3)
        addSubview(titleView)

        txtView.textView.textColor = .c3
        txtView.textView.font = .size(15)
        txtView.minNumberOfLines = 3
        txtView.maxNumberOfLines = 30
        txtView.inputLimit = 300
        txtView.textView.keyboardDismissMode = .onDrag
        txtView.textView.showsVerticalScrollIndicator = false
        txtView.placeholderAttributedText = NSMutableAttributedString(string: "请详细描述您的主要症状，持续时间，或者上传近期检查单等资料，供医生参考并给出更详细的回复", attributes: [NSAttributedString.Key.foregroundColor: UIColor.fieldDefaultColor, NSAttributedString.Key.font: UIFont.size(15)])
        addSubview(txtView)
        
        txtView.delegates.didChangeHeight = { [weak self] height in
            guard let self = self else { return }
            let h = max(80, height)
            self.txtView.snp.updateConstraints { (make) in
                make.height.equalTo(h)
            }
            self.heightProperty.value = h + 45 + 20
        }

        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }

        txtView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.left.equalTo(12)
            make.height.equalTo(80)
            make.right.bottom.equalTo(-10)
        }
    }
}
