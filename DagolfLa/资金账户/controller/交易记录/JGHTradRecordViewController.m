//
//  JGHTradRecordViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTradRecordViewController.h"
#import "JGHTradRecordCell.h"
#import "JGHWithdrawDetailsViewController.h"

@interface JGHTradRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tradRecordTableView;


@end

@implementation JGHTradRecordViewController

- (instancetype)init{
    if (self == [super init]) {
        self.tradRecordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
        self.tradRecordTableView.delegate = self;
        self.tradRecordTableView.dataSource = self;
        [self.view addSubview:self.tradRecordTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"交易记录";
    
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tradRecordCell = @"JGHTradRecordCell";
    JGHTradRecordCell *tradCell = [tableView dequeueReusableCellWithIdentifier:tradRecordCell];
    if (tradCell == nil) {
        tradCell = [[JGHTradRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tradRecordCell];
    }
    
    tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tradCell configModel];
    
    return tradCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHWithdrawDetailsViewController *withdrawDetailsCtrl = [[JGHWithdrawDetailsViewController alloc]init];
    [self.navigationController pushViewController:withdrawDetailsCtrl animated:YES];
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
