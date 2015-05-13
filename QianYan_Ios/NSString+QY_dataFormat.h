//
//  NSString+QY_dataFormat.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"
#pragma mark - NSString+NSStringHexToBytes

@interface NSString (QY_dataFormat)

/**
 *  NSString(hex) --> NSData
 *  例:@"AA21f0c1762a3abc299c013abe7dbcc50001DD" 转换为 <AA21f0c1 762a3a.. ........ ....01DD>
 *
 *  @return NSData
 */
-(NSData*)QY_HexStrToHexBytes ;

/**
 *  NSString(ascil) --> NSData
 *  例:@"123456" --> <31323334 3536>
 *  UseAge:用户名，密码字符串转编码Data
 *
 *  @return NSData
 */
-(NSData*)QY_NormalStrToHexBytes ;

/**
 *  转换 JOSEPH_COMMAND --> NSString(hex)
 *  JCLIENT_REG_NEW_USER(412) --> @"19c" ;
 *
 *  @param cmd JOSEPH_COMMAND类型
 *
 *  @return cmd字符串
 */
+(NSString *)QY_CMD2HexString:(JOSEPH_COMMAND)cmd ;

/**
 *  转换 UInteger --> NSString(hex)
 *  40 --> @"28"
 *
 *  @param integer 长度等等东西...
 *
 *  @return hex String
 */
+(NSString *)QY_UInteger2HexString:(NSUInteger)integer ;

@end
