//
//  MyNewsBoxTableCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyNewsBoxTableCell.h"
#import "UIView+ChangeFrame.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation MyNewsBoxTableCell

- (void)awakeFromNib {
    // Initialization code
//    _titleLabel.backgroundColor = [UIColor redColor];
//    _timeLabel.backgroundColor = [UIColor blackColor];
    
    _messageLable = [[UILabel alloc] init];
    _messageLable.textColor = [UIColor whiteColor];
    
    [self addSubview:_messageLable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//-(void)showData:(NewsModel *)model{
//    if (model != nil) {
//        if ([model.seeCount integerValue] != 0) {
//            _messageLable.hidden = NO;
//            ////NSLog(@"%@",model.seeCount);
//            _messageLable.font = [UIFont systemFontOfSize:8*ScreenWidth/375];
//            if (ScreenWidth > 320) {
//                if ([model.seeCount integerValue] > 99) {
//                    _messageLable.frame = CGRectMake(_iconImage.width + _iconImage.frameX - 15 * ScreenWidth / 375, _iconImage.frameY + 0 * ScreenWidth / 375, 40 * ScreenWidth / 375, 20 * ScreenWidth / 375);
//                    
//                    _messageLable.text =  [NSString stringWithFormat:@"99+"];
//                }else {
//                    
//                    _messageLable.frame = CGRectMake(_iconImage.width + _iconImage.frameX - 15 * ScreenWidth / 375, _iconImage.frameY + 0 * ScreenWidth / 375, 20 * ScreenWidth / 375, 20 * ScreenWidth / 375);
//                    _messageLable.text =  [NSString stringWithFormat:@"%@", model.seeCount];
//                }
//            }
//            else{
//                if ([model.seeCount integerValue] > 99) {
//                    _messageLable.frame = CGRectMake(_iconImage.width + _iconImage.frameX - 25 * ScreenWidth / 375, _iconImage.frameY + 0 * ScreenWidth / 375, 40 * ScreenWidth / 375, 20 * ScreenWidth / 375);
//                    _messageLable.text =  [NSString stringWithFormat:@"99+"];
//                } else {
//                    
//                    _messageLable.frame = CGRectMake(_iconImage.width + _iconImage.frameX - 25 * ScreenWidth / 375, _iconImage.frameY + 0 * ScreenWidth / 375, 20 * ScreenWidth / 375, 20 * ScreenWidth / 375);
//                    _messageLable.text =  [NSString stringWithFormat:@"%@", model.seeCount];
//                }
//            }
//        }
//        else
//        {
//            _messageLable.hidden = YES;
//        }
//        
//        _messageLable.layer.cornerRadius = 10 * ScreenWidth / 375;
//        _messageLable.textAlignment = NSTextAlignmentCenter;
//        _messageLable.font = [UIFont systemFontOfSize:12 * ScreenWidth / 375];
//        _messageLable.layer.masksToBounds = YES;
//        
//        if (![Helper isBlankString:model.content]) {
//            _newsLabel.text = model.content;
//        }
//        else{
//            _newsLabel.text = @"暂无新消息";
//        }
//        
//        _timeLabel.text = model.createTime;
//    }
//    
//    
//}

@end
