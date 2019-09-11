//
//  PictureSelectView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PictureSelectView: BaseView {
    
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
    var config: Config? {
        didSet {
            guard let config = config else { return }
            
            let itemWH = (config.width - CGFloat(config.column - 1) * config.xSpacing) / CGFloat(config.column)
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: itemWH, height: itemWH)
            layout.minimumLineSpacing = config.ySpacing
            layout.minimumInteritemSpacing = config.xSpacing
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    var itemSize: CGSize {
        return (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    }
    
    var collectionView: UICollectionView!
    
    let viewModel = PictureSelectViewModel()
    
    var deleteClosure: ((Int, ImageData) -> Void)?
    var addClosure: (() -> Void)?
    var pictureClosure: ((ImageData) -> Void)?
}

// MARK: - UI
extension PictureSelectView {
    private func setUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .cf
        collectionView.register(cell: PicCell.self)
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setBinding() {
        collectionView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Action
extension PictureSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: PicCell.self, for: indexPath)
        cell.data = viewModel.dataSourceProperty.value[indexPath.item]
        
        cell.addClosure = { [weak self] in
            self?.addClosure?()
        }
        
        cell.deleteClosure = { [weak self] data in
            self?.deleteClosure?(indexPath.row, data)
        }
        
        cell.pictureClosure = { [weak self] data in
            guard let self = self, let config = self.config else { return }
            
            let picShow = {
                PhotoBrowser.showLocalImage(numberOfItems: { () -> Int in
                    return self.viewModel.imgsCount
                }, localImage: { (idx) -> UIImage? in
                    switch self.viewModel.dataSourceProperty.value[idx] {
                    case .empty: return nil
                    case let .data(image: image): return image
                    }
                }, showAt: indexPath.row)
            }
            
            switch config.picAction {
            case .onlyAction:
                self.pictureClosure?(data)
            case .onlyPicShow:
                picShow()
            case .both:
                self.pictureClosure?(data)
                picShow()
            }
        }
        
        return cell
    }
}

// MARK: - Other
extension PictureSelectView {
    class PicCell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(imgView)
            
            delView.addTarget(self, action: #selector(delAction), for: .touchUpInside)
            addSubview(delView)
            
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
                        
            imgView.snp.makeConstraints { (make) in
                make.top.left.equalTo(5)
                make.right.bottom.equalTo(-5)
            }
            
            delView.snp.makeConstraints { (make) in
                make.right.top.equalToSuperview()
                make.width.height.equalTo(15)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let imgView = UIImageView()
        let delView = UIButton(backgroundImageName: "picture_del")
        
        var deleteClosure: ((ImageData) -> Void)?
        var addClosure: (() -> Void)?
        var pictureClosure: ((ImageData) -> Void)?
        
        var data: ImageData = .empty {
            didSet {
                switch data {
                case .empty:
                    imgView.image = UIImage(named: "picture_add")
                    delView.isHidden = true
                case let .data(image: image):
                    imgView.image = image
                    delView.isHidden = false
                }
            }
        }
        
        @objc private func delAction() {
            deleteClosure?(data)
        }
        
        @objc private func tapAction() {
            switch data {
            case .empty:
                addClosure?()
            case .data:
                pictureClosure?(data)
            }
        }
    }

    enum ImageData {
        case empty
        case data(image: UIImage)
    }
    
    struct Config {
        let width: CGFloat
        let column: Int
        let xSpacing: CGFloat
        let ySpacing: CGFloat
        let picAction: Mode
        
        enum Mode {
            case onlyPicShow
            case onlyAction
            case both
        }
        
        var itemSize: CGSize {
            let itemWH = (width - CGFloat(column - 1) * xSpacing) / CGFloat(column)
            return CGSize(width: itemWH, height: itemWH)
        }
        
        static func defaultConfig() -> Config {
            return PictureSelectView.Config(width: UIScreen.zz_width - 30, column: 4, xSpacing: 5, ySpacing: 5, picAction: .onlyPicShow)
        }
    }
}

// MARK: - Public
extension PictureSelectView {
    
}
