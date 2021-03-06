//
//  Helper.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "Helper.h"
#import "CommonCrypto/CommonDigest.h"
#import "UIAlertController+JGHUIAlertController.h"
#import "UserInformationModel.h"
#import "UserDataInformation.h"
#import "TabBarController.h"
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
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
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
    NSString *imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/team/%td.jpg@200w_200h_2o",timeKey];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}


+ (NSURL *)setImageIconUrl:(NSString *)iconType andTeamKey:(NSInteger)timeKey andIsSetWidth:(BOOL)isSet andIsBackGround:(BOOL)isBack
{
    NSString *imageStr;
    if (isSet == 0) {
        if (isBack == 0) {
            if ([iconType isEqualToString:@"user"] == 1) {
                imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/head/%td.jpg",iconType,timeKey];
            }
            else
            {
                imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/%td.jpg@400w_400h_2o",iconType,timeKey];
            }
            
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/%td_background.jpg",iconType,timeKey];
        }
        
    }
    else
    {
        if (isBack == 0) {
            if ([iconType isEqualToString:@"user"] == 1) {
                imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",iconType,timeKey];
            }
            else
            {
                imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/%td.jpg@200w_200h_2o",iconType,timeKey];
            }
            
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/%td_background.jpg@400w_150h_2o",iconType,timeKey];
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
    [LQProgressHud showMessage:@"亲，没有网络哦！请检查您网络！"];
}
//加载超时
+(void)downLoadDataOverrun {
    [LQProgressHud showMessage:@"亲，服务器开小差了，请稍后再试！"];
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
    
    UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
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

+(void)alertViewWithTitle:(NSString *)title withBlockCancle:(void (^)())blockCancle withBlockSure:(void (^)())blockSure withBlock:(void (^)(UIAlertController *))blockOver{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"君高高尔夫" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    
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
+(void)alertSubmitWithTitle:(NSString *)title withBlockFirst:(void (^)())blockFirst withBlock:(void(^)(UIAlertController *alertView))block{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockFirst();
    }];
    
    [alert addAction:action];
    block(alert);
}

#pragma mark --actionsheet

+(void)actionSheetWithTitle:(NSString *)title withArrayTitle:(NSArray *)arayTitle withBlockFirst:(void (^)())blockFirst withBlockSecond:(void (^)())blockSecond{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:arayTitle[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockFirst();
    }];
    UIAlertAction* action2=[UIAlertAction actionWithTitle:arayTitle[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockSecond();
    }];
    UIAlertAction* actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:actionCancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


+(void)actionSheetWithTitle:(NSString *)title withArrayTitle:(NSArray *)arayTitle withBlockFirst:(void (^)())blockFirst withBlockSecond:(void (^)())blockSecond withBlockThird:(void (^)())blockThird{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:arayTitle[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockFirst();
    }];
    UIAlertAction* action2=[UIAlertAction actionWithTitle:arayTitle[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockSecond();
    }];
    UIAlertAction* action3=[UIAlertAction actionWithTitle:arayTitle[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        blockThird();
    }];
    UIAlertAction* actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:actionCancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
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
//    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return paraStr;
}


// 返回距离当前时间。。。刚刚 今天
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

// 标准时间
+ (NSString *)distanceTimeWithBeforeTimeNotificat:(NSString *)strTime
{
    CGFloat beTime = [Helper stringConversionToDate:strTime];
        
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"yyyy-MM-dd"];

    return [df stringFromDate:beDate];
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



+(NSString *)numTranslation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}

// 赛事头像
+ (NSURL *)setMatchImageIconUrl:(NSInteger)timeKey {
    //   https://imgcache.dagolfla.com/match/244.jpg
    
    NSString *imageStr = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/match/%td.jpg",timeKey];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+ (NSString *)returnKeyVlaueWithUrlString:(NSString *)string andKey:(NSString *)key{
    
    NSString *lastKey = [[string componentsSeparatedByString:key] lastObject];
    NSArray *lastAllKey = [lastKey componentsSeparatedByString:@"&"];
    
    NSMutableString *allValueString = [lastAllKey firstObject];
    
    NSString *value = [allValueString stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return value;
}

+ (void)callPHPLoginUserId:(NSString *)userId{
    NSString *url = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLoginUserid&uid=%@&url=dsadsa", userId];
    
    [[JsonHttp jsonHttp]httpRequest:url failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        //state - 1成功
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if ([data objectForKey:@"state"]) {
            [userDef setObject:[data objectForKey:@"state"] forKey:PHPState];
        }
        
    }];
}

+ (NSString *)returnPasswordString:(NSString *)pass{
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                   invertedSet ];
    return [[pass componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate

{
    
    //设置源日期时区
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    return destinationDateNow;
    
}


+ (NSString *)stringFromDateString:(NSString *)nowDate withFormater:(NSString *)formate{
    
    NSDateFormatter* formater =[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:nowDate];
    
    [formater setDateFormat:formate];
    NSString *result = [formater stringFromDate:date];
    
    return result;
}




+ (NSString *)dateFromDate:(NSString *)date timeInterval:(NSTimeInterval)timeTer{
    
   NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* newdate = [dateFormatter dateFromString:date];
    
    [dateFormatter setDateFormat:@"HH:mm"];
 
    return [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:timeTer sinceDate:newdate]];
}

+ (void)requestRCIMWithToken:(NSString *)token{
    NSString *md5 = [NSString stringWithFormat:@"userKey=%@&seeUserKey=%@dagolfla.com",DEFAULF_USERID, DEFAULF_USERID];
    NSDictionary *dataDic = @{
                              @"userKey":DEFAULF_USERID,
                              @"seeUserKey":DEFAULF_USERID,
                              @"md5":md5,
                              };
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserMainInfo" JsonKey:nil withData:dataDic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = [NSString stringWithFormat:@"%@", DEFAULF_USERID];
            
            if ([data objectForKey:@"user"]) {
                if ([[data objectForKey:@"user"] objectForKey:UserName]) {
                    userInfo.name = [[data objectForKey:@"user"] objectForKey:UserName];
                }
                
                if ([data objectForKey:@"handImgUrl"]) {
                    userInfo.portraitUri = [data objectForKey:@"handImgUrl"];
                }
                
                UserInformationModel *model = [[UserInformationModel alloc] init];
                [model setValuesForKeysWithDictionary:[data objectForKey:@"user"]];
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo  withUserId:userInfo.userId];
                [RCIM sharedRCIM].currentUserInfo=userInfo;
                [RCIM sharedRCIM].enableMessageAttachUserInfo=NO;
                // 快速集成第二步，连接融云服务器
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RongTKChat" object:nil];
                    //自动登录   连接融云服务器
                    [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
                }error:^(RCConnectErrorCode status) {
                    // Connect 失败
                    NSLog(@"status === %td", status);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RongTKChat" object:nil];
                }tokenIncorrect:^() {
                    // Token 失效的状态处理
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RongTKChat" object:nil];
                }];
            }
        }
    }];
}

+ (void)requestCountPushLog:(NSMutableDictionary *)dict{
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"push/doPushClick" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
}


//  封装cell方法
+ (UILabel *)lableRect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
}


+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error){
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                }else if (!granted){
                    
                    block(NO);
                }else{
                    block(YES);
                }
            });
        });
    }else{
        block(YES);
    }
    
}


+ (void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 7; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}


+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 7;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, [[UIScreen mainScreen]bounds].size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
