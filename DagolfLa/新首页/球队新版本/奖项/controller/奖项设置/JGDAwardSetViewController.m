//
//  JGDAwardSetViewController.m
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAwardSetViewController.h"
#import "JGDActivityHeadView.h"
#import "JGDAwardSetTableViewCell.h"

#import "JGHChooseAwardViewController.h"
#import "JGHAwardModel.h"

@interface JGDAwardSetViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bgView;

//完成按钮
@property (nonatomic,strong) UIButton *commitButton;
@end

@implementation JGDAwardSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

    self.title = @"奖项设置";
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(getNotificationAction:) name:@"customPrize" object:nil];
    //  Do any additional setup after loading the view.
}

#pragma mark -- 添加自定义奖项

- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    JGHAwardModel *model = [[JGHAwardModel alloc]init];
    [model setValuesForKeysWithDictionary:infoDic];
    [self.dataArray addObject:model];
    [self.listTableView reloadData];
}


- (void)createTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - kHvertical(60) - 64) style:(UITableViewStylePlain)];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = kHvertical(111);
    [self.listTableView registerClass:[JGDAwardSetTableViewCell class] forCellReuseIdentifier:@"JGDAwardSet"];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    JGDActivityHeadView *headView = [[JGDActivityHeadView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, kHvertical(90))];
    headView.model = self.model;
    self.listTableView.tableHeaderView = headView;
    self.listTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self.view addSubview:self.listTableView];
    [self createFooter];

    [self loadData];
}

- (void)createFooter{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(60))];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.listTableView.tableFooterView = backView;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(10), screenWidth, kWvertical(50))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];
    
    UIImageView *iconImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(14), kWvertical(22), kHvertical(22)) Image:[UIImage imageNamed:@"icn_addawards"]];
    [whiteView addSubview:iconImageView];
    
    UIButton *addAwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(50))];

    [addAwardBtn setTitle:@"添加奖项" forState:(UIControlStateNormal)];
    [addAwardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWvertical(235))];
    addAwardBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    [addAwardBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
    [addAwardBtn addTarget:self action:@selector(addAwardAct) forControlEvents:(UIControlEventTouchUpInside)];
    [whiteView addSubview:addAwardBtn];
    
    UIImageView *chooseImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(356), kHvertical(19), kWvertical(8), kHvertical(13))];
    chooseImageV.image = [UIImage imageNamed:@")"];
    [whiteView addSubview:chooseImageV];
    // 529
    
    self.commitButton = [[UIButton alloc] initWithFrame:CGRectMake(kWvertical(10), ScreenHeight - kHvertical(60)-64, screenWidth - kWvertical(20), kHvertical(45))];
    [self.commitButton setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = kWvertical(8);
    [self.commitButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.commitButton addTarget:self action:@selector(commitAct) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.commitButton];
}

#pragma mark -- 完成


- (void)commitAct{
    
    [self.listTableView endEditing:YES];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dataDic setObject:@(self.activityKey) forKey:@"activityKey"];
    [dataDic setObject:@(self.teamKey) forKey:@"teamKey"];

    NSMutableArray *prizelist = [NSMutableArray array];
    
    for (JGHAwardModel *model in _dataArray) {
        
        NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
        [modelDic setObject:@(self.activityKey) forKey:@"teamActivityKey"];
        [modelDic setObject:@(self.teamKey) forKey:@"teamKey"];
        if (model.timeKey) {
            [modelDic setObject:model.timeKey forKey:@"timeKey"];
        }
        if (model.name) {
            [modelDic setObject:model.name forKey:@"name"];
        }
        if (model.prizeSize) {
            [modelDic setObject:model.prizeSize forKey:@"prizeSize"];
        }
        if (model.prizeName) {
            [modelDic setObject:model.prizeName forKey:@"prizeName"];
        }
        if (model.userInfo) {
            [modelDic setObject:model.userInfo forKey:@"userInfo"];
        }
        if (model.signupKeyInfo) {
            [modelDic setObject:model.signupKeyInfo forKey:@"signupKeyInfo"];
        }
        if (model.isDefault) {
            [modelDic setObject:model.isDefault forKey:@"isDefault"];
        }
        
        [prizelist addObject:modelDic];
    }
    
    [dataDic setObject:prizelist forKey:@"prizeList"];

    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"team/doBatchSavePrize" JsonKey:nil withData:dataDic failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            _refreshBlock();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
}

- (void)deleteCurrentCell:(UIButton *)button {
    JGDAwardSetTableViewCell *cell= (JGDAwardSetTableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPth = [self.listTableView indexPathForCell:cell];
    [self.dataArray removeObjectAtIndex:indexPth.row];
    [self.listTableView deleteRowAtIndexPath:indexPth withRowAnimation:(UITableViewRowAnimationTop)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    JGDAwardSetTableViewCell *cell= (JGDAwardSetTableViewCell *)[[[textField superview] superview] superview];
    NSIndexPath *indexPth = [self.listTableView indexPathForCell:cell];
    
    JGHAwardModel *model = _dataArray[indexPth.row];
    if ([textField.placeholder isEqualToString:@"奖品名称"]) {
        model.prizeName = textField.text;
    }else{
        model.prizeSize = [Helper returnNumberForString:textField.text];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDAwardSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDAwardSet"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.prizeTF.delegate = self;
    cell.prizeCountTF.delegate = self;
    if ([self.dataArray count] > 0) {
        cell.model = self.dataArray[indexPath.row];
        [cell.trashButton addTarget:self action:@selector(deleteCurrentCell:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count == 0) {
        [self.listTableView addSubview:self.bgView];
    }else{
        if ([self.listTableView.subviews containsObject:self.bgView]) {
            [self.bgView removeFromSuperview];
        }
    }
    
    return self.dataArray.count;
}

- (void)addAwardAct{
    JGHChooseAwardViewController *chooseAwardCtrl = [[JGHChooseAwardViewController alloc]init];
    chooseAwardCtrl.teamKey = _teamKey;
    chooseAwardCtrl.activityKey = _activityKey;
    chooseAwardCtrl.selectChooseArray = _dataArray;
    chooseAwardCtrl.refreshBlock = ^(NSMutableArray *array){
        
        NSMutableArray *copyArray = [NSMutableArray arrayWithArray:_dataArray];
        for (JGHAwardModel *model in copyArray) {
            if (![array containsObject: model.name] && [model.isDefault integerValue] == 1) {
                [_dataArray removeObject:model];
            }
        }
        
        NSMutableArray *modelNameArray = [NSMutableArray array];
        for (JGHAwardModel *model in copyArray) {
            [modelNameArray addObject:model.name];
        }
        
        for (NSString *nameString in array) {
            if (![modelNameArray containsObject:nameString]) {
                JGHAwardModel *model = [[JGHAwardModel alloc] init];
                model.name = nameString;
                model.prizeSize = @0;
                model.isDefault = @1;
                [_dataArray addObject:model];
            }
        }
        [self.listTableView reloadData];
    };
    [self.navigationController pushViewController:chooseAwardCtrl animated:YES];
}

#pragma mark -- 下载数据
- (void)loadData{
    
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivityPrizeAllList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
        NSLog(@"data = %@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];

        [self.dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            for (NSDictionary *dict in [data objectForKey:@"list"]) {
                JGHAwardModel *model = [[JGHAwardModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.listTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kHorizontal(220), screenWidth, 300)];
        UIImageView *weifabuImageview = [[UIImageView alloc]initWithFrame:CGRectMake(kWvertical(65), 0, screenWidth - kWvertical(106), kHvertical(153))];
        weifabuImageview.image = [UIImage imageNamed:@"bg_set_awards"];
        [_bgView addSubview:weifabuImageview];
        
        UILabel *weifaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kHvertical(190), screenWidth, 20*ProportionAdapter)];
        weifaLabel.text = @"暂未发布奖项";
        weifaLabel.textAlignment = NSTextAlignmentCenter;
        weifaLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
        weifaLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        [_bgView addSubview:weifaLabel];
    }
    return _bgView;
}


//textField改变
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
