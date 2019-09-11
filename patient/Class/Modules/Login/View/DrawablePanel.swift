//
//  DrawablePanel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/10.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DrawablePanel: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var lineColor = UIColor.c3
    var lineWidth: CGFloat = 3
    var placeholder = ""
    var placeholderColor = UIColor.c6
    var placeholderFont = UIFont.size(19)
    // MARK: - Private Property
    private var lines = [DrawableLine]()
    private var currentLine = DrawableLine()
}

// MARK: - UI
extension DrawablePanel {
    private func setUI() {
        
    }
}

// MARK: - Helper
extension DrawablePanel {
    class DrawableLine {
        var lines = [CGPoint]()
    }
}

// MARK: - Other
extension DrawablePanel {
    override func draw(_ rect: CGRect) {
        let bg = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        bg.fill()
        
        if lines.count > 0 {
            for nextLine in lines {
                let bezier = UIBezierPath()
                bezier.lineWidth = lineWidth
                lineColor.set()
                for (idx, point) in nextLine.lines.enumerated() {
                    if idx == 0 {
                        bezier.move(to: point)
                    } else {
                        bezier.addLine(to: point)
                    }
                }
                bezier.stroke()
            }
        } else {
            let size = placeholder.zz_size(withLimitWidth: 300, fontSize: placeholderFont.pointSize)
            let x = (zz_width - size.width) * 0.5
            let y = (zz_height - size.height) * 0.5
            (placeholder as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: [NSAttributedString.Key.font: placeholderFont, NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first, let view = touch.view else { return }
        self.currentLine = DrawableLine()
        self.lines.append(self.currentLine)
        
        let point = touch.location(in: view)
        currentLine.lines.append(point)
        setNeedsDisplay()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = touch.view else { return }
        let point = touch.location(in: view)
        currentLine.lines.append(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
}

// MARK: - Public
extension DrawablePanel {
    func clear() {
        self.currentLine = DrawableLine()
        self.lines = [DrawableLine]()
        setNeedsDisplay()
    }
    
    func getImage() -> UIImage? {
        return lines.count > 0 ? zz_snapshotImage() : nil
    }
}
