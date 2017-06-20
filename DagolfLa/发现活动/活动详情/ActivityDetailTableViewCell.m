//
//  ActivityDetailTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/5/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityDetailTableViewCell.h"

@implementation ActivityDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - CreateView
-(void)createView{
    //icon
    _iconImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(11), kHvertical(22), kHvertical(22)) Image:nil];
    [self.contentView addSubview:_iconImageView];
    //描述
    _descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(40), 0, screenWidth-kWvertical(50), kHvertical(45)) textColor:RGB(0,0,0) fontSize:kHorizontal(15) Title:nil];
    [self.contentView addSubview:_descLabel];
    //查看分组
    _viewGroup = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(100), kHvertical(10), kWvertical(87), kHvertical(31)) titleFont:kHorizontal(13) textColor:BarRGB_Color backgroundColor:ClearColor target:self selector:nil Title:@"查看分组"];
    _viewGroup.layer.cornerRadius = kWvertical(5);
    _viewGroup.layer.borderWidth = 1;
    _viewGroup.layer.borderColor = BarRGB_Color.CGColor;
    [self.contentView addSubview:_viewGroup];
    //向右箭头
    _arrowImageView = [Factory createImageViewWithFrame:CGRectMake(screenWidth - kWvertical(24), kHvertical(16), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@"darkArrow"]];
    _arrowImageView.tintColor = RGB(160,160,160);

    [self.contentView addSubview:_arrowImageView];
    //分割线
    _line = [Factory createViewWithBackgroundColor:RGB(232, 232, 232) frame:CGRectMake(0, kHvertical(45)-1, screenWidth, 1)];
    _line.hidden = false;
    [self.contentView addSubview:_line];
}

#pragma mark - InitData
-(void)configModel:(ActivityDetailModel *)model{
    _iconImageView.y = kHvertical(11);
    _descLabel.height = kHvertical(45);
    _line.y = kHvertical(45)-1;
    _arrowImageView.hidden = true;
    _line.hidden = false;
    _viewGroup.hidden = true;
    //icon
    NSString *iconImage = model.iconStr;
    [_iconImageView setImage:[UIImage imageNamed:iconImage]];
    //描述
    NSString *desc = model.desc;
    _descLabel.text = desc;
    if (model.price) {
        _line.hidden = true;
        _descLabel.height = kHvertical(35);
    }
    //活动说明包含向右箭头
    if ([desc isEqualToString:@"活动说明"]) {
        _arrowImageView.hidden = false;
    }
    //价格
    if (model.price) {
        NSString *price = model.price;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:desc];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB(255,6,23) range:NSMakeRange(desc.length - price.length - 3, price.length)];
        _descLabel.attributedText = attributedStr;
    }
    //活动成员title
    if (model.activityPlayer) {
        _viewGroup.hidden = false;
        _iconImageView.y = kHvertical(14);
        _descLabel.height = kHvertical(51);
        _line.y = kHvertical(50)-1;
        NSString *listTitle = model.activityPlayer;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:desc];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGB(178,178,178) range:NSMakeRange(6, listTitle.length)];
        _descLabel.attributedText = attributedStr;
    }
    
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
