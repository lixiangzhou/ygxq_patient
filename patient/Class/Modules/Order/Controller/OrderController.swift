//
//  OrderController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

enum OrderState {
    case toPay
    case payed
    case refund
}

class OrderController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的订单"
        setUI()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension OrderController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "开发票", style: .plain, target: self, action: #selector(getTicketAction))
        
        loadSegmentedConfig()
    }
    
    func loadSegmentedConfig() {
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let toPayVC = OrderListController()
        toPayVC.title = "待支付"
        toPayVC.state = .toPay
        
        let payedVC = OrderListController()
        payedVC.title = "已支付"
        payedVC.state = .payed
        
        let refundVC = OrderListController()
        refundVC.title = "退款"
        refundVC.state = .refund
        
        reloadViewControllers(ctls:[toPayVC, payedVC, refundVC])
    }
    
    func setUpSegmentStyle() {
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.selectedColor = UIColor.c3
        itemStyle.unSelectedColor = UIColor.c407cec
        itemStyle.selectedTitleScale = 1
        itemStyle.titleFontSize = 17
        itemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)//如果不指定是自动适配的
        //这里可以继续增加itemStyle的其他配置项... ...
        
        segmentCtlView.backgroundColor = UIColor.white
        
//        segmentCtlView.separatorLineShowEnabled = true //间隔线显示，默认不显示
        //还有其他配置项：颜色、宽度、上下的间隔...
        
        segmentCtlView.bottomSeparatorStyle = (1, UIColor.cdcdcdc) //分割线:默认透明色
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 30)//横杆宽度:有默认值
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)//横杆位置:有默认值
        segmentCtlView.indicatorView.backgroundColor = .c407cec
        segmentCtlView.indicatorView.shapeStyle = .custom //形状样式:有默认值
        
        var segmentedCtlStyle = LLSegmentedControlStyle()
        segmentedCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self  //ItemView和ItemViewStyle要统一对应
        segmentedCtlStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentedCtlStyle)
    }
}

// MARK: - Action
extension OrderController {
    @objc private func getTicketAction() {
        
    }
}

// MARK: - Network
extension OrderController {
    
}

// MARK: -
extension OrderController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
