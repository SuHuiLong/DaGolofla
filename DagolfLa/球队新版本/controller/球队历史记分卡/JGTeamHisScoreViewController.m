//
//  JGDHistoryScoreViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamHisScoreViewController.h"
#import "JGTeamHIsScoreTableViewCell.h"
#import "JGDHistoryScoreModel.h"
#import "JGDNotActivityHisCoreViewController.h"
#import "JGHScoresViewController.h"


#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "JGHRetrieveScoreViewController.h" // 取回记分
#import "JGDHistoryScoreShowViewController.h"
#import "JGTeamDeatilWKwebViewController.h"

#import "JGLScoreRankViewController.h"


@interface JGTeamHisScoreViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JGTeamHisScoreViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    //    leftBar.tintColor = [UIColor whiteColor];
    //    self.navigationItem.leftBarButtonItem = leftBar;
    self.searchController.searchBar.hidden = NO;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球队历史记分卡";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self createTableView];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"成绩总览" style:(UIBarButtonItemStyleDone) target:self action:@selector(takeCode)];
    rightBar.tintColor = [UIColor whiteColor];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    

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
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JGTeamHIsScoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self createGuidedView:YES];
}

- (void)createGuidedView:(BOOL)isHaveData{
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,isHaveData ? 0 : (screenHeight - 200 * ProportionAdapter), screenWidth, 100 * ProportionAdapter)];
    
    UILabel *oneLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    oneLable.text = @"纸质记分如何导入系统？";
    oneLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    oneLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    oneLable.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:oneLable];
    
    UILabel *twoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    twoLable.text = @"我们提供了PC端导入工具、excel成绩表一键导入！";
    twoLable.textAlignment = NSTextAlignmentCenter;
    twoLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    twoLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [footView addSubview:twoLable];
    
    UILabel *threeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
    threeLable.text = @"PC端登录地址：http://keeper.dagolfla.com";
    threeLable.textColor = [UIColor colorWithHexString:Ba0_Color];
    //    self.baseLabel.text = [NSString stringWithFormat:@"用户本人线上支付-%.2f", price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:threeLable.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:B31_Color] range:NSMakeRange(8, threeLable.text.length-8)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    threeLable.attributedText = attributedString;
    
    threeLable.textAlignment = NSTextAlignmentCenter;
    threeLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    [footView addSubview:threeLable];
    
    if (isHaveData) {
        self.tableView.tableFooterView = footView;
    }else{
        [self.view addSubview: footView];
    }
}

#pragma mark ----- 成绩总览
- (void)takeCode{
    if (self.isTeamMem == NO) {
        [[ShowHUD showHUD]showToastWithText:@"您还不是该球队成员" FromView:self.view];
    }else{
        //成绩总览
        JGTeamDeatilWKwebViewController * VC = [[JGTeamDeatilWKwebViewController alloc] init];
        //    VC.timeKey = @33160;
        VC.isScoreAll = YES;
        VC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/teamYearScoreOverview.html?userKey=%@&teamKey=%@",DEFAULF_USERID,_teamKey];
        VC.title = @"成绩总览";
        VC.teamKey = [_teamKey integerValue];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArray count] > indexPath.row) {
        JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
        if ([model.srcType integerValue] == 0) {
            
            if (indexPath.row == 0) {
                JGTeamHIsScoreTableViewCell *cell = [[JGTeamHIsScoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"123"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lineLimageV.frame = CGRectMake(90 * ProportionAdapter, 25 * ProportionAdapter, 2 * ProportionAdapter, 40 * ProportionAdapter);
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }else{
                JGTeamHIsScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }
        }else{
            
            if (indexPath.row == 0) {
                JGTeamHIsScoreTableViewCell *cell = [[JGTeamHIsScoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"123"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lineLimageV.frame = CGRectMake(90 * ProportionAdapter, 35 * ProportionAdapter, 2 * ProportionAdapter, 50 * ProportionAdapter);
                if ([self.dataArray count] > indexPath.row) {
                    cell.model = self.dataArray[indexPath.row];
                }
                return cell;
            }else{
                JGTeamHIsScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    [dic setObject:self.teamKey forKey:@"teamKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%@dagolfla.com", DEFAULF_USERID, self.teamKey]] forKey:@"md5"];
    [dic setObject:@"" forKey:@"likeStr"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getTeamActivityHistoryList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
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
                    [self.view addSubview:imageV];
                    
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 251 * ProportionAdapter, 300 * ProportionAdapter, 30 * ProportionAdapter)];
                    label1.text = @"您的球队还没有成绩记录哦";
                    label1.textAlignment = NSTextAlignmentCenter;
                    label1.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
                    label1.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                    [self.view addSubview:label1];

                    [self createGuidedView:NO];

                    //                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 311 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 80 * ProportionAdapter)];
                    //                    label2.text = @"您所有的记分都会保留在此，点击右上角“取回记分”，可通过“秘钥”取回别人给你代记的成绩。";
                    //                    label2.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                    //                    label2.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                    //                    label2.numberOfLines = 0;
                    //                    [self.view addSubview:label2];
                    
                    [self.tableView removeFromSuperview];
                }
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
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
    [dic setObject:self.teamKey forKey:@"teamKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%@dagolfla.com", DEFAULF_USERID, self.teamKey]] forKey:@"md5"];
    [dic setObject:[self.searchController.searchBar text] forKey:@"likeStr"];
    
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getTeamActivityHistoryList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
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
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        [self.tableView reloadData];
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isTeamMem == NO) {
        [[ShowHUD showHUD]showToastWithText:@"您还不是该球队成员" FromView:self.view];
    }else{
        JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
        
        JGLScoreRankViewController *rankVC = [[JGLScoreRankViewController alloc] init];
        rankVC.teamKey = self.teamKey;
        rankVC.activity = [NSNumber numberWithInteger:[model.teamActivityKey integerValue]];
        
        [self.navigationController pushViewController:rankVC animated:YES];
    }
    

    
//
//    if ([model.scoreFinish integerValue] == 0) {
//        JGHScoresViewController *scoreVC = [[JGHScoresViewController alloc] init];
//        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
//        if ([userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]) {
//            scoreVC.currentPage = [[userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]] integerValue];
//        }
//        NSLog(@"%@", [userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]);
//        scoreVC.scorekey = [NSString stringWithFormat:@"%@", model.timeKey];
//        [self.navigationController pushViewController:scoreVC animated:YES];
//    }else{
//        
//        if ([model.srcType integerValue] == 0) {
//            
//            JGDNotActivityHisCoreViewController *notAciVC = [[JGDNotActivityHisCoreViewController alloc] init];
//            notAciVC.timeKey = model.timeKey;
//            [self.navigationController pushViewController:notAciVC animated:YES];
//            
//        }else{
//            
//            JGDHistoryScoreShowViewController *showVC = [[JGDHistoryScoreShowViewController alloc] init];
//            showVC.timeKey = model.timeKey;
//            [self.navigationController pushViewController:showVC animated:YES];
//        }
//    }
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    JGDHistoryScoreModel *model = self.dataArray[indexPath.row];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    if ([model.scoreFinish integerValue] == 2) {
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"该记分卡由%@代记，是否删除", model.scoreUserName] preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [alert dismissViewControllerAnimated:YES completion:nil];
//            
//        }];
//        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [dic setValue:DEFAULF_USERID forKey:@"userKey"];
//            [dic setValue:model.timeKey forKey:@"scoreKey"];
//            
//            [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/deleteScore" JsonKey:nil withData:dic failedBlock:^(id errType) {
//                
//            } completionBlock:^(id data) {
//                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//                    [self.dataArray removeObjectAtIndex:indexPath.row];
//                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
//                    
//                }else{
//                    if ([data objectForKey:@"packResultMsg"]) {
//                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//                    }
//                }
//            }];
//        }];
//        
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }else{
//        
//        [dic setValue:DEFAULF_USERID forKey:@"userKey"];
//        [dic setValue:model.timeKey forKey:@"scoreKey"];
//        
//        [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/deleteScore" JsonKey:nil withData:dic failedBlock:^(id errType) {
//            
//        } completionBlock:^(id data) {
//            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//                [self.dataArray removeObjectAtIndex:indexPath.row];
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
//                
//            }else{
//                if ([data objectForKey:@"packResultMsg"]) {
//                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//                }
//            }
//        }];
//    }
//    
//}

- (void)backBtn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
