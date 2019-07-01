//
//  UploadResourceController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

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
    
    private let tableView = UITableView()
    private let descLabel = UILabel(font: .size(15), textColor: .c6)
    private let viewModel = UploadResourceViewModel()
    private let headerTipView = UploadResourceHeaderTipView()
}

// MARK: - UI
extension UploadResourceController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self, rowHeight: viewModel.rowHeight)
        tableView.register(cell: UploadResourceCell.self)
        headerTipView.textLabel.text = tipString
        headerTipView.zz_height = viewModel.getHeaderSize(tipString).height
        tableView.tableHeaderView = headerTipView
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
        footer.backgroundColor = .cf
        tableView.tableFooterView = footer
        view.addSubview(tableView)
        
        let submitBtn = UIButton(title: "提交", font: .size(18), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(submitAction))
        view.addSubview(submitBtn)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.skipRepeats().map(value: ())
    }
}

// MARK: - Action
extension UploadResourceController {
    @objc private func submitAction() {
        viewModel.uploadImages().startWithValues { (urls) in
            print(urls)
            if let urls = urls {
                HUD.show(toast: "上传成功")
            } else {
                HUD.show(toast: "上传失败")
            }
        }
    }
}

// MARK: - Network
extension UploadResourceController {
    
}

// MARK: - Delegate Internal

// MARK: - UITableViewDataSource
extension UploadResourceController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: UploadResourceCell.self, for: indexPath)
        
        let items = viewModel.itemsInRow(indexPath.row)
        
        for (idx, itemView) in cell.itemViews.enumerated() {
            if idx <= items.count - 1 {
                itemView.isHidden = false
                let item = items[idx]
                itemView.imgView.image = item.image
                itemView.delView.isHidden = false
                itemView.tapClosure = { [weak self] view in
                    guard let self = self else { return }
                    if indexPath.row == 0 && idx == 0 { // 打开相册
                        let ops = HEPickerOptions()
                        ops.maxCountOfImage = 30
                        ops.mediaType = .image
                        let picker = HEPhotoPickerViewController(delegate: self, options: ops)
                        self.hePresentPhotoPickerController(picker: picker, animated: true)
                    } else {    // 点击图片
                        
                    }
                }
                
                itemView.delClosure = { [weak self] view in
                    guard let self = self else { return }
                    self.viewModel.delItem(item)
                }
            } else {
                itemView.isHidden = true
            }
        }
        
        return cell
    }
}


// MARK: - Delegate External

// MARK: -

extension UploadResourceController: HEPhotoPickerViewControllerDelegate {
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        viewModel.addImages(selectedImages)
    }
}

//extension UploadResourceController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            let item = UploadResourceViewModel.ImageItem(url: nil, image: image)
//            viewModel.addItem(item)
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        navigationController.navigationBar.setBackgroundImage(UIImage.zz_image(withColor: UIColor.c407cec.withAlphaComponent(0.95)), for: .default)
//        navigationController.navigationBar.shadowImage = nil
//    }
//}

// MARK: - Helper
extension UploadResourceController {
    
}

// MARK: - Other
extension UploadResourceController {
    
}

// MARK: - Public
extension UploadResourceController {
    
}

