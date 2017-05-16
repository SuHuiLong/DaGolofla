//
//  ScoreTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/12/3.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ScoreTableViewCell : UITableViewCell


@property (strong, nonatomic) UILabel* labelTitle;

@property (strong, nonatomic) UIImageView* imgvState;


@end
