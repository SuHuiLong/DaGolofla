//
//  JGHCaddieActivityScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLChooseScoreModel;

@interface JGHCaddieActivityScoreView : UIView

///活动积分
@property (strong, nonatomic) JGLChooseScoreModel* model;

//@property (strong, nonatomic) NSString* userNamePlayer;//打球人姓名
//
//@property (strong, nonatomic) NSNumber* userKeyPlayer;//打球人userkey

@property (copy, nonatomic) void (^blockCaddieActivityScore)(NSString *);

@property (copy, nonatomic) void (^blockCaddieActivityTime)();

@property (copy, nonatomic) void (^blockCaddieActivityAddPalyer)(JGLChooseScoreModel *, NSMutableArray *, NSNumber *);

- (void)reloadTime:(NSString *)time;

- (void)reloadPalyArray:(NSMutableArray *)palyArray;

- (void)reloadData:(JGLChooseScoreModel *)model andUserKey:(NSString *)userKey;

@end
