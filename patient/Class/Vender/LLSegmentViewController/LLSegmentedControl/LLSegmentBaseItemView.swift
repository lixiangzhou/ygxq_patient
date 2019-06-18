//
//  LLSegmentCtlItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/20.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

//选中的变化位置
enum LLSegmentItemViewSelectedStyle {
    /*从中间*/
    case mid
    /*从一开始0...1*/
    case gradient
    /*完全选中才变化*/
    case totalSelected
}

//自动计算返回宽度
let LLSegmentAutomaticDimension:CGFloat = -1
class LLSegmentItemViewStyle:NSObject {
    /*itemView的宽度*/
    var itemWidth:CGFloat = LLSegmentAutomaticDimension
    /*过渡变化*/
    var selectedStyle = LLSegmentItemViewSelectedStyle.gradient
}


class LLSegmentBaseItemView: UIView {
    var associateViewCtl:UIViewController?

    var contentOffsetOnRight = false
    var index = 0
    var isSelected = false
    var percent:CGFloat = 0
    var title:String = ""
    internal weak var indicatorView:LLIndicatorView!
    private var itemViewStyle = LLSegmentItemViewStyle()
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindAssociateViewCtl(ctl:UIViewController){
        associateViewCtl = ctl
    }
    
    func percentConvert()->CGFloat{
        switch itemViewStyle.selectedStyle {
        case .gradient:
            return percent
        case .mid:
            if percent >= 0.5 {
                return 1
            }else{
                return 0
            }
        case .totalSelected:
            if isSelected == true {
                return 1
            }else{
                return 0
            }
        }
    }

    func percentChange(percent:CGFloat){
        if percent == 1 {
            self.isSelected = true
        }else if percent == 0 {
            self.isSelected = false
        }
        self.percent = percent
    }

    //override for subClass
    func titleChange(title:String){ self.title = title }
    func itemWidth() ->CGFloat { return 0 }
    func setSegmentItemViewStyle(itemViewStyle:LLSegmentItemViewStyle) { self.itemViewStyle=itemViewStyle }
}
