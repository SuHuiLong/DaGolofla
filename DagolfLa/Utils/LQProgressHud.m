//
//  Created by 刘超 on 15/4/14.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LQProgressHud.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 定义HUD
static LQProgressHud *HUD;

@implementation LQProgressHud

+ (void)showMessage:(NSString *)text {
    
    HUD = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [HUD showAnimated:YES];//[hud show:YES];
    HUD.label.text = text;//[hud setLabelText:text];
    HUD.label.numberOfLines = 1;
    
    HUD.mode = MBProgressHUDModeText;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    HUD.bezelView.alpha = 1;
    HUD.label.textColor = [UIColor whiteColor];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
    });
}

+ (void)showInfoMsg:(NSString *)text {
    
    HUD = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [HUD showAnimated:YES];//[hud show:YES];
    HUD.label.text = text;//[hud setLabelText:text];
    HUD.label.numberOfLines = 0;
    [HUD setRemoveFromSuperViewOnHide:YES];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    HUD.bezelView.alpha = 1;
    HUD.label.textColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
    });
}


+ (void)showLoading:(NSString *)text {
    
    HUD = [LQProgressHud showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [HUD showAnimated:YES];//[hud show:YES];
    HUD.label.text = text;//[hud setLabelText:text];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    
}

+ (void)hide{
    [HUD hideAnimated:YES];
}

@end
