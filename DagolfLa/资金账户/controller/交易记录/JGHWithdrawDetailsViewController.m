//
//  JGHWithdrawViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawDetailsViewController.h"
#import "JGHWithdrawMoneyCell.h"
#import "JGHWithdrawDetailsCell.h"
#import "JGHWithdrawTimeCell.h"
#import "JGHWithdrawCatoryCell.h"
#import "JGHWithdrawTimeCell.h"
#import "JGHWithdrawDetailsCell.h"

static NSString *const JGHWithdrawDetailsCellIdentifier = @"JGHWithdrawDetailsCell";

@interface JGHWithdrawDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *withdrawTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHWithdrawDetailsViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"提现详情";
    
    [self createWithdrawTableView];
}

- (void)createWithdrawTableView{
    self.withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.withdrawTableView.delegate = self;
    self.withdrawTableView.dataSource = self;
    self.withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.withdrawTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    //注册cell
    UINib *detailsNib = [UINib nibWithNibName:@"JGHWithdrawDetailsCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:detailsNib forCellReuseIdentifier:JGHWithdrawDetailsCellIdentifier];
    
    [self.view addSubview:self.withdrawTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100 *ProportionAdapter;
    }else if (indexPath.section == 4){
        return 250 * ProportionAdapter;
    }else{
        return 45 * ProportionAdapter;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *withdrawMonayCellIdef = @"JGHWithdrawMoneyCell";
    static NSString *withdrawCatoryCellIdef = @"JGHWithdrawCatoryCell";
    static NSString *withdrawTimeCellIdef = @"JGHWithdrawTimeCell";
    if (indexPath.section == 0) {
        JGHWithdrawMoneyCell *withdrawMonayCell = [tableView dequeueReusableCellWithIdentifier:withdrawMonayCellIdef];
        if (withdrawMonayCell == nil) {
            withdrawMonayCell = [[JGHWithdrawMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawMonayCellIdef];
        }
        
        withdrawMonayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawMonayCell;
    }else if (indexPath.section == 1){
        JGHWithdrawCatoryCell *withdrawCatoryCell = [tableView dequeueReusableCellWithIdentifier:withdrawCatoryCellIdef];
        if (withdrawCatoryCell == nil) {
            withdrawCatoryCell = [[JGHWithdrawCatoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawCatoryCellIdef];
        }
        
        withdrawCatoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawCatoryCell;
    }else if (indexPath.section == 2 || indexPath.section == 3){
        //
        JGHWithdrawTimeCell *withdrawtimeCell = [tableView dequeueReusableCellWithIdentifier:withdrawTimeCellIdef];
        if (withdrawtimeCell == nil) {
            withdrawtimeCell = [[JGHWithdrawTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawTimeCellIdef];
        }
        
        withdrawtimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawtimeCell;
    }else{
        JGHWithdrawDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawDetailsCellIdentifier];
        return detailsCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
