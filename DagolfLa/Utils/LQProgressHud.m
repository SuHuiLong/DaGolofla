//
//  Created by 刘超 on 15/4/14.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LQProgressHud.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

@implementation LQProgressHud

+ (instancetype)sharedHUD {
    
    static LQProgressHud *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //hud = [[LQProgressHud alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        
        hud = [[LQProgressHud alloc]initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(LQProgressHUDStatus)status text:(NSString *)text {
    
    LQProgressHud *hud = [LQProgressHud sharedHUD];
    [hud showAnimated:YES];//[hud show:YES];
    [hud setShowNow:YES];
    hud.label.text = text;//[hud setLabelText:text];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];//[hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    //hud.bezelView.color = BlackColor;
    //hud.label.textColor = [UIColor whiteColor];
    //hud.activityIndicatorColor = WhiteColor;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LQProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case LQProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"hud_success@2x.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hideAnimated:YES afterDelay:TIMESlEEP];//[hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LQProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"hud_error@2x.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hideAnimated:YES afterDelay:TIMESlEEP];//[hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LQProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case LQProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"hud_info@2x.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hideAnimated:YES afterDelay:TIMESlEEP];//[hud hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    LQProgressHud *hud = [LQProgressHud sharedHUD];
    [hud showAnimated:YES];//[hud show:YES];
    [hud setShowNow:YES];
//    hud.detailsLabelText = text;
    //只显示单行文字
    hud.label.text = text;//[hud setLabelText:text];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];//[hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //    [hud hide:YES afterDelay:2.0f];
    
    [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:LQProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:LQProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:LQProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:LQProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    
    [[LQProgressHud sharedHUD] setShowNow:NO];
    [[LQProgressHud sharedHUD] hideAnimated:YES];//[[LQProgressHud sharedHUD] hide:YES];
}

@end
