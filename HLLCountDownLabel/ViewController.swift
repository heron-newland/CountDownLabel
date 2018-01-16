//
//  ViewController.swift
//  HLLCountDownLabel
//
//  Created by  bochb on 2018/1/16.
//  Copyright © 2018年 com.heron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //初始化计时器label, 
        let lbl = HLLCountDownLabel(with: 60000, frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        //设置分割符号
        lbl.seperateString = "-"
        //设置显示格式
        lbl.format = .ddhhmmss
        //开始倒计时
        lbl.resumeTimer()
        //获取倒计时的剩余时间和总时间, 不要做复杂操作, 这个回调可能非常频繁
        lbl.currentRemains = {remains, total in
            //remains: 剩余时间
            //total: 总时间
            
        }
        //是否隐藏文字描述
        lbl.isDesHidden = false
        //设置文字对齐方法
        lbl.textAlignment = .center
        //添加到父控件
        view.addSubview(lbl)
        //暂停定时器
//        lbl.suspendTimer()
        //取消定时器, 取消后不开再次开启
//        lbl.candelTimer()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

