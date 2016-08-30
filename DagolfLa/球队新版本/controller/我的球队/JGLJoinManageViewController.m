//
//  JGLJoinManageViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLJoinManageViewController.h"
#import "TeamApplyViewCell.h"
#import "JGLTeamAdviceTableViewCell.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "JGLTeamMemberModel.h"

#import "UITool.h"
@interface JGLJoinManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataUpDataArray;
    NSInteger _page;
}
@end

@implementation JGLJoinManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    [self.view addSubview:view];
    
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _dataUpDataArray = [[NSMutableArray alloc]init];
    self.title = @"申请审批";
    [self uiConfig];
    
    
}

-(void) uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"TeamApplyViewCell" bundle:nil] forCellReuseIdentifier:@"TeamApplyViewCell"];
    [_tableView registerClass:[JGLTeamAdviceTableViewCell class] forCellReuseIdentifier:@"JGLTeamAdviceTableViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    NSString *para = [JGReturnMD5Str getAuditTeamMemberListWithTeamKey:[_teamKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:para forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getAuditTeamMemberList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
                [_dataUpDataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dataDic in [data objectForKey:@"teamMemberList"]) {
                JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            //拒绝或者同意的成员
            for (NSDictionary *dataDic in [data objectForKey:@"updateTeamMemeberList"]) {
                JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataUpDataArray addObject:model];
            }
            
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:@"失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else{
        return 55* screenWidth / 375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62 * screenWidth / 375;
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count;
    }
    else{
        return _dataUpDataArray.count;
    }
}
//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 5*ScreenWidth/375, ScreenWidth, 50*ScreenWidth/375)];
        view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        //        93 5
        UIView* viewLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 27*ScreenWidth/375, 93*ScreenWidth/375, 1*ScreenWidth/375)];
        viewLeft.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:viewLeft];
        
        UIView* viewRight = [[UIView alloc]initWithFrame:CGRectMake(screenWidth-93*ScreenWidth/375, 27*ScreenWidth/375, 93*ScreenWidth/375, 1*ScreenWidth/375)];
        viewRight.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:viewRight];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55*ScreenWidth/375)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"审批记录";
        label.textColor = [UIColor lightGrayColor];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        return view;
    }
    else{
        return nil;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLTeamAdviceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamAdviceTableViewCell" forIndexPath:indexPath];
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
        cell.iconImage.layer.masksToBounds = YES;
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.agreeBtn.tag = indexPath.row + 10000;
        [cell.disMissBtn addTarget:self action:@selector(disMissClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.disMissBtn.tag = indexPath.row + 100000;
        cell.stateLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
        return cell;
    }
    else{
        JGLTeamAdviceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamAdviceTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataUpDataArray[indexPath.row]];
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
        cell.iconImage.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agreeBtn.hidden = YES;
        cell.disMissBtn.hidden = YES;
        cell.stateLabel.textColor = [UITool colorWithHexString:@"#a0a0a0" alpha:1];
        if (![Helper isBlankString:[_dataUpDataArray[indexPath.row] createTime]]) {
            
            NSString* str = [[_dataUpDataArray[indexPath.row] createTime] substringToIndex:16];
            cell.timeLabel.text = str;
        }
        else{
            cell.timeLabel.text = @"暂无时间";
        }
        
        if ([[_dataUpDataArray[indexPath.row] joinState] integerValue] == 1) {
            cell.stateLabel.text = @"已同意";
            cell.stateLabel.textColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        }
        else if ([[_dataUpDataArray[indexPath.row] joinState] integerValue] == 2){
            cell.stateLabel.text = @"已拒绝";
            cell.stateLabel.textColor = [UITool colorWithHexString:@"e00000" alpha:1];
        }
        else{
            cell.stateLabel.text = @"仍未审核";
            cell.stateLabel.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }
}

-(void)agreeClick:(UIButton *)btn
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_dataArray[btn.tag - 10000] teamKey] forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[_dataArray[btn.tag - 10000] timeKey] forKey:@"memberKey"];
    [dict setObject:@1 forKey:@"state"];
    [[JsonHttp jsonHttp]httpRequest:@"team/auditTeamMember" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if (_dataArray.count != 0) {
                [_dataArray removeObjectAtIndex:btn.tag - 10000];
            }
            [_tableView reloadData];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        
    }];
}
-(void)disMissClick:(UIButton *)btn
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_dataArray[btn.tag - 100000] teamKey] forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[_dataArray[btn.tag - 100000] timeKey] forKey:@"memberKey"];
    [dict setObject:@2 forKey:@"state"];
    [[JsonHttp jsonHttp]httpRequest:@"team/auditTeamMember" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([data objectForKey:@"packSuccess"]) {
            if (_dataArray.count != 0) {
                [_dataArray removeObjectAtIndex:btn.tag - 100000];
            }
            [_tableView reloadData];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
