//
//  TeamIntroduceViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface TeamIntroduceViewCell : UITableViewCell


@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* detroLabel;
@property (strong, nonatomic) UIImageView* jtImage;

@end
