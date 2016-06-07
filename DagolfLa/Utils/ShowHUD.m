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
-(void)showToastWithText:(NSString *)text FromView:(UIView *)view;
{
    _HUD = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:_HUD];
    _HUD.labelText = text;
    _HUD.mode = MBProgressHUDModeText;
    
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
}

/**
 *  显示菊花加载动画和文字
 *
 *  @param text 要显示的文字
 *  @param view 所需展示的界面
 */
-(void)showAnimationWithText:(NSString *)text FromView:(UIView *)view
{
    _HUD = [[MBProgressHUD alloc]initWithView:view];
    
    [view addSubview:_HUD];
    _HUD.labelText = text;
    _HUD.delegate = self;//添加代理
    
    [_HUD show:YES];
}

/**
 *  隐藏菊花加载动画和文字
 *
 *  @param view 正在展示的界面
 */
-(void)hideAnimationFromView:(UIView *)view
{
    [_HUD hide:YES];
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
