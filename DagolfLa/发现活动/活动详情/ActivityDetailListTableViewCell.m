//
//  ActivityDetailListTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/18.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityDetailListTableViewCell.h"

@implementation ActivityDetailListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //头像
    _headImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(5), kHvertical(40), kHvertical(40)) Image:[UIImage imageNamed:DefaultHeaderImage]];
    CAShapeLayer *maskLayer = [self bezierCorners:_headImageView.bounds];
    _headImageView.layer.mask = maskLayer;
    [self.contentView addSubview:_headImageView];
    //昵称
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(_headImageView.x_width + kWvertical(15), kHvertical(10), kWvertical(120), kHvertical(14)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [self.contentView addSubview:_nameLabel];
    //性别
    _sexImageView = [Factory createImageViewWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y_height + kHvertical(2), kWvertical(12), kHvertical(14)) Image:nil];
    [self.contentView addSubview:_sexImageView];
    //差点
    _almostLabel = [Factory createLabelWithFrame:CGRectMake(_headImageView.x_width + kWvertical(35),_nameLabel.y_height + kHvertical(3), kWvertical(100), kHvertical(12)) textColor:RGB(49,49,49) fontSize:kHorizontal(12) Title:nil];
    [self.contentView addSubview:_almostLabel];
    //球员类型
    _playerType = [Factory createLabelWithFrame:CGRectMake(_almostLabel.x_width, 0, screenWidth - _almostLabel.x_width - kWvertical(19), kHvertical(50)) textColor:RGB(243,152,0) fontSize:kHorizontal(14) Title:nil];
    [_playerType setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_playerType];
    //球员手机号
    _phoneLabel = [Factory createLabelWithFrame:CGRectMake(_headImageView.x_width + kWvertical(93), 0, kWvertical(98), kHvertical(50)) textColor:RGB(160,160,160) fontSize:kHorizontal(14) Title:nil];
    [_phoneLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_phoneLabel];
    _phoneLabel.hidden = true;
    
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(245,245,245) frame:CGRectMake(0, kHorizontal(50)-1, screenWidth, 1)];
    [self.contentView addSubview:line];
    
}
#pragma mark - InitData
//发现活动&&队员
-(void)configModel:(ActivityDetailModel *)model{
    //头像
    if (model.signupUserKey) {
        NSURL *imageUrl = [Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue]andIsSetWidth:YES andIsBackGround:NO];
        [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    }else{
        _headImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    }
    //昵称
    NSString *name = model.name;
    _nameLabel.text = name;
    //性别
    if (model.sex == 0) {
        _sexImageView.image = [UIImage imageNamed:@"xb_n"];
    }else{
        _sexImageView.image = [UIImage imageNamed:@"xb_nn"];
    }
    //差点
    NSString *almostStr = [NSString stringWithFormat:@"%ld",(long)model.almost];
    if (model.almost) {
        if ([almostStr integerValue] == -10000) {
            _almostLabel.text = @"差点  --";
        }else{
            _almostLabel.text = [NSString stringWithFormat:@"差点  %@", almostStr];
        }
    }else{
        _almostLabel.text = @"差点  --";
    }
    //手机号
    _phoneLabel.text = model.mobile;
    //类型
    NSString *playerType = model.showName;
    _playerType.textColor = RGB(243,152,0);
    if (model.userType==1) {
        _phoneLabel.hidden = true;
        if ([model.userKey isEqualToString:[model.signupUserKey stringValue]]) {
            playerType = @"嘉宾";
        }
//        _playerType.textColor = RGB(235,97,0);
    }
    _playerType.text = playerType;
    
    if (model.mobile.length>0) {
        
        [_playerType sizeToFitSelf];
        [_phoneLabel sizeToFit];
        [_nameLabel sizeToFitSelf];
        _playerType.height = kHvertical(50);
        _phoneLabel.height = kHvertical(50);
        CGFloat nameLabelWidth = _nameLabel.width;
        CGFloat phoneLabelWidth = _phoneLabel.width;
        CGFloat playerTypeWidth = _playerType.width;
        CGFloat totalWidth = nameLabelWidth + phoneLabelWidth + playerTypeWidth;
        if (totalWidth > screenWidth - kWvertical(95)) {
            _nameLabel.width = kWvertical(80);
            _phoneLabel.width = screenWidth - kWvertical(95) - kWvertical(80) - playerTypeWidth;
        }else{
            _phoneLabel.x = screenWidth - phoneLabelWidth - playerTypeWidth - kWvertical(40);
        }
        _playerType.x = _phoneLabel.x_width + kWvertical(11);
    }
    
}
//球队管理
-(void)playerManagerConfigModel:(ActivityDetailModel *)model{
    _phoneLabel.hidden = false;
    _phoneLabel.text = model.mobile;
    [self configModel:model];

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
