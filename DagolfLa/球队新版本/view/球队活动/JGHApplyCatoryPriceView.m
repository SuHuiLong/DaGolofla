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

@interface JGHApplyCatoryPriceView ()<UITableViewDelegate, UITableViewDataSource, JGHApplyCatoryPriceViewCellDelegate ,JGHApplyCatoryPromCellDelegate>
{
    NSInteger _selectId;
}

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
    self.justApplistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 164) style:UITableViewStylePlain];
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
        return self.applyCatoryArray.count + 1;
//    }
//    return 1;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }
    return 30;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JGHApplyCatoryPromCell *applyProCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyCatoryPromCellIdentifier forIndexPath:indexPath];
        applyProCell.selectionStyle = UITableViewCellSelectionStyleNone;
        applyProCell.delegate = self;
        return applyProCell;
    }else{
        JGHApplyCatoryPriceViewCell *applyCatoryCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyCatoryPriceViewCellIdentifier forIndexPath:indexPath];
        applyCatoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [applyCatoryCell configJGHApplyCatoryPriceViewCell:_applyCatoryArray[indexPath.row -1]];
        applyCatoryCell.selectBtn.tag = indexPath.row -1 +100;
        applyCatoryCell.delegate = self;
        if (indexPath.row -1 == _selectId) {
            [applyCatoryCell.selectBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        }else{
            [applyCatoryCell.selectBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        }
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
    NSLog(@"index.row == %td", indexPath.row);
    if (indexPath.row > 0) {
        _selectId = indexPath.row -1;
        
        [self.justApplistTableView reloadData];
    }
}

#pragma mark -- 刷新页面数据
- (void)configViewData:(NSMutableArray *)dataArray{
    _selectId = 0;
    self.applyCatoryArray = dataArray;
    self.justApplistTableView.frame = CGRectMake(0, 0, screenWidth, self.applyCatoryArray.count *30 + 44);
    [self.justApplistTableView reloadData];
}

#pragma mark-- 勾选代理
- (void)selectJGHApplyCatoryPriceViewCell:(UIButton *)btn{
    NSLog(@"勾选代理 == %ld", (long)btn.tag);
    _selectId = btn.tag -100;
    
    [self.justApplistTableView reloadData];
}

#pragma mark -- 确定
- (void)applyCatoryPromCellCommitBtn:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate selectApplyCatory:_applyCatoryArray[_selectId]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
