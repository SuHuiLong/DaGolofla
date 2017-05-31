//
//  GuestRegistrationAuditTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "GuestRegistrationAuditTableViewCell.h"

@implementation GuestRegistrationAuditTableViewCell


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
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(_headImageView.x_width + kWvertical(15), kHvertical(5), kWvertical(120), kHvertical(24)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    [self.contentView addSubview:_nameLabel];
    //性别
    _sexImageView = [Factory createImageViewWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y_height + kHvertical(2), kWvertical(12), kHvertical(14)) Image:nil];
    [self.contentView addSubview:_sexImageView];
    //差点
    _almostLabel = [Factory createLabelWithFrame:CGRectMake(_headImageView.x_width + kWvertical(35),_nameLabel.y_height + kHvertical(3), kWvertical(100), kHvertical(12)) textColor:RGB(49,49,49) fontSize:kHorizontal(12) Title:nil];
    [self.contentView addSubview:_almostLabel];
    //球员手机号
    _phoneLabel = [Factory createLabelWithFrame:CGRectMake(_almostLabel.x_width + kWvertical(10), _almostLabel.y, kWvertical(100), _almostLabel.height) textColor:RGB(160,160,160) fontSize:kHorizontal(13) Title:nil];
    [self.contentView addSubview:_phoneLabel];
    _phoneLabel.hidden = true;
    
    //按钮
    NSArray *titleArray = @[@"同意",@"拒绝"];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(117) + kWvertical(59)*i, kHvertical(13), kWvertical(49), kHvertical(26)) titleFont:kHorizontal(11) textColor:RGB(243,152,0) backgroundColor:ClearColor  target:nil selector:nil Title:titleArray[i]];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGB(243,152,0).CGColor;
        btn.layer.cornerRadius = kWvertical(2);
        [self.contentView addSubview:btn];
        if (i==0) {
            _sureBtn = btn;
        }else{
            _reguestBtn = btn;
        }
        btn.hidden = true;
    }
    
    //时间
    _timeLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(10), screenWidth - kWvertical(10), kHvertical(17)) textColor:RGB(160,160,160) fontSize:kHorizontal(11) Title:@"2016.06.22 11:58"];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    //状态
    _styleLabel = [Factory createLabelWithFrame:CGRectMake(screenWidth - kWvertical(100), kHvertical(32), kWvertical(90), kHvertical(12)) textColor:RGB(0,134,73) fontSize:kHorizontal(12) Title:@"已通过"];
    [_styleLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_styleLabel];
    
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(245,245,245) frame:CGRectMake(0, kHorizontal(50)-1, screenWidth, 1)];
    [self.contentView addSubview:line];
    
}
#pragma mark - InitData
//发现活动&&队员
-(void)configModel:(GuestRegistrationAuditModel *)model{
    //头像
    NSURL *imageUrl = [Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue]andIsSetWidth:YES andIsBackGround:NO];
    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    //昵称
    NSString *name = model.name;
    _nameLabel.text = name;
    //性别
    if (model.sex == 0) {
        _sexImageView.image = [UIImage imageNamed:@"xb_n"];
    }else{
        _sexImageView.image = [UIImage imageNamed:@"xb_nn"];
    }
    _phoneLabel.text = model.mobile;
    //差点
    NSString *almostStr = [NSString stringWithFormat:@"%ld",(long)model.almost];
    if (model.almost) {
        if ([almostStr floatValue] == -10000) {
            _almostLabel.text = @"差点  --";
        }else{
            _almostLabel.text = [NSString stringWithFormat:@"差点  %@", almostStr];
        }
    }else{
        _almostLabel.text = @"差点  --";
    }

    
    _sureBtn.hidden = true;
    _reguestBtn.hidden = true;
    _timeLabel.hidden = true;
    _styleLabel.hidden = true;
    
    NSString *buttonString = model.stateButtonString;
    if ([buttonString isEqualToString:@"报名中"]) {
        _sureBtn.hidden = false;
        _reguestBtn.hidden = false;
    }else{
        _timeLabel.hidden = false;
        _styleLabel.hidden = false;
        //时间
        NSString *createTime = [Helper stringFromDateString:model.createTime withFormater:@"yyyy.MM.dd HH:mm"];
        _timeLabel.text = createTime;
        //状态
        NSString *showStr = model.stateShowString;
        _styleLabel.text = showStr;
        if ([buttonString isEqualToString:@"已通过"]) {
            _styleLabel.text = @"已通过";
        }
        if ([buttonString isEqualToString:@"已拒绝"]) {
            _styleLabel.textColor = RGB(236,14,39);
        }else if ([buttonString isEqualToString:@"已通过"]){
            _styleLabel.textColor = RGB(0,134,73);
        }else if ([buttonString isEqualToString:@"已取消"]){
            _styleLabel.textColor = RGB(243,152,0);
        }
    
    }
    
    
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
