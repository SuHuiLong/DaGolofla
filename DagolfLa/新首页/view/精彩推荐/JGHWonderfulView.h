//
//  JGHWonderfulView.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHWonderfulView : UIView

@property (nonatomic, strong)UIImageView *activityImageView;

@property (nonatomic ,strong)UILabel *name;

- (void)configJGHWonderfulView:(NSDictionary *)dict;

@end
