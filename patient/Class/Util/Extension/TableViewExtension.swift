//
//  TableViewExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

extension UITableView {
    func set(dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil, separatorStyle: UITableViewCell.SeparatorStyle = .none, rowHeight: CGFloat = 50) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.separatorStyle = separatorStyle
        self.rowHeight = rowHeight
    }
    
    func register<T: UITableViewCell>(cell: T.Type) where T: IDView {
        register(cell, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T where T: IDView  {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) where T: IDView {
        register(cell, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T where T: IDView  {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

protocol IDView {
}

extension IDView {
    static var identifier: String { return "\(self)" }
}

