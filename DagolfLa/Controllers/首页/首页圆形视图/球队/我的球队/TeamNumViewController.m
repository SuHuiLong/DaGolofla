//
//  TeamNumViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamNumViewController.h"
#import "ZanNumTableViewCell.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "TeamPeopleModel.h"

#import "UITableViewRowAction+JZExtension.h"

@interface TeamNumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _arrayNum;
    
    NSMutableArray* _dataArray;
    
    NSInteger _page;
}
@end

@implementation TeamNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队成员";
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ZanNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZanNumTableViewCell"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/queryByUserList.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10,@"type":@10,@"teamId":_teamId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamPeopleModel *model = [[TeamPeopleModel alloc] init];
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        if ([_isExit integerValue] == 1) {
            //设置队长
            void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                //        [self setEditing:false animated:true];
                //        ////NSLog(@"%ld",)
                if ([_teamStatus integerValue] == 1) {
                    //NSLog(@"%@",_teamId);
                    [[PostDataRequest sharedInstance]postDataRequest:@"tTeamApply/updateRole.do" parameter:@{@"teamType":@10,@"teamTeamId":_teamId,@"teamfrindUser":[_dataArray[indexPath.row] userId],@"context":@"您已被设定为球队队长",@"userId":[_dataArray[indexPath.row]userId],@"userIds":@0,@"teamRoleType":@2,@"isexit":@0} success:^(id respondsData) {
                        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[dict objectForKey:@"success"]integerValue] == 1) {
                            if ([_teamType integerValue] != 10) {
                                
                                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlockCancle:^{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                } withBlockSure:^{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                } withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                                
                            }
                            else
                            {
                                _callBackNumber();
                            }
                            
                            
                        }
                        else
                        {
                            [Helper alertViewNoHaveCancleWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                        }
                    } failed:^(NSError *error) {
                        
                    }];
                }
                else
                {
                    [Helper alertViewNoHaveCancleWithTitle:@"您已经是队长了" withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                
            };
            
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为队长" handler:rowActionHandler];
            action1.enabled = YES;
            return @[action1];
        }
        else
        {
            //如果是队长
            if ([_teamStatus integerValue] == 1) {
                //删除成员
                void(^rowActionHandler1)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    
                    [Helper alertViewWithTitle:@"是否删除此成员?" withBlockCancle:^{
                        
                    } withBlockSure:^{
                        
                        //USERID I系统发出的为0
                        [[PostDataRequest sharedInstance]postDataRequest:@"tTeamApply/deleteUser.do" parameter:@{@"teamUserId":[_dataArray[indexPath.row] teamUserId],@"teamType":@10,@"teamTeamId ":_teamId,@"teamfrindUser":[_dataArray[indexPath.row] userId],@"context":@"您已被从球队中移出",@"userId":@0} success:^(id respondsData) {
                            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            if ([[dict objectForKey:@"success"]integerValue] == 1) {
                                //                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                //                        [alert show];
                                [_tableView.header endRefreshing];
                                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
                                [_tableView.header beginRefreshing];
                                [Helper alertViewNoHaveCancleWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                            else
                            {
                                [Helper alertViewNoHaveCancleWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                        
                        
                    } withBlock:^(UIAlertController *alertView) {
                        
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                    
                };
                //设置管理员
                void(^rowActionHandler2)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    //        [self setEditing:false animated:true];
                    //        ////NSLog(@"%ld",)
                    if ([[_dataArray[indexPath.row] teamRoleType] integerValue] == 0) {
                        [[PostDataRequest sharedInstance]postDataRequest:@"tTeamApply/updateRole.do" parameter:@{@"teamType":@10,@"teamTeamId":_teamId,@"teamfrindUser":[_dataArray[indexPath.row] userId],@"context":@"您已被队长设置为管理员",@"userId":[_dataArray[indexPath.row]userId],@"userIds":@0,@"teamRoleType":@1} success:^(id respondsData) {
                            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            if ([[dict objectForKey:@"success"]integerValue] == 1) {
                                
                                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlockCancle:^{
                                    //                                [self.navigationController popToRootViewControllerAnimated:YES];
                                } withBlockSure:^{
                                    //                                [self.navigationController popToRootViewControllerAnimated:YES];
                                } withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                            else
                            {
                                [Helper alertViewNoHaveCancleWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                    else
                    {
                        [Helper alertViewNoHaveCancleWithTitle:@"他已经是管理员了,无需再次设置" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                };
                //设置队长
                void(^rowActionHandler3)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    //        [self setEditing:false animated:true];
                    //        ////NSLog(@"%ld",)
                    if ([_teamStatus integerValue] == 1) {
                        //                        //NSLog(@"%@",_teamId);
                        [[PostDataRequest sharedInstance]postDataRequest:@"tTeamApply/updateRole.do" parameter:@{@"teamType":@10,@"teamTeamId":_teamId,@"teamfrindUser":[_dataArray[indexPath.row] userId],@"context":@"您已被设定为球队队长",@"userId":[_dataArray[indexPath.row]userId],@"userIds":@0,@"teamRoleType":@2,@"isexit":@0} success:^(id respondsData) {
                            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            if ([[dict objectForKey:@"success"]integerValue] == 1) {
                                if ([_teamType integerValue] != 10) {
                                    
                                    [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlockCancle:^{
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    } withBlockSure:^{
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    } withBlock:^(UIAlertController *alertView) {
                                        [self presentViewController:alertView animated:YES completion:nil];
                                    }];
                                    
                                }
                                else
                                {
                                    _callBackNumber();
                                }
                                
                                
                            }
                            else
                            {
                                [Helper alertViewNoHaveCancleWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                    else
                    {
                        [Helper alertViewNoHaveCancleWithTitle:@"您已经是队长了" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                    
                };
                
                UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除成员" handler:rowActionHandler1];
                action1.enabled = YES;
                UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"管理员" handler:rowActionHandler2];
                action2.enabled = YES;
                action2.backgroundColor = [UIColor orangeColor];
                UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"队长" handler:rowActionHandler3];
                action3.enabled = YES;
                return @[action1,action2,action3];
            }
            else
            {
                //删除成员
                void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    //        [self setEditing:false animated:true];
                    //        ////NSLog(@"%ld",)
                    
                };
                
                UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除成员" handler:rowActionHandler];
                action1.enabled = YES;
                return @[action1];
                
            }
        }
    }
    else
    {
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZanNumTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"ZanNumTableViewCell" forIndexPath:indexPath];
    [cellid showTeamPeopleData:_dataArray[indexPath.row]];
    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellid;
}


@end
