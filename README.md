# CountDownLabel
A CountDown label
![](https://github.com/heron-newland/CountDownLabel/blob/master/img/Icon.png)

*	使用Swift4.0


*	一款简单的倒计时工具, 能满足各种格式的倒计时格式.
*	使用DispatchSource制作定时器, 准确度高, 不收Runloop模式影响

#### 导入方式:

直接将 `Source` 文件夹中的 `HLLCountDownLabel.swift` 文件导入项目, 编译即可

#### 使用方式:


		 //初始化计时器label
		 //参数一: 倒计时的时长, 以秒为单位, 参数二:frame
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