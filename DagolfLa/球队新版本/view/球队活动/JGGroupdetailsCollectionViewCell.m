//
//  JGGroupdetailsCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGGroupdetailsCollectionViewCell.h"
#import "JGHPlayersModel.h"

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
        [self.delegate didSelectHeaderImage:btn JGGroupCell:self];
    }
}

- (void)configJGHPlayersModel:(JGHPlayersModel *)model andSortIndex:(NSInteger)sortIndex{
    self.lable1.text = model.name;
}

- (void)configCellWithModelArray:(NSMutableArray *)modelArray{
    NSLog(@"%ld", (long)self.tag);

//    if () {
//        <#statements#>
//    }
    
    self.groupName.text = [NSString stringWithFormat:@"第%ld组", (long)self.tag];
    //清空空间内容
    if (self.lable1.text.length != 0) {
        self.lable1.text = nil;
    }
    
    if (self.lable2.text.length != 0) {
        self.lable2.text = nil;
    }
    
    if (self.lable3.text.length != 0) {
        self.lable3.text = nil;
    }
    
    if (self.lable4.text.length != 0) {
        self.lable4.text = nil;
    }
    
    for (JGHPlayersModel *model in modelArray) {
        if (model.groupIndex == self.tag) {
            if (model.sortIndex == 0) {
                self.lable1.text = model.name;
                [self.sction1 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                self.sction1.layer.masksToBounds = YES;
                self.sction1.layer.cornerRadius = self.sction1.frame.size.width/2;
            }
            
            if (model.sortIndex == 1){
                self.lable2.text = model.name;
                [self.sction2 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                self.sction2.layer.masksToBounds = YES;
                self.sction2.layer.cornerRadius = self.sction1.frame.size.width/2;
            }
            
            if (model.sortIndex == 2){
                self.lable3.text = model.name;
                [self.section3 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                self.section3.layer.masksToBounds = YES;
                self.section3.layer.cornerRadius = self.sction1.frame.size.width/2;
            }
            
            if (model.sortIndex == 3){
                self.lable4.text = model.name;
                [self.section4 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                self.section4.layer.masksToBounds = YES;
                self.section4.layer.cornerRadius = self.sction1.frame.size.width/2;
            }
        }
    }
}

@end
