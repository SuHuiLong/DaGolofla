//
//  Factory.m
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "Factory.h"

@implementation Factory

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             target:(id)target
                           selector:(SEL)selector
                              Title:(NSString *)title
{
    return [self createButtonWithFrame:frame titleFont:14.f textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] target:target selector:selector Title:title];
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target selector:(SEL)selector Title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:frame];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame titleFont:(CGFloat)size textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor target:(id)target selector:(SEL)selector Title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
//    button.layer.cornerRadius = 3.f;
//    button.layer.masksToBounds = YES;
    button.backgroundColor=bgColor;
    button.titleLabel.font=[UIFont systemFontOfSize:size];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame  NormalImage:(NSString *)normalName SelectedImage:(NSString *)selectedName target:(id)target selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
//    button.layer.cornerRadius = 3.f;
//    button.layer.masksToBounds = YES;
    [button setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame Title:(NSString *)title  {
    return [self createLabelWithFrame:frame fontSize:14.f Title:title ];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame textColor:(UIColor *)color Title:(NSString *)title {
    return [self createLabelWithFrame:frame textColor:color fontSize:14.f Title:title ];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(CGFloat)size Title:(NSString *)title {
    return [self createLabelWithFrame:frame textColor:[UIColor blackColor] fontSize:size Title:title];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size Title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame Image:(UIImage *)image{
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.image = image;

    return view;
}


+ (UITextField *)createViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle Text:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    return textField;
}

@end







