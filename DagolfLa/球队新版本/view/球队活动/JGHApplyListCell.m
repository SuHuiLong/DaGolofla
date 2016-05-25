//
//  JGHApplyListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyListCell.h"

@implementation JGHApplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 勾选按钮事件
- (IBAction)chooseBtn:(UIButton *)sender {
    [self.chooseBtn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate didChooseBtn:sender];
    }
}
#pragma mark -- 删除按钮事件
- (IBAction)deleteBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectDeleteBtn:sender];
    }
}

- (void)configDict:(NSDictionary *)dict{
    //名字
    self.name.text = [dict objectForKey:@"name"];
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    //价格
    self.price.text = [dict objectForKey:@"money"];
//    @property (weak, nonatomic) IBOutlet UILabel *price;
    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }
}

@end
