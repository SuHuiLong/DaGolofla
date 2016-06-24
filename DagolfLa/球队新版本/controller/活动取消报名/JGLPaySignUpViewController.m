//
//  JGLPaySignUpViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPaySignUpViewController.h"
#import "JGLPayHeaderTableViewCell.h"
#import "JGLSignPeoTableViewCell.h"
#import "JGLPayListTableViewCell.h"

#import "UITool.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"

#import "JGLPaySignModel.h"
@interface JGLPaySignUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    UIView* _viewFoott;
    
    NSInteger _page;
    
    NSMutableArray* _dataArrayYet;//已付款
    NSMutableArray* _dataArrayWait;//代付款
    

}
@end

@implementation JGLPaySignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:view];
    
    _page = 0;
    self.title = @"报名/支付";
    _dataArrayYet = [[NSMutableArray alloc]init];
    _dataArrayWait = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self createFooterView];
    [self uiConfig];
    
    [self createBtn];
    
}

-(void)createBtn
{
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor orangeColor];
    [btnDelete setTitle:@"添加报名人" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
    btnDelete.frame = CGRectMake(10*screenWidth/375, screenHeight - 54*screenWidth/375-64, screenWidth-20*screenWidth/375, 44*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    [btnDelete addTarget:self action:@selector(addPeopleClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --添加报名人点击事件
-(void)addPeopleClick
{
    
}

-(void)createFooterView
{
    _viewFoott = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20*screenWidth/375)];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20*screenWidth/375)];
    label.font = [UIFont systemFontOfSize:15*screenWidth/375];
    label.text = @"提示：当前报名者在线支付，本人可享受平台补贴。";
    [_viewFoott addSubview:label];
}
#pragma mark --uitableview创建
-(void)uiConfig
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-65*screenWidth/375-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _viewFoott;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [_tableView registerClass:[JGLPayHeaderTableViewCell class] forCellReuseIdentifier:@"JGLPayHeaderTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JGLSignPeoTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLSignPeoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JGLPayListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLPayListTableViewCell"];
 
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:@4481 forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getUserActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArrayYet removeAllObjects];
                [_dataArrayWait removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"teamSignUpList"])
            {
                JGLPaySignModel *model = [[JGLPaySignModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                if ([model.payMoney integerValue] > 0) {
                    [_dataArrayYet addObject:model];
                }
                else
                {
                    [_dataArrayWait addObject:model];
                }
            }
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
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


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*screenWidth/375;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75*ScreenWidth/320;
    }
    else if (indexPath.section == 1)
    {
        return 50*ScreenWidth/375;
    }
    else{
        return 44*ScreenWidth/375;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1 + _dataArrayYet.count + _dataArrayWait.count;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  头视图
     */
    if (indexPath.section == 0) {
        JGLPayHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPayHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    /**
        报名人视图
     */
    else if (indexPath.section == 1)
    {
        JGLSignPeoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLSignPeoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            /**
             *  报名人名单和发票信息
             */
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"报名人名单(8)";
            return cell;
        }
        else{
            JGLPayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPayListTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //cell从1开始
            if (indexPath.row - 1 < _dataArrayYet.count) {//已付款的cell，个数为数组0 ----- count-1 个
                [cell showData:_dataArrayYet[indexPath.row - 1]];
                cell.stateBtn.hidden = YES;
                cell.payBtn.hidden = YES;
                if (indexPath.row == 1) {
                    cell.titleLabel.text = @"已付款";
                }
                else{
                    cell.titleLabel.hidden = YES;
                }
            }
            else{
                if (_dataArrayWait.count != 0) {
                    [cell showData:_dataArrayWait[indexPath.row-_dataArrayYet.count-1]];
                }
                
                
                if (indexPath.row == _dataArrayYet.count+1) {
                    cell.titleLabel.text = @"待付款";
                    cell.payBtn.hidden = NO;
                    [cell.payBtn addTarget:self action:@selector(payMoneyClick) forControlEvents:UIControlEventTouchUpInside];
                }
                else{
                    cell.titleLabel.hidden = YES;
                    cell.payBtn.hidden = YES;
                }
            }
            return cell;
        }
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"发票信息";
        return cell;
    }
    
}


#pragma mark --支付
-(void)payMoneyClick
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

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
