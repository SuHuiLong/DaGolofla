//
//  JGLGuestAddPlayerTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGuestAddPlayerTableViewCell.h"

@implementation JGLGuestAddPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 15*ProportionAdapter, 40*ProportionAdapter, 30*ProportionAdapter)];
        _labelName.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _labelName.text = @"姓名";
        [self.contentView addSubview:_labelName];
        
        _textName = [[UITextField alloc]initWithFrame:CGRectMake(60*ProportionAdapter, 15*ProportionAdapter, 100*ProportionAdapter, 30*ProportionAdapter)];
        _textName.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        [self.contentView addSubview:_textName];
        
        _btnMan = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMan.frame = CGRectMake(170*ProportionAdapter, 15*ProportionAdapter, 80*ProportionAdapter, 30*ProportionAdapter);
        [self.contentView addSubview:_btnMan];
        
        _labelMan = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40*ProportionAdapter, 30*ProportionAdapter)];
        _labelMan.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _labelMan.text = @"男";
        _labelMan.textAlignment = NSTextAlignmentRight;
        [_btnMan addSubview:_labelMan];
        
        _imgvMan = [[UIImageView alloc]initWithFrame:CGRectMake(50*ProportionAdapter, 5*ProportionAdapter, 20*ProportionAdapter, 20*ProportionAdapter)];
        _imgvMan.image = [UIImage imageNamed:@"gou_w"];
        [_btnMan addSubview:_imgvMan];
        
        
        _btnWomen = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWomen.frame = CGRectMake(250*ProportionAdapter, 15*ProportionAdapter, 80*ProportionAdapter, 30*ProportionAdapter);
        [self.contentView addSubview:_btnWomen];
        
        _labelWomen = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40*ProportionAdapter, 30*ProportionAdapter)];
        _labelWomen.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _labelWomen.text = @"女";
        _labelWomen.textAlignment = NSTextAlignmentRight;
        [_btnWomen addSubview:_labelWomen];
        
        _imgvWomen = [[UIImageView alloc]initWithFrame:CGRectMake(50*ProportionAdapter, 5*ProportionAdapter, 20*ProportionAdapter, 20*ProportionAdapter)];
        _imgvWomen.image = [UIImage imageNamed:@"gou_w"];
        [_btnWomen addSubview:_imgvWomen];
        
        
        
        _labelAlmost = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 75*ProportionAdapter, 40*ProportionAdapter, 30*ProportionAdapter)];
        _labelAlmost.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _labelAlmost.text = @"差点";
        [self.contentView addSubview:_labelAlmost];
        
        _textAlmost = [[UITextField alloc]initWithFrame:CGRectMake(60*ProportionAdapter, 75*ProportionAdapter, 100*ProportionAdapter, 30*ProportionAdapter)];
        _textAlmost.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        [self.contentView addSubview:_textAlmost];
        
        _labelMobile = [[UILabel alloc]initWithFrame:CGRectMake(165*ProportionAdapter, 75*ProportionAdapter, 55*ProportionAdapter, 30*ProportionAdapter)];
        _labelMobile.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _labelMobile.text = @"手机号";
        [self.contentView addSubview:_labelMobile];
        
        _textMobile = [[UITextField alloc]initWithFrame:CGRectMake(220*ProportionAdapter, 75*ProportionAdapter, 100*ProportionAdapter, 30*ProportionAdapter)];
        _textMobile.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        [self.contentView addSubview:_textMobile];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
