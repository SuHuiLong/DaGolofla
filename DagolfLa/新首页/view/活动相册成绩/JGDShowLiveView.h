//
//  JGDShowLiveView.h
//  DagolfLa
//
//  Created by 東 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDShowLiveView : UIView

@property (nonatomic, strong)UIImageView *activityImageView;

@property (nonatomic, strong)UIImageView *isSignUpImageView;

@property (nonatomic ,strong)UILabel *activityName;

@property (nonatomic ,strong)UILabel *time;

@property (nonatomic ,strong)UILabel *address;

- (void)configJGHShowLiveView:(NSDictionary *)dic;

@end
