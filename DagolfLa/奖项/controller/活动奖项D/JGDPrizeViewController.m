//
//  JGDPrizeViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrizeViewController.h"
#import "JGDtopTableViewCell.h"
#import "JGDprizeTableViewCell.h"
#import "JGDActvityPriziSetTableViewCell.h"
#import "JGLPresentAwardViewController.h"
#import "JGHSetAwardViewController.h"
#import "JGHActivityBaseCell.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGDPrizeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end


@implementation JGDPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动奖项";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self createTableView];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAct)];
    barBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    // Do any additional setup after loading the view.
}

// 分享
- (void)shareAct{
    
}


- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDprizeTableViewCell class] forCellReuseIdentifier:@"prizeCell"];
    UINib *activityBaseCellNib = [UINib nibWithNibName:@"JGHActivityBaseCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib:activityBaseCellNib forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[JGDActvityPriziSetTableViewCell class] forCellReuseIdentifier:@"setCell"];
    _page = 0;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];

    [self.view addSubview:self.tableView];
}

// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"activityKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getPublishPrizeList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errtype == %@", errType);
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            self.dataArray = [data objectForKey:@"list"];
            [self.tableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }

    }];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JGHActivityBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        [cell configJGTeamActivityModel:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            JGDActvityPriziSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLB.text = [NSString stringWithFormat:@"活动奖项（%td）",self.dataArray.count];
            
            if (self.isManager != 1) {
                
                [cell.contentView addSubview:cell.presentationBtn];
                [cell.contentView addSubview:cell.prizeBtn];
                
                [cell.presentationBtn addTarget:self action:@selector(present) forControlEvents:(UIControlEventTouchUpInside)];
                [cell.prizeBtn addTarget:self action:@selector(prizeSet) forControlEvents:(UIControlEventTouchUpInside)];
            }
            return cell;
        }else{
            
            JGDprizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prizeCell"];
            cell.nameLabel.text = [self.dataArray[indexPath.row - 1] objectForKey:@"name"];
            cell.prizeLbel.text = [self.dataArray[indexPath.row - 1] objectForKey:@"prizeName"];
            cell.numberLabel.text = [[self.dataArray[indexPath.row - 1] objectForKey:@"prizeSize"] stringValue];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
    }
}

//
- (void)prizeSet{
    JGHSetAwardViewController *setAwardVC = [[JGHSetAwardViewController alloc] init];
    setAwardVC.activityKey = self.activityKey;
    setAwardVC.teamKey = self.teamKey;
    setAwardVC.model = self.model;
    [self.navigationController pushViewController:setAwardVC animated:YES];
}


//立即颁奖
- (void)present{
    
    JGLPresentAwardViewController *preVC = [[JGLPresentAwardViewController alloc] init];
    preVC.activityKey = _activityKey;
    [self.navigationController pushViewController:preVC animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80 * ProportionAdapter;
    }else{
        return 44 * ProportionAdapter;
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
