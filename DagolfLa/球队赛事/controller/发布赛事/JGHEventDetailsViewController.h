//
//  JGHEventDetailsViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHEventDetailsViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign) NSInteger timeKey;

- (void)getMatchInfo:(NSInteger)timeKey;

@end
