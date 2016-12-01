//
//  JGLFriendAddTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLFriendAddTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"

#import "NoteHandlle.h"
#import "NoteModel.h"
@implementation JGLFriendAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgvState = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 15*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
        [self addSubview:_imgvState];
        _imgvState.image = [UIImage imageNamed:@"dot_wu"];
        
        _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(50*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        _imgvIcon.image = [UIImage imageNamed:TeamBGImage];
        [self addSubview:_imgvIcon];
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _labelTitle.text = @"啊实打实大声道";
        [self addSubview:_labelTitle];
        
        _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(100*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 14*screenWidth/375)];
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
        [self addSubview:_imgvSex];
    }
    return self;
}

- (void)setMyModel:(MyattenModel *)myModel{
    
    NoteModel *model = [NoteHandlle selectNoteWithUID:myModel.otherUserId];
    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        self.labelTitle.text = myModel.userName;
    }else{
        self.labelTitle.text = model.userremarks;
    }
    [self.imgvIcon sd_setImageWithURL:[Helper imageIconUrl:myModel.pic] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    if ([myModel.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }else{
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    self.imgvIcon.layer.cornerRadius  = self.imgvIcon.frame.size.width /2;
    self.imgvIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
