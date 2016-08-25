//
//  JGMenberTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMenberTableViewCell.h"
#import "UITool.h"
@implementation JGMenberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        [self addSubview:_iconImgv];
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.layer.cornerRadius = 40*screenWidth/375/2;
        [_iconImgv setImage:[UIImage imageNamed:DefaultHeaderImage]];//moren
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.text = @"没什么特长就名字特长";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor blackColor];
        
        
        _sexImgv = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 16*screenWidth/375)];
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
        [self addSubview:_sexImgv];
        
        _almostLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/375, 30*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
        _almostLabel.textColor = [UIColor blackColor];
        _almostLabel.text = @"差点 39";
        [self addSubview:_almostLabel];
        _almostLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
        _poleLabel = [[UILabel alloc]initWithFrame:CGRectMake(160*screenWidth/375, 30*screenWidth/375, 130*screenWidth/375, 20*screenWidth/375)];
        _poleLabel.textColor = [UIColor blackColor];
        _poleLabel.text = @"平均杆数 102杆";
        [self addSubview:_poleLabel];
        _poleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - 90)*screenWidth/375, 13*screenWidth/375, 60*screenWidth/375, 24*screenWidth/375)];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        
        _moneyLabel.hidden = NO;
        _moneyLabel.text = nil;
        [self addSubview:_moneyLabel];
        _moneyLabel.layer.cornerRadius = 5*screenWidth/375;
        _moneyLabel.layer.masksToBounds = YES;
        _moneyLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    }
    return self;
}

- (void)showData:(JGLTeamMemberModel *)model andPower:(NSString *)power
{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    
    if ([model.sex integerValue] == 0) {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    _almostLabel.text = [NSString stringWithFormat:@"%@",model.almost];
    
    //显示模式XXX。。。XXX
    if ([power containsString:@"1001"]) {
        _poleLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
    }else{
        if (model.mobile.length == 11) {
            _poleLabel.text = [NSString stringWithFormat:@"%@***%@",[model.mobile substringToIndex:3], [model.mobile substringFromIndex:8]];
        }else{
            _poleLabel.text = [NSString stringWithFormat:@"%@***", model.mobile];
        }
    }
    
    
    _moneyLabel.hidden = NO;
    _moneyLabel.text = nil;
    _moneyLabel.textColor = [UIColor blackColor];
    
    /**
     public static final int  IDENTITY_UNKNOW            =  0;   // 未知
     public static final int  IDENTITY_CAPTAIN           =  1;   //队长
     public static final int  IDENTITY_PRESIDENT         =  2;   //会长
     public static final int  IDENTITY_VICEPRESIDENT     =  3;   //副会长
     public static final int  IDENTITY_SECRETARYGENERAL  =  4;   //球队秘书长
     public static final int  IDENTITY_SECRETARY         =  5;   //球队秘书
     public static final int  IDENTITY_MOHAMED           =  6;   //干事
     */
    
    if(model.identity == 1){
        _moneyLabel.text = @"队长";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#fec72e" alpha:1];
    }else if(model.identity == 2){
        _moneyLabel.text = @"会长";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#6cd9a3" alpha:1];
    }else if(model.identity == 3){
        _moneyLabel.text = @"副会长";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#6cd9a3" alpha:1];
    }else if(model.identity == 4){
        _moneyLabel.text = @"秘书长";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#6cd9a3" alpha:1];
    }else if(model.identity == 5){
        _moneyLabel.text = @"秘书";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#6cd9a3" alpha:1];
    }else if(model.identity == 6){
        _moneyLabel.text = @"干事";
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.backgroundColor = [UITool colorWithHexString:@"#6cd9a3" alpha:1];
    }else{
        _moneyLabel.hidden = YES;
    }
    
}

- (void)configJGHPlayersModel:(JGHPlayersModel *)model{
    [_iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"addGroup"]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    if (model.sex == 0) {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
    }
    else
    {
        [_sexImgv setImage: [UIImage imageNamed:@"xb_nn"]];
    }
    
    _almostLabel.text = [NSString stringWithFormat:@"%@", model.almost];
    
    if (![Helper isBlankString:model.mobile]) {
        _poleLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    }
    else{
        _poleLabel.text = [NSString stringWithFormat:@"暂无手机号"];
    }
    [_poleLabel setUserInteractionEnabled:YES];
    _poleLabel.textColor = [UIColor blueColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [_poleLabel addGestureRecognizer:recognizer];
    
    _moneyLabel.hidden = NO;
    _moneyLabel.text = nil;
    _moneyLabel.textColor = [UIColor blackColor];
    if (model.groupIndex < 0) {
        _moneyLabel.text = @"未分组";
        _moneyLabel.textColor = [UIColor redColor];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"%td组%td号", model.groupIndex+1, model.sortIndex+1];
    }
    
}

- (void)clickTap:(UITapGestureRecognizer *)recognizer{
    NSLog(@"%@", _poleLabel.text);
    NSString *string = [_poleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length == 0)
    {
        if (self.delegate) {
            [self.delegate makePhoneClick:_poleLabel.text];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
