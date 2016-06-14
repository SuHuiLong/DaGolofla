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
    //清楚缓存
//    [[SDImageCache sharedImageCache] clearDisk];
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    
    if (!iPhone6) {
        [self.lable1 removeConstraints:self.constraints];
        self.lable1.frame = CGRectMake(self.sction1.frame.origin.x, self.sction1.frame.origin.y + self.sction1.frame.size.height/7*4, self.sction1.frame.size.width, self.sction1.frame.size.height/7*2);
        [self.sction1 addSubview:self.lable1];
    }
    
    //姓名
    self.lable1 = [[UILabel alloc]init];
    self.lable1.frame = CGRectMake(0, _sction1.frame.size.height*3/5, _sction1.frame.size.width, _sction1.frame.size.height*1/4);
    self.lable1.font = [UIFont systemFontOfSize:11];
    self.lable1.backgroundColor = [UIColor whiteColor];
    self.lable1.alpha = 0.4;
    self.lable1.textAlignment = NSTextAlignmentCenter;
    [self.sction1 addSubview:self.lable1];
    
    self.lable2 = [[UILabel alloc]init];
    self.lable2.frame = CGRectMake(0, _sction2.frame.size.height*3/5, _sction2.frame.size.width, _sction2.frame.size.height*1/4);
    self.lable2.font = [UIFont systemFontOfSize:11];
    self.lable2.backgroundColor = [UIColor whiteColor];
    self.lable2.alpha = 0.4;
    self.lable2.textAlignment = NSTextAlignmentCenter;
    [self.sction2 addSubview:self.lable2];
    
    self.lable3 = [[UILabel alloc]init];
    self.lable3.frame = CGRectMake(0, _section3.frame.size.height*3/5, _section3.frame.size.width, _section3.frame.size.height*1/4);
    self.lable3.font = [UIFont systemFontOfSize:11];
    self.lable3.backgroundColor = [UIColor whiteColor];
    self.lable3.alpha = 0.4;
    self.lable3.textAlignment = NSTextAlignmentCenter;
    [self.section3 addSubview:self.lable3];
    
    self.lable4 = [[UILabel alloc]init];
    self.lable4.frame = CGRectMake(0, _section4.frame.size.height*3/5, _section4.frame.size.width, _section4.frame.size.height*1/4);
    self.lable4.font = [UIFont systemFontOfSize:11];
    self.lable4.backgroundColor = [UIColor whiteColor];
    self.lable4.alpha = 0.4;
    self.lable4.textAlignment = NSTextAlignmentCenter;
    [self.section4 addSubview:self.lable4];
    
    //付款图标
    self.money1 = [[UIImageView alloc]initWithFrame:CGRectMake(_sction1.frame.size.width - 12, _sction1.frame.size.height/2-6, 12, 12)];
    [_sction1 addSubview:_money1];
    
    self.money2 = [[UIImageView alloc]initWithFrame:CGRectMake(_sction2.frame.size.width - 12, _sction2.frame.size.height/2-6, 12, 12)];
    [_sction2 addSubview:_money2];
    
    self.money3 = [[UIImageView alloc]initWithFrame:CGRectMake(_section3.frame.size.width - 12, _section3.frame.size.height/2-6, 12, 12)];
    [_section3 addSubview:_money3];
    
    self.money4 = [[UIImageView alloc]initWithFrame:CGRectMake(_section4.frame.size.width - 12, _section4.frame.size.height/2-6, 12, 12)];
    [_section4 addSubview:_money4];
    
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

- (void)configGroupName:(NSString *)groupname{
    NSLog(@"tag == %ld", (long)self.tag);
    self.groupName.text = [NSString stringWithFormat:@"第%ld组", (long)self.tag + 1];
}

- (void)configCellWithModelArray:(NSMutableArray *)modelArray{
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
    
    //清空背景图
    [self.sction1 setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    [self.sction2 setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    [self.section3 setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    [self.section4 setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    //清空钱币图标
    [self.money1 setImage:nil];
    [self.money2 setImage:nil];
    [self.money3 setImage:nil];
    [self.money4 setImage:nil];
    
    for (JGHPlayersModel *model in modelArray) {
        if (model.groupIndex == self.tag) {
            
            if (model.sortIndex == -1) {
                [self.section4 setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
            }else{
                if (model.sortIndex == 0) {
                    [self.sction1 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                    self.sction1.layer.masksToBounds = YES;
                    self.sction1.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable1.text = model.name;
                    //金钱按钮
                    if (model.payMoney != 0) {
                        [self.money1 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                }
                
                if (model.sortIndex == 1){
                    
                    [self.sction2 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                    self.sction2.layer.masksToBounds = YES;
                    self.sction2.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable2.text = model.name;
                    
                    //金钱按钮
                    if (model.payMoney != 0) {
                        [self.money2 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                }
                
                if (model.sortIndex == 2){
                    
                    [self.section3 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                    self.section3.layer.masksToBounds = YES;
                    self.section3.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable3.text = model.name;
                    
                    //金钱按钮
                    if (model.payMoney != 0) {
                        [self.money3 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                }
                
                if (model.sortIndex == 3){
                    
                    [self.section4 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addGroup"]];
                    self.section4.layer.masksToBounds = YES;
                    self.section4.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable4.text = model.name;
                    
                    //金钱按钮
                    if (model.payMoney != 0) {
                        [self.money4 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                }
            }
        }
    }
    
}

@end
