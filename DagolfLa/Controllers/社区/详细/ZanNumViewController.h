//
//  ZanNumViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/8/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

#import "CommunityViewController.h"

#import "CommunityModel.h"
#import "YMTextData.h"

@interface ZanNumViewController : ViewController


@property (nonatomic,strong) CommunityModel *comModel;
@property (nonatomic, strong) YMTextData *ymModel;

// like 667     share 668
@property (nonatomic, assign) NSInteger likeOrShar;

@end
