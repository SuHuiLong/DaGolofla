//
//  PayPassWordAlert.m
//  DagolfLa
//
//  Created by BIHUA－PEI on 15/8/20.
//  Copyright (c) 2015年 BIHUA－PEI. All rights reserved.
//

#import "ShareAlert.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#define kAlertWidth ScreenWidth
#define kAlertHeight kHvertical(210)


@interface ShareAlert ()
{
    
    CGFloat space;
    CGFloat font;
    UIButton* _btnBack;
}

@property (nonatomic, strong) UIView *backImageView;
@end
@implementation ShareAlert
+ (CGFloat)alertWidth
{
    return ScreenHeight<490?300:(ScreenHeight<570?300:(ScreenHeight<670?300:(ScreenHeight<740?390:1000)));
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f


- (id)initMyAlert{
    
    if (self = [super init]){
        [self createView];
    }
    return self;
}

//创建alert
-(void)createView{

    
    NSArray *titleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博"];
    NSArray *iconArray = @[@"weixin-1",@"pengyouquan",@"xinliang"];
    
    UIView *buttonView = [Factory createViewWithBackgroundColor:RGB(255,255,255) frame:CGRectMake(kWvertical(10), 0, screenWidth - kWvertical(20), kHvertical(140))];
    buttonView.layer.masksToBounds = true;
    buttonView.layer.cornerRadius = kHvertical(8);
    [self addSubview:buttonView];
    for (int i = 0; i < 3; i++) {
        //按钮
        UIButton *indexBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(4) + (buttonView.width/3 - kWvertical(8))*i, kHvertical(13), buttonView.width/3 - kWvertical(8), kHvertical(84)) image:[UIImage imageNamed:iconArray[i]] target:self selector:@selector(selectIndex:) Title:nil];
        indexBtn.tag = i+200;
        [buttonView addSubview:indexBtn];
        //文字
        UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(indexBtn.x, kHvertical(90), indexBtn.width, kHvertical(21)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:titleArray[i]];
        [descLabel setTextAlignment:NSTextAlignmentCenter];
        [buttonView addSubview:descLabel];
    }
    
    
    UIButton *cancel = [Factory createButtonWithFrame:CGRectMake(buttonView.x, buttonView.y_height + kHvertical(10), buttonView.width, kHvertical(50)) titleFont:kHorizontal(20) textColor:RGB(49,49,49) backgroundColor:WhiteColor target:self selector:@selector(dismissAlert) Title:@"取消"];
    cancel.layer.cornerRadius = kHvertical(8);
    cancel.layer.masksToBounds = true;
    [self addSubview:cancel];
}




#pragma mark---查询
-(void)selectIndex:(UIButton*)sender{
    
    _callBackTitle(sender.tag-200);
    [self dismissAlert];
}




- (void)dismissAlert
{
    [UIView animateWithDuration:0.2 animations:^{
         [self removeFromSuperview];
    }];
   
    
}


- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    //self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, 200, 550);
    [topVC.view addSubview:self];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    self.frame=afterFrame;
    [super removeFromSuperview];
    //    [UIView animateWithDuration:0.5f delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        self.frame = afterFrame;
    //        [super removeFromSuperview];
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _btnBack = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBack.frame = self.backImageView.bounds;
        _btnBack.backgroundColor = [UIColor clearColor];
        [self addSubview:_btnBack];
        [_btnBack addTarget:self action:@selector(hideShareClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [topVC.view addSubview:self.backImageView];
    [self.backImageView addSubview:_btnBack];
    CGRect afterFrame = CGRectMake(0, ScreenHeight-kAlertHeight, ScreenWidth, kAlertHeight);
    self.frame = afterFrame;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //self.transform = CGAffineTransformMakeRotation(0);
        self.backImageView.alpha = 0.4f;
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}
-(void)hideShareClick:(UIButton *)btn
{
    [self dismissAlert];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
