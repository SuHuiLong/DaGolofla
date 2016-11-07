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
    
    self.almostTop1.constant = 25 *ProportionAdapter;
    self.conViewTop1.constant = -25 *ProportionAdapter;
    self.conViewLeft1.constant = -25 *ProportionAdapter;
    self.conViewW1.constant = 55 *ProportionAdapter;
    
    self.almostTop2.constant = 25 *ProportionAdapter;
    self.conViewTop2.constant = -25 *ProportionAdapter;
    self.conViewLeft2.constant = -25 *ProportionAdapter;
    self.conViewW2.constant = 55 *ProportionAdapter;

    self.almostTop3.constant = 25 *ProportionAdapter;
    self.almostLeft3.constant = 25 *ProportionAdapter;
    self.almostRight3.constant = 5 *ProportionAdapter;
    self.conViewTop3.constant = -25 *ProportionAdapter;
    self.conViewLeft3.constant = -25 *ProportionAdapter;
    self.conViewW3.constant = 55 *ProportionAdapter;
    
    self.almostTop4.constant = 25 *ProportionAdapter;
    self.almostLeft4.constant = 25 *ProportionAdapter;
    self.almostRight4.constant = 5 *ProportionAdapter;
    self.conViewTop4.constant = -25 *ProportionAdapter;
    self.conViewLeft4.constant = -25 *ProportionAdapter;
    self.conViewW4.constant = 55 *ProportionAdapter;
    
//    [self insertSubview:self.leftTopView atIndex:0];
    self.leftTopView.layer.masksToBounds = YES;
    self.leftTopView.layer.cornerRadius = self.RightTopView.frame.size.width/2;
    self.leftTopView.backgroundColor = [UIColor colorWithHexString:@"#edfaf8"];
    
    self.leftTopValue.text = @" ";
    self.leftTopValue.tintColor = [UIColor colorWithHexString:@"#00d3bc"];
    self.leftTopAlmost.font = [UIFont systemFontOfSize:8*ProportionAdapter];
    self.leftTopAlmost.tintColor = [UIColor colorWithHexString:@"#a0a0a0"];
    
//    [self insertSubview:self.RightTopView atIndex:0];
    self.RightTopView.layer.masksToBounds = YES;
    self.RightTopView.layer.cornerRadius = self.RightTopView.frame.size.width/2;
    self.RightTopView.backgroundColor = [UIColor colorWithHexString:@"#edfaf8"];
    
    self.rightTopValue.text = @" ";
    self.rightTopValue.tintColor = [UIColor colorWithHexString:@"#00d3bc"];
    self.rightTopAlmost.font = [UIFont systemFontOfSize:8*ProportionAdapter];
    self.rightTopAlmost.tintColor = [UIColor colorWithHexString:@"#a0a0a0"];

//    [self insertSubview:self.leftDownView atIndex:0];
    self.leftDownView.layer.masksToBounds = YES;
    self.leftDownView.layer.cornerRadius = self.RightTopView.frame.size.width/2;
    self.leftDownView.backgroundColor = [UIColor colorWithHexString:@"#edfaf8"];
    
    self.leftDownValue.text = @" ";
    self.leftDownValue.tintColor = [UIColor colorWithHexString:@"#00d3bc"];
    self.leftDownAlmost.font = [UIFont systemFontOfSize:8*ProportionAdapter];
    self.leftDownAlmost.tintColor = [UIColor colorWithHexString:@"#a0a0a0"];

//    [self insertSubview:self.rightDownView atIndex:0];
    self.rightDownView.layer.masksToBounds = YES;
    self.rightDownView.layer.cornerRadius = self.RightTopView.frame.size.width/2;
    self.rightDownView.backgroundColor = [UIColor colorWithHexString:@"#edfaf8"];
    
    self.rightDownVlaue.text = @" ";
    self.rightDownVlaue.tintColor = [UIColor colorWithHexString:@"#00d3bc"];
    self.rightDownAlmost.font = [UIFont systemFontOfSize:8*ProportionAdapter];
    self.rightDownAlmost.tintColor = [UIColor colorWithHexString:@"#a0a0a0"];
    
    if (iPhone5) {
        self.leftTopValue.font = [UIFont systemFontOfSize:10*ProportionAdapter];
        self.rightTopValue.font = [UIFont systemFontOfSize:10*ProportionAdapter];
        self.leftDownValue.font = [UIFont systemFontOfSize:10*ProportionAdapter];
        self.rightDownVlaue.font = [UIFont systemFontOfSize:10*ProportionAdapter];
    }else{
        self.leftTopValue.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        self.rightTopValue.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        self.leftDownValue.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        self.rightDownVlaue.font = [UIFont systemFontOfSize:12*ProportionAdapter];
    }

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
    
//    UILongPressGestureRecognizer *recognizerone = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    recognizerone.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
//    UILongPressGestureRecognizer *recognizertwo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    recognizertwo.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
//    UILongPressGestureRecognizer *recognizerthree = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    recognizerthree.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
//    UILongPressGestureRecognizer *recognizerfour = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    recognizerfour.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
//    [_sction1 addGestureRecognizer:recognizerone];
//    [_sction2 addGestureRecognizer:recognizertwo];
//    [_section3 addGestureRecognizer:recognizerthree];
//    [_section4 addGestureRecognizer:recognizerfour];
}
#pragma mark -- 长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    NSLog(@"%td", recognizer.view.tag);
    if (self.delegate) {
        [self.delegate handleLongPressWithBtnTag:recognizer.view.tag JGGroupCell:self];
    }
}
//- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
//    NSLog(@"%td", recognizer.view.tag);
//    if (self.delegate) {
//        [self.delegate handleLongPressWithBtnTag:recognizer.view.tag];
//    }
//}
//- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
//    NSLog(@"%td", recognizer.view.tag);
//    if (self.delegate) {
//        [self.delegate handleLongPressWithBtnTag:recognizer.view.tag];
//    }
//}
//- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
//    NSLog(@"%td", recognizer.view.tag);
//    if (self.delegate) {
//        [self.delegate handleLongPressWithBtnTag:recognizer.view.tag];
//    }
//}
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
    self.leftTopValue.text = @"";
    self.rightTopValue.text = @"";
    self.leftDownValue.text = @"";
    self.rightDownVlaue.text = @"";
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
                    NSLog(@"%@", [Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO]);
                    [self.sction1 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    self.sction1.layer.masksToBounds = YES;
                    self.sction1.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable1.text = model.name;
                    //金钱按钮
                    if ([model.payMoney floatValue] != 0) {
                        [self.money1 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                    
                    if (model.almost) {
                        self.leftTopValue.text = [NSString stringWithFormat:@"%.1f", [model.almost floatValue]];
                    }
                }
                
                if (model.sortIndex == 1){
                    
                    [self.sction2 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    self.sction2.layer.masksToBounds = YES;
                    self.sction2.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable2.text = model.name;
                    
                    //金钱按钮
                    if ([model.payMoney floatValue] != 0) {
                        [self.money2 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                    
                    if (model.almost) {
                        self.rightTopValue.text = [NSString stringWithFormat:@"%.1f", [model.almost floatValue]];
                    }
                }
                
                if (model.sortIndex == 2){
                    
                    [self.section3 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    self.section3.layer.masksToBounds = YES;
                    self.section3.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable3.text = model.name;
                    
                    //金钱按钮
                    if ([model.payMoney floatValue] != 0) {
                        [self.money3 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                    
                    if (model.almost) {
                        self.leftDownValue.text = [NSString stringWithFormat:@"%.1f", [model.almost floatValue]];
                    }
                }
                
                if (model.sortIndex == 3){
                    
                    [self.section4 sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    self.section4.layer.masksToBounds = YES;
                    self.section4.layer.cornerRadius = self.sction1.frame.size.width/2;
                    
                    self.lable4.text = model.name;
                    
                    //金钱按钮
                    if ([model.payMoney floatValue] != 0) {
                        [self.money4 setImage:[UIImage imageNamed:@"payMoney"]];
                    }
                    
                    if (model.almost) {
                        self.rightDownVlaue.text = [NSString stringWithFormat:@"%.1f", [model.almost floatValue]];
                    }
                }
            }
        }
    }
    
}

@end
