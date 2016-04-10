//
//  HappinessViewController.swift
//  Happiness
//
//  Created by xayoung on 16/4/9.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    //设置datasource代理
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            
        }
    }
    
    private struct Constrants {
        static let HappinessGestureScale: CGFloat = 4
    }

    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            fallthrough
        case .Changed:
            //获取手指拖动改变的translation
            let translation = gesture.translationInView(faceView)
            //改变比例
            let happinessChange = -Int(translation.y / Constrants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                //重置，每次改变跟着改变，保证增量变化
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:
            break
        }
    }
    var happiness: Int  = 10 {
        didSet{
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI() {
        faceView.setNeedsDisplay()
    }

    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50)/50
    }
}
