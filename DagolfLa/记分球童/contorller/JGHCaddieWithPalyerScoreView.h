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


- (void)blackQRcodeName:(NSString *)name andThrow:(NSInteger)sourethrow;

@end
