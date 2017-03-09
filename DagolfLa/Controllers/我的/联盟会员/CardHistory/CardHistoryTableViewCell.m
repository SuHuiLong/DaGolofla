//
//  CardHistoryTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "CardHistoryTableViewCell.h"

@interface CardHistoryTableViewCell()
{
    //时间
    UILabel *_timeLable;
    //竖线之间的圆点
    UIImageView *_circleImageView;
    //使用的会员卡类型图片
    UIImageView *_styleImageView;
    //球场背景图
    UIImageView *_parkImageView;
    //球场
    UILabel *_parkLabel;
}
@end

@implementation CardHistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - CreateView
-(void)createView{
    //自身的view
    UIView *contentView = self.contentView;
    contentView.backgroundColor = RGBA(238, 238, 238, 1);
    //时间
    _timeLable = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(5) ,kWvertical(70),kHvertical(60)) textColor:[UIColor colorWithHexString:@"#b8b8b8"] fontSize:kHorizontal(14) Title:nil];
    [contentView addSubview:_timeLable];
    
    //上下竖线和圆点//70
    _topLineImageView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#58a9be"] frame:CGRectMake(kWvertical(95), 0, kWvertical(2), kHvertical(27.5))];
    _circleImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(87), kHvertical(26), kWvertical(18), kWvertical(18)) Image:[UIImage imageNamed:@"dot"]];
    _bottomLineImageView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#58a9be"] frame:CGRectMake(kWvertical(95), kHvertical(42.5), kWvertical(2), kHvertical(27.5))];
    
    [contentView addSubview:_topLineImageView];
    [contentView addSubview:_circleImageView];
    [contentView addSubview:_bottomLineImageView];
    
    //卡片类型
    _styleImageView = [Factory createImageViewWithFrame:CGRectMake(_circleImageView.x_width + kWvertical(18), kHvertical(24), kWvertical(33), kHvertical(22)) Image:nil];
    [contentView addSubview:_styleImageView];
    
    //球场背景图片
    _parkImageView = [Factory createImageViewWithFrame:CGRectMake(_styleImageView.x_width + kWvertical(15), kHvertical(12.5), kWvertical(200), kHvertical(45)) Image:[UIImage imageNamed:@"icn_allianceParkBorder"]];
    [contentView addSubview:_parkImageView];
    
    //球场名
    _parkLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(15), 0, kWvertical(175), kHvertical(45)) textColor:[UIColor colorWithHexString:@"#666666"] fontSize:kHorizontal(14) Title:nil];
    _parkLabel.numberOfLines = 2;
    [_parkImageView addSubview:_parkLabel];
}


-(void)configModel:(CardHIstoryModel *)model{
    //时间
    NSString *time = model.timeStr;
    _timeLable.text = time;
    //卡片类型数据
    NSString *picUrl = model.picUrl;
    [_styleImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
    //球场名
    NSString *parkName = model.parkStr;
    _parkLabel.text = parkName;
    _parkLabel.numberOfLines = 2;
    
    [_parkLabel setTextAlignment:NSTextAlignmentJustified];
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
