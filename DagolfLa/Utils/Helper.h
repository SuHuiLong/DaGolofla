//
//  Helper.h
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//根据字符串内容的多少  在高度宽度 下计算出实际的宽度
+ (CGFloat)textWidthFromTextString:(NSString *)text height:(CGFloat)textHeight fontSize:(CGFloat)size;

//获取 当前设备版本
+ (double)getCurrentIOS;

//拼接图片路径
+ (NSURL*)imageUrl:(NSString*)downloadImageUrl;

+ (NSURL *)imageIconUrl:(NSString *)downloadImageUrl;

+ (NSURL *)setImageIconUrl:(NSInteger)timeKey;



// 新版本球队图片请求
+ (NSURL *)setImageIconUrl:(NSString *)iconType andTeamKey:(NSInteger)timeKey andIsSetWidth:(BOOL)isSet andIsBackGround:(BOOL)isBack;




//验证手机号码格式
+ (BOOL)testMobileIsTrue:(NSString *)mobile;

//邮箱格式验证
+(BOOL)isValidateEmail:(NSString *)email;

//判断nil和NULL、<NULL>
+(BOOL)isBlankString:(NSString *)string;

//加载超时
+(void)downLoadDataOverrun;

//网络错误
+(void)netWorkError;

//网络错误
+(void)noNetWork;

//图片旋转
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;

//弹窗
+(void)alertViewWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block;
+(void)alertViewNoHaveCancleWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block;

+(void)alertViewWithTitle:(NSString *)title  withBlockCancle:(void(^)())blockCancle withBlockSure:(void(^)())blockSure withBlock:(void(^)(UIAlertController *alertView))blockOver;



//判断登录
+(void)loginWithBlock:(void(^)(UIViewController *vc))block WithBlock1:(void(^)(UIAlertController *alertView))block1;
//判断是否为数字
+(BOOL)isPureNumandCharacters:(NSString *)string;

//毫秒转化string
+ (NSString *)dateConversionToString:(CGFloat )date;

//string转化毫秒
+ (CGFloat )stringConversionToDate:(NSString *)dateStr;

+ (NSString *)returnCurrentDateString;
@end
