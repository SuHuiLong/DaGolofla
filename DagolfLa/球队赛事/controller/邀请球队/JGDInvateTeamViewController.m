//
//  JGDInvateTeamViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDInvateTeamViewController.h"

#import "JGDInviteTableViewCell.h"
#import "JGTeamDetail.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGDInvateTeamViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *localDataArray;

@property (nonatomic, copy) NSString *likeSting;

@end

@implementation JGDInvateTeamViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    self.title = @"邀请球队";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self createTableView];
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(commitAct)];
    rightBar.tintColor = [UIColor whiteColor];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    // Do any additional setup after loading the view.
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 50.0 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//    self.tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
//    [self.tableView.header beginRefreshing];
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defCell"];
    [self.tableView registerClass:[JGDInviteTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


#pragma mark ----- 完成

- (void)commitAct{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (JGTeamDetail *model in self.localDataArray) {
        [array addObject:[NSNumber numberWithInteger:model.timeKey]];
    }
    [dic setObject:array forKey:@"invitationTeamKeyList"];
    [dic setObject:self.matchKey forKey:@"matchKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];

    [[JsonHttp jsonHttp] httpRequestWithMD5:@"match/doInvitationTeam" JsonKey:nil withData:dic failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];

    } completionBlock:^(id data) {
       
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
          
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
        return [self.dataArray count];
    }else{
        return [self.localDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchController.active) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"defCell"];
        JGTeamDetail *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else{
        JGDInviteTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        JGTeamDetail *model = self.localDataArray[indexPath.row];
        cell.teamNameLB.text = model.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.removeButton addTarget:self action:@selector(removeAct:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
    
}

- (void)removeAct:(UIButton *)button{
    
    JGDInviteTableViewCell *cell = (JGDInviteTableViewCell *)[[button superview] superview];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    [self.localDataArray removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45 * ProportionAdapter;
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
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getSearchTeamList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"teamList"]) {
                if (_page == 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dic in [data objectForKey:@"teamList"]) {
                    JGTeamDetail *model = [[JGTeamDetail alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                _page ++;
            }else{

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
    [self.tableView reloadData];
    _page = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [dic setObject:searchBar.text forKey:@"likeName"];
    self.likeSting = searchBar.text;
    [[JsonHttp jsonHttp] httpRequest:@"team/getSearchTeamList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"teamList"]) {
                if (_page == 0) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dic in [data objectForKey:@"teamList"]) {
                    JGTeamDetail *model = [[JGTeamDetail alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                _page ++;
            }else{
                
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
    
    if (self.searchController.active) {
        [self.searchController setActive:NO];
        NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:[self.localDataArray count] inSection:0];
        [self.localDataArray addObject:self.dataArray[indexPath.row]];
        [self.tableView insertRowsAtIndexPaths:@[addIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)localDataArray{
    if (!_localDataArray) {
        _localDataArray = [[NSMutableArray alloc] init];
    }
    return _localDataArray;
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
