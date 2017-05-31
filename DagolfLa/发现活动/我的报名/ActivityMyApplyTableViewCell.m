//
//  ActivityMyApplyTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityMyApplyTableViewCell.h"

@implementation ActivityMyApplyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //活动照片
    _headerImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(11), kHvertical(69), kHvertical(69)) Image:nil];
    _headerImageView.layer.masksToBounds = true;
    _headerImageView.layer.cornerRadius = kHvertical(6);
    [self.contentView addSubview:_headerImageView];
    //状态
    _statuView = [Factory createButtonWithFrame:CGRectMake(_headerImageView.x_width + kWvertical(11), kHvertical(17), kWvertical(45), kHvertical(16)) titleFont:kHorizontal(11) textColor:WhiteColor backgroundColor:ClearColor target:self selector:nil Title:nil];
    [self.contentView addSubview:_statuView];
    //活动名
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(_headerImageView.x_width + kWvertical(60), kHvertical(15), screenWidth - _headerImageView.x_width - kWvertical(85), kHvertical(20)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:nil];
    [self.contentView addSubview:_nameLabel];
    //时间
    UIImageView *timeImageView = [Factory createImageViewWithFrame:CGRectMake(_headerImageView.x_width + kWvertical(11), kHvertical(42), kWvertical(13), kHvertical(14)) Image:[UIImage imageNamed:@"time"]];
    _timeLabel = [Factory createLabelWithFrame:CGRectMake(_headerImageView.x_width + kWvertical(31), kHvertical(40), kWvertical(90), kHvertical(19)) textColor:RGB(98,98,98) fontSize:kHorizontal(14) Title:nil];
    [self.contentView addSubview:timeImageView];
    [self.contentView addSubview:_timeLabel];
    //位置
    UIImageView *locationImageView = [Factory createImageViewWithFrame:CGRectMake(_headerImageView.x_width + kWvertical(13), kHvertical(63), kWvertical(10), kHvertical(13)) Image:[UIImage imageNamed:@"address"]];
    _parkLabel = [Factory createLabelWithFrame:CGRectMake(_timeLabel.x, kHvertical(60), screenWidth - _timeLabel.x - kWvertical(25), kHvertical(21)) textColor:RGB(98,98,98) fontSize:kHorizontal(14) Title:nil];
    [self.contentView addSubview:locationImageView];
    [self.contentView addSubview:_parkLabel];
    //已报名人数
    _applyLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(40), 0, kHvertical(19)) textColor:RGB(160,160,160) fontSize:kHorizontal(13) Title:nil];
    [self.contentView addSubview:_applyLabel];
    
    //细线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(kWvertical(10), kHvertical(90), screenWidth - kWvertical(20), 1)];
    [self.contentView addSubview:line];
    
}

#pragma mark - InitData
-(void)configModel:(ActivityMyApplyViewModel *)model{
    //活动照片    
    NSURL *imageUrl = [Helper setImageIconUrl:@"activity" andTeamKey:model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES];
    NSLog(@"%@",imageUrl);
    [_headerImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    //状态
    NSString *statu = model.stateShowString;
    [_statuView setTitle:statu forState:UIControlStateNormal];
    _statuView.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    if (statu.length==4) {
        _statuView.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    }
    NSString *buttonStr = model.stateButtonString;
    NSString *imageName = @"red_bg_activity";
    if ([buttonStr isEqualToString:@"报名中"]||[buttonStr isEqualToString:@"已拒绝"]) {
        imageName = @"red_bg_activity";
    }else if ([buttonStr isEqualToString:@"已通过"]){
        imageName = @"green_bg_activity";
    }else if ([buttonStr isEqualToString:@"已取消"]||[buttonStr isEqualToString:@"已结束"]){
        imageName = @"gray_bg_activity";
    }
    
    [_statuView setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //活动名
    NSString *name = model.name;
    _nameLabel.text = name;
    //活动时间
    NSString *begainTime = [Helper stringFromDateString:model.beginDate withFormater:@"yyyy.MM.dd"];
    _timeLabel.text = begainTime;
    //球场
    NSString *parkName = model.ballName;
    _parkLabel.text = parkName;
    //已报名人数
    NSString *apply = [NSString stringWithFormat:@"%ld",(long)model.sumCount];
    NSString *totalStr = [NSString stringWithFormat:@"%ld",(long)model.maxCount];
    NSString *applyStr = [NSString stringWithFormat:@"已报名%@（人）",apply];
    if (model.maxCount>0) {
        applyStr = [NSString stringWithFormat:@"已报名%@/%@（人）",apply,totalStr];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:applyStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB(248, 134, 0) range:NSMakeRange(3, apply.length)];
    _applyLabel.attributedText = attributedStr;
    [_applyLabel sizeToFitSelf];
    _applyLabel.x = screenWidth - _applyLabel.width;
}


//裁剪
-(CAShapeLayer *)bezierCorners:(CGRect )frame{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:frame.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
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
