//
//  NewsDetailViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/8/30.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDetailModel.h"
@interface NewsDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)showData:(NewsDetailModel *)model;
-(void)showPeople:(NewsDetailModel *)model;
@end
