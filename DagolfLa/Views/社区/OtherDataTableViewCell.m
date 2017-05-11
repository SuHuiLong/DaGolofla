//
//  OtherDataTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/10/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "OtherDataTableViewCell.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width



@implementation OtherDataTableViewCell
{
//    NSString * _pdStr;
    
}


- (void)awakeFromNib {
    _picViewWidth.constant = 119*ScreenWidth/375;
    _contentLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setDeatilModel:(DeatilModel *)deatilModel {

    _contentLabel.text = deatilModel.moodContent;
    _contentLabel.numberOfLines = 0;
    
    
    
    _zanLabel.text = [NSString stringWithFormat:@"%@",deatilModel.assistCount];
    _pingLabel.text = [NSString stringWithFormat:@"%@",deatilModel.commentCount];
    _fenLabel.text = [NSString stringWithFormat:@"%@",deatilModel.forwardNum];
    
    //无图片 自适应高度
    if (deatilModel.picUrl) {
        //NSLog(@"%@",_deatilModel.moodContent);
        _picView.hidden = NO;
        [_picView sd_setImageWithURL:[Helper imageIconUrl:deatilModel.picUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    }else{
        _picView.hidden = YES;
        _picViewWidth.constant = 0;
    }
    
    //日期对比
    NSUserDefaults *uesde = [NSUserDefaults standardUserDefaults];
    if ([[uesde objectForKey:@"data"] isEqualToString:[deatilModel.createTime substringWithRange:NSMakeRange(5, 5)]]) {
        _dateLabel.hidden = YES;
        _tuoYuan.hidden = YES;
        self.lineTop.constant = -25*ScreenWidth/375;
    }else{
        _dateLabel.hidden = NO;
        _tuoYuan.hidden = NO;
        _dateLabel.text = [deatilModel.createTime substringWithRange:NSMakeRange(5, 5)];
    }
    _pdStr = _dateLabel.text;
    [uesde setValue:_pdStr forKey:@"data"];
  
}

@end
