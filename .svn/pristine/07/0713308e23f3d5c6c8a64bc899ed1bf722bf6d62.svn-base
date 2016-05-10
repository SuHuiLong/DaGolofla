//
//  ManageMessageViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/12.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ManageMessageViewCell.h"
#import "TeamMessageController.h"
@implementation ManageMessageViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 12*ScreenWidth/375, 150*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        

        _btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMessage.frame = CGRectMake(ScreenWidth-77*ScreenWidth/375, 0, 44*ScreenWidth/375, 44*ScreenWidth/375);
        [self.contentView addSubview:_btnMessage];
        [_btnMessage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        [_btnMessage addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 14*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 44*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
        [self.contentView addSubview:_view];
        _view.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

-(void)chooseClick
{
    if (_choose == NO) {
        _choose = YES;
        
        if (_strlegth <= 0) {
            _choose = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选择通讯录好友" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
                [_btnMessage setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
                TeamMessageController* team = [[TeamMessageController alloc]init];

                team.dataArray = _dataArray;
                team.telArray = _telArray;
                _block(team);

        }
        
        
    }
    else
    {
        _choose = NO;
        [_btnMessage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
