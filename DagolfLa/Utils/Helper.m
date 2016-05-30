//
//  Helper.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "Helper.h"
#import "EnterViewController.h"

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
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
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
        CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.width;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(MAXFLOAT, textHeight) lineBreakMode:NSLineBreakByCharWrapping];
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
     NSString *imageStr = [NSString stringWithFormat:@"http://139.196.9.49:8081/%@",downloadImageUrl];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    return imageUrl;
}

//拼接头像路径
+ (NSURL *)imageIconUrl:(NSString *)downloadImageUrl {
//        NSString *imageStr = [NSString stringWithFormat:@"http://192.168.2.18:8080/%@",downloadImageUrl];
    NSString *imageStr = [NSString stringWithFormat:@"http://139.196.9.49:8081/small_%@",downloadImageUrl];
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
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@120w_120h",iconType,timeKey];
            }
            else
            {
                imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td.jpg@120w_120h",iconType,timeKey];
            }
            
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/%td_background.jpg@120w_120h",iconType,timeKey];
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
    [dm setDateFormat:@"yyyy-MM-dd"];
    NSDate * newdate = [dm dateFromString:datestring];
    return [newdate timeIntervalSince1970];
}

+ (NSString *)returnCurrentDateString{
    NSDate *dateNew = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd 00:00:00"];
    return [dm stringFromDate:dateNew];
}

@end
