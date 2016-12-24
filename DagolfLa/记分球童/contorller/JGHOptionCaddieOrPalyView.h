//
//  JGHOptionCaddieOrPalyView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHOptionCaddieOrPalyView : UIView

@property (copy, nonatomic) void (^blockSelectPalyer)();

@property (copy, nonatomic) void (^blockSelectCaddie)();

@end
