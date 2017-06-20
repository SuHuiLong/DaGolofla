//
//  ShowHUD.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ShowHUD.h"

@interface ShowHUD ()<MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation ShowHUD

static ShowHUD *showHUD = nil;

+(instancetype)showHUD
{
    @synchronized(self){
        if (showHUD == nil) {
            showHUD = [[self alloc]init];
        }
    }
    return showHUD;
}
/**
 *  @param text 要显示的文本
 *  @param view 在所在的view上展示
 */
-(void)showToastWithText:(NSString *)text FromView:(UIView *)view;{
    [self hideAnimationFromView:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        _HUD.label.text = text;
        _HUD.mode = MBProgressHUDModeText;
        _HUD.bezelView.backgroundColor = [UIColor blackColor];
        _HUD.bezelView.alpha = 1;
        _HUD.label.textColor = [UIColor whiteColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
            _HUD = nil;
        });
    });
    
}
/**
 显示多行文本
 
 @param text 要显示的文本
 @param view 所在view
 */

-(void)showLinesToastWithText:(NSString *)text FromView:(UIView *)view{
    [self hideAnimationFromView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        _HUD.mode = MBProgressHUDModeText;
        _HUD.bezelView.backgroundColor = [UIColor blackColor];
        _HUD.bezelView.alpha = 1;
        _HUD.detailsLabel.text = text;
        _HUD.bezelView.color = BlackColor;
        _HUD.detailsLabel.textColor = WhiteColor;
        _HUD.detailsLabel.font = [UIFont systemFontOfSize:kHorizontal(16)]; //Johnkui - added
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMESlEEP * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
            _HUD = nil;
        });
    });
    
}


/**
 *  显示菊花加载动画和文字
 *
 *  @param text 要显示的文字
 *  @param view 所需展示的界面
 */
-(void)showAnimationWithText:(NSString *)text FromView:(UIView *)view{
    [self hideAnimationFromView:view];
    
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.bezelView.backgroundColor = BlackColor;
    [UIActivityIndicatorView appearanceWhenContainedIn:[_HUD class],nil].color = WhiteColor;
    _HUD.label.text = text;
    _HUD.label.textColor = WhiteColor;
    _HUD.delegate = self;//添加代理
    
}

/**
 *  隐藏菊花加载动画和文字
 *
 *  @param view 正在展示的界面
 */
-(void)hideAnimationFromView:(UIView *)view
{
    if (_HUD.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD removeFromSuperview];
            [_HUD hideAnimated:YES];
            _HUD = nil;
        });
    }
}


#pragma mark MBProgressHUD代理方法
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    
    [_HUD removeFromSuperview];
    if (_HUD != nil) {
        _HUD = nil;
    }
}

@end
