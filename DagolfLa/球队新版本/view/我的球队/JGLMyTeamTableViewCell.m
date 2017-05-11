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
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 5 * screenWidth / 320, kWvertical(69), kHvertical(69))];
        self.iconImageV.layer.cornerRadius = 5 * screenWidth / 320;
        self.iconImageV.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageV];
        [self.iconImageV setContentMode:UIViewContentModeScaleAspectFill];
        
        self.iconState = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(40) , 0, kWvertical(29), kHvertical(29))];
        [self.iconImageV addSubview:self.iconState];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(92 * screenWidth / 320, kHvertical(11), screenWidth - 117 * screenWidth / 320, 20 * screenWidth / 320)];
        self.nameLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        self.nameLabel.textColor = RGB(49,49,49);
        [self.contentView addSubview:self.nameLabel];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * screenWidth / 320, kHvertical(40), 12 * screenWidth / 320, 12 * screenWidth / 320)];
        imageV.image = [UIImage imageNamed:@"juli"];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageV];
        
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * screenWidth / 320, kHvertical(35), screenWidth - 135 * screenWidth / 320, 20 * screenWidth / 320)];
        self.adressLabel.textColor = RGB(98,98,98);
        self.adressLabel.font = [UIFont systemFontOfSize:12 * screenWidth / 320];
        [self.contentView addSubview:self.adressLabel];
        
        self.describLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * screenWidth / 320, kHvertical(55), screenWidth - 115 * screenWidth / 320, 20 * screenWidth / 320)];
        self.describLabel.font = [UIFont systemFontOfSize:12 * screenWidth / 320];
        [self.contentView addSubview:self.describLabel];
        self.describLabel.textColor = RGB(160,160,160);

        self.lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 * screenWidth / 320, screenWidth, 3 * screenWidth / 320)];
        self.lightGrayView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        
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
//        _iconState.image  = [UIImage imageNamed:@"jj"];
    }else{
//        self.stateLabel.text = @"";
        _iconState.image  = nil;
    }
}

- (void)newShowData:(JGLMyTeamModel *)model{
    self.lightGrayView.backgroundColor = [UIColor whiteColor];
    
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@.jpg@100w_100h", model.teamKey ];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];

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
        //        _iconState.image  = [UIImage imageNamed:@"jj"];
    }else{
        //        self.stateLabel.text = @"";
        _iconState.image  = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
