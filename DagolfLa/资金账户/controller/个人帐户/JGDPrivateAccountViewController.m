//
//  JGDPrivateAccountViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrivateAccountViewController.h"

@interface JGDPrivateAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGDPrivateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人帐户";
    [self creatTableV];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // 去黑线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"parentTopBackgroupd"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    
    // Do any additional setup after loading the view.
}


- (void)creatTableV{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 289 * ScreenWidth / 375) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 160 *ScreenWidth / 375)];
    view.backgroundColor = [UIColor colorWithHexString:@"#32B14D"];
    self.tableView.tableHeaderView = view;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 * ScreenWidth / 375, 20 * ScreenWidth / 375, 100 * ScreenWidth / 375, 30 * ScreenWidth / 375)];
    label.text = @"帐户余额（元）";
    label.font = [UIFont systemFontOfSize:14 * ScreenWidth / 375];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    UILabel *balanceLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ScreenWidth / 375, 40 * ScreenWidth / 375, screenWidth - 20 * ScreenWidth / 375, 80 * ScreenWidth / 375)];
    balanceLB.text = @"$99999.99";
    balanceLB.textAlignment = NSTextAlignmentCenter;
    balanceLB.font = [UIFont systemFontOfSize:40 * ScreenWidth / 375];
    balanceLB.textColor = [UIColor whiteColor];
    [view addSubview:balanceLB];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(120 * ScreenWidth / 375, 136 * ScreenWidth / 375, 135 * ScreenWidth / 375, 47 * ScreenWidth / 375) ;
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(takeMoney) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sysCell"];
    
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:button aboveSubview:self.tableView];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 * ScreenWidth / 375;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"交易记录";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"银行卡";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"中国银行";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else{
        
    }
}


#pragma mark -----提现

- (void)takeMoney{
    
}

#pragma mark -----添加银行卡

- (void)addBank{
    
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
