//
//  JGHNewFriendAddTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewFriendAddTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"

@implementation JGHNewFriendAddTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        _imgvIcon.image = [UIImage imageNamed:TeamBGImage];
        [self addSubview:_imgvIcon];
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(70*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _labelTitle.text = @"啊实打实大声道";
        [self addSubview:_labelTitle];
        
        _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(70*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 14*screenWidth/375)];
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
        [self addSubview:_imgvSex];
        
        _selectImgv = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - 45)*screenWidth/375, 17*screenWidth/375, 15*screenWidth/375, 15*screenWidth/375)];
        //        [_selectImgv setImage: [UIImage imageNamed:@"duihao"]];
        _selectImgv.hidden = YES;
        [self addSubview:_selectImgv];
    }
    return self;
}

- (void)setMyModel:(MyattenModel *)myModel{
    
    //    NoteModel *model = [NoteHandlle selectNoteWithUID:myModel.otherUserId];
    //    if (myModel.userName == nil) {
    self.labelTitle.text = myModel.userName;
    //    }else{
    //        self.labelTitle.text = model.userremarks;
    //    }
    
//    [self.imgvIcon sd_setImageWithURL:[Helper imageUrl:[NSString stringWithFormat:@"%@", myModel.friendUserKey]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    [self.imgvIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[myModel.friendUserKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    if ([myModel.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }else{
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    self.imgvIcon.layer.cornerRadius  = self.imgvIcon.frame.size.width /2;
    self.imgvIcon.layer.masksToBounds = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
