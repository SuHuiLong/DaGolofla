//
//  JGLBankCardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLBankCardTableViewCell.h"
#import "UITool.h"
@implementation JGLBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        _viewBack = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, screenWidth-20*screenWidth/375, 140*screenWidth/375)];
        [self addSubview:_viewBack];
        _viewBack.backgroundColor = [UITool colorWithHexString:@"#408f73" alpha:1];
        _viewBack.layer.cornerRadius = 8*screenWidth/375;
        _viewBack.layer.masksToBounds = YES;
        
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(20*screenWidth/375, 20*screenWidth/375, 44*screenWidth/375, 44*screenWidth/375)];
        [_viewBack addSubview:_iconImg];
        [_iconImg setImage:[UIImage imageNamed:@"nonghang"]];
        
        _titleName = [[UILabel alloc]initWithFrame:CGRectMake(75*screenWidth/375, 20*screenWidth/375, 200*screenWidth/375, 25*screenWidth/375)];
        [_viewBack addSubview:_titleName];
        _titleName.font = [UIFont systemFontOfSize:17*screenWidth/375];
        _titleName.textColor = [UIColor whiteColor];
        _titleName.text = @"中国农业银行";
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(75*screenWidth/375, 40*screenWidth/375, 200*screenWidth/375, 25*screenWidth/375)];
        _stateLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _stateLabel.textColor = [UIColor whiteColor];
        [_viewBack addSubview:_stateLabel];
        _stateLabel.text = @"储蓄卡";
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = CGRectMake(15*screenWidth/375, 90*screenWidth/375, 80*screenWidth/375, 44*screenWidth/375);
        [_viewBack addSubview:_deleteBtn];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-5*ScreenWidth/375, -20*ScreenWidth/375, -5*ScreenWidth/375, -5*ScreenWidth/375);
        _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _deleteBtn.tag = 1000;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
        _deleteBtn.tintColor = [UIColor whiteColor];
        
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/375, 90*screenWidth/375, screenWidth - 140*screenWidth/375, 44*screenWidth/375)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont systemFontOfSize:18*screenWidth/375];
        [_viewBack addSubview:_numLabel];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.text = @"***************5727";
        
    }
    return self;
}

-(void)showData:(JGLBankModel *)model
{
    NSArray* arrIcon = @[@"zhonghang",@"nonghang",@"jianhang",@"gonghang",@"jiaohang",@"youzheng",@"zhaohang",@"zhongxin",@"minsheng",@"xingye"];
    NSArray* arrColor = @[@"#a71e32",@"#408f73",@"#0092dd",@"#b32032",@"#0f4282",@"#018263",@"#c8271d",@"#c82316",@"#1c69c0",@"#014299"];

    [_iconImg setImage:[UIImage imageNamed:arrIcon[[model.cardType integerValue]-1]]];
    _viewBack.backgroundColor = [UITool colorWithHexString:arrColor[[model.cardType integerValue]-1] alpha:1];
    if (![Helper isBlankString:model.backName]) {
        _titleName.text = model.backName;
    }
    else{
        _titleName.text = @"您未填写银行名称";
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%@",model.cardNumber];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
