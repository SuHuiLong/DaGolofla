//
//  JGHScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHScoreView : UIView

@property (copy, nonatomic) void (^blockSelectBall)();

@property (copy, nonatomic) void (^blockSelectTime)();

@property (copy, nonatomic) void (^blockSelectPalyer)(NSMutableArray *);

@property (copy, nonatomic) void (^blockSelectScore)(NSString *);

- (void)reloadDataBallArray:(NSArray *)dataBallArray andSelectAreaArray:(NSArray *)selectAreaArray andNumTimeKeyLogo:(NSInteger)numTimeKeyLogo;

- (void)reloadBallName:(NSString *)ballName andBallId:(NSInteger)ballID;

- (void)reloadTime:(NSString *)time;

- (void)reloadPalyerArray:(NSArray *)palerArray;

@end
