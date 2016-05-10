//
//  YueWaitTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/10/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueWaitTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "NoteHandlle.h"
#import "NoteModel.h"

@implementation YueWaitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showData:(RewordCheckModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    if ([model.state integerValue] == 0) {
        if (![Helper isBlankString:model.userName]) {
            
            NoteModel *noteMod = [NoteHandlle selectNoteWithUID:model.userId];
            if ([noteMod.userremarks isEqualToString:@"(null)"] || [noteMod.userremarks isEqualToString:@""] || noteMod.userremarks == nil) {
                _nameLabel.text = [NSString stringWithFormat:@"%@(待审核)",model.userName];
            }else{
                _nameLabel.text = [NSString stringWithFormat:@"%@(待审核)",noteMod.userremarks];
            }            
//            _nameLabel.text = [NSString stringWithFormat:@"%@(待审核)",model.userName];
        }
        else
        {
            _nameLabel.text = [NSString stringWithFormat:@"暂无用户名(待审核)"];
        }
        
    }
    else if ([model.state integerValue] == 1)
    {
        if (![Helper isBlankString:model.userName]) {
            _nameLabel.text = [NSString stringWithFormat:@"%@(已通过)",model.userName];
        }
        else
        {
            _nameLabel.text = [NSString stringWithFormat:@"暂无用户名(已通过)"];
        }

        
    }
    else if ([model.state integerValue] == 2)
    {
        if (![Helper isBlankString:model.userName]) {
            _nameLabel.text = [NSString stringWithFormat:@"%@(已拒绝)",model.userName];
        }
        else
        {
            _nameLabel.text = [NSString stringWithFormat:@"暂无用户名(已拒绝)"];
        }
        
    }
    else
    {
        if (![Helper isBlankString:model.userName]) {
            _nameLabel.text = [NSString stringWithFormat:@"%@(已取消)",model.userName];
        }
        else
        {
            _nameLabel.text = [NSString stringWithFormat:@"暂无用户名(已取消)"];
        }
    }

    
}


@end
