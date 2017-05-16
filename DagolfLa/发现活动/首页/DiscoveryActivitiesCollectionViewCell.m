//
//  DiscoveryActivitiesCollectionViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "DiscoveryActivitiesCollectionViewCell.h"

@implementation DiscoveryActivitiesCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //带圆角的背景
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(15), kHvertical(10), screenWidth - kWvertical(30), kHvertical(251))];
    backView.layer.cornerRadius = kWvertical(8);
    [self.contentView addSubview:backView];
    //背景左上角的icon
    UIImageView *leftIcon = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(20), kWvertical(6), kHvertical(26)) Image:[UIImage imageNamed:@""]];
    [self.contentView addSubview:leftIcon];
    //背景图片
    _headerImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, backView.width, kHvertical(151)) Image:nil];
    [backView addSubview:_headerImageView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kWvertical(8),kWvertical(8))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = backView.bounds;
    maskLayer.path = maskPath.CGPath;
    _headerImageView.layer.mask = maskLayer;
    
    //已报名人数
    
    UIImageView *applyLabelBackView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(20), kWvertical(80), kHvertical(26)) Image:[UIImage imageNamed:@"teamActivityApplyIcon"]];
    [self.contentView addSubview:applyLabelBackView];
    
    _applyLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), kHvertical(20), 0, kHvertical(21)) textColor:WhiteColor fontSize:kHorizontal(14) Title:nil];

    [self.contentView addSubview:_applyLabel];
    //浅灰色背景
    UIView *grayBackView = [Factory createViewWithBackgroundColor:RGBA(0, 0, 0, 0.5) frame:CGRectMake(0, kHvertical(130), backView.width, kHvertical(21))];
    [backView addSubview:grayBackView];
    //球场定位icon
    UIImageView *locationIcon = [Factory createImageViewWithFrame:CGRectMake(kWvertical(6), kHvertical(134), kWvertical(9), kHvertical(13)) Image:[UIImage imageNamed:@"mapsearch_location"]];
    [backView addSubview:locationIcon];
    //球场名
    _parkLabel = [Factory createLabelWithFrame:CGRectMake(locationIcon.x_width+kWvertical(7), grayBackView.y, screenWidth-kWvertical(61), grayBackView.height) textColor:WhiteColor fontSize:kHorizontal(14) Title:nil];
    [backView addSubview:_parkLabel];
    //球队名
    _teamnameLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(6), _headerImageView.y_height + kHvertical(13), screenWidth - kWvertical(45), kHvertical(16)) textColor:RGB(98,98,98) fontSize:kHorizontal(17) Title:nil];
    [backView addSubview:_teamnameLabel];
    //活动名
    _activityNameLabel = [Factory createLabelWithFrame:CGRectMake(_teamnameLabel.x, _headerImageView.y_height + kHvertical(42), _teamnameLabel.width, kHvertical(17)) textColor:RGB(49,49,49) fontSize:kHorizontal(18) Title:nil];
    [backView addSubview:_activityNameLabel];
    //状态&时间
    _statuLabel = [Factory createLabelWithFrame:CGRectMake(_teamnameLabel.x, _headerImageView.y_height + kHvertical(69), _teamnameLabel.width/2, kHvertical(17)) textColor:RGB(252,90,1) fontSize:kHorizontal(15) Title:nil];
    [backView addSubview:_statuLabel];
    //资费
    _priceLabel = [Factory createLabelWithFrame:CGRectMake(_statuLabel.x_width, _statuLabel.y, _activityNameLabel.width-_statuLabel.width-kWvertical(12), _statuLabel.height) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_priceLabel];
    
    
    
}

-(void)configModel:(DisCoveryActivityModel *)model{
    //已报名人数
    NSString *applyNumStr = [NSString stringWithFormat:@"已报%ld人",model.activityCount];
    _applyLabel.text = applyNumStr;
    [_applyLabel sizeToFitSelf];

    //图片
    NSURL *imageUrl = [Helper setImageIconUrl:@"activity" andTeamKey:[model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES];

    [_headerImageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    _headerImageView.backgroundColor = RandomColor;
    //球场&距离
    NSString *distanceStr = [NSString stringWithFormat:@"%@", model.distance];
    NSString *parkAndDistance = [NSString stringWithFormat:@"%@  |  %@km",@"上海天马乡村俱乐部",distanceStr];
    _parkLabel.text = parkAndDistance;
    
    //球队名
    NSString *parkName = @"上海优高科高尔夫球队";
    _teamnameLabel.text = parkName;
    
    //活动名
    NSString *activityname = model.name;
    _activityNameLabel.text = activityname;
    
    //状态&时间
    NSString *begainTime = model.beginDate;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate* inputDate = [inputFormatter dateFromString:begainTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    begainTime = [dateFormatter stringFromDate:inputDate];
    NSString *statueAndTime = [NSString stringWithFormat:@"【%@】%@",@"进行中",begainTime];
    NSMutableAttributedString *statueAndTimeStr = [[NSMutableAttributedString alloc] initWithString:statueAndTime];
    [statueAndTimeStr addAttribute:NSForegroundColorAttributeName value:RGB(49,49,49) range:NSMakeRange(5, statueAndTime.length - 5)];
    _statuLabel.attributedText = statueAndTimeStr;
    //费用
    NSString *costRange = model.costRange;
    if (![costRange isEqualToString:@"无费用"]) {
        _priceLabel.hidden = false;
        NSString *price = [NSString stringWithFormat:@"资费 %@元 /人",costRange];
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:price];
        [priceStr addAttribute:NSForegroundColorAttributeName value:RGB(252,90,1) range:NSMakeRange(3, price.length - 5)];
        _priceLabel.attributedText = priceStr;
    }else{
        _priceLabel.hidden = true;
    }

}




@end












