//
//  JGDPickerView.h
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic) void (^blockStr)(NSString *);

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *selectString;

@property (nonatomic,assign) NSInteger selectRow;

@end
