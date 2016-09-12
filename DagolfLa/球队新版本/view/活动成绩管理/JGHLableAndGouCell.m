//
//  JGHLableAndGouCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLableAndGouCell.h"
#import "JGHBallAreaModel.h"

@implementation JGHLableAndGouCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameLeft.constant = 42 *ProportionAdapter;

    self.gouImageViewRight.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)configImageGouRegist1:(NSInteger)regist1 andRegist2:(NSInteger)regist2{
//    if ((self.name.tag - 10) == regist1 || (self.name.tag - 10) == regist2) {
//        self.gouImageView.image = [UIImage imageNamed:@"duihao"];
//    }else{
//        self.gouImageView.image = nil;
//    }
//}

- (void)configJGHBallAreaModel:(JGHBallAreaModel *)model{
    self.name.text = model.ballArea;
    
    if (model.select == 1) {
        self.gouImageView.image = [UIImage imageNamed:@"duihao"];
    }else{
        self.gouImageView.image = nil;
    }
}

@end
