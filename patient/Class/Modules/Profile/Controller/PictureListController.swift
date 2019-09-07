//
//  PictureListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PictureListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    var collectionView: UICollectionView!
    let viewModel = PictureListViewModel()
}

// MARK: - UI
extension PictureListController {
    override func setUI() {
        
        let paddingEdge: CGFloat = 15
        let column: CGFloat = 4
        let spacing: CGFloat = 10
        
        let itemWH = (UIScreen.zz_width - paddingEdge * 2 - (column - 1) * spacing) / column
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: paddingEdge, left: paddingEdge, bottom: paddingEdge, right: paddingEdge)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .cf
        collectionView.register(cell: PictureListCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        collectionView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension PictureListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: PictureListCell.self, for: indexPath)
        let url = viewModel.dataSourceProperty.value[indexPath.item]
        cell.imgView.kf.setImage(with: URL(string: url), placeholder: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoBrowser.showNetImage(numberOfItems: { [weak self] () -> Int in
            return self?.viewModel.dataSourceProperty.value.count ?? 0
            }, placeholder: { _ in return nil }, autoloadURLString: { [weak self] (idx) -> String? in
                return self?.viewModel.dataSourceProperty.value[idx]
        }, showAt: indexPath.item)
    }
}
