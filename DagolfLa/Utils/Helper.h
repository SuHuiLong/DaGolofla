//
//  Helper.h
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LQProgressHud.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

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

//图片旋转
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;

//弹窗
+(void)alertViewWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block;
+(void)alertViewNoHaveCancleWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block;

+(void)alertViewWithTitle:(NSString *)title  withBlockCancle:(void(^)())blockCancle withBlockSure:(void(^)())blockSure withBlock:(void(^)(UIAlertController *alertView))blockOver;

+(void)alertSubmitWithTitle:(NSString *)title withBlockFirst:(void (^)())blockFirst withBlock:(void(^)(UIAlertController *alertView))block;

+(void)actionSheetWithTitle:(NSString *)title withArrayTitle:(NSArray *)arayTitle withBlockFirst:(void (^)())blockFirst withBlockSecond:(void (^)())blockSecond;

+(void)actionSheetWithTitle:(NSString *)title withArrayTitle:(NSArray *)arayTitle withBlockFirst:(void (^)())blockFirst withBlockSecond:(void (^)())blockSecond withBlockThird:(void (^)())blockThird;

//判断是否为数字
+(BOOL)isPureNumandCharacters:(NSString *)string;

//毫秒转化string
+ (NSString *)dateConversionToString:(CGFloat )date;

//string转化毫秒
+ (CGFloat )stringConversionToDate:(NSString *)dateStr;
//返回当前时间
+ (NSString *)returnCurrentDateString;

//2016-06-06 07:07:45 返回 2016年6月6号
+ (NSString *)returnDateformatString:(NSString *)dateString;

//nsstring 转成 nsnumber类型

+ (NSNumber *)returnNumberForString:(NSString *)string;

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate;


// md5
+ (NSString*)dictionaryHaveSpaceToJson:(NSDictionary *)dic;

+(NSString *)md5HexDigest:(NSString*)Des_str;

// 字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

// 返回距离当前时间。。。
+ (NSString *)distanceTimeWithBeforeTime:(NSString *)strTime;

- (BOOL)isPureNumandCharacters:(NSString *)string;//纯数字


//解析URL，返回需要的字段值，没有返回error
+ (NSString *)returnUrlString:(NSString *)url WithKey:(NSString *)key;

+ (BOOL)returnPriceString:(NSString *)price;
//阿拉伯数字转成中文数字  例如：9-->>九
+(NSString *)numTranslation:(NSString *)arebic;

// 赛事头像
+ (NSURL *)setMatchImageIconUrl:(NSInteger)timeKey;

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//在URL中取key对应的值
+ (NSString *)returnKeyVlaueWithUrlString:(NSString *)string andKey:(NSString *)key;

//登录PHP
+ (void)callPHPLoginUserId:(NSString *)userId;

//返回密码
+ (NSString *)returnPasswordString:(NSString *)pass;

+ (NSString *)distanceTimeWithBeforeTimeNotificat:(NSString *)strTime;


// 时区转换  转换为当前的
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;


// return yyyy-MM-dd EEEE HH:mm 
+ (NSString *)stringFromDateString:(NSString *)nowDate withFormater:(NSString *)formate;


// 时间加减
+ (NSString *)dateFromDate:(NSString *)date timeInterval:(NSTimeInterval)timeTer;

+ (void)requestRCIMWithToken:(NSString *)token;

+ (void)requestCountPushLog:(NSMutableDictionary *)dict;


+ (UILabel *)lableRect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment;

+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;


// 设置label的行间距
+ (void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;

// 获取带有行间距的label的高度
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;





@end
