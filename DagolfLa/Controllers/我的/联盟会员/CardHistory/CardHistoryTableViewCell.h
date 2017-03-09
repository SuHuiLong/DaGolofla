//
//  CardHistoryTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardHIstoryModel.h"

@interface CardHistoryTableViewCell : UITableViewCell
//上竖线
@property(nonatomic,copy)UIView *topLineImageView;
//下竖线
@property(nonatomic,copy)UIView *bottomLineImageView;

//配置数据
-(void)configModel:(CardHIstoryModel *)model;

@end
