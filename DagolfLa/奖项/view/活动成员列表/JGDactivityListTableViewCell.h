//
//  JGDactivityListTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGDActivityList.h"

@interface JGDactivityListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headIconV;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *phoneLB;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) JGDActivityList *listModel;

@end
