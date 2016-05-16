//
//  UIColor+ColorTransfer.h
//  legalaid
//
//  Created by 小鱼 on 15/6/24.
//  Copyright (c) 2015年 com.bestone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorTransfer)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end
