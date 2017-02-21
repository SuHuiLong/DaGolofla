//
//  Factory.h
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface Factory : NSObject

//创建Button的工厂，将特殊的元素传入，生产相对应的Button
+ (UIButton *)createButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector Title:(NSString *)title;

+ (UIButton *)createButtonWithFrame:(CGRect)frame titleFont:(CGFloat)size textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor target:(id)target selector:(SEL)selector Title:(NSString *)title;

+ (UIButton *)createButtonWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target selector:(SEL)selector Title:(NSString *)title;

+(UIButton *)createButtonWithFrame:(CGRect)frame  NormalImage:(NSString *)normalName SelectedImage:(NSString *)selectedName target:(id)target selector:(SEL)selector;





//创建Label的工厂，将特殊的元素传入，生产相对应的Label
+ (UILabel *)createLabelWithFrame:(CGRect)frame Title:(NSString *)title ;
+ (UILabel *)createLabelWithFrame:(CGRect)frame textColor:(UIColor *)color Title:(NSString *)title;
+ (UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(CGFloat)size Title:(NSString *)title;
+ (UILabel *)createLabelWithFrame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size Title:(NSString *)title;

//创建View的工厂，将特殊的元素传入，生产相应的View
+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame;
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame Image:(UIImage *)image;




//创建textField的工厂，将特殊的元素传入，生产响应的textField
+ (UITextField *)createViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle Text:(NSString *)text;
@end






