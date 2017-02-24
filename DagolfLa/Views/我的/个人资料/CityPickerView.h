//
//  CityPickerView.h
//  DagolfLa
//
//  Created by SHL on 2017/2/22.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cityPickerBlock)(NSDictionary *dict);
@interface CityPickerView : UIView
//确认选择回调
@property(nonatomic,strong)cityPickerBlock  cityPickerBlock;
//设置bloc
-(void)setBlock:(cityPickerBlock)block;

/*
 *数据源
 */
@property (nonatomic, strong) NSMutableArray *provincesArray;
@end
