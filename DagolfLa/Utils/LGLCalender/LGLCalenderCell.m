//
//  LGLCalenderCell.m
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "LGLCalenderCell.h"
#import "UIView+Frame.h"
//#define LGLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation LGLCalenderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 8;
        self.dateL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 10*ProportionAdapter, self.width, 20*ProportionAdapter)];
        self.dateL.textAlignment = NSTextAlignmentCenter;
        self.dateL.backgroundColor = [UIColor clearColor];
        self.dateL.font = [UIFont systemFontOfSize:17];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30*ProportionAdapter, self.width, 18*ProportionAdapter)];
        self.priceL.textAlignment = NSTextAlignmentCenter;
        self.priceL.backgroundColor = [UIColor clearColor];
        self.priceL.textColor = [UIColor colorWithHexString:@"#fc5a01"];
        self.priceL.font = [UIFont systemFontOfSize:12];
        
//        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height -0.5, self.frame.size.width, 0.5)];
//        self.line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        
        [self addSubview:self.dateL];
        [self addSubview:self.priceL];
//        [self addSubview:self.line];
    }
    return self;
}


@end
