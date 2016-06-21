//
//  JGHApplyListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyListViewDelegate <NSObject>



@end

@interface JGHApplyListView : UIView

@property (nonatomic, strong)NSMutableArray *applistArray;


- (void)configViewData:(NSMutableArray *)array;

@end
