//
//  BaseViewController.m
//  UIViewController2
//
//  Created by Hailong.wang on 15/7/30.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //获取进入时界面展示数据
    [self initViewData];
    //添加视图
    [self createView];
    //初始化数据
    [self initData];
    //添加行为
    [self addTouchAction];
    //刷新
    [self createRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //每次界面进入调用
    [self initViewWillApperData];
    /*
     将要做还没有做的时候提醒
     */
    //注册键盘将要弹出的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘将要消失时的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //移除注册的键盘将要显示的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //移除注册的键盘将要隐藏的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//每次进入界面都会调用
-(void)initViewWillApperData{
    
}
//获取进入时界面展示数据
-(void)initViewData{

}

//创建视图
- (void)createView {
    //不做实现，只是为了使用方便
}
//创建刷新
-(void)createRefresh{

}

- (void)toNextView {
    
}

//初始化数据源
- (void)initData {
    //不做实现，只是为了使用方便
}

//添加事件
- (void)addTouchAction {
    //不做实现，只是为了使用方便
}

//键盘弹出
- (void)keyboardShow:(NSNotification *)notification {
    //不做实现，只是为了使用方便
}

//键盘隐藏
- (void)keyboardHide:(NSNotification *)notification {
    //不做实现，只是为了使用方便
}

//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//创建上导航左侧按钮(系统标题)
- (void)createNavigationLeftButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//创建上导航右侧按钮(系统标题)
- (void)createNavigationRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc {
    NSString *deallocClass =  [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass(self.class)];
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
//        HUD.mode = MBProgressHUDModeText;
//        HUD.color = BlackColor;
//        HUD.label.text = deallocClass;
//        HUD.label.textColor = WhiteColor;
//        [HUD showAnimated:true];
//        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [HUD setHidden:YES];
//        });
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            [HUD setHidden:YES];
//        }];
//        HUD.userInteractionEnabled = true;
//        [HUD addGestureRecognizer:tap];
//        
//        
//    });

}

@end





