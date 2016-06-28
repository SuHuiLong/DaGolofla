//
//  JGHWithdrawViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawViewController.h"
#import "JGHTradRecordCell.h"
#import "JGHWithdrawTimeCell.h"

@interface JGHWithdrawViewController ()

@property (nonatomic, strong)UITableView *withdrawTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"提现";
    
    [self createRefoundTableView];
}
- (void)createRefoundTableView{
    self.withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.withdrawTableView.delegate = self;
    self.withdrawTableView.dataSource = self;
    [self.view addSubview:self.withdrawTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70 *ProportionAdapter;
    }
    return 45 * ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *withdrawMonayCellIdef = @"JGHWithdrawMoneyCell";
    static NSString *withdrawCatoryCellIdef = @"JGHWithdrawCatoryCell";
    static NSString *withdrawTimeCellIdef = @"JGHWithdrawTimeCell";
    if (indexPath.section == 0) {
        static NSString *tradRecordCell = @"JGHTradRecordCell";
        JGHTradRecordCell *tradCell = [tableView dequeueReusableCellWithIdentifier:tradRecordCell];
        if (tradCell == nil) {
            tradCell = [[JGHTradRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tradRecordCell];
        }
        
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tradCell configModel];
        
        return tradCell;
    }else{
        JGHWithdrawTimeCell *withdrawtimeCell = [tableView dequeueReusableCellWithIdentifier:withdrawTimeCellIdef];
        if (withdrawtimeCell == nil) {
            withdrawtimeCell = [[JGHWithdrawTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawTimeCellIdef];
        }
        
        withdrawtimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawtimeCell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *labeltext =[[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 20)];
    labeltext.text = @"每笔金额提现最少为10元，预计两小时到账";
    return (UIView *)labeltext;
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
