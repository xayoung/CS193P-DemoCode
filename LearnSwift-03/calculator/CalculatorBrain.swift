//
//  CalculatorBrain.swift
//  calculator
//
//  Created by xayoung on 16/4/4.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import Foundation

class CalculatorBrian {
    //":CustomStringConvertible"不是继承关系，这里指的是这个enum需要自己实现这个protocol的内容
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        //添加计算属性，转换成String
        var description: String{
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //定义、初始化数组
    private var opStack = [Op]()
    //定义字典，key为运算符，value为Op，即运算方法
    private var knownOps = Dictionary<String, Op>()
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    //压入栈函数
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    //传入运算符，执行运算
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    //获取ops操作，进行递归算法
    private func evaluate(ops: [Op]) ->(result: Double?, remainingOps:[Op]){
        if !ops.isEmpty{
            //因为传入的数组是copy过来的，数组和字典，甚至int等都是结构体。（结构体几乎等同类，有方法有存取方法等等，但是有两大不同之处：1.类可以继承，结构体不行。2.结构体传递的是值，而类传递的是引用）.所以传入的参数ops: [Op]其实为let ops: [Op],说明这是一个不可变的数组（read-only），so。此处定义一个局部变量来接收该数组
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    //传入operation，返回结果
    func evaluate() ->Double? {
        let (result, reminder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(reminder) left over")
        return result
    
    }
}