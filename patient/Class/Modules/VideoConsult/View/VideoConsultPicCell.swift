//
//  VideoConsultPicCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultPicCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    var collectionView: UICollectionView!
    
    var dataSource = [ImageModel]() {
        didSet {
            collectionView.reloadData()
            
            let row = ceil(Double(dataSource.count) / 4.0)
            let height = (row - 1) * 10 + row * Double(itemWidth)
            
            imgsView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
        }
    }
    // MARK: - Private Property
    private let itemWidth = floor((UIScreen.zz_width - 30 - 30) / 4)
    private let imgsView = UIView()
}

// MARK: - UI
extension VideoConsultPicCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "图片资料"
        contentView.addSubview(titleView)
        
        imgsView.backgroundColor = .red
        contentView.addSubview(imgsView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width - 30, height: itemWidth), collectionViewLayout: layout)
//        collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: ImageCell.self)
        collectionView.backgroundColor = .cf
        imgsView.addSubview(collectionView)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        imgsView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(itemWidth)
            make.bottom.equalTo(-12)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Delegate
extension VideoConsultPicCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ImageCell.self, for: indexPath)
        cell.imgView.kf.setImage(with: URL(string: dataSource[indexPath.item].mediaUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoBrowser.showNetImage(numberOfItems: { [weak self] () -> Int in
            return self?.dataSource.count ?? 0
        }, placeholder: { (index) -> UIImage? in
            return nil
        }, autoloadURLString: { [weak self] (index) -> String? in
            return self?.dataSource[index].mediaUrl
        })
    }
}

extension VideoConsultPicCell {
    class ImageCell: UICollectionViewCell {
        let imgView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .cf0efef
            
            contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
