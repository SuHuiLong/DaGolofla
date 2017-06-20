//
//  RedPacketTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/6/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "RedPacketTableViewCell.h"

@implementation RedPacketTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ClearColor;
        [self createView];
    }
    return self;
}

#pragma mark - CreateView
-(void)createView{
    //选中图标
    _selectImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(11), kHvertical(52), kHvertical(21), kHvertical(21)) Image:[UIImage imageNamed:@"icon_unselect_lucky"]];
    _selectImageView.hidden = true;
    [self.contentView addSubview:_selectImageView];
    //左背景
    UIImageView *leftImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(11), 0, kWvertical(125), kHvertical(125)) Image:[UIImage imageNamed:@"bg_luckybag_left"]];
    _leftImageView = leftImageView;
    [self.contentView addSubview:leftImageView];
    //黄色圆形背景
    UIView *yellowView = [Factory createViewWithBackgroundColor:RGB(252,207,67) frame:CGRectMake(kWvertical(10), kHvertical(22), kHvertical(83), kHvertical(83))];
    yellowView.layer.cornerRadius = kHvertical(41.5);
    yellowView.layer.masksToBounds = true;
    [leftImageView addSubview:yellowView];
    _circleView = yellowView;
    //金额
    _moneyLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(15), kWvertical(83), kHvertical(31)) textColor:RGB(255,255,255) fontSize:kHorizontal(40) Title:nil];
    [_moneyLabel setTextAlignment:NSTextAlignmentCenter];
    [yellowView addSubview:_moneyLabel];
    //满减条件
    _conditionLabel = [Factory createLabelWithFrame:CGRectMake(0, _moneyLabel.y_height + kHvertical(7), kWvertical(83), kHvertical(10)) textColor:RGB(255,255,255) fontSize:kHorizontal(11) Title:nil];
    [_conditionLabel setTextAlignment:NSTextAlignmentCenter];
    [yellowView addSubview:_conditionLabel];
    
    //右背景
    UIImageView *rightImageView = [Factory createImageViewWithFrame:CGRectMake(leftImageView.x_width, leftImageView.y, screenWidth - leftImageView.x_width, leftImageView.height) Image:[UIImage imageNamed:@"bg_luckybag_right"]];
    _rightImageView = rightImageView;
    [self.contentView addSubview:rightImageView];
    //红包类型和剩余天数
    _residueLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(0), kHvertical(31), rightImageView.width, kHvertical(16)) textColor:RGB(49,49,49) fontSize:kHorizontal(16) Title:nil];
    [rightImageView addSubview:_residueLabel];
    //使用条件
    UIView *circle1 = [Factory createViewWithBackgroundColor:RGB(197,197,197) frame:CGRectMake(kWvertical(2), kHvertical(71), kWvertical(4), kHvertical(4))];
    circle1.layer.masksToBounds = true;
    circle1.layer.cornerRadius = kWvertical(2);
    [rightImageView addSubview:circle1];
    _serviceLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(11), kHvertical(67), kWvertical(200), kHvertical(13)) textColor:RGB(160,160,160) fontSize:kHvertical(13) Title:@"订场全额预付可用"];
    [rightImageView addSubview:_serviceLabel];
    //有效期
    UIView *circle2 = [Factory createViewWithBackgroundColor:RGB(197,197,197) frame:CGRectMake(kWvertical(2), kHvertical(91), kWvertical(4), kHvertical(4))];
    circle2.layer.masksToBounds = true;
    circle2.layer.cornerRadius = kWvertical(2);
    [rightImageView addSubview:circle2];
    _endTimeLabel = [Factory createLabelWithFrame:CGRectMake(_serviceLabel.x, kHvertical(87), _serviceLabel.width, kHvertical(13)) textColor:RGB(160,160,160) fontSize:kHorizontal(13) Title:nil];
    [rightImageView addSubview:_endTimeLabel];
    
}

#pragma mark - InitData
//配置界面数据
-(void)configModel:(RedPacketModel *)model{
    //金额
    NSString *money = [NSString stringWithFormat:@"¥%ld",(long)model.money];
    NSMutableAttributedString *moneyAstring = [[NSMutableAttributedString alloc] initWithString:money];
    [moneyAstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(18)] range:NSMakeRange(0, 1)];
    _moneyLabel.attributedText = moneyAstring;
    //满减条件
    _moneyLabel.y = kHvertical(27);
    if (model.minSellMoney>0) {
        _moneyLabel.y = kHvertical(15);
        NSString *conditionStr = [NSString stringWithFormat:@"满%ld可用",(long)model.minSellMoney];
        _conditionLabel.text = conditionStr;
    }
    //红包类型和剩余天数
    NSString *type = @"订场分享红包";
    NSInteger remainingtime = model.remainingtime;
    
    NSMutableAttributedString *residueAstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",type]];
    NSString *buttonString = model.stateButtonString;
    NSLog(@"%@",buttonString);
    if (remainingtime<4&&remainingtime>=0&&[buttonString isEqualToString:@"有效"]) {
        NSString *remainingTime = [NSString stringWithFormat:@"（还剩%ld天）",(long)model.remainingtime];
        residueAstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",type,remainingTime]];
        [residueAstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(13)] range:NSMakeRange(type.length, remainingTime.length)];
        [residueAstr addAttribute:NSForegroundColorAttributeName value:RGB(255,72,72) range:NSMakeRange(type.length, remainingTime.length)];
    }
    _residueLabel.attributedText = residueAstr;
    
    //使用条件
    NSString *serviceStr = @"订场全额预付可用";
    _serviceLabel.text = serviceStr;
    //有效期
    NSString *endTime = model.expiryEnd;
    endTime = [Helper stringFromDateString:endTime withFormater:@"yyyy.MM.dd"];
    endTime = [NSString stringWithFormat:@"有效期至%@",endTime];
    _endTimeLabel.text = endTime;
}
//历史红包
-(void)configHistoryModel:(RedPacketModel *)model{
    NSString *buttonString = model.stateButtonString;
    _leftImageView.image = [UIImage imageNamed:@"bg_luckybag_leftnocolor"];
    //右边背景
    NSString *rightImageStr = @"bg_luckybag_rightused";
    if ([buttonString isEqualToString:@"已过期"]) {
        rightImageStr = @"bg_luckybag_rightexpired";
    }else if ([buttonString isEqualToString:@"已失效"]){
        rightImageStr = @"bg_luckybag_rightinvalid";
    }
    _circleView.backgroundColor = RGB(197,197,197);
    _rightImageView.image = [UIImage imageNamed:rightImageStr];
    [self configModel:model];
}
//选择红包
-(void)configSelectModel:(RedPacketModel *)model selectModel:(RedPacketModel *)selectModel{
    _selectImageView.hidden = false;
    _leftImageView.x = kWvertical(46);
    _rightImageView.x = _leftImageView.x_width;
    
    NSString *imageName = @"icon_unselect_lucky";
    if ([selectModel isEqual:model]) {
        imageName = @"icon_select_lucky";
    }
    _selectImageView.image = [UIImage imageNamed:imageName];
    [self configModel:model];
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
