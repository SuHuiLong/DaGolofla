//
//  JGDSetConfrontViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSetConfrontViewController.h"
#import "JGDSetConfrontTableViewCell.h"

@interface JGDSetConfrontViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JGDSetConfrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JGDSetConfrontTableViewCell class] forCellReuseIdentifier:@"setConfront"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70 * ProportionAdapter)];
    headBackV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    tableView.tableHeaderView = headBackV;
    
    UILabel *setLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 300 * ProportionAdapter, 25 * ProportionAdapter)];
    setLB.text = @"请先设置球队的对抗关系！";
    setLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    setLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
    [headBackV addSubview:setLB];
    
    UIView *wihteBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
    wihteBackV.backgroundColor = [UIColor whiteColor];
    [headBackV addSubview:wihteBackV];
    
    UILabel *setConfLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 5 * ProportionAdapter, 300 * ProportionAdapter, 25 * ProportionAdapter)];
    setConfLB.text = @"设置对抗";
    setConfLB.textColor = [UIColor colorWithHexString:@"#313131"];
    setConfLB.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    [wihteBackV addSubview:setConfLB];
    
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDSetConfrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setConfront"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * ProportionAdapter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *styleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 8 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 30 * ProportionAdapter)];
    styleLB.text =@"第一轮 四人四球赛";
    styleLB.textAlignment = NSTextAlignmentCenter;
    styleLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    styleLB.textColor = [UIColor colorWithHexString:@"#313131"];
    [view addSubview:styleLB];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5 * ProportionAdapter)];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:lineV];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50 * ProportionAdapter;
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
