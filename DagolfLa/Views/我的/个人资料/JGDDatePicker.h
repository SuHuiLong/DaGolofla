//
//  JGDDatePicker.h
//  DagolfLa
//
//  Created by 東 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDDatePicker : UIView

@property (copy, nonatomic) void (^blockStr)(NSString *);

@property (nonatomic, strong) UIDatePicker *dataPickerView;
@property (nonatomic, strong) NSDate *lastDate;

@end
