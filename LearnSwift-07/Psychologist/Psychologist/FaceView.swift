//
//  FaceView.swift
//  Happiness
//
//  Created by xayoung on 16/4/9.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import UIKit

//声明datasource协议，这里需要把FaceVireDataSource变成一个类才能实现的协议，
protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double?
}
//实时在stroybord现实代码描绘的view
@IBDesignable
class FaceView: UIView {
    
    @IBInspectable //实时显示在stroybord设置栏中
    //线宽，设置时调用setNeedsDisplay
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    @IBInspectable //实时显示在stroybord设置栏中
    //颜色,同理
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    
    @IBInspectable //实时显示在stroybord设置栏中
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    //中心位置
    var faceCenter:CGPoint {
        //获取superview的center，并转换成point返回
        return convertPoint(center, fromView: superview)
    }
    //半径
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    //把FaceVireDataSource变成一个类才能实现的协议这里才可以设为weak指针
    weak var dataSource: FaceViewDataSource?
    
    //双指手势处理
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    //常量
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0 , endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath{
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPointMake(faceCenter.x - mouthWidth / 2, faceCenter.y + mouthVerticalOffset)
        let end = CGPointMake(start.x + mouthWidth, start.y)
        let cp1 = CGPointMake(start.x + mouthWidth / 3, start.y + smileHeight)
        let cp2 = CGPointMake(end.x - mouthWidth / 3, cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI ) , clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        //使用操作符？？，左侧有值使用它的值，左侧为nil时则使用右侧
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }


}
