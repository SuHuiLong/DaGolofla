//
//  YueHallPeoTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/14.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "YueHallPeoTableViewCell.h"

@implementation YueHallPeoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    ////NSLog(@"1");
    
    _btnPeo1.layer.cornerRadius = _btnPeo1.frame.size.height/2;
    _btnPeo2.layer.masksToBounds = YES;
    _btnPeo2.layer.cornerRadius = _btnPeo2.frame.size.height/2;
    _btnPeo3.layer.masksToBounds = YES;
    _btnPeo3.layer.cornerRadius = _btnPeo3.frame.size.height/2;
    _btnPeo4.layer.masksToBounds = YES;
    _btnPeo4.layer.cornerRadius = _btnPeo4.frame.size.height/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
