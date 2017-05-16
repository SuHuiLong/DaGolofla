//
//  JGDActivityHeadView.h
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGTeamAcitivtyModel.h"

@interface JGDActivityHeadView : UIView

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *activityTitleLB;

@property (nonatomic, strong) UILabel *dateLB;

@property (nonatomic, strong) UILabel *addressLB;


@property (nonatomic, strong)JGTeamAcitivtyModel *model;


@end
