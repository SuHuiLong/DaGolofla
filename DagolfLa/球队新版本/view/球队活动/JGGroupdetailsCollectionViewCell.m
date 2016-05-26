//
//  JGGroupdetailsCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGGroupdetailsCollectionViewCell.h"

@implementation JGGroupdetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    
    if (!iPhone6) {
        [self.lable1 removeConstraints:self.constraints];
        self.lable1.frame = CGRectMake(self.sction1.frame.origin.x, self.sction1.frame.origin.y + self.sction1.frame.size.height/7*4, self.sction1.frame.size.width, self.sction1.frame.size.height/7*2);
        [self.sction1 addSubview:self.lable1];
    }
    
//    self.lable1.frame = CGRectMake(self.sction1.frame.origin.x, self.sction1.frame.origin.y + self.sction1.frame.size.height/7*4, self.sction1.frame.size.width, self.sction1.frame.size.height/7*2);
    
}

//第一个
- (IBAction)sction1:(UIButton *)sender {
    [self selectImage:sender];
}
//第二个
- (IBAction)sction2:(UIButton *)sender {
    [self selectImage:sender];
}
//第三个
- (IBAction)section3:(UIButton *)sender {
    [self selectImage:sender];
}
//第四个
- (IBAction)section4:(UIButton *)sender {
    [self selectImage:sender];
}

- (void)selectImage:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didSelectHeaderImage:btn];
    }
}

@end
