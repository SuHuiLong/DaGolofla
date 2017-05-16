//
//  JGHCaddieWithCaddieScoreView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLCaddieModel;

@interface JGHCaddieWithCaddieScoreView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (copy, nonatomic) void (^blockCaddieMoreScore)();

//
@property (copy, nonatomic) void (^blockCaddieErweimaClick)();

@property (copy, nonatomic) void (^blockCaddieSaomaClick)();

@property (copy, nonatomic) void (^blockCaddieContinueScore)(JGLCaddieModel *);//继续记分

@end
