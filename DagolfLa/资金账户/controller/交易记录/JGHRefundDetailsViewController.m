//
//  JGHRefundDetailsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRefundDetailsViewController.h"
#import "JGHWithdrawCatoryCell.h"
#import "JGHWithdrawCell.h"
#import "JGHWithdrawMoneyCell.h"

static NSString *const JGHWithdrawMoneyCellIdentifier = @"JGHWithdrawMoneyCell";
static NSString *const JGHWithdrawCatoryCellIdentifier = @"JGHWithdrawCatoryCell";
static NSString *const JGHWithdrawCellIdentifier = @"JGHWithdrawCell";

@interface JGHRefundDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *refoundTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHRefundDetailsViewController

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
    self.navigationItem.title = @"退款详情";
    
}

- (void)createRefoundTableView{
    self.refoundTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.refoundTableView.delegate = self;
    self.refoundTableView.dataSource = self;
    
    UINib *monayNib = [UINib nibWithNibName:@"JGHWithdrawMoneyCell" bundle: [NSBundle mainBundle]];
    [self.refoundTableView registerNib:monayNib forCellReuseIdentifier:JGHWithdrawMoneyCellIdentifier];
    
    UINib *catoryNib = [UINib nibWithNibName:@"JGHWithdrawCatoryCell" bundle: [NSBundle mainBundle]];
    [self.refoundTableView registerNib:catoryNib forCellReuseIdentifier:JGHWithdrawCatoryCellIdentifier];
    
    UINib *cellNib = [UINib nibWithNibName:@"JGHWithdrawCell" bundle: [NSBundle mainBundle]];
    [self.refoundTableView registerNib:cellNib forCellReuseIdentifier:JGHWithdrawCellIdentifier];
    
    [self.view addSubview:self.refoundTableView];
}


#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 2;
    }
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

    if (indexPath.section == 0) {
        JGHWithdrawMoneyCell *withdrawMonayCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawMoneyCellIdentifier];
        
        withdrawMonayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawMonayCell;
    }else if (indexPath.section == 1){
        JGHWithdrawCatoryCell *withdrawCatoryCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCatoryCellIdentifier];
        
        withdrawCatoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
        }else{
            
        }
        
        return withdrawCatoryCell;
    }else{
        JGHWithdrawCell *withdrawCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCellIdentifier];

        withdrawCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return withdrawCell;
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
