//
//  TextViewController.swift
//  Psychologist
//
//  Created by xayoung on 16/5/2.
//  Copyright © 2016年 xayoung. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!{
        didSet {
            //防止outlet在没被设置好的时候设置课其中的属性导致程序崩溃
            textView.text = text
        }
    }

    var text: String = ""{
        didSet {
            textView?.text = text
            
        }
    
    }
    //重写presentingViewController大小
    override var preferredContentSize: CGSize{
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
}
