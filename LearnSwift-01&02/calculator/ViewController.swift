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
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        //给preformOperationx传入函数{ $0 * $1 }，返回一个double
        case "×": preformOperationx(){ $0 * $1 }
        case "÷": preformOperationx(){ $1 / $0 }
        case "+": preformOperationx(){ $0 + $1 }
        case "-": preformOperationx(){ $1 - $0 }
        //函数虽然同名，但是swift会推断传入的参数调用哪个方法
        case "√": preformOperationx(){ sqrt($0)}
        default:break
        }
    }
    //自定义函数，复用运算的代码
   private func preformOperationx(operation:(Double, Double)-> Double) {
        if operandStark.count >= 2 {
            displayValue = operation(operandStark.removeLast() , operandStark.removeLast())
            enter()
        }
    }
    private func preformOperationx(operation:(Double)-> Double) {
        if operandStark.count >= 1 {
            displayValue = operation(operandStark.removeLast())
            enter()
        }
    }

    //定义数组,作为栈存储输入的数
    var  operandStark:Array<Double> = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStark.append(displayValue)
        print("operandStark = \(operandStark)")
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

