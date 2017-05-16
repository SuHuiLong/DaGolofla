//
//  NewsDetailController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/30.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "NewsDetailController.h"
#import "NewsDetailViewCell.h"
#import "NewsDetailModel.h"

#import "ChatDetailViewController.h"

//#import "YueDetailViewController.h"
//#import "PostDetailViewController.h"
//#import "TeamDeMessViewController.h"
//#import "ManageDetailController.h"
//#import "TeamActiveDeController.h"

@interface NewsDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem* _rightBtn;
    UITableView *_tableView;

    NSMutableArray* _dataArray;
    //表头视图
    UIView* _viewBase;
    //视图上按钮
    UIButton* _btnDel;
    
    NSMutableDictionary *_deleteDic;
    
    NSMutableDictionary* _dict;
    
    NSInteger _page;
}
@end

@implementation NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _page = 1;
    //    //右边按钮
    _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(removeAllClick)];
    _rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _rightBtn;
    
    _messType = @0;
    _indexType = 0;
    _dict = [[NSMutableDictionary alloc]init];
    [_dict setValue:[NSNumber numberWithInteger:_indexType] forKey:@"messType"],
    
    //创建视图
    [self uiConfig];

}
//导航栏上清空按钮
-(void)removeAllClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定清空所有信息，删除后无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        if (_dataArray.count == 0) {
            return;
        }else{
            NewsDetailModel* model = _dataArray[0];
            [_dict setValue:model.mId forKey:@"mId"];
            [_dict setValue:@0 forKey:@"type"];
            [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        }
        
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/delete.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                [_dataArray removeAllObjects];
                [_tableView reloadData];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failed:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
        }];
    }
}

-(void)uiConfig
{
    _dataArray = [[NSMutableArray alloc]init];
    //_dataArray = @[@"信息0",@"信息1",@"信息2",@"信息3"];
    _deleteDic = [[NSMutableDictionary alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-15*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsDetailViewCell" bundle:nil] forCellReuseIdentifier:@"NewsDetailViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.mj_header beginRefreshing];
}
#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    if (_indexType == 0) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [dict setObject:@10 forKey:@"rows"];
        [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybySystem.do" parameter:dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                if (page == 1)[_dataArray removeAllObjects];
                for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                    //NSLog(@"%@",[dict objectForKey:@"rows"]);
                    NewsDetailModel *model = [[NewsDetailModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [_dataArray addObject:model];
                }
                _page++;
                [_tableView reloadData];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            if (isReshing) {
                [_tableView.mj_header endRefreshing];
            }else {
                [_tableView.mj_footer endRefreshing];
            }
        } failed:^(NSError *error) {
            if (isReshing) {
                [_tableView.mj_header endRefreshing];
            }else {
                [_tableView.mj_footer endRefreshing];
            }
        }];

    }
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}

/**
 *  点击编辑后展示的删除按钮
 */
-(void)deleteClick
{
    [_dataArray removeObjectsInArray:[_deleteDic allKeys]];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[_deleteDic allValues]] withRowAnimation:UITableViewRowAnimationFade];
    [_deleteDic removeAllObjects];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_indexType == 0) {
        NewsDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailViewCell" forIndexPath:indexPath];
        cell.tintColor = [UIColor greenColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showData:_dataArray[indexPath.row]];
        return cell;
//    }
//    else
//    {
//        NewsDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailViewCell" forIndexPath:indexPath];
//        cell.tintColor = [UIColor greenColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell showPeople:_dataArray[indexPath.row]];
//        return cell;
//    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NewsDetailModel* model = _dataArray[indexPath.row];
        [_dict setValue:model.mId forKey:@"mId"];
        [_dict setValue:@1 forKey:@"type"];
        [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/delete.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                [_dataArray removeObjectAtIndex:indexPath.row];
                //         Delete the row from the data source.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failed:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //系统消息
    if ([[_dataArray[indexPath.row] messObjid] integerValue] == 0) {
        
    }
    else
    {
        
    }
}


@end
