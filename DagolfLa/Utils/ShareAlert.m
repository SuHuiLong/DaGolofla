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
#define kAlertHeight ((ScreenWidth/4.0)+70)


@interface ShareAlert ()
{
    CGFloat space;
    CGFloat font;
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
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initMyAlert
{
    //CGFloat x=17.0;
    //font=selfHeight<490?x-3:(selfHeight<570?x-2:(selfHeight<670?x:(selfHeight<740?x:1000)));
    NSArray* titleArray=@[@"微信",@"朋友圈",@"新浪"];
    NSArray* imagArray=@[@"weixin-1",@"pengyouquan",@"xinliang"];
    space=10.0;
    //CGFloat btnWidth=(selfWidth-8*10)/4.0;
    CGFloat btnWidth=ScreenWidth/3.0;
    UIImage* shareImg=[UIImage imageNamed:imagArray[0]];
    CGFloat imgWidth=shareImg.size.width;
    
    
    if (self = [super init])
    {
        
        for(int i=0;i<3;i++)
        {
            UIButton* myBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [myBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [myBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            myBtn.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
            
            if(ScreenHeight<700)
            {
                if(ScreenHeight<500)
                {
                    myBtn.frame=CGRectMake(btnWidth*i, 0, btnWidth, btnWidth+40);
                    myBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
                    [myBtn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
                    ////NSLog(@"%@",titleArray[0]);
                    [myBtn setTitle:titleArray[i] forState:UIControlStateNormal];
                    myBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
                    [myBtn setImageEdgeInsets:UIEdgeInsetsMake(space, (btnWidth-imgWidth)/2.0,btnWidth-imgWidth, (btnWidth-imgWidth)/2.0)];
                    [myBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, -myBtn.titleLabel.bounds.size.width-50, 0, 0)];
                }
                else
                {
//                    if (i == 1) {
//                        myBtn.frame=CGRectMake(btnWidth*i, 0, btnWidth, btnWidth+20);
//                        myBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
//                        [myBtn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
//                        [myBtn setTitle:titleArray[i] forState:UIControlStateNormal];
//                        myBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//                        [myBtn setImageEdgeInsets:UIEdgeInsetsMake(space, (btnWidth-imgWidth)/2.0,btnWidth-imgWidth, (btnWidth-imgWidth)/2.0)];
//                        [myBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, -myBtn.titleLabel.bounds.size.width-50, 0, 0)];
//                    }
//                    else{
                        myBtn.frame=CGRectMake(btnWidth*i, 0, btnWidth, btnWidth+20);
                        myBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
                        [myBtn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
                        [myBtn setTitle:titleArray[i] forState:UIControlStateNormal];
                        myBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
                        [myBtn setImageEdgeInsets:UIEdgeInsetsMake(space, (btnWidth-imgWidth)/2.0,btnWidth-imgWidth, (btnWidth-imgWidth)/2.0)];
                        [myBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, -myBtn.titleLabel.bounds.size.width-50, 0, 0)];
//                    }
                    
                }
            }
            else
            {
                myBtn.frame=CGRectMake(btnWidth*i, 25, btnWidth, btnWidth);
                myBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
                [myBtn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
                [myBtn setTitle:titleArray[i] forState:UIControlStateNormal];
                myBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
                [myBtn setImageEdgeInsets:UIEdgeInsetsMake(space, (btnWidth-imgWidth)/2.0,btnWidth-imgWidth-20, (btnWidth-imgWidth)/2.0)];
                [myBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, -myBtn.titleLabel.bounds.size.width-50, 0, 0)];
            }
            [myBtn addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventTouchUpInside];
            myBtn.tag=i+200;
            myBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:myBtn];
        }
        UIButton* cancle=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        cancle.frame=CGRectMake(0, kAlertHeight-(ScreenHeight<500?35:50), ScreenWidth, ScreenHeight<500?35:50);
        cancle.backgroundColor=[UIColor whiteColor];
        [cancle addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancle];
        
    }
    return self;
}
#pragma mark---查询
-(void)selectIndex:(UIButton*)sender
{
    //NSString* str=_titleArray[sender.tag-200];
    _callBackTitle(sender.tag-200);
    [self dismissAlert];
}


//
- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    //self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, 200, 550);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [UIView animateWithDuration:0.2 animations:^{
         [self removeFromSuperview];
    }];
   
    
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
    }
    [topVC.view addSubview:self.backImageView];
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
