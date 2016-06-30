//
//  JGHNOBlankPasswordViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNOBlankPasswordViewController.h"
#import "JGHButtonCell.h"
#import "JGHWithdrawCell.h"
#import "JGSignUoPromptCell.h"
#import "JGDSubMitPayPasswordViewController.h"

static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHWithdrawCellIdentifier = @"JGHWithdrawCell";

@interface JGHNOBlankPasswordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *setBlankPassTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHNOBlankPasswordViewController

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
    self.navigationItem.title = @"提现";
    
    
    [self createSetBlankPassTableView];
}

- (void)createSetBlankPassTableView{
    self.setBlankPassTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 63) style:UITableViewStyleGrouped];
    self.setBlankPassTableView.delegate = self;
    self.setBlankPassTableView.dataSource = self;
    self.setBlankPassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *promptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.setBlankPassTableView registerNib:promptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *catoryNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.setBlankPassTableView registerNib:catoryNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
    UINib *drawNib = [UINib nibWithNibName:@"JGHWithdrawCell" bundle: [NSBundle mainBundle]];
    [self.setBlankPassTableView registerNib:drawNib forCellReuseIdentifier:JGHWithdrawCellIdentifier];


    [self.view addSubview:self.setBlankPassTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        static JGSignUoPromptCell *cell;
        if (!cell) {
            cell = [self.setBlankPassTableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        }
        
        cell.pamaptLabel.text = @"提示：您当前未设置支付密码，请前去设置密码保障账户安全。";
        return ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1)*ProportionAdapter;
    }
    return 45 * ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 25* ProportionAdapter;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHWithdrawCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCellIdentifier];
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tradCell configWithdrawBalance:_reaplyBalance];
        
        return tradCell;
    }else if (indexPath.section == 1){
        JGSignUoPromptCell *promptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        
        promptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptCell configPromptSetPasswordString:@"提示：您当前未设置支付密码，请前去设置密码保障账户安全。"];
        return promptCell;
        
    }else if (indexPath.section == 2){
        JGHWithdrawCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCellIdentifier];
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tradCell configSetPassword];
        
        return tradCell;
        
    }else{
        JGHButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        btnCell.delegate = self;
        btnCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        [btnCell.clickBtn setTitle:@"确认" forState:UIControlStateNormal];
        return btnCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //设置密码页面
        JGDSubMitPayPasswordViewController *payCtrl = [[JGDSubMitPayPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:payCtrl animated:YES];
    }
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
