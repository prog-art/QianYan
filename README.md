# QianYan
千衍通信

## 简介
项目使用cocoapod管理第三方库。

手动添加的第三方在**QianYan_Ios/ThirdPart_byHand**路径下
***

### Services/Sockets 
简介:

	完成和JDAS服务器的连接，获取JRM服务器的IP & Port 信息。
	完成与JRM服务器的所有工作
		1.发送数据包格式化。
		2.发送数据包。
		3.接受服务器返回数据包。 
		4.解析服务器返回数据包。
		5.发送Delegate通知，一个操作对应一个通知。
			

文件

	QY_SocketService.h
			QY_Socket组件的入口。
	header/
		QY_Socket.h
			组件头文件,使用时引入这个头文件。
		QY_SocketServiceDelegate.h
			QY_SocketServiceDelegate定义文件	。
			定义QY_Socket组件的输出。
		QY_jclient_jrm_protocol_Marco.h 
			项目通信协议宏定义头文件
	socketDataServices/
		QY_JRMDataPharser.h
			解析器
			input: (NSData *, JRM_REQUEST_OPERATION_TYPE)
			output: QY_JRMDataPacket * 
		QY_dataPacketFactor.h
			打包器
			组装满足JRM通信协议的16进制数据包
			output: 对应的NSData实例。
		NSString+QY_dataFormat.h
			添加一些转换字符串的方法。
		NSData+QY_dataFormat.h
			添加一些转换data数据的方法。
	socketDelegaters/
		QY_JDASSocketDelegater.h
			处理AsyncSocketDelegate回调。(仅JDAS Socket)
		[重要]QY_JRMSocketDelegater.h
			处理AsyncSocketDelegate回调。(仅JRM Socket)
	models/
		QY_JRMDataPacket.h
			数据Model类，<length , cmd , value0 , value1 , ...>


使用方法

	import "QY_Socket.h"
	引入后 [[QY_SocketService shareInstance］connectToJDASHost:&error] 就能开始连接服务器。
	接收结果使用delegate<QY_SocketServiceDelegate>即可。
	
***
### ../Setting
头文件

+ QY_Common.h 包含项目常用头文件的头文件
+ QY_CommonDefine.h 项目常用宏定义头文件
***
### ../Services
服务类  


	1.QYUtils
		介绍:
			包含常用方法：快速Alert，APP NetworkIndicatorGCD .
		依赖:
			无
		使用:
			公共方法类.[QYUtils methodA]即可
***
### ../Models

数据模型

***
### ../ThirdPart_ByHand

	1.QRCodeGenerator.h
		介绍:
			封装libqrencode库用于生成二维码图片
		依赖:
			<libqrencode/qrencode.h>
		使用:
			+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

	2.QRCodeReaderViewController
		介绍:
			一个扫描二维码的组件,通过QRCodeReaderDelegate回调通知扫描结果字符
			串 or [QRCodeReaderViewController setCompletionWithBlock] 
			接受结果

		依赖:
			组件内部
		使用:
			唤起着完成QRCodeReaderDelegate,接受通知,代码里需要加上 
				[reader.navigationController popViewControllerAnimated:YES] ;
			来显式的离开reader界面。
				[reader setCompletionWithBlock:^(NSString 
			*resultAsString)completionBlock]
			或者使用回调block接受结果。


*** 
## 开发人员
+ 张睿 <793951781@qq.com> 18817870386
+ 王东 <314917769@qq.com> 18721926536
+ 刘书齐 <379130674@qq.com> 18817870387