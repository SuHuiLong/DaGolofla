//
//  JGHWithdrawViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawViewController.h"
#import "JGHTradRecordImageCell.h"
#import "JGHWithdrawCell.h"
#import "JGSignUoPromptCell.h"
#import "JGHButtonCell.h"
#import "JGLBankModel.h"

static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHWithdrawCellIdentifier = @"JGHWithdrawCell";
static NSString *const JGHTradRecordImageCellIdentifier = @"JGHTradRecordImageCell";

@interface JGHWithdrawViewController ()<UITableViewDataSource, UITableViewDelegate, JGHButtonCellDelegate>

@property (nonatomic, strong)UITableView *withdrawTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHWithdrawViewController

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
    
    [self createRefoundTableView];
    
    [self loadData];
}

- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBankCardList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray array];
            array = [data objectForKey:@"userBankCardList"];
            for (NSMutableDictionary *dict in array) {
                JGLBankModel *model = [[JGLBankModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }else{
            
        }
        
        [self.withdrawTableView reloadData];
    }];
}

- (void)createRefoundTableView{
    self.withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.withdrawTableView.delegate = self;
    self.withdrawTableView.dataSource = self;
    self.withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *promptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:promptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *catoryNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:catoryNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
    UINib *cellNib = [UINib nibWithNibName:@"JGHWithdrawCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:cellNib forCellReuseIdentifier:JGHWithdrawCellIdentifier];
    
    UINib *recordNib = [UINib nibWithNibName:@"JGHTradRecordImageCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:recordNib forCellReuseIdentifier:JGHTradRecordImageCellIdentifier];
    
    [self.view addSubview:self.withdrawTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70 *ProportionAdapter;
    }else if (indexPath.section == 1){
        return 40*ProportionAdapter;
    }
    return 45 * ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHTradRecordImageCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHTradRecordImageCellIdentifier];
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArray.count > 0) {
//            [tradCell configJGHWithDrawModelWithDraw:_dataArray[indexPath.section]];
        }
        
        return tradCell;
    }else if (indexPath.section == 1){
        
        JGSignUoPromptCell *promptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        
        promptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptCell configPromptString:@"每笔金额提现最少为10元，预计两小时到账"];
        return promptCell;
    }else if (indexPath.section == 2){
        JGHWithdrawCell *withdrawCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCellIdentifier];
        
        withdrawCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawCell;
    }else{
        JGHButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        btnCell.delegate = self;
        [btnCell.clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
        return btnCell;
    }
}


#pragma mark -- 下一步
- (void)selectCommitBtnClick:(UIButton *)btn{
    NSLog(@"下一步");
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
