//
//  Helper.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "Helper.h"
#import "EnterViewController.h"
#import "CommonCrypto/CommonDigest.h"

@implementation Helper

//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if ([Helper getCurrentIOS] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        //xxxxxxxxxxxxxxxxxx
        //ghjdgkfgsfgskdgfjk
        //sdhgfsdjkhgfjd
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth + 10 * ProportionAdapter, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth + 10 * ProportionAdapter, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}
//固定高度计算宽度
+ (CGFloat)textWidthFromTextString:(NSString *)text height:(CGFloat)textHeight fontSize:(CGFloat)size{
    if ([Helper getCurrentIOS] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        //xxxxxxxxxxxxxxxxxx
        //ghjdgkfgsfgskdgfjk
        //sdhgfsdjkhgfjd
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight + 10 * ProportionAdapter) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.width;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(MAXFLOAT, textHeight + 10 * ProportionAdapter) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.width;//返回 计算出得行高
    }
}

//获取iOS版本号
+ (double)getCurrentIOS {
    
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

//拼接图片路径
+ (NSURL *)imageUrl:(NSString *)downloadImageUrl {
//    NSString *imageStr = [NSString stringWithFormat:@"http://192.168.2.18:8080/%@",downloadImageUrl];
     NSString *imageStr = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/%@",downloadImageUrl];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}

//拼接头像路径
+ (NSURL *)imageIconUrl:(NSString *)downloadImageUrl {
//        NSString *imageStr = [NSString stringWithFormat:@"http://192.168.2.18:8080/%@",downloadImageUrl];
    NSString *imageStr = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",downloadImageUrl];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}


//新方法 头像路径
+ (NSURL *)setImageIconUrl:(NSInteger)timeKey {
    //        NSString *imageStr = [NSString stringWithFormat:@"http://192.168.2.18:8080/%@",downloadImageUrl];
    NSString *imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%td.jpg@100w_100h",timeKey];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}


+ (NSURL *)setImageIconUrl:(NSString *)iconType andTeamKey:(NSInteger)timeKey andIsSetWidth:(BOOL)isSet andIsBackGround:(BOOL)isBack
{
    NSString *imageStr;
    if (isSet == 0) {
        if (isBack == 0) {
            if ([iconType isEqualToString:@"user"] == 1) {
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg",iconType,timeKey];
            }
            else
            {
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td.jpg",iconType,timeKey];
            }
            
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td_background.jpg",iconType,timeKey];
        }
        
    }
    else
    {
        if (isBack == 0) {
            if ([iconType isEqualToString:@"user"] == 1) {
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h",iconType,timeKey];
            }
            else
            {
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td.jpg@200w_200h",iconType,timeKey];
            }
            
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td_background.jpg@400w_150h",iconType,timeKey];
        }
    }
    
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;

}



//手机号码格式验证
+ (BOOL)testMobileIsTrue:(NSString *)mobile {
    ////NSLog(@"monlie  ==  %@",mobile);
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|7[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobile] == YES) {
        return YES;
    }else {
        return NO;
    }
}
//邮箱格式验证
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
//判断各种空
+(BOOL)isBlankString:(NSString *)string{
    if (string==nil||[string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//网络错误
+(void)netWorkError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n网络链接异常，请检查您的网络！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}
//加载超时
+(void)downLoadDataOverrun {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n请求数据超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}
//网络错误
+(void)noNetWork {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n亲，没有网络哦！请检查您网络！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}
//
+(void)alertViewWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    block(alert);
}




+(void)alertViewNoHaveCancleWithTitle:(NSString *)title withBlock:(void(^)(UIAlertController *alertView))block{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    block(alert);
}


+(void)loginWithBlock:(void(^)(UIViewController *vc))block WithBlock1:(void(^)(UIAlertController *alertView))block1{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EnterViewController *login=[[EnterViewController alloc] init];
        block(login);
    }];
    UIAlertAction* action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action2];
    [alert addAction:action1];
    block1(alert);
    return;
}



+(void)alertViewWithTitle:(NSString *)title withBlockCancle:(void (^)())blockCancle withBlockSure:(void (^)())blockSure withBlock:(void (^)(UIAlertController *))blockOver{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockCancle();
    }];
    UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockSure();
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    blockOver(alert);
    

}


+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

//毫秒转化string
+ (NSString *)dateConversionToString:(CGFloat )date{
    
    NSDate *dateNew = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [dm stringFromDate:dateNew];
    return dateString;
}
//string转化毫秒
+ (CGFloat )stringConversionToDate:(NSString *)dateStr{
    
    NSString *datestring = [NSString stringWithFormat:@"%@", dateStr];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:datestring];
    return [newdate timeIntervalSince1970];
}

+ (NSString *)returnCurrentDateString{
    NSDate *dateNew = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@", [dm stringFromDate:dateNew]);
    return [dm stringFromDate:dateNew];
}


+ (NSString *)returnDateformatString:(NSString *)dateString{
    NSString *str = nil;
    NSString *yearStr = [[dateString componentsSeparatedByString:@" "]objectAtIndex:0];
    NSString *dateCatory = nil;
    NSArray *array = [yearStr componentsSeparatedByString:@"-"];
    for (int i=0; i<3; i++) {
        if (i == 0) {
            dateCatory = @"年";
            str = [NSString stringWithFormat:@"%@", [[array objectAtIndex:0]stringByAppendingString:dateCatory]];
        }else if (i == 1){
            dateCatory = @"月";
            str = [NSString stringWithFormat:@"%@%@", str, [[array objectAtIndex:1]stringByAppendingString:dateCatory]];
        }else{
            dateCatory = @"日";
            str = [NSString stringWithFormat:@"%@%@", str, [[array objectAtIndex:2]stringByAppendingString:dateCatory]];
            NSLog(@"str == %@", str);
        }
    }
    return str;
}

+ (NSNumber *)returnNumberForString:(NSString *)string{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter numberFromString:string];
}

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}



#pragma mark  -----MD5

+(NSString *)md5HexDigest:(NSString*)Des_str
{
    
    const char *original_str = [Des_str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash uppercaseString];
    
    return mdfiveString;
    
}


// 字典转字符串
+ (NSString*)dictionaryHaveSpaceToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    NSString *paraStr;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    paraStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return paraStr;
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    NSString *paraStr;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    paraStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return paraStr;
}


// 返回距离当前时间。。。
+ (NSString *)distanceTimeWithBeforeTime:(NSString *)strTime
{
    CGFloat beTime = [Helper stringConversionToDate:strTime];
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    NSLog(@"%@",distanceStr);
    return distanceStr;
}


- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

+ (NSString *)returnUrlString:(NSString *)url WithKey:(NSString *)key{
    NSArray *array = [url componentsSeparatedByString:@"?"]; //从字符A中分隔成2个元素的数组
    NSArray *array1 = [[array objectAtIndex:1] componentsSeparatedByString:@"&"];
    
    for (int i=0; i<array1.count; i++) {
        NSString *conString = array1[i];
        if ([conString containsString:key]) {
            return [[[array1 objectAtIndex:i]componentsSeparatedByString:@"="] lastObject];
        }
    }
    
    return @"error";
}

//+ (BOOL)returnPriceString:(NSString *)price{
////    NSCharacterSet *priceCharSet = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789."]
////                                   invertedSet ];
//}

@end
