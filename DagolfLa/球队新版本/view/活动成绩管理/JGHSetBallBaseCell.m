//
//  JGHSetBallBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSetBallBaseCell.h"
#import "JGHLableAndGouCell.h"
#import "JGHBallAreaModel.h"

static NSString *const JGHLableAndGouCellIdentifier = @"JGHLableAndGouCell";

@interface JGHSetBallBaseCell ()

//{
//    NSInteger _regist1;
//    NSInteger _regist2;
//}


@end

@implementation JGHSetBallBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.areaArray = [NSArray array];
    
    self.bgTop.constant = 5 *ProportionAdapter;
    self.bgLeft.constant = 20 *ProportionAdapter;
    self.bgRight.constant = 20 *ProportionAdapter;
    
    self.headerImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.headerImageViewTop.constant = 30 *ProportionAdapter;
    self.headerImageViewLeft.constant = 35 *ProportionAdapter;
    self.headerImageViewWith.constant = 40 *ProportionAdapter;
    
    self.ballName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.ballNameLeft.constant = 10 *ProportionAdapter;

    self.twolineLeft.constant = 20 *ProportionAdapter;
    self.twolineRight.constant = 20 *ProportionAdapter;
    self.twolineDown.constant = 15 *ProportionAdapter;
    
    self.oneLineLeft.constant = 20 *ProportionAdapter;
    self.oneLineRigh.constant = 20 *ProportionAdapter;
    
    self.setBallAreaTableViewTop.constant = 16 *ProportionAdapter;
    self.setBallAreaTableViewLeft.constant = 20 *ProportionAdapter;
    self.setBallAreaTableViewDown.constant = 30 *ProportionAdapter;
    self.setBallAreaTableViewRight.constant = 20 *ProportionAdapter;
 
    self.startBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.startBtnDown.constant = 15 *ProportionAdapter;
    
    self.bgImage.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    UINib *lableAndGouCellNib = [UINib nibWithNibName:@"JGHLableAndGouCell" bundle: [NSBundle mainBundle]];
    [self.setBallAreaTableView registerNib:lableAndGouCellNib forCellReuseIdentifier:JGHLableAndGouCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)startBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate startScoreBtn];
    }
}

- (void)configViewBallName:(NSString *)ballName andLoginpic:(NSString *)loginpic{
    [self.headerImageView sd_setImageWithURL:[Helper imageIconUrl:loginpic] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    self.ballName.text = ballName;
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.areaArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGHLableAndGouCell *lableAndGouCell = [tableView dequeueReusableCellWithIdentifier:JGHLableAndGouCellIdentifier];
    lableAndGouCell.name.tag = indexPath.section + 10;
    [lableAndGouCell configJGHBallAreaModel:_areaArray[indexPath.section]];
    lableAndGouCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return lableAndGouCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        [self.delegate returnAreaArray:_areaArray andAreaId:indexPath.section];
    }
}

- (void)configJGHSetBallBaseCellArea:(NSArray *)areaArray{
    self.areaArray = areaArray;
    
    [self.setBallAreaTableView reloadData];
}




@end
