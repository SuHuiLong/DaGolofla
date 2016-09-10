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

@end

@implementation JGDAlmostStlyleSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    [lockBtn setTitle:@"锁定" forState:(UIControlStateNormal)];
    [lockBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -60 * ProportionAdapter, 0, 0)];

    [lockBtn setImage:[UIImage imageNamed:@"lock"] forState:(UIControlStateNormal)];
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDAlmostSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"almost"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
