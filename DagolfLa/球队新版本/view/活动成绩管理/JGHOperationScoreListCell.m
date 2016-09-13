//
//  JGHOperationScoreListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperationScoreListCell.h"
#import "JGHOperScoreBtnListCell.h"
#import "JGHOperScoreHeaderCell.h"
#import "JGHBallAreaModel.h"

static NSString *const JGHOperScoreBtnListCellIdentifier = @"JGHOperScoreBtnListCell";
static NSString *const JGHOperScoreHeaderCellIdentifier = @"JGHOperScoreHeaderCell";

@interface JGHOperationScoreListCell ()<JGHOperScoreBtnListCellDelegate>
{
    NSString *_region1;
    NSString *_region2;
}

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
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (screenWidth-25*ProportionAdapter)/11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHOperScoreHeaderCell * tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperScoreHeaderCellIdentifier];
        if (!tranCell) {
            tranCell = [[[NSBundle mainBundle]loadNibNamed:@"JGHOperScoreHeaderCell" owner:self options:nil]lastObject];
        }
        
        [tranCell configJGHOperScoreHeaderCell:_region1 andregion2:_region1];
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return tranCell;
    }else {
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
        
        if (indexPath.section == 1){
            [tranCell confgiTitleString];
        }else{
            [tranCell configIndex:indexPath.section -1 andOneHoel:[_poleArray[indexPath.section -2] integerValue] andTwoHole:[_poleArray[indexPath.section +7] integerValue]];
            [tranCell configViewBGColor:_selectId];
        }
        
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tranCell;
    }
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

- (void)reloadOperScoreBtnListCellData:(NSArray *)areaArray{
    for (int i=0; i<areaArray.count; i++) {
        JGHBallAreaModel *model = [[JGHBallAreaModel alloc]init];
        model = areaArray[i];
        if (model.select == 1) {
            if (_region1 == nil) {
                _region1 = model.ballArea;
            }else{
                _region2 = model.ballArea;
            }
        }
    }
    
    [self.operationScoreListTable reloadData];
}

@end
