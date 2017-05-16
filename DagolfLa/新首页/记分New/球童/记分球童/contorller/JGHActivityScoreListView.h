//
//  JGHActivityScoreListView.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLChooseScoreModel;

@interface JGHActivityScoreListView : UIView

@property (copy, nonatomic) void (^blockChangeActivityStartScore)(JGLChooseScoreModel *);

- (void)loadActivityListData:(NSString *)userKey;


- (void)loadAnimate;


@end
