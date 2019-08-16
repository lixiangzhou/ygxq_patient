//
//  SelectDistrictView.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SelectDistrictView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setUI()
        setBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var completion: ((AreaModel) -> Void)?
    
    
    // MARK: - Private Property
    
    private var provinceBtn: UIButton!
    private var cityBtn: UIButton!
    private var districtBtn: UIButton!
    private var selectBtn: UIButton!
    
    private let headerLine = UIView()
    
    private let scrollView = UIScrollView()
    private let provincesTableView = UITableView()
    private let citysTableView = UITableView()
    private let districtsTableView = UITableView()
    
    private let viewModel = SelectDistrictViewModel()
}

// MARK: - UI
extension SelectDistrictView {
    private func setUI() {
        backgroundColor = .clear
        let backView = zz_add(subview: UIView())
        backView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        let contentView = zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        
        let titleLabel = UILabel(text: "选择地区", font: .size(18), textColor: .c3, textAlignment: .center)
        contentView.addSubview(titleLabel)
        
        let headerView = contentView.zz_add(subview: UIView())
        
        provinceBtn = headerView.zz_add(subview: UIButton(title: "请选择", font: .size(15), titleColor: .c3, target: self, action: #selector(areaAction))) as? UIButton
        cityBtn = headerView.zz_add(subview: UIButton(title: "请选择", font: .size(15), titleColor: .c3, target: self, action: #selector(areaAction))) as? UIButton
        districtBtn = headerView.zz_add(subview: UIButton(title: "请选择", font: .size(15), titleColor: .c3, target: self, action: #selector(areaAction))) as? UIButton
        
        provinceBtn.isSelected = true
        selectBtn = provinceBtn
        
        provinceBtn.tag = ViewType.province.rawValue
        cityBtn.tag = ViewType.city.rawValue
        districtBtn.tag = ViewType.district.rawValue
        
        provinceBtn.setTitleColor(.c407cec, for: .selected)
        cityBtn.setTitleColor(.c407cec, for: .selected)
        districtBtn.setTitleColor(.c407cec, for: .selected)
        
        headerLine.backgroundColor = .c407cec
        headerView.addSubview(headerLine)
        
        scrollView.isPagingEnabled = true
        contentView.addSubview(scrollView)
        
        provincesTableView.set(dataSource: self, delegate: self, rowHeight: 44)
        citysTableView.set(dataSource: self, delegate: self, rowHeight: 44)
        districtsTableView.set(dataSource: self, delegate: self, rowHeight: 44)
        
        provincesTableView.register(cell: DistrictCell.self)
        citysTableView.register(cell: DistrictCell.self)
        districtsTableView.register(cell: DistrictCell.self)
        
        provincesTableView.tag = ViewType.province.rawValue
        citysTableView.tag = ViewType.city.rawValue
        districtsTableView.tag = ViewType.district.rawValue
        
        scrollView.addSubview(provincesTableView)
        scrollView.addSubview(citysTableView)
        scrollView.addSubview(districtsTableView)
        
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(-150)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        provinceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
        }
        
        cityBtn.snp.makeConstraints { (make) in
            make.left.equalTo(provinceBtn.snp.right)
            make.width.top.bottom.equalTo(provinceBtn)
        }
        
        districtBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cityBtn.snp.right)
            make.width.top.bottom.equalTo(provinceBtn)
        }
        
        headerLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(provinceBtn).offset(0)
            make.width.equalTo(80)
            make.height.equalTo(2)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.height.equalToSuperview()
        }
        
        provincesTableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalToSuperview()
            make.bottom.equalTo(contentView)
            make.width.equalTo(UIScreen.zz_width)
        }
        
        citysTableView.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(provincesTableView)
            make.left.equalTo(provincesTableView.snp.right)
        }
        
        districtsTableView.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(provincesTableView)
            make.left.equalTo(citysTableView.snp.right)
        }
    }
    
    private func setBinding() {
        provinceBtn.reactive.title <~ viewModel.selectProvinceProperty.map { $0?.name ?? "请选择" }
        cityBtn.reactive.title <~ viewModel.selectCityProperty.map { $0?.name ?? "请选择" }
        districtBtn.reactive.title <~ viewModel.selectDistrictProperty.map { $0?.name ?? "请选择" }
        
        cityBtn.reactive.isHidden <~ viewModel.selectProvinceProperty.map { $0 == nil ? true : false }
        districtBtn.reactive.isHidden <~ viewModel.selectCityProperty.map { $0 == nil ? true : false }
        
        // 有数据时变化时刷新
        provincesTableView.reactive.reloadData <~ viewModel.provincesProperty.map(value: ())
        citysTableView.reactive.reloadData <~ viewModel.citysProperty.map(value: ())
        districtsTableView.reactive.reloadData <~ viewModel.districtsProperty.map(value: ())
        
        //
        viewModel.selectCityProperty <~ viewModel.selectProvinceProperty.map(value: nil)
        viewModel.selectDistrictProperty <~ viewModel.selectCityProperty.map(value: nil)
        
        viewModel.citysProperty <~ viewModel.selectProvinceProperty.map(value: [AreaModel]())
        viewModel.districtsProperty <~ viewModel.selectCityProperty.map(value: [AreaModel]())
        
        viewModel.contentSizeProperty <~ viewModel.selectProvinceProperty.signal.map { CGSize(width: UIScreen.zz_width * ($0 == nil ? 1 : 2), height: 0) }
        viewModel.contentSizeProperty <~ viewModel.selectCityProperty.signal.map { CGSize(width: UIScreen.zz_width * ($0 == nil ? 2 : 3), height: 0) }
        viewModel.contentSizeProperty <~ viewModel.selectDistrictProperty.signal.map(value: CGSize(width: UIScreen.zz_width * 3, height: 0))
        
        scrollView.reactive.makeBindingTarget { $0.contentSize = $1 } <~ viewModel.contentSizeProperty
        
        viewModel.contentSizeProperty.producer.startWithValues{ print("Size ==> ", $0) }
    }
}

// MARK: - Action
extension SelectDistrictView {
    @objc private func areaAction(_ sender: UIButton) {
        if sender == selectBtn {
            return
        }
        sender.isSelected = true
        selectBtn.isSelected = false
        selectBtn = sender
        
        headerLine.snp.updateConstraints { (make) in
            make.left.equalTo(provinceBtn).offset(sender.tag * 80)
        }
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * UIScreen.zz_width, y: 0), animated: true)
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Helper
extension SelectDistrictView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getModels(type: tableView.tag).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: DistrictCell.self, for: indexPath)
        let model = viewModel.getModel(type: tableView.tag, indexPath: indexPath)
        cell.nameLabel.text = model.name
        cell.backgroundColor = model.isSelect ? UIColor(white: 0, alpha: 0.1) : .cf
        cell.selView.isHidden = !model.isSelect
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.selectModel(type: tableView.tag, indexPath: indexPath)
        
        if tableView == provincesTableView {
            areaAction(cityBtn)
        } else if tableView == citysTableView {
            areaAction(districtBtn)
        } else {
            hide()
            completion?(model)
        }
    }
}

// MARK: - Other
extension SelectDistrictView {
    enum ViewType: Int {
        case province
        case city
        case district
    }
}

// MARK: - Public
extension SelectDistrictView {
    override func show() {
        super.show()
        viewModel.getProvinces()
    }
    
    static func show() -> SelectDistrictView {
        let view = SelectDistrictView()
        view.show()
        return view
    }
}

private class DistrictCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(selView)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        selView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let nameLabel = UILabel(font: .size(15), textColor: .c3)
    let selView = UIImageView(image: UIImage(named: "common_arrow_right"))
}
