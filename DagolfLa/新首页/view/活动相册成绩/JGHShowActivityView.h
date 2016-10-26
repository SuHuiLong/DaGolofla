//
//  JGHShowActivityView.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHShowActivityView : UIView

@property (nonatomic, strong)UIImageView *activityImageView;

@property (nonatomic, strong)UIImageView *isSignUpImageView;

@property (nonatomic ,strong)UILabel *activityName;

@property (nonatomic ,strong)UILabel *time;

@property (nonatomic ,strong)UILabel *address;

- (void)configJGHShowActivityView:(NSDictionary *)dataDict;

@end
