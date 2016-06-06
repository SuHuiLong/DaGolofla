//
//  JGTeamGroupCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamGroupCollectionViewCell.h"
#import "JGHPlayersModel.h"

@implementation JGTeamGroupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSInteger _collectionHegith;
    if (iPhone5) {
        _collectionHegith = 200;
    }else{
        _collectionHegith = screenHeight/3-20;
    }
//    self.headImageView.frame = CGRectMake(5, 5, (screenWidth-50)/5, _collectionHegith);
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 50/2;
    
}

- (void)configJGHPlayersModel:(JGHPlayersModel *)model{
    
    //image
    [_headImageView sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"addGroup"]];
//    [_headImageView sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO]];
//    @property (weak, nonatomic) IBOutlet UIImageView *headImageView;
    //名字
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    self.name.text = model.name;
    //性别 差点
//    self.sexAndValue.text = [NSString stringWithFormat:@"%@ 差点:%ld", model.sex==0? @"女":@"男", (long)model.almost];
    
    NSString *sexStr = nil;
    if (model.sex == 0) {
        sexStr = @"女";
    }else if (model.sex == 1){
        sexStr = @"男";
    }else{
        sexStr = @"保密";
    }
    
    self.sexAndValue.text = [NSString stringWithFormat:@"%@ 差点:%ld", sexStr, (long)model.almost];
}

@end
