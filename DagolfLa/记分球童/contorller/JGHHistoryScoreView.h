//
//  JGHHistoryScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGDHistoryScoreModel;

@interface JGHHistoryScoreView : UIView

@property (copy, nonatomic) void (^blockSelectHistoryScore)(JGDHistoryScoreModel *);

@property (copy, nonatomic) void (^blockSelectHistoryScoreAlert)(UIAlertController *);


@end
