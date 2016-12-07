//
//  JGHPersonalInfoViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHPersonalInfoViewController : ViewController

@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UIImageView *sexImageView;

@property (nonatomic, retain)UILabel *nickname;

@property (nonatomic, retain)UILabel *alm;

@property (nonatomic, retain)UILabel *almost;

@property (nonatomic, retain)UILabel *note;

@property (nonatomic, retain)UIView *dynamicView;

@property (nonatomic, retain)UILabel *nick;

typedef void(^PersonRemark)(NSString *);
@property(nonatomic,copy)PersonRemark personRemark;

//用户key
@property (nonatomic, retain)NSNumber *otherKey;

@end
