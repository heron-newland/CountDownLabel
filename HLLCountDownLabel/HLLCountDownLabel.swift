//
//  HLLCountDownLabel.swift
//  HLLCountDownLabel
//
//  Created by  bochb on 2018/1/16.
//  Copyright © 2018年 com.heron. All rights reserved.
//

/**使用方法
 //初始化计时器label
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
 
 //是否隐藏文字描述, 如果不隐藏只有在中文状态才会显示日,时,分,秒等描述
 lbl.isDesHidden = false
 
 //设置文字对齐方法
 lbl.textAlignment = .center
 
 //添加到父控件
 view.addSubview(lbl)
 
 //暂停定时器
         lbl.suspendTimer()
 
 //取消定时器, 取消后不开再次开启
         lbl.candelTimer()
 */

import UIKit

/// 倒计时格式
///
/// - case ssmm: 秒毫秒
/// - case ss: 秒
/// - mmss: 分秒
/// - hhmmss: 时分秒
/// - ddhhmmss: 日时分秒
/// - ddhhmm: 日时分
/// - hhmm: 十分
/// - ddhh: 日时
enum HLLTimeFormat: String {
    case ssmm
    case ss
    case mmss
    case hhmmss
    case ddhhmmss
    case ddhhmm
    case hhmm
    case ddhh
}

class HLLCountDownLabel: UILabel {
    
    /// 倒计时时长(以秒为单位)
    var time: UInt = 0
    
    /// 倒计时格式
    var format: HLLTimeFormat = .mmss {
        didSet{
            self.text = self.convert(time: self.time).replacingOccurrences(of: self.seperate, with: self.seperateString)
            //            suspendTimer()
            configureTimer()
        }
    }
    
    /// 是否隐藏到计时中的汉字(隐藏 12:12, 不隐藏 12分12秒)
    var isDesHidden = true
    
    /// 时间的分隔符
    var seperateString:String = ":"
    
    //当前剩余时间
    var currentRemains: ((_ remains: UInt, _ total: UInt) -> (Void))?
    
    private var originTime: UInt = 0
    //系统语言是汉语就显示汉字, 否则显示英文
    private let isHans:Bool = Locale.preferredLanguages[0].hasPrefix("zh-Hans")
    private let seperate: String = ":"
    private let queue = DispatchQueue(label: "com.heron")
    private lazy var timer:DispatchSourceTimer = {
        return DispatchSource.makeTimerSource(flags: .strict, queue: queue)
    }()
    
    
    
    
    /// 将时间转化成对应格式的字符串
    private func convert(time: UInt) -> String {
        switch format {
        case .ssmm:
            let s: UInt = time
            let m: UInt = (time - s * 1000) % 1000
            if isHans && !isDesHidden {
                return  String(format: "%02d", s) + "秒" + String(format: "%03d", m) + "毫秒"
            }
            return   String(format: "%02d", s) + seperateString + String(format: "%03d", m)
        case .ss:
            if isHans && !isDesHidden {
                return  String(format: "%02d", self.time) + "秒"
            }
            return  String(format: "%02d", self.time)
        case .mmss:
            let m: UInt = time / 60
            let s: UInt = time % 60
            
            if isHans && !isDesHidden {
                return String(format: "%02d", m) + "分" + String(format: "%02d", s) + "秒"
            }
            return String(format: "%02d", m) + seperate + String(format: "%02d", s)
            
        case .hhmm:
            let h: UInt = time / 3600
            let m: UInt = (time - 3600 * h) % 60
            if isHans && !isDesHidden {
                return "\(h)" + "时" + String(format: "%02d", m) + "分"
            }
            return "\(h)" + seperate + String(format: "%02d", m)
        case .ddhhmm:
            let d: UInt = time / (60 * 60 * 24)
            let h: UInt = (time - (60 * 60 * 24) * d) / 3600
            let m: UInt = (time - 3600 * h) % 60
            if isHans && !isDesHidden {
                return String(format: "%02d", d) + "日" + String(format: "%02d", h) + "时" + String(format: "%02", m) + "分"
            }
            return String(format: "%02d", d) + seperate + String(format: "%02d", h) + seperate + String(format: "%02", m)
        case .ddhh:
            let d: UInt = time / (60 * 60 * 24)
            let h: UInt = (time - (60 * 60 * 24) * d) % 3600
            if isHans && !isDesHidden {
                return "\(d)" + "日" + String(format: "%02d", h) + "时"
            }
            return "\(d)" + seperate + String(format: "%02d", h)
            
        case .hhmmss:
            let h: UInt = time / 3600
            let m: UInt = (time - 3600 * h) / 60
            let s: UInt = time % 60
            if isHans && !isDesHidden {
                return "\(h)" + "时" + String(format: "%02d", m) + "分" + String(format: "%02d", s) + "秒"
            }
            return "\(h)" + seperate + String(format: "%02d", m) + seperate + String(format: "%02d", s)
        case .ddhhmmss:
            let d: UInt = time / (60 * 60 * 24)
            let h: UInt = (time - (60 * 60 * 24) * d) / 3600
            let m: UInt = (time - 3600 * h) / 60
            let s: UInt = time % 60
            if isHans && !isDesHidden {
                return "\(d)" + "日" + String(format: "%02d", h) + "时" + String(format: "%02d", m) + "分" + String(format: "%02d", s) + "秒"
            }
            return "\(d)" + seperate + String(format: "%02d", h) + seperate + String(format: "%02d", m) + seperate + String(format: "%02d", s)
            
        }
    }
    
    private func configureTimer() {
        
        timer.setEventHandler { [unowned self] in
            if self.time == 0 {
                self.time = 0
                self.candelTimer()
                return
            }
            print(Thread.current)
            self.time -= 1
            
            DispatchQueue.main.sync {
                self.text = self.convert(time: self.time).replacingOccurrences(of: self.seperate, with: self.seperateString)
                if self.currentRemains != nil {
                    self.currentRemains!(self.time, self.originTime)
                }
            }
            
        }
        timer.setCancelHandler {
            
        }
        
        var repeating:DispatchTimeInterval = .seconds(1)
        
        switch format {
        case .ssmm:
            repeating = .milliseconds(1)
        case .mmss, .hhmmss, .ddhhmmss, .ss:
            repeating = .seconds(1)
        case .ddhhmm, .hhmm:
            repeating = .seconds(60)
        case .ddhh:
            repeating = .seconds(60 * 60)
        }
        timer.schedule(deadline: DispatchTime.now(), repeating: repeating)
        //开启定时器
        //        timer.resume()
    }
    
    
    
    public func suspendTimer() {
        if timer.isCancelled {
            assertionFailure("Timer has been cancelled!")
            return
        }
        timer.suspend()
    }
    public func resumeTimer() {
        if timer.isCancelled {
            assertionFailure("Timer has been cancelled!")
            return
        }
        timer.resume()
    }
    public func candelTimer() {
        if !timer.isCancelled {
            timer.cancel()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension HLLCountDownLabel{
    
    convenience init(with time: UInt,frame: CGRect) {
        self.init(frame: frame)
        self.originTime = time
        self.time = time
        self.text = self.convert(time: self.time).replacingOccurrences(of: self.seperate, with: self.seperateString)
        configureTimer()
        
    }
}
