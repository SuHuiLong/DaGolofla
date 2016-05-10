//
//  NewFriendViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NewFriendTableViewCell.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "NewFriendModel.h"
#import "PersonHomeController.h"
#import "ChatDetailViewController.h"

@interface NewFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新朋友";
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    [self uiConfig];
    
}
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[NewFriendTableViewCell class] forCellReuseIdentifier:@"NewFriendTableViewCell"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querbyUserFollowList.do" parameter:@{@"userId":@0,@"otherUserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                NewFriendModel *model = [[NewFriendModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page ++;
            [_tableView reloadData];
        }else {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
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
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewFriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriendTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataArray[indexPath.row]];
    cell.btnIcon.tag = indexPath.row + 10000;
    [cell.btnIcon addTarget:self action:@selector(selfDetClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnFocus.tag = indexPath.row + 100000;
    [cell.btnFocus addTarget:self action:@selector(focusClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)selfDetClick:(UIButton *)btn
{
    PersonHomeController *selfVC = [[PersonHomeController alloc] init];
    selfVC.strMoodId = [_dataArray[btn.tag - 10000] userId];
    [self.navigationController pushViewController:selfVC animated:YES];
}


-(void)focusClick:(UIButton *)btn
{
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":[_dataArray[btn.tag - 100000] userId]} success:^(id respondsData) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 166/255,166/255,166/255, 1 });
            [btn.layer setBorderColor:colorref];//边框颜色

            btn.userInteractionEnabled = NO;
        }
        else
        {
            [Helper alertViewWithTitle:@"关注好友成功" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }
    } failed:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] userId]];
    //设置对方的名字
    //    vc.userName = model.conversationTitle;
    //设置聊天标题
    vc.title = [_dataArray[indexPath.row] userName];
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];
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
