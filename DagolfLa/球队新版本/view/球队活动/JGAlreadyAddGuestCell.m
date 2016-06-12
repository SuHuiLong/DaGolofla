//
//  JGAlreadyAddGuestCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGAlreadyAddGuestCell.h"

@implementation JGAlreadyAddGuestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 删除事件
- (IBAction)deleteGuestBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelecctDeleteGuestId:sender.tag - 100];
    }
}

- (void)configDict:(NSMutableDictionary *)dict{
    //姓名
//    @property (weak, nonatomic) IBOutlet UILabel *name;
    self.name.text = [dict objectForKey:@"name"];
    //性别
//    @property (weak, nonatomic) IBOutlet UILabel *sex;
    if ([dict objectForKey:@"sex"]) {
        if ([[dict objectForKey:@"sex"] integerValue] == 0) {
            self.sex.text = @"女";
        }else{
            self.sex.text = @"男";
        }
        
    }
    //电话
//    @property (weak, nonatomic) IBOutlet UILabel *number;
    self.number.text = [dict objectForKey:@"mobile"];
}

@end
