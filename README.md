# QianYan
千衍通信

## 简介
项目使用cocoapod管理第三方库。

手动添加的第三方在**QianYan_Ios/ThirdPart_byHand**路径下
***
### ../Setting
头文件

+ QY_Common.h 包含项目常用头文件的头文件
+ QY_CommonDefine.h 项目常用宏定义头文件
+ QY_jclient_jrm_protocol_Marco.h 项目通信协议宏定义头文件
***
### ../Services
服务类  

	1.QY_SocketService
		介绍:
			封装上述库用于与QianYan后端服务器通信。	
		依赖:
			<CocoaAsyncSocket/AsyncSocket.h>
		使用:
			获取单例.[QY_SocketService ShareInstance]

	2.QYUtils
		介绍:
			包含常用方法：快速Alert，APP NetworkIndicatorGCD .
		依赖:
			无
		使用:
			公共方法类.[QYUtils methodA]即可

### ../Models

数据模型



## 开发人员
+ 张睿 <793951781@qq.com> 18817870386
+ 王东 <314917769@qq.com> 18721926536
+ 刘书齐 <379130674@qq.com> 18817870387