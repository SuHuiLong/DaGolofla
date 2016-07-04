//
//  JGLBankListViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLBankListViewController.h"
#import "JGLBankCardTableViewCell.h"
#import "JGLAddBankCardViewController.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "JGLBankModel.h"

#import "MBProgressHUD.h"
@interface JGLBankListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView* _viewHeader;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSInteger _page;
    MBProgressHUD* _progress;
    
    NSInteger _isClick;
}
@end

@implementation JGLBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.title = @"银行卡";
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    
    [self createHeader];
    [self uiConfig];
}

-(void)createHeader
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64*screenWidth/375)];
    _viewHeader.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:_viewHeader];
    
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor colorWithHexString:Click_Color];
    [btnDelete setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [_viewHeader addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:17];
    btnDelete.frame = CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth-20*screenWidth/375, 44*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    [btnDelete addTarget:self action:@selector(addBankCardClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --添加银行卡按钮
-(void)addBankCardClick
{
    JGLAddBankCardViewController* addVc = [[JGLAddBankCardViewController alloc]init];
    addVc.refreshBlock = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:addVc animated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _viewHeader;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [_tableView.header beginRefreshing];
}



#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBankCardList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"userBankCardList"])
            {
                JGLBankModel *model = [[JGLBankModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:[data objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*screenWidth/375;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*screenWidth/375)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*ScreenWidth/375;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"JGLBankCardTableViewCell";
    JGLBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JGLBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell showData:_dataArray[indexPath.section]];
    cell.deleteBtn.tag = 100+indexPath.section;
    [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:BG_color];
    return cell;
}
#pragma mark --删除银行卡
-(void)deleteClick:(UIButton *)btn
{
    NSLog(@"%td",btn.tag);
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在删除...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    NSString* strDet = [NSString stringWithFormat:@"您确定要删除此%@卡",[_dataArray[btn.tag - 100] backName]];
    [Helper alertViewWithTitle:strDet withBlockCancle:^{
        
    } withBlockSure:^{
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
        [dict setObject:[_dataArray[btn.tag - 100] timeKey] forKey:@"bankCardKey"];
        [[JsonHttp jsonHttp] httpRequest:@"user/deleteUserBankCard" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"%@",errType);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } completionBlock:^(id data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                [_tableView.header beginRefreshing];
            }
            else
            {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }];
    } withBlock:^(UIAlertController *alertView) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
