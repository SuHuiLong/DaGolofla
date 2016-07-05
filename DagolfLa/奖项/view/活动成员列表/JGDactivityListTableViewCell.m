
//
//  JGDactivityListTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDactivityListTableViewCell.h"

@implementation JGDactivityListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.selectImage.userInteractionEnabled = YES;
        [self.contentView addSubview:self.selectImage];
        
        self.headIconV = [[UIImageView alloc] initWithFrame:CGRectMake(50 * screenWidth / 375, 5 * screenWidth / 375, 40 * screenWidth / 375, 40 * screenWidth / 375)];
        self.headIconV.layer.cornerRadius = 20 * screenWidth / 375;
        self.headIconV.clipsToBounds = YES;
        [self.contentView addSubview:self.headIconV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(100 * screenWidth / 375, 0, 80 * screenWidth / 375, 50 * screenWidth / 375)];
        self.nameLB.font = [UIFont systemFontOfSize:16 * screenWidth / 375];
        [self.contentView addSubview:self.nameLB];
        
        self.phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(190 * screenWidth / 375, 0, 200 * screenWidth / 375, 50 * screenWidth / 375l)];
        self.phoneLB.font = [UIFont systemFontOfSize:16 * screenWidth / 375];
        [self.contentView addSubview:self.phoneLB];
        
        
    }
    return self;
}

- (void)setListModel:(JGDActivityList *)listModel{
    self.nameLB.text = listModel.name;
    NSString *str = [NSString stringWithFormat:@"%@", listModel.mobile];
    NSMutableString *muatbleStr = [str mutableCopy];
    [muatbleStr replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    self.phoneLB.text = muatbleStr;
    [self.headIconV sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[listModel.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
    if (listModel.isSelect) {
        self.selectImage.image = [UIImage imageNamed:@"kuang_xz"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"kuang"];
    }

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
