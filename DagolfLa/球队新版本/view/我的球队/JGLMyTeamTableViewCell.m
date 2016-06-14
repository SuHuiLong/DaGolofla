//
//  JGLMyTeamTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLMyTeamTableViewCell.h"

@implementation JGLMyTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5 * screenWidth / 320, 5 * screenWidth / 320, 70 * screenWidth / 320, 70 * screenWidth / 320)];
        //        self.iconImageV.backgroundColor = [UIColor orangeColor];
        self.iconImageV.layer.cornerRadius = 5 * screenWidth / 320;
        self.iconImageV.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageV];
        
        self.iconState = [[UIImageView alloc] initWithFrame:CGRectMake(40* screenWidth / 320 , 0, 30 * screenWidth / 320, 30 * screenWidth / 320)];
        [self.iconImageV addSubview:self.iconState];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * screenWidth / 320, 5 * screenWidth / 320, screenWidth - 160 * screenWidth / 320, 20 * screenWidth / 320)];
        self.nameLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self.contentView addSubview:self.nameLabel];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * screenWidth / 320, 30 * screenWidth / 320, 18 * screenWidth / 320, 18 * screenWidth / 320)];
        imageV.image = [UIImage imageNamed:@"juli"];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageV];
        
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * screenWidth / 320, 30 * screenWidth / 320, screenWidth - 90 * screenWidth / 320, 20 * screenWidth / 320)];
        self.adressLabel.textColor = [UIColor lightGrayColor];
        self.adressLabel.font = [UIFont systemFontOfSize:12 * screenWidth / 320];
        [self.contentView addSubview:self.adressLabel];
        
        self.describLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * screenWidth / 320, 55 * screenWidth / 320, screenWidth - 90 * screenWidth / 320, 20 * screenWidth / 320)];
        self.describLabel.font = [UIFont systemFontOfSize:12 * screenWidth / 320];
        [self.contentView addSubview:self.describLabel];
        
        UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 * screenWidth / 320, screenWidth, 3 * screenWidth / 320)];
        lightGrayView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.contentView addSubview:lightGrayView];
        
        
    }
    
    return self;
}

-(void)showData:(JGLMyTeamModel *)model
{
    NSLog(@"%@",[Helper setImageIconUrl:[model.teamKey integerValue]]);
    [self.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[model.teamKey integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@人)",model.name,model.userSum];
    self.adressLabel.text = model.crtyName;
    self.describLabel.text = model.info;
    if ([model.state integerValue] == 0) {
//        self.stateLabel.text = @"正在审核";
        _iconState.image  = [UIImage imageNamed:@"dsh"];
    }else if ([model.state integerValue] == 2){
//        self.stateLabel.text = @"审核未通过";
        _iconState.image  = [UIImage imageNamed:@"jj"];
    }else{
//        self.stateLabel.text = @"";
        _iconState.image  = [UIImage imageNamed:@"tg"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
