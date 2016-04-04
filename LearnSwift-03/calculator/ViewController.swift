//
//  ViewController.swift
//  LearnSwift-01
//
//  Created by xayoung on 16/4/2.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber:Bool = false
    
    var brain = CalculatorBrian()
    //点击button方法
    @IBAction func appendDigit(sender: UIButton) {
        //默认是Optional类型，通过！将button的值解包
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    //运算
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else{
                displayValue = 0
            }
        }
        
    }
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else{
            displayValue = 0
        }
    }

    var displayValue: Double{
        //实现自定义get、set方法
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            //设置显示的数字
            display.text = "\(newValue)"
            //设置用户输入状态为false
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

