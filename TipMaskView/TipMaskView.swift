//
//  TipMaskView.swift
//  FeeCloudsPE
//
//  Created by 王浩 on 2019/8/2.
//  Copyright © 2019 haoge. All rights reserved.
//
import UIKit

class TipMaskView: UIControl {
    
    fileprivate let strokeColor = UIColor(white: 0, alpha: 0).cgColor
    fileprivate let fillColor = UIColor(white: 0, alpha: 0.6).cgColor
    fileprivate let kMarkerWidth: CGFloat = 70
    fileprivate let kMarkerHeight: CGFloat = 44
    fileprivate let kTextHPadding: CGFloat = 15
    fileprivate let kCornerRadius: CGFloat = 5
    
    fileprivate let kArrowWidth: CGFloat = 10
    fileprivate let kArrowHeight: CGFloat = 10
    fileprivate let kverticalThreshold: CGFloat = 60
    fileprivate let kHorizontalThreshold: CGFloat = 25
    fileprivate var tapFrame: CGRect!
    // text
    fileprivate var drawText: NSString?
    fileprivate var drawAttributes: [NSAttributedString.Key : Any] = {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.lineSpacing = 4
        paragraphStyle?.alignment = .left
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        return attributes
    }()
    
    // size
    fileprivate var parentWidth: CGFloat = 0
    fileprivate var realSize: CGSize = CGSize()
    fileprivate var point: CGPoint!
    init(frame: CGRect, tapFrame: CGRect) {
        super.init(frame: frame)
        self.tapFrame = tapFrame
        self.parentWidth = frame.width
        self.backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if (drawText == nil) {
            return
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let arrowDown = (self.frame.height-tapFrame.maxY) < realSize.height ? true : false

        var point = CGPoint.zero
        if arrowDown {
            point = CGPoint(x: tapFrame.midX, y: tapFrame.minY)
        } else {
            point = CGPoint(x: tapFrame.midX, y: tapFrame.maxY)
        }
        
        var rect = CGRect(origin: point, size: realSize)
        if arrowDown {
            rect.origin.y -= realSize.height
        }
        if point.x < realSize.width / 2 {
            rect.origin.x -= kCornerRadius + kArrowWidth / 2 /*至少的偏移 半径+半个三角*/
                + (point.x - kCornerRadius - kArrowWidth / 2) * 0.8 /*动态的偏移*/
        } else if parentWidth - point.x < kHorizontalThreshold {
            rect.origin.x -= realSize.width
        } else if parentWidth - point.x < realSize.width / 2 {
            let right = kCornerRadius + kArrowWidth / 2 + (parentWidth - point.x - kCornerRadius - kArrowWidth / 2) * 0.8
            rect.origin.x -= realSize.width - right
        } else {
            rect.origin.x -= realSize.width / 2
        }
        let minx = rect.minX, maxx = rect.maxX
        let miny = rect.minY, maxy = rect.maxY
        
        ctx?.saveGState()
        
        // color
        ctx?.setLineWidth(1)
        ctx?.setStrokeColor(strokeColor)
        ctx?.setFillColor(fillColor)
        // balloon
        ctx?.beginPath()
        if point.x < kHorizontalThreshold {
            if arrowDown {
                ctx?.move(to: CGPoint(x: point.x + kArrowWidth/2, y: maxy - kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: maxy))
                ctx?.addLine(to: CGPoint(x: point.x, y: maxy - kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x-kArrowWidth/2, y: maxy - kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: minx-kArrowWidth/2, y: miny), tangent2End: CGPoint(x: maxx, y: miny), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxy - kArrowHeight), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: maxy - kArrowHeight), tangent2End: CGPoint(x: minx, y: maxy - kArrowHeight), radius: kCornerRadius)
            } else {
                ctx?.move(to: CGPoint(x: point.x, y: miny + kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: miny))
                ctx?.addLine(to: CGPoint(x: point.x + kArrowWidth/2, y: miny + kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: miny + kArrowHeight), tangent2End: CGPoint(x: maxx, y: maxy), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: minx, y: maxy), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny + kArrowHeight), radius: kCornerRadius)
            }
            
        } else if parentWidth - point.x < kHorizontalThreshold {
            if arrowDown {
                ctx?.move(to: CGPoint(x: point.x, y: maxy - kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: maxy))
                ctx?.addLine(to: CGPoint(x: point.x - kArrowWidth/2, y: maxy - kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: maxy - kArrowHeight), tangent2End: CGPoint(x: minx, y: miny), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: miny), tangent2End: CGPoint(x: maxx, y: miny), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxy - kArrowHeight), radius: kCornerRadius)
            } else {
                ctx?.move(to: CGPoint(x: point.x - kArrowWidth/2, y: miny + kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: miny))
                ctx?.addLine(to: CGPoint(x: point.x, y: miny + kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: minx, y: maxy), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny + kArrowHeight), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: miny + kArrowHeight), tangent2End: CGPoint(x: maxx, y: miny + kArrowHeight), radius: kCornerRadius)
            }
            
        } else {
            if arrowDown {
                ctx?.move(to: CGPoint(x: point.x + kArrowWidth/2, y: maxy - kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: maxy))
                ctx?.addLine(to: CGPoint(x: point.x - kArrowWidth/2, y: maxy - kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: maxy - kArrowHeight), tangent2End: CGPoint(x: minx, y: miny), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: miny), tangent2End: CGPoint(x: maxx, y: miny), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxy - kArrowHeight), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: maxy - kArrowHeight), tangent2End: CGPoint(x: minx, y: maxy - kArrowHeight), radius: kCornerRadius)
                
            } else {
                ctx?.move(to: CGPoint(x: point.x - kArrowWidth/2, y: miny + kArrowHeight))
                ctx?.addLine(to: CGPoint(x: point.x, y: miny))
                ctx?.addLine(to: CGPoint(x: point.x + kArrowWidth/2, y: miny + kArrowHeight))
                
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: miny + kArrowHeight), tangent2End: CGPoint(x: maxx, y: maxy), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: minx, y: maxy), radius: kCornerRadius)
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny + kArrowHeight), radius: kCornerRadius)
                
                ctx?.addArc(tangent1End: CGPoint(x: minx, y: miny + kArrowHeight), tangent2End: CGPoint(x: maxx, y: miny + kArrowHeight), radius: kCornerRadius)
            }
        }
        ctx?.closePath()
        ctx?.drawPath(using: .fillStroke)
        
        
        // text
        UIGraphicsPushContext(ctx!)
        if arrowDown {
            rect.origin.x += 8 + kArrowWidth
            rect.origin.y += 8
            rect.size.height -= kArrowHeight
            rect.size.width -= kArrowWidth
        } else {
            rect.origin.y += kArrowHeight + 8
            rect.size.height -= kArrowHeight
            
            rect.origin.x += kArrowWidth + 8
            rect.size.width -= kArrowWidth
        }
        
        drawText?.draw(in: rect, withAttributes: drawAttributes)
        UIGraphicsPopContext()
        
        ctx?.restoreGState()
    }
    
    func refreshContent(text: String) {
        drawText = NSString(string: text)
        let textSize = drawText?.size(withAttributes: drawAttributes) ?? CGSize.zero
        realSize.width = min(self.bounds.width-kTextHPadding * 2, textSize.width + kTextHPadding * 2)
        realSize.height = min(self.bounds.height - kTextHPadding*2 - kArrowHeight - 8, textSize.height + kTextHPadding*2 + kArrowHeight + 8)
    }
    
    func open(text: String) {
        self.refreshContent(text: text)

        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
        }, completion:nil)
        
        self.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    //MARK:--关闭
    @objc func closeAction() {
        UIView.animate(withDuration: 0.3, animations: {
        }, completion:{ (finished) in
            self.removeFromSuperview()
        })
    }
}

