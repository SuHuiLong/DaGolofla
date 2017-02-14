//
//  JGHIndexEventView.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHIndexEventView : UIView

@property (nonatomic, strong) UIImageView *iconImageV;
@property (nonatomic, strong) UIImageView *isVideoImageV;

@property (nonatomic, strong) UILabel *titleNewsLB;
@property (nonatomic, strong) UILabel *deltailLB;

- (void)configJGHIndexEventView:(NSDictionary *)dict;

@end
