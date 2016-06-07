//
//  ShowHUD.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowHUD : NSObject

+(instancetype)showHUD;
/**
 *  @param text 要显示的文本
 *  @param view 在所在的view上展示
 */
-(void)showToastWithText:(NSString *)text FromView:(UIView *)view;

/**
 *  显示菊花加载动画和文字
 *
 *  @param text 要显示的文字
 *  @param view 所需展示的界面
 */
-(void)showAnimationWithText:(NSString *)text FromView:(UIView *)view;

/**
 *  隐藏菊花加载动画和文字
 *
 *  @param view 正在展示的界面
 */
-(void)hideAnimationFromView:(UIView *)view;

@end
