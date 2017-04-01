//
//  LQProgressHud.h
//  DagolfLa
//
//  Created by Madridlee on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "MBProgressHUD.h"


@interface LQProgressHud : MBProgressHUD

#pragma mark - 建议使用的方法

/** 在 window 上添加一个只显示文字的 HUD */
+ (void)showMessage:(NSString *)text;

/** 在 window 上添加一个提示`信息`的 HUD */
+ (void)showInfoMsg:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hide;
@end
