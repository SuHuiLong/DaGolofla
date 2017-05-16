//
//  JGDAlmostStlyleSetViewController.m
//  DagolfLa
//
//  Created by 東 on 16/9/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDAlmostStlyleSetViewController.h"
#import "JGDAlmostSetTableViewCell.h"

@interface JGDAlmostStlyleSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIButton *calculateBySelfButton;

@end

@implementation JGDAlmostStlyleSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"差点设置";
    
    UIBarButtonItem *barBitm = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(changeAct)];
    barBitm.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barBitm;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.tableView registerClass:[JGDAlmostSetTableViewCell class] forCellReuseIdentifier:@"almost"];
    
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150 * ProportionAdapter)];
    self.tableView.tableHeaderView = headerBackView;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 150 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 200 * ProportionAdapter, 20 * ProportionAdapter)];
    titleLB.text = @"成绩同步设置";
    titleLB.textColor = [UIColor colorWithHexString:@"#32b14d"];
    titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headerView addSubview:titleLB];
    
    UIButton *lockBtn = [[UIButton alloc] initWithFrame:CGRectMake(260 * ProportionAdapter, 15 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
    if (_lockScore == 0) {
        [lockBtn setTitle:@"同步" forState:(UIControlStateNormal)];
        [lockBtn setImage:[UIImage imageNamed:@"synchronous"] forState:(UIControlStateNormal)];
    }else{
        [lockBtn setTitle:@"锁定" forState:(UIControlStateNormal)];
        [lockBtn setImage:[UIImage imageNamed:@"lock"] forState:(UIControlStateNormal)];
    }
    [lockBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -60 * ProportionAdapter, 0, 0)];
    [lockBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50 * ProportionAdapter, 0, 0)];

    [lockBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [lockBtn addTarget:self action:@selector(lockAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:lockBtn];

    UILabel *synchroLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 45 * ProportionAdapter, 50 * ProportionAdapter, 20 * ProportionAdapter)];
    synchroLB.text = @"同步：";
    synchroLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headerView addSubview:synchroLB];
    
    UILabel *synchroDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter, 40 * ProportionAdapter, 260 * ProportionAdapter, 50 * ProportionAdapter)];
    synchroDetailLB.text = @"同步成绩后，成绩管理页将实时同步活动成员已完成的成绩数据；";
    synchroDetailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    synchroDetailLB.numberOfLines = 0;
    synchroDetailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headerView addSubview:synchroDetailLB];
    
    UILabel *lockLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 95 * ProportionAdapter, 50 * ProportionAdapter, 20 * ProportionAdapter)];
    lockLB.text = @"锁定：";
    lockLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headerView addSubview:lockLB];
    
    UILabel *lockDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter, 90 * ProportionAdapter, 260 * ProportionAdapter, 60 * ProportionAdapter)];
    lockDetailLB.text = @"成绩锁定后，所有成绩管理页将不再接受成员成绩以避免成员对成绩的修改而造成的不公。";
    lockDetailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    lockDetailLB.numberOfLines = 0;
    lockDetailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headerView addSubview:lockDetailLB];
    
    [headerBackView addSubview:headerView];
}

- (void)lockAct:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"锁定"]) {
        _lockScore = 0;
        [button setTitle:@"同步" forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"synchronous"] forState:(UIControlStateNormal)];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:@(_teamActivityKey) forKey:@"activityKey"];
        [dict setObject:@(_almostType) forKey:@"almostType"];
        [dict setObject:@(_lockScore) forKey:@"lockScore"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/lockActivityScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    }else{
        _lockScore = 1;
        [button setTitle:@"锁定" forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"lock"] forState:(UIControlStateNormal)];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:@(_teamActivityKey) forKey:@"activityKey"];
        [dict setObject:@(_almostType) forKey:@"almostType"];
        [dict setObject:@(_lockScore) forKey:@"lockScore"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/lockActivityScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    }
}

- (void)changeAct{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:@(_teamActivityKey) forKey:@"teamActivityKey"];
    [dict setObject:@(_almostType) forKey:@"almostType"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/setAlmost" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDAlmostSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"almost"];
    self.changeButton = [cell viewWithTag:201];
    self.calculateBySelfButton = [cell viewWithTag:202];
    [self.changeButton addTarget:self action:@selector(changeStyle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.calculateBySelfButton addTarget:self action:@selector(changeStyle:) forControlEvents:(UIControlEventTouchUpInside)];
    if (_almostType == 1) {
        [self.calculateBySelfButton setImage:[UIImage imageNamed:@"scorXZ"] forState:UIControlStateNormal];
    }else if(_almostType == 0) {
        [self.changeButton setImage:[UIImage imageNamed:@"scorXZ"] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)changeStyle:(UIButton *)button{
    if (button.tag == 201) {
        [self.changeButton setImage:[UIImage imageNamed:@"scorXZ"] forState:UIControlStateNormal];
        [self.calculateBySelfButton setImage:[UIImage imageNamed:@"yuanquan"] forState:UIControlStateNormal];
        _almostType = 0;
    }else{
        [self.changeButton setImage:[UIImage imageNamed:@"yuanquan"] forState:UIControlStateNormal];
        [self.calculateBySelfButton setImage:[UIImage imageNamed:@"scorXZ"] forState:UIControlStateNormal];
        _almostType = 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 390;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
