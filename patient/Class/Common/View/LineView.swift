//
//  LineView.swift
//  sphr-doctor-iOS
//
//  Created by lixiangzhou on 2019/8/9.
//  Copyright © 2019 qingsong. All rights reserved.
//

import UIKit

class LineView: BaseView {
    
    struct LineModel {
        var lineColor: UIColor
        var string: String
        
        var values: [Int]
    }
    
    // MARK: - Config
    var pointXs: [String]?
    /// 确保每个 LineModel 的 values 个数相同
    var pointYs: [LineModel]?
    
    var lineColor = UIColor.c6
    var xItemWidthMin: CGFloat = 20
    var showTop = true
    var showInfoView = true
    // 线图距离上下左右的距离
    var leftPadding: CGFloat = 45
    var bottomPadding: CGFloat = 65
    var topPadding: CGFloat = 30
    var rightPadding: CGFloat = 10
    
    var maxYValue: Int?
    var rowCountValue: Int?
    
    var lineWidth: CGFloat = 1
    var pointRadius: CGFloat = 2.5
    var pointWidth: CGFloat = 1.5
    
    var selectClosure: ((Int) -> Void)?
    
    private var itemWidth: CGFloat = 0
    
    private var panGesture: UIPanGestureRecognizer?
    private let infoView = InfoView()
    
    func refreshViews() {
        for v in subviews {
            v.removeFromSuperview()
        }
        gestureRecognizers?.removeAll()
        guard let pointXs = pointXs, let pointYs = pointYs, pointXs.count > 0, pointYs.count > 0 else {
            return
        }
        
        let width = frame.width
        let height = frame.height
        let count = pointXs.count
        
        var maxY = 0
        if let maxYValue = maxYValue {
            maxY = maxYValue
        } else {
            for model in pointYs {
                if model.values.max()! > maxY {
                    maxY = model.values.max()!
                }
            }
            
            maxY = Int(SCTool.rangeMax(withValueMax: CGFloat(maxY)))
        }
        
        var rowCount = 0
        
        
        if let rowCountValue = rowCountValue {
            rowCount = rowCountValue
        } else {
            rowCount = SCTool.rowCount(withValueMax: CGFloat(maxY))
            rowCount = rowCount == 0 ? 5 : rowCount
        }
        
        // 每行的范围
        let rowRange = CGFloat(maxY) / CGFloat(rowCount)
        
        let scrollWidth = width - leftPadding - rightPadding
        let scrollHeight = height - topPadding
        let panelHeight = scrollHeight - bottomPadding
        
        let rowHeight = panelHeight / CGFloat(rowCount)
        itemWidth = max(scrollWidth / CGFloat(count), xItemWidthMin)
        
        if showTop {        
            let descView = UIView(frame: CGRect(x: leftPadding, y: 0, width: scrollWidth, height: topPadding))
            addSubview(descView)
            addDescView(pointYs, to: descView)
        }
        
        
        // 纵坐标的值
        let yItemW = leftPadding - 5
        let yItemH: CGFloat = 15
        for row in 0...rowCount {
            let yLabel = UILabel(text: String(format: "%.0f", rowRange * CGFloat(rowCount - row)), font: .size(10), textColor: .c3, textAlignment: .right)
            
            yLabel.frame = CGRect(x: 0,
                                  y: topPadding + CGFloat(row) * rowHeight - yItemH * 0.5,
                                  width: yItemW, height: yItemH)
            addSubview(yLabel)
        }
        
        let scrollView = UIScrollView(frame: CGRect(x: leftPadding, y: topPadding, width: scrollWidth, height: scrollHeight))
        let contentWidth = itemWidth * CGFloat(count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollHeight)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        if contentWidth > scrollWidth {
            scrollView.contentOffset = CGPoint(x: contentWidth - scrollWidth, y: 0)
        }
        addSubview(scrollView)
        
        for model in pointYs {
            // 画线、点、横坐标
            let path = UIBezierPath()
            let values = model.values
            
            for i in 0..<count {
                let py = CGFloat(values[i])
                
                let x = itemWidth * CGFloat(CGFloat(i) + 0.5)
                // 2.5 是圆点的半径
                let y = (1 - py / CGFloat(maxY)) * panelHeight
                
                let point = CGPoint(x: x, y: y)
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                
                // 横坐标的分割点
                let xLine = UIView(frame: CGRect(x: itemWidth * CGFloat(i), y: panelHeight - 2, width: 1, height: 2))
                xLine.backgroundColor = lineColor
                scrollView.addSubview(xLine)
                
                // 点
                let pView = UIView(frame: CGRect(x: 0, y: 0, width: pointRadius * 2, height: pointRadius * 2))
                pView.center = point
                pView.zz_setCorner(radius: pointRadius, masksToBounds: true)
                pView.zz_setBorder(color: model.lineColor, width: pointWidth)
                scrollView.addSubview(pView)
            }
            
            let line = CAShapeLayer()
            line.lineWidth = lineWidth
            line.lineJoin = .bevel
            line.lineCap = .round
            line.strokeColor = model.lineColor.cgColor
            line.fillColor = nil
            line.path = path.cgPath
            scrollView.layer.addSublayer(line)
        }
        
        // 横坐标
        for i in 0..<count {
            let w: CGFloat = 100
            let xLabel = UILabel(text: pointXs[i], font: .size(10), textColor: .c3, numOfLines: 1, textAlignment: .center)
            xLabel.frame = CGRect(x: CGFloat(i) * itemWidth - (w - itemWidth) * 0.5, y: panelHeight + 3, width: w , height: bottomPadding - 3)
//            xLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            scrollView.addSubview(xLabel)
        }
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        panGesture?.maximumNumberOfTouches = 1
        panGesture?.delegate = self
        scrollView.addGestureRecognizer(panGesture!)
        
        
        let yLine = UIView()
        yLine.backgroundColor = lineColor
        yLine.frame = CGRect(x: leftPadding, y: topPadding, width: 0.5, height: panelHeight)
        addSubview(yLine)
        
        for row in 0...rowCount {
            let xLine = UIView()
            
            xLine.frame = CGRect(x: 0,
                                 y: CGFloat(row) * rowHeight,
                                 width: contentWidth, height: 0.5)
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.lineWidth = 0.5
            if row < rowCount {
                shapeLayer.lineDashPattern = [3, 3]
            }
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: xLine.frame.maxX, y: 0))
            shapeLayer.path = path
            xLine.layer.addSublayer(shapeLayer)
            scrollView.addSubview(xLine)
        }
    }
    
    private func addDescView(_ models: [LineModel], to view: UIView) {
        let width = view.zz_width * 0.5
        for (idx, model) in models.enumerated() {
            let label = UILabel(text: "", font: .boldSize(12), textColor: .c3)
            let attr = NSMutableAttributedString(string: "●", attributes: [NSAttributedString.Key.foregroundColor: model.lineColor])
            attr.append(NSAttributedString(string: model.string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.c3]))
            label.attributedText = attr
            let col = idx % 2
            let row = idx / 2
            label.frame = CGRect(x: CGFloat(col) * width, y: CGFloat(row * 20), width: width, height: CGFloat(15))
            view.addSubview(label)
        }
    }
}

extension LineView {
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        let view = tap.view as! UIScrollView
        
        if showInfoView {
            changeInfoView(tap)
            infoView.alpha = 1
            view.addSubview(infoView)
        }
        
        selectAction(tap)
    }
    
    @objc func panAction(_ pan: UITapGestureRecognizer) {
        let view = pan.view as! UIScrollView
        
        if showInfoView {
            switch pan.state {
            case .began:
                changeInfoView(pan)
                infoView.alpha = 1
                view.addSubview(infoView)
            case .changed:
                changeInfoView(pan)
            default:
                hideInfoView()
                break
            }
        }
        
        selectAction(pan)
    }
    
    private func changeInfoView(_ ges: UIGestureRecognizer) {
        guard let pointXs = pointXs, let pointYs = pointYs, pointXs.count > 0, pointYs.count > 0 else {
            return
        }
        
        let view = ges.view as! UIScrollView
        let point = ges.location(in: view)
        
        if point.y < 0 || point.x - view.contentOffset.x < 0 || view.zz_height - bottomPadding - point.y < 0 || view.contentOffset.x + view.zz_width - point.x < 0 {
            return
        }
        
        let idx = Int(point.x / itemWidth)
        if idx >= pointXs.count {
            return
        }
        infoView.setModels(pointYs, at: idx)
        infoView.xLabel.text = pointXs[idx]
        
        var infoFrame = infoView.frame
        infoFrame.origin = CGPoint(x: point.x - infoFrame.width - 10, y: point.y)
        
        let marginLeft = point.x - view.contentOffset.x - infoFrame.width - 15
        let marginRight = view.contentOffset.x + view.zz_width - point.x - infoFrame.width - 15
        let marginTop = point.y - 10
        let marginBottom = view.zz_height - bottomPadding - point.y - infoFrame.height - 10
        
        if marginTop < 0 {
            infoFrame.origin.y = 5
        }
        
        if marginLeft < 0 {
            infoFrame.origin.x = point.x + 10
        }
        
        if marginRight < 0 {
        }
        
        if marginBottom < 0 {
            infoFrame.origin.y = view.zz_height - bottomPadding - infoFrame.height - 5
        }
        
        infoView.frame = infoFrame
    }
    
    private func hideInfoView() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.infoView.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.infoView.alpha = 0
        }) { (_) in
            self.infoView.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func selectAction(_ ges: UIGestureRecognizer) {
        guard let pointXs = pointXs, let pointYs = pointYs, pointXs.count > 0, pointYs.count > 0 else {
            return
        }
        
        let view = ges.view as! UIScrollView
        let point = ges.location(in: view)
        
        if point.y < 0 || point.x - view.contentOffset.x < 0 || view.zz_height - bottomPadding - point.y < 0 || view.contentOffset.x + view.zz_width - point.x < 0 {
            return
        }
        
        let idx = Int(point.x / itemWidth)
        if idx >= pointXs.count {
            return
        }
        selectClosure?(idx)
    }
}

extension LineView {
    class InfoView: UIView {
        override init(frame: CGRect) {
            let rect = CGRect(x: 0, y: 0, width: 140, height: 50)
            super.init(frame: rect)
            
            xLabel.frame = CGRect(x: 10, y: 5, width: rect.width - 20, height: 15)
            yViews.frame = CGRect(x: 10, y: xLabel.zz_maxY, width: xLabel.zz_width, height: 15)
            addSubview(xLabel)
            addSubview(yViews)
            
            zz_setBorder(color: UIColor.orange, width: 1)
            backgroundColor = .cf
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let xLabel = UILabel(text: "", font: .size(12), textColor: .c3)
        private let yViews = UIView()
        private var yLabels = [UILabel]()
        
        
        func setModels(_ models: [LineModel], at idx: Int) {
            
            var lastY: CGFloat = 0
            let width = yViews.zz_width
            for (index, model) in models.enumerated() {
                var yLabel: UILabel!
                if index < yLabels.count {
                    yLabel = yLabels[index]
                } else {
                    yLabel = UILabel(text: "", font: .size(10))
                    yViews.addSubview(yLabel)
                    yLabels.append(yLabel)
                }
                let attr = NSMutableAttributedString(string: "●", attributes: [NSAttributedString.Key.foregroundColor: model.lineColor])
                attr.append(NSAttributedString(string: "\(model.string)：\(model.values[idx])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c3]))
                yLabel.attributedText = attr
                yLabel.frame = CGRect(x: 0, y: lastY, width: width, height: 15)
                lastY = yLabel.zz_maxY
            }
            
            var yFrame = yViews.frame
            yFrame.size.height = lastY
            yViews.frame = yFrame
            
            var rect = frame
            rect.size.height = yFrame.maxY + 5
            
            frame = rect
        }
    }
}

extension LineView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let view = gestureRecognizer.view as? UIScrollView else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
        let point = gestureRecognizer.location(in: view)
        if point.x >= 0 && point.x < view.contentSize.width && point.y >= 0 && point.y <= view.frame.height - bottomPadding {
            return true
        } else {
            return false
        }
    }
}
