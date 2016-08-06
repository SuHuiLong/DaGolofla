//
//  JGHOperationScoreListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperationScoreListCell.h"
#import "JGHOperScoreBtnListCell.h"

static NSString *const JGHOperScoreBtnListCellIdentifier = @"JGHOperScoreBtnListCell";

@interface JGHOperationScoreListCell ()<JGHOperScoreBtnListCellDelegate>

@end

@implementation JGHOperationScoreListCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.poleArray = [NSMutableArray array];
        self.operationScoreListTable.scrollEnabled = NO;
        self.operationScoreListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (screenWidth-25*ProportionAdapter)/10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    JGHOperScoreBtnListCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperScoreBtnListCellIdentifier];
    
    JGHOperScoreBtnListCell * tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperScoreBtnListCellIdentifier];
    if (!tranCell) {
        tranCell = [[[NSBundle mainBundle]loadNibNamed:@"JGHOperScoreBtnListCell" owner:self options:nil]lastObject];
    }
    
    tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tranCell.delegate = self;
    
    tranCell.oneBtn.tag = 100 +indexPath.section;
    tranCell.twoBtn.tag = 200 +indexPath.section;
    tranCell.threeBtn.tag = 300 +indexPath.section;
    tranCell.fourBtn.tag = 400 +indexPath.section;
    NSLog(@"section == %td", indexPath.section);
    NSLog(@"row == %td", indexPath.row);
    if (indexPath.section == 0) {
        [tranCell confgiTitleString];
    }else{
        [tranCell configIndex:indexPath.section andOneHoel:[_poleArray[indexPath.section -1] integerValue] andTwoHole:[_poleArray[indexPath.section +8] integerValue]];
    }
    
    tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tranCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark -- 选择球洞的代理
- (void)didSelectOneHole:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    NSInteger index = btn.tag % 100;
    self.returnHoleId(index);
}

- (void)didSelectThreeHole:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    NSInteger index = (btn.tag % 100) +9;
    self.returnHoleId(index);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadOperScoreBtnListCellData{
    [self.operationScoreListTable reloadData];
}

@end
