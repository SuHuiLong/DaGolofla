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

@implementation JGHOperationScoreListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UINib *operScoreBtnListCellNib = [UINib nibWithNibName:@"JGHOperScoreBtnListCell" bundle: [NSBundle mainBundle]];
//        [self.operationScoreListTable registerNib:operScoreBtnListCellNib forCellReuseIdentifier:JGHOperScoreBtnListCellIdentifier];
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
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (screenWidth-25*ProportionAdapter)/9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    JGHOperScoreBtnListCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperScoreBtnListCellIdentifier];
    
    JGHOperScoreBtnListCell * tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperScoreBtnListCellIdentifier];
    if (!tranCell) {
        tranCell = [[[NSBundle mainBundle]loadNibNamed:@"JGHOperScoreBtnListCell" owner:self options:nil]lastObject];
    }
    
    tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tranCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
