//
//  LGLHeaderView.m
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "LGLHeaderView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define LGLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation LGLHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*ProportionAdapter, WIDTH, 19 *ProportionAdapter)];
        self.dateL.textAlignment = NSTextAlignmentCenter;
        self.dateL.textColor = [UIColor blackColor];
        self.dateL.font = [UIFont systemFontOfSize:16*ProportionAdapter];
        [self addSubview:self.dateL];
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 39 *ProportionAdapter, screenWidth -20 *ProportionAdapter, 0.5)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        [self addSubview:self.line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end
