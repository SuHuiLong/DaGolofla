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

#import "JGAddFriendViewController.h"


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
    
    if (_fromWitchVC == 1) {
        self.title = @"推荐球友";
        
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"下一批" style:(UIBarButtonItemStyleDone) target:self action:@selector(nextFriend)];
        rightBar.tintColor = [UIColor whiteColor];
        [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];

        self.navigationItem.rightBarButtonItem = rightBar;
        
    }else{
        self.title = @"新朋友";

    }
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    [self uiConfig];
    
}

- (void)nextFriend{
    [self downLoawdDataWithRecommend];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[NewFriendTableViewCell class] forCellReuseIdentifier:@"NewFriendTableViewCell"];
    
    if (_fromWitchVC == 2) {
        [self downLoawdDataWithNewFriend];
        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    }else{
        
        [self downLoawdDataWithRecommend];
//        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//        [_tableView.header beginRefreshing];

    }
}


// 新朋友
- (void)downLoawdDataWithNewFriend{
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com",DEFAULF_USERID]] forKey:@"md5"];
    
    
    
    [[JsonHttp jsonHttp] httpRequest:@"userFriend/getUserNewFriendList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                
                [_dataArray removeAllObjects];
                
                for (NSDictionary *dataDict in [data objectForKey:@"list"]) {
                    NewFriendModel *model = [[NewFriendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [_dataArray addObject:model];
                }
                [_tableView reloadData];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];
    
}


// 推荐好友	recommend

- (void)downLoawdDataWithRecommend{
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com",DEFAULF_USERID]] forKey:@"md5"];
    [dic setObject:@(_page) forKey:@"offset"];
    
    [[JsonHttp jsonHttp] httpRequest:@"userFriend/getRecommendFriendList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                _page ++;
                [_dataArray removeAllObjects];
                
                for (NSDictionary *dataDict in [data objectForKey:@"list"]) {
                    NewFriendModel *model = [[NewFriendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [_dataArray addObject:model];
                }
                [_tableView reloadData];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ProportionAdapter;
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
    
    if (_fromWitchVC == 1) {
        [cell showData:_dataArray[indexPath.row]];
        [cell.btnFocus addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [cell exhibitionData:_dataArray[indexPath.row]]; // 新朋友
        [cell.btnFocus addTarget:self action:@selector(selfDetClick:event:) forControlEvents:UIControlEventTouchUpInside];

    }
    cell.btnIcon.tag = indexPath.row + 10000;
    
    cell.btnFocus.tag = indexPath.row + 100000;
    return cell;
}

-(void)selfDetClick:(UIButton *)btn event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[_dataArray[indexPath.row] timeKey] forKey:@"userFriendKey"];
    [dic setValue:@1 forKey:@"state"];
    [[ShowHUD showHUD] showAnimationWithText:@"添加中…" FromView:self.view];

    [[JsonHttp jsonHttp] httpRequestWithMD5:@"userFriend/doApplyHandle" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"添加成功"];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    


}


// 添加球友
- (void)cellBtnClicked:(id)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    
    if (_fromWitchVC == 1) {
        JGAddFriendViewController *addFriVC = [[JGAddFriendViewController alloc] init];
        addFriVC.otherUserKey = [_dataArray[indexPath.row] userId];
        addFriVC.popToVC = ^(NSInteger num){
            if (num == 1) {
                [_dataArray removeObjectAtIndex:indexPath.row];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            }
        };
        [self.navigationController pushViewController:addFriVC animated:YES];
    }
    
    
    if (indexPath!= nil)
    {
        // do something
    }
}


-(void)focusClick:(UIButton *)btn
{
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":[_dataArray[btn.tag - 100000] userId]} success:^(id respondsData) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            NewFriendTableViewCell* cell = (NewFriendTableViewCell* )[[btn superview] superview];
            NSLog(@"%@", cell);
        }
        else
        {
            [LQProgressHud showMessage:@"添加失败，请稍后再试"];
        }
    } failed:^(NSError *error) {
        [LQProgressHud showMessage:@"添加失败，请稍后再试"];
        
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
