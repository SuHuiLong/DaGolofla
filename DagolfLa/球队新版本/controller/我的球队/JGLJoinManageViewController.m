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
@interface JGLJoinManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@end

@implementation JGLJoinManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    self.title = @"我的球队";
    [self uiConfig];
    
    
}

-(void) uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.rowHeight = 83 * screenWidth / 320;
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
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dataDic in [data objectForKey:@"teamMemberList"]) {
                JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                if ([model.state integerValue] != 2) {
                    [_dataArray addObject:model];
                }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*ScreenWidth/320;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGLTeamAdviceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamAdviceTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
    cell.iconImage.layer.masksToBounds = YES;
    [cell showData:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeBtn.tag = indexPath.row + 10000;
    [cell.disMissBtn addTarget:self action:@selector(disMissClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.disMissBtn.tag = indexPath.row + 100000;
    return cell;
    
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
        if ([data objectForKey:@"packSuccess"]) {
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
