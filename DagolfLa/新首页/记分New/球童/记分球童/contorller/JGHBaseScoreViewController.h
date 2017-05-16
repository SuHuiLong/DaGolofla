//
//  JGHBaseScoreViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHBaseScoreViewController : UIViewController

@property (nonatomic, retain)UIScrollView *baseScrollView;

@property (nonatomic, retain)UISegmentedControl *segment;

- (void)createItem;

- (void)segmentAction:(UISegmentedControl *)segment;//导航选择事件

@end
