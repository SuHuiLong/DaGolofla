//
//  JGDInputView.h
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDInputView : UIView <UITextViewDelegate>

@property (copy, nonatomic) void (^blockStr)(NSString *);

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextView *putTextView;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *placeHolderString;

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *confirmBtn;
@property (nonatomic, strong)UILabel *placeHolderLB;

@end
