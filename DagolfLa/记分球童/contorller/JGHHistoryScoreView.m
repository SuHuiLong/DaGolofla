//
//  JGHHistoryScoreView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHHistoryScoreView.h"
#import "JGDHistoryScoreTableViewCell.h"
#import "JGDHistoryScore2TableViewCell.h"

@interface JGHHistoryScoreView ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JGHHistoryScoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        
        [self createTableView];
        
    }
    return self;
}

- (void)createTableView{
    //x
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0 * ProportionAdapter);
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.searchController.searchBar.placeholder = @"搜索你需要的内容";
    self.searchController.searchBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.tableView.header beginRefreshing];
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[JGDHistoryScoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[JGDHistoryScore2TableViewCell class] forCellReuseIdentifier:@"cell2"];
    
}


//#pragma mark ----- 取回记分／成绩总览
//
//- (void)takeMyCode{
//    
//    JGHRetrieveScoreViewController *retriveveVC = [[JGHRetrieveScoreViewController alloc] init];
//    [self.navigationController pushViewController:retriveveVC animated:YES];
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArray count] > indexPath.row) {
        JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
        if ([model.srcType integerValue] == 0) {
            
            if (indexPath.row == 0) {
                JGDHistoryScore2TableViewCell *cell = [[JGDHistoryScore2TableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"123"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lineLimageV.frame = CGRectMake(90 * ProportionAdapter, 25 * ProportionAdapter, 2 * ProportionAdapter, 40 * ProportionAdapter);
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }else{
                JGDHistoryScore2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }
        }else{
            
            if (indexPath.row == 0) {
                JGDHistoryScoreTableViewCell *cell = [[JGDHistoryScoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"123"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lineLimageV.frame = CGRectMake(90 * ProportionAdapter, 35 * ProportionAdapter, 2 * ProportionAdapter, 50 * ProportionAdapter);
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }else{
                JGDHistoryScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }
        }
    }else{
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
    
    if ([model.srcType integerValue] == 0) {
        return 65 * ProportionAdapter;
    }else{
        return 85 * ProportionAdapter;
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
}


#pragma mark 开始进入刷新状态

- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page ];
}

- (void)footRereshing
{
    [self downLoadData:_page];
}

- (void)downLoadData:(NSInteger)page {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"offset"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [dic setObject:@"" forKey:@"likeStr"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getScoreHistory" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                if (_page == 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDHistoryScoreModel *model = [[JGDHistoryScoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                _page ++;
            }else{
                
                if (_page == 0) {
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 105 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
                    imageV.image = [UIImage imageNamed:@"bg-shy"];
                    [self addSubview:imageV];
                    
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100 * ProportionAdapter, 251 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
                    label1.text = @"您还没有记分记录哦";
                    label1.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
                    label1.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                    [self addSubview:label1];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 311 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 80 * ProportionAdapter)];
                    label2.text = @"您所有的记分都会保留在此，点击右上角“取回记分”，可通过“秘钥”取回别人给你代记的成绩。";
                    label2.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                    label2.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                    label2.numberOfLines = 0;
                    [self addSubview:label2];
                    
                    [self.tableView removeFromSuperview];
                }
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
            }
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        [self.tableView reloadData];
        
    }];
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.dataArray removeAllObjects];
    _page = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[self.searchController.searchBar text] forKey:@"likeStr"];
    
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getScoreHistory" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                if (_page == 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDHistoryScoreModel *model = [[JGDHistoryScoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                _page ++;
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
            }
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        [self.tableView reloadData];
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
    _blockSelectHistoryScore(model);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if ([model.scoreFinish integerValue] == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"该记分卡由%@代记，是否删除？", model.scoreUserName] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [dic setValue:DEFAULF_USERID forKey:@"userKey"];
            [dic setValue:model.timeKey forKey:@"scoreKey"];
            
            [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/deleteScore" JsonKey:nil withData:dic failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
                    
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
                    }
                }
            }];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
//        [self presentViewController:alert animated:YES completion:nil];
        _blockSelectHistoryScoreAlert(alert);
    }else{
        
        [dic setValue:DEFAULF_USERID forKey:@"userKey"];
        [dic setValue:model.timeKey forKey:@"scoreKey"];
        
        [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/deleteScore" JsonKey:nil withData:dic failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
                }
            }
        }];
    }
    
}

//- (void)backBtn{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
