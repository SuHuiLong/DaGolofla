//
//  JGLTeamCounterMemberTableViewCell.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLCompeteMemberModel.h"
@interface JGLTeamCounterMemberTableViewCell : UITableViewCell


@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  UILabel     *nameLabel;
@property (strong, nonatomic)  UIImageView *sexImage;

@property (strong, nonatomic)  UILabel     *chadianLabel;
@property (strong, nonatomic)  UILabel     *mobileLabel;

@property (strong, nonatomic)  UIImageView*    stateImgv;

-(void)showData:(JGLCompeteMemberModel *)model;
-(void)showData:(JGLCompeteMemberModel *)model withUserKey:(NSNumber *)userKey;

@end
