//
//  JGHCaddieScoreListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHCaddieWithPalyerScoreView : UIView

@property (copy, nonatomic) void (^blockSelectMyCode)();

@property (copy, nonatomic) void (^blockSelectSweepCode)();

@property (copy, nonatomic) void (^blockSelectMoreScore)();

@property (copy, nonatomic) void (^blockShowCaddieBtn)();

@property (copy, nonatomic) void (^blockHideCaddieBtn)();

@property (copy, nonatomic) void (^blockHistoryScore)();


@property (copy, nonatomic) void (^blockPlayerHisScoreCard)(NSNumber *);

@property (copy, nonatomic) void (^blockNotActScore)(NSNumber *);


@property (nonatomic, strong) UITableView *tableView;

- (void)blackQRcodeName:(NSString *)name andThrow:(NSInteger)sourethrow;

@end
