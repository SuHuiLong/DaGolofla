//
//  HistoryViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "HistoryViewController.h"

#import "HistoryHeadTableViewCell.h"
#import "HistoryLeftTableViewCell.h"
#import "HistoryRightTableViewCell.h"
#import "ScoredCardViewController.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "ScoreCardModel.h"
#import "MBProgressHUD.h"

#import "UITool.h"
@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    NSInteger _page;
    
    MBProgressHUD* _progressHud;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记分卡";
    _dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
    [self uiConfig];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重写返回按钮，需要一个提示，确定是否返回
    UIBarButtonItem *leftBtn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(hisBackClick)];
    leftBtn1.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBtn1;
    self.view.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
    
}

-(void)hisBackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)uiConfig
{
    
    _page = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-16*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
    [_tableView registerClass:[HistoryHeadTableViewCell class] forCellReuseIdentifier:@"HistoryHeadTableViewCell"];
    [_tableView registerClass:[HistoryLeftTableViewCell class] forCellReuseIdentifier:@"HistoryLeftTableViewCell"];
    [_tableView registerClass:[HistoryRightTableViewCell class] forCellReuseIdentifier:@"HistoryRightTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
    
    //给cell加长按手势
    UILongPressGestureRecognizer* gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration = 1;
    [_tableView addGestureRecognizer:gestureLongPress];
    
}

- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSInteger focusRow;
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:_tableView];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
        }else{
            focusRow = [indexPath row];
            
            
            //
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"删除记分卡后无法找回,是否确认删除" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            UIAlertAction* action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _progressHud=[[MBProgressHUD alloc] initWithView:self.view];
                _progressHud.mode=MBProgressHUDModeIndeterminate;
                _progressHud.labelText=@"删除中...";
                [self.view addSubview:_progressHud];
                [_progressHud show:YES];
                
                
                //删除操作
                [[PostDataRequest sharedInstance] postDataRequest:@"score/delete.do" parameter:@{@"ids":[_dataArray[indexPath.row-1] scoreId]} success:^(id respondsData) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([[dict objectForKey:@"success"]integerValue] == 1) {
                        //刷新单行
//                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:focusRow inSection:0];
//                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [_dataArray removeObjectAtIndex:focusRow-1];
                        [_tableView reloadData];
                        
                        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:@"scoreObjectTitle"];
                        [user removeObjectForKey:@"scoreballName"];
                        [user removeObjectForKey:@"scoreSite0"];
                        [user removeObjectForKey:@"scoreSite1"];
                        [user removeObjectForKey:@"scoreType"];
                        [user removeObjectForKey:@"scoreTTaiwan"];
                        [user removeObjectForKey:@"scoreObjectId"];
                        [user removeObjectForKey:@"scoreballId"];
                        [user synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];

            }];
            [alert addAction:action1];
            [alert addAction:action2];

        }
    }
}



#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"] forKey:@"userMobile"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"score/queryByList.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ScoreCardModel *model = [[ScoreCardModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];     
            }
            _page++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [_tableView reloadData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ////NSLog(@"%ld",_dataArray.count);
    return _dataArray.count == 0 ? 1 : _dataArray.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80*ScreenWidth/375;
    if (indexPath.row == 0) {
        height = 44*ScreenWidth/375;
    }
    else
    {
        height = 80*ScreenWidth/375;
    }
    
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataArray.count != 0) {
        if (indexPath.row == 0) {
            HistoryHeadTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"HistoryHeadTableViewCell" forIndexPath:indexPath];
            cellid.selectionStyle = UITableViewCellSelectionStyleNone;
            cellid.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            cellid.label.hidden = YES;
            cellid.imgvYuan.hidden = NO;
            cellid.line.hidden = NO;
            [cellid width];
            _tableView.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            return cellid;
        }
        else if (indexPath.row%2 == 0)
        {
            HistoryLeftTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryLeftTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            [cell showData:_dataArray[indexPath.row - 1]];
            _tableView.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            return cell;
        }
        else
        {
            HistoryRightTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"HistoryRightTableViewCell" forIndexPath:indexPath];
            cellid.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            cellid.selectionStyle = UITableViewCellSelectionStyleNone;
            [cellid showData:_dataArray[indexPath.row - 1]];
            _tableView.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
            return cellid;
            
        }
    }
    else
    {
        HistoryHeadTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"HistoryHeadTableViewCell" forIndexPath:indexPath];
        cellid.selectionStyle = UITableViewCellSelectionStyleNone;
        cellid.backgroundColor = [UITool colorWithHexString:@"3b3f42" alpha:1];
        cellid.imageView.hidden = YES;
        cellid.line.hidden = YES;
        cellid.imgvYuan.hidden = YES;
        cellid.label.hidden = YES;
        return cellid;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        ScoredCardViewController* scVc = [[ScoredCardViewController alloc]init];
        scVc.model = _dataArray[indexPath.row-1];
        [self.navigationController pushViewController:scVc animated:YES];
    }
}

@end
