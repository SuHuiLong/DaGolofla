//
//  JGHApplyCatoryPriceView.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyCatoryPriceView.h"
#import "JGHApplyCatoryPriceViewCell.h"
#import "JGHApplyCatoryPromCell.h"

static NSString *const JGHApplyCatoryPriceViewCellIdentifier = @"JGHApplyCatoryPriceViewCell";
static NSString *const JGHApplyCatoryPromCellIdentifier = @"JGHApplyCatoryPromCell";

@interface JGHApplyCatoryPriceView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *justApplistTableView;

@property (nonatomic, strong)NSMutableArray *applyCatoryArray;

@end

@implementation JGHApplyCatoryPriceView


- (instancetype)init{
    if (self == [super init]) {
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.applyCatoryArray = [NSMutableArray array];
        [self createTeamActivityTabelView];//tableView
    }
    return self;
}
#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.justApplistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 196) style:UITableViewStyleGrouped];
    self.justApplistTableView.delegate = self;
    self.justApplistTableView.dataSource = self;
    self.justApplistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGHApplyCatoryPriceViewCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGHApplyCatoryPriceViewCellIdentifier];

    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHApplyCatoryPromCell" bundle: [NSBundle mainBundle]];
    [self.justApplistTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHApplyCatoryPromCellIdentifier];
    //    self.applistTableView.bounces = NO;
    [self addSubview:self.justApplistTableView];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        //人员个数
//    if (self.applyCatoryArray.count > 0) {
//        return self.applyCatoryArray.count + 1;
//    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHApplyCatoryPromCell *applyProCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyCatoryPromCellIdentifier forIndexPath:indexPath];
        applyProCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyProCell;
    }else{
        JGHApplyCatoryPriceViewCell *applyCatoryCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyCatoryPriceViewCellIdentifier forIndexPath:indexPath];
        applyCatoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyCatoryCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *bgLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
    bgLable.backgroundColor = [UIColor colorWithHexString:BG_color];
    [footView addSubview:bgLable];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index.section == %td", indexPath.section);
    if (indexPath.section > 0) {
        if (self.delegate) {
            [self.delegate selectApplyCatory];
        }
    }
}

- (void)configViewData:(NSMutableArray *)dataArray{
    self.applyCatoryArray = dataArray;
    [self.justApplistTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
