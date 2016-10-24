//
//  JGHEventViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHEventViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign) NSInteger timeKey;

- (void)getMatchInfo:(NSInteger)timeKey;

@end
