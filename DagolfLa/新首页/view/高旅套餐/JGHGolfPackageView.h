//
//  JGHGolfPackageView.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHGolfPackageViewDelegate <NSObject>

- (void)didSelectGolgPackageViewUrlString:(NSInteger)selectID;

@end

@interface JGHGolfPackageView : UIView

@property (weak, nonatomic)id <JGHGolfPackageViewDelegate> delegate;

- (void)configJGHGolfPackageViewData:(NSArray *)dataArray;

@end
