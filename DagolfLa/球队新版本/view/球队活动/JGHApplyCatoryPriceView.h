//
//  JGHApplyCatoryPriceView.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyCatoryPriceViewDelegate <NSObject>

- (void)selectApplyCatory:(NSMutableDictionary *)costDict;

@end

@interface JGHApplyCatoryPriceView : UIView

@property (nonatomic, weak)id <JGHApplyCatoryPriceViewDelegate> delegate;

- (void)configViewData:(NSMutableArray *)dataArray;

@end
