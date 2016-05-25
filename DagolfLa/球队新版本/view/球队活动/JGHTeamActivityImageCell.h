//
//  JGHTeamActivityImageCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@protocol JGHTeamActivityImageCellDelegate <NSObject>

- (void)didSelectPhotoImage;

@end

@interface JGHTeamActivityImageCell : UITableViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
//球队名称
@property (weak, nonatomic) IBOutlet UITextView *teamNameText;
//占位符
@property (weak, nonatomic) IBOutlet UILabel *placeholdertext;

@property (nonatomic, weak) id <JGHTeamActivityImageCellDelegate> delegate;

@end
