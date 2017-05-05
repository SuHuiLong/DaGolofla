//
//  JGLPresentAwardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPresentAwardTableViewCell.h"
#import "JGHAwardModel.h"

@implementation JGLPresentAwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(kWvertical(10), kHvertical(14), kWvertical(22), kHvertical(22))];
        _iconImgv.image = [UIImage imageNamed:@"add_prize"];
        [self addSubview:_iconImgv];
        
        
        _titleLabel = [Helper lableRect:CGRectMake(kWvertical(42), 0, 250*screenWidth/320, kHvertical(50)) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(17) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self addSubview:_titleLabel];
        
        
        UILabel *line1LB = [Helper lableRect:CGRectMake(0, kHvertical(50), screenWidth, 1) labelColor:[UIColor colorWithHexString:@"#f5f5f5"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        line1LB.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self.contentView addSubview:line1LB];
        
        _awardLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWvertical(42), kHvertical(51), 150*screenWidth/320, kHvertical(50))];
        _awardLabel.text = @"奖品：纯银奖杯";
        _awardLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        _awardLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        [self addSubview:_awardLabel];
        
        
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWvertical(200), kHvertical(51), kWvertical(150), kHvertical(50))];
        _countLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        _countLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        _countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_countLabel];
        
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(kWvertical(40), kHvertical(101), screenWidth - 20*screenWidth/320, 1)];
        _viewLine.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_viewLine];
        
        
        self.nameTitleLB = [Helper lableRect:CGRectMake(kWvertical(42), kHvertical(102), kWvertical(65), kWvertical(50)) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:kHorizontal(15) text:@"获奖人：" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.nameTitleLB];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWvertical(102), kHvertical(102), screenWidth - kWvertical(140), kWvertical(50))];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#313131"];
        _nameLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        [self addSubview:_nameLabel];


        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(kWvertical(60), kHvertical(102),kWvertical(300), kWvertical(50));
        [_chooseBtn setTitle:@"选择获奖人" forState:UIControlStateNormal];
        [_chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWvertical(-200))];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        [_chooseBtn setTitleColor:[UIColor colorWithHexString:@"#A0A0A0"] forState:(UIControlStateNormal)];
        [self addSubview:_chooseBtn];
        
        self.chooseImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(356), kHvertical(121), kWvertical(8), kHvertical(13))];
        self.chooseImageV.image = [UIImage imageNamed:@")"];
        [self.contentView addSubview:self.chooseImageV];
        
    }
    return self;
}

- (void)configJGHAwardModel:(JGHAwardModel *)model{
    _titleLabel.text = model.name;
    
    if ([model.prizeSize integerValue] == 0) {
        _countLabel.text = _isManager ? @"数量：奖品数量" : @"数量：暂无";
    }else{
        _countLabel.attributedText = [self returnMutableString:[NSString stringWithFormat:@"数量：%@个",model.prizeSize]];
    }
    
    if (model.prizeName && ![model.prizeName isEqualToString:@""]) {
        _awardLabel.attributedText = [self returnMutableString:[NSString stringWithFormat:@"奖品：%@", model.prizeName]];
        _titleLabel.frame = CGRectMake(kWvertical(42), 0, 250*screenWidth/320, kHvertical(50));
    }else{
        _awardLabel.text = _isManager ? @"奖品：奖品名称" : @"奖品：暂无";
        _titleLabel.frame = CGRectMake(kWvertical(42), 0, 150*screenWidth/320, kHvertical(50));
    }
    
    
    if (model.userInfo) {

        if (_isManager) {
            _nameLabel.text = [self stringDeleteLastStr:model.userInfo];
            [model.userInfo isEqualToString:@""] ? [_chooseBtn setTitle:@"选择获奖人" forState:UIControlStateNormal] : [_chooseBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            
            if ([model.isPublish integerValue] == 0) {
                _nameLabel.hidden = YES;
                _nameTitleLB.hidden = YES;
            }else{
                _nameTitleLB.hidden = NO;
                _nameLabel.hidden = NO;
                CGFloat rowHeigth = [Helper getSpaceLabelHeight:model.userInfo withFont:[UIFont systemFontOfSize:kHorizontal(15)] withWidth:screenWidth - kWvertical(140)];
                _nameLabel.numberOfLines = 0;
                
                [Helper setLabelSpace:_nameLabel withValue:[NSString stringWithFormat:@"%@", model.userInfo] withFont:[UIFont systemFontOfSize:kHorizontal(15)]];
                _nameLabel.frame = CGRectMake(kWvertical(102), kHvertical(117), screenWidth - kWvertical(140), rowHeigth);
            }
            

        }
        
    }else{
        
        if (([model.isPublish integerValue] == 0) && !_isManager) {
            _nameLabel.hidden = YES;
            _nameTitleLB.hidden = YES;
        }else{
            _nameTitleLB.hidden = NO;
            _nameLabel.hidden = NO;
        }
        
         _nameLabel.text = @"";
        [_chooseBtn setTitle:@"选择获奖人" forState:UIControlStateNormal];
    }
    
}

- (NSString *)stringDeleteLastStr: (NSString *)string{
    NSString *returnString;
    if (string.length > 0) {
        returnString = [string substringWithRange:NSMakeRange(0, string.length - 2)];
    }
    return returnString;
}

- (NSMutableAttributedString *)returnMutableString:(NSString *)String {
    
    NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:String];
    [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#A0A0A0"] range:NSMakeRange(0, 3)];
    [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#313131"] range:NSMakeRange(3, mutaAttStr.length - 3)];
    return mutaAttStr;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
