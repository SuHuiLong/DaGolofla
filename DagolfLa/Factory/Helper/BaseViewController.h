//
//  BaseViewController.h
//  UIViewController2
//
//  Created by Hailong.wang on 15/7/30.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Addition.h"
#import "Factory.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+GPExtension.h"
//#import "FileUtils.h"
//#import "StorageManager.h"
@interface BaseViewController : UIViewController

//获取进入时界面展示数据
-(void)initViewData;
//创建视图
- (void)createView;
//初始化数据源
- (void)initData;
//添加事件
- (void)addTouchAction;
//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view;
//创建上导航的左侧按钮(系统标题)
- (void)createNavigationLeftButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view;
//创建上导航的右侧按钮(系统标题)
- (void)createNavigationRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
//使用pop返回
- (void)backAction;

//键盘弹出
- (void)keyboardShow:(NSNotification *)notification;
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notification;



-(id)cachedObjectForKey:(NSString *)cachedKey;
-(id)cachedObjectForKey:(NSString *)cachedKey WithSuffix:(NSString *)suffix;

-(id)saveObject:(id)object forKey:(NSString *)cachedKey;
-(id)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;

-(NSMutableArray *)commonLoadCaches:(NSString *)cacheKey;   //读取缓存
@end










