//
//  JGHCaddieScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHCaddieScoreView : UIView

//@property (strong, nonatomic) NSString* userNamePlayer;//打球人姓名
//
//@property (strong, nonatomic) NSNumber* userKeyPlayer;//打球人userkey
//
//@property (strong, nonatomic) NSString* userMobilePlayer;//打球人手机号
//
//@property (assign, nonatomic)NSInteger sex;//性别

@property (copy, nonatomic) void (^blockCaddieActivityScore)(NSString *);

@property (copy, nonatomic) void (^blockSelectBall)();

@property (copy, nonatomic) void (^blockSelectTime)();

@property (copy, nonatomic) void (^blockSelectPalyer)(NSMutableArray *);

- (void)reloadDataBallArray:(NSArray *)dataBallArray andSelectAreaArray:(NSArray *)selectAreaArray andNumTimeKeyLogo:(NSInteger)numTimeKeyLogo andBtnEnble:(BOOL)enble;

- (void)reloadBallName:(NSString *)ballName andBallId:(NSInteger)ballID;

- (void)reloadTime:(NSString *)time;

- (void)reloadPalyerArray:(NSMutableArray *)palerArray;

- (void)reloadCaddieDefaultUserKeyPlayer:(NSString *)userKeyPlayer andUserNamePlayer:(NSString *)userNamePlayer andSex:(NSInteger)sex;

@end
