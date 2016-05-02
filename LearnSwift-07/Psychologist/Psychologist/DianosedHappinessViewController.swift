//
//  DianosedHappinessViewController.swift
//  Psychologist
//
//  Created by xayoung on 16/5/2.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import UIKit

class DianosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate{
    override var happiness: Int{
        //先执行父类didSet，后执行子类的didSet。不会覆盖
        didSet{
            dianosticHistory += [happiness]
        }
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    var dianosticHistory: [Int] {
        get{ return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? [] }
        set{ defaults.setObject(newValue, forKey: History.DefaultsKey) }
    }
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DianosedHappinessViewController.History"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController{
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(dianosticHistory)"
                }
            default: break
            }
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        //在iPhone上不做处理
        return UIModalPresentationStyle.None
    }
}
