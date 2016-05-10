//
//  TeamInviteTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
@interface TeamInviteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;

// 区分是否选中
@property (assign, nonatomic) BOOL isSelected;

-(void)showFriendData:(FriendModel *)model;

@end
