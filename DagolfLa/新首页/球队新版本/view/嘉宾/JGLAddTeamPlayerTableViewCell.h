//
//  JGLAddTeamPlayerTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/9/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLTeamMemberModel.h"
@interface JGLAddTeamPlayerTableViewCell : UITableViewCell



@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel* nameLabel;

@property (strong, nonatomic) UIImageView* sexImgv;

@property (strong, nonatomic) UILabel* almostLabel;

@property (strong, nonatomic) UILabel* mobileLabel;

@property (strong, nonatomic) UIImageView *stateImgv;


-(void)showData:(JGLTeamMemberModel *)model;

@end
