//
//  Created by 刘超 on 15/4/14.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LQProgressHud.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小

@implementation LQProgressHud

+ (void)showMessage:(NSString *)text {
    
    LQProgressHud *hud = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [hud showAnimated:YES];//[hud show:YES];
    hud.label.text = text;//[hud setLabelText:text];
    hud.label.numberOfLines = 1;
    
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.label.textColor = [UIColor whiteColor];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

+ (void)showInfoMsg:(NSString *)text {
    
    LQProgressHud *hud = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [hud showAnimated:YES];//[hud show:YES];
    hud.label.text = text;//[hud setLabelText:text];
    hud.label.numberOfLines = 0;
    [hud setRemoveFromSuperViewOnHide:YES];
    
    hud.mode = MBProgressHUDModeText;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}


+ (void)showLoading:(NSString *)text {
    
    LQProgressHud *hud = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [hud showAnimated:YES];//[hud show:YES];
    hud.label.text = text;//[hud setLabelText:text];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
}

+ (void)hide{
    LQProgressHud *hud = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [hud hideAnimated:YES];
}

@end
