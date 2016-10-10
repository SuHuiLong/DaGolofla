//
//  JGDCheckScoreViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCheckScoreViewController.h"
#import "JGDCheckScoreTableViewCell.h"

@interface JGDCheckScoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JGDCheckScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[JGDCheckScoreTableViewCell class] forCellReuseIdentifier:@"checkScore"];
    
    [self.view addSubview:tableView];
    
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDCheckScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkScore"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83 * ProportionAdapter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
