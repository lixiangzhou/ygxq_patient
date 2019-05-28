//
//  TableViewExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

extension UITableView {
    func set(dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil, separatorStyle: UITableViewCell.SeparatorStyle = .none, rowHeight: CGFloat = 44) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.separatorStyle = separatorStyle
        self.rowHeight = rowHeight
    }
    
    func register<T: UITableViewCell>(cell: T.Type) where T: IDCell {
        register(cell, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T where T: IDCell  {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

protocol IDCell {
}

extension IDCell {
    static var identifier: String { return "\(self)" }
}

