//
//  UploadResourceController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import TZImagePickerController

class UploadResourceController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
    }

    // MARK: - Public Property
    var tipString = "可上传病历、出院记录、手术记录、检查单、化验单等信息。"
    
    // MARK: - Private Property
    let viewModel = UploadResourceViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let picsView = PictureSelectView()
    let submitBtn = UIButton(title: "提交", font: .size(18), titleColor: .cf, backgroundColor: .c407cec)
}

// MARK: - UI
extension UploadResourceController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "上传记录", target: self, action: #selector(recordAction))
        
        scrollView.backgroundColor = .cf
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let topView = contentView.zz_add(subview: UIView())
        let tipLabel = topView.zz_add(subview: UILabel(text: tipString, font: .size(16), textColor: .c6)) as! UILabel
        topView.addBottomLine()
        
        let config = PictureSelectView.Config.defaultConfig()
        picsView.config = config
        contentView.addSubview(picsView)
        
        setActions()
        
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        contentView.addSubview(submitBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_safeFrameUnderNavigation.height)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        
        let tipHeight = tipString.zz_size(withLimitWidth: UIScreen.zz_width - 30, fontSize: tipLabel.font.pointSize).height
        tipLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.bottom.equalTo(-15)
            make.height.equalTo(tipHeight)
        }
        
        picsView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.height.equalTo(config.itemSize)
            make.width.equalTo(config.width)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        let submitEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(viewModel.selectedImagesProperty.producer.map { !$0.isEmpty })
        submitBtn.reactive.isUserInteractionEnabled <~ submitEnabledSignal
        submitBtn.reactive.backgroundColor <~ submitEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        picsView.viewModel.dataSourceProperty.signal.map { [weak self] (values) -> CGFloat in
            guard let self = self, let config = self.picsView.config else { return 0 }
            let row = ceil(CGFloat(values.count) / CGFloat(config.column))
            return config.itemSize.height * row + (row - 1) * config.ySpacing
            }.skipRepeats().observeValues { [weak self] (height) in
                self?.picsView.snp.updateConstraints { (make) in
                    make.height.equalTo(height)
                }
                self?.updateContentHeight()
        }
        
        // 选择图片
        viewModel.selectedImagesProperty.signal.observeValues { [weak self] (imgs) in
            guard let self = self else { return }
            var values = [UIImage]()
            HUD.showLoding()
            DispatchQueue.global().async {
                for img in imgs {
                    if let resizeImage = UIImage(data: img.zz_resetToSize(1000, maxWidth: 1000, maxHeight: 1000)) {
                        values.append(resizeImage)
                    }
                }
                
                DispatchQueue.main.async {
                    HUD.hideLoding()
                    self.picsView.viewModel.set(images: values)
                }
            }
        }
        
        viewModel.uploadStatusProperty.signal.observeValues { [weak self] (uploaded) in
            if uploaded {
                self?.pop()
            }
        }
    }
}

// MARK: - Action
extension UploadResourceController {
    @objc private func submitAction() {
        viewModel.uploadImages()
    }
    
    private func setActions() {
        let count = 30
        picsView.viewModel.maxCount = count
        picsView.addClosure = { [weak self] in
            TZImagePickerController.commonPresent(from: self, maxCount: count, selectedModels: self?.viewModel.selectedModelsProperty.value, delegate: self)
        }
        
        picsView.deleteClosure = { [weak self] idx, data in
            self?.viewModel.removeAt(index: idx)
        }
    }
    
    @objc private func recordAction() {
        let vc = UploadHistoryController()
        push(vc)
    }
}

// MARK: - Network
extension UploadResourceController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        viewModel.selectedModelsProperty.value = picker.selectedModels
        viewModel.selectedImagesProperty.value = photos
    }
}

// MARK: - Helper
extension UploadResourceController {
    func updateContentHeight() {
        print(#function)
        contentView.layoutHeight()
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.zz_height)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: max(contentView.zz_height, UIScreen.zz_safeFrameUnderNavigation.height) + 50)
    }
}
