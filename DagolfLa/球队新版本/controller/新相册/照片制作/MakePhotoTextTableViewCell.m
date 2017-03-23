//
//  MakePhotoTextTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextTableViewCell.h"

@implementation MakePhotoTextTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - CreateView
-(void)createUI{
    self.backgroundColor = ClearColor;
    self.contentView.backgroundColor = ClearColor;
    //带边框view
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(10), kHvertical(10), screenWidth - kWvertical(20), kHvertical(104))];
    [self.contentView addSubview:backView];
    //删除符号
    _deleateBtn = [Factory createButtonWithFrame:CGRectMake(backView.width - kWvertical(27), 0, kWvertical(27), kWvertical(27)) NormalImage:@"photoTextDeleate" SelectedImage:nil target:nil selector:nil];
    
    //文字
    _textViewLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(14), kHvertical(25), backView.width - kWvertical(42), backView.height - kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    _textViewLabel.numberOfLines = 3;
    [backView addSubview:_textViewLabel];
    
    //图片&描述文字
    _iconImageView = [Factory createImageViewWithFrame:CGRectMake(kHorizontal(13), kHorizontal(13), kHvertical(78), kHvertical(78)) Image:nil];
    _iconImageView.backgroundColor = RandomColor;
    [backView addSubview:_iconImageView];
    
    _descLabel = [Factory createLabelWithFrame:CGRectMake(_iconImageView.x_width , kHvertical(46), backView.width - _iconImageView.x_width, kHvertical(14)) textColor:RGB(160,160,160) fontSize:kHorizontal(14) Title:@"长按拖动，调整图片顺序"];
    [_descLabel setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:_descLabel];
    
    
    [backView addSubview:_deleateBtn];
    

}

//配置数据
-(void)configModel:(MakePhotoTextViewModel *)model{
    _iconImageView.hidden = true;
    _descLabel.hidden = true;
    _textViewLabel.hidden = true;
    NSURL *iconUrl = [Helper setImageIconUrl:@"album/media" andTeamKey:[model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO];
    NSString *textStr = model.textStr;
    
    if (textStr.length>0) {
        _textViewLabel.hidden = false;
        _textViewLabel.text = textStr;
    }else{
        _descLabel.hidden = false;
        _iconImageView.hidden = false;

        [_iconImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"teamPhotoGroupDefault"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;

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
