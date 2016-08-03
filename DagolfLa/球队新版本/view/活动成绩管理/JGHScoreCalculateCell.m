//
//  JGHScoreCalculateCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoreCalculateCell.h"
#import "JGHOperationScoreCell.h"

static NSString *const JGHOperationScoreCellIdentifier = @"JGHOperationScoreCell";

@interface JGHScoreCalculateCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *scoreCalculateTable;

@end

@implementation JGHScoreCalculateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self createScoreCalculateTable];
}

- (void)createScoreCalculateTable{
    self.scoreCalculateTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    
    UINib *operationScoreCellNib = [UINib nibWithNibName:@"JGHOperationScoreCell" bundle: [NSBundle mainBundle]];
    [self.scoreCalculateTable registerNib:operationScoreCellNib forCellReuseIdentifier:JGHOperationScoreCellIdentifier];
//
//    UINib *playersScoreNib = [UINib nibWithNibName:@"JGHPlayersScoreTableViewCell" bundle: [NSBundle mainBundle]];
//    [self.scoreCalculateTable registerNib:playersScoreNib forCellReuseIdentifier:JGHPlayersScoreTableViewCellIdentifier];
//    
//    UINib *centerBtnNib = [UINib nibWithNibName:@"JGHCenterBtnTableViewCell" bundle: [NSBundle mainBundle]];
//    [self.scoreCalculateTable registerNib:centerBtnNib forCellReuseIdentifier:JGHCenterBtnTableViewCellIdentifier];
    
    self.scoreCalculateTable.delegate = self;
    self.scoreCalculateTable.dataSource = self;
    
    self.scoreCalculateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreCalculateTable.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self addSubview:self.scoreCalculateTable];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHOperationScoreCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperationScoreCellIdentifier];
    return tranCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
