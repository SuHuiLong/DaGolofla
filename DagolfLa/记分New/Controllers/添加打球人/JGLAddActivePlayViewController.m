//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddActivePlayViewController.h"
//#import "JGMenberTableViewCell.h"

#import "PYTableViewIndexManager.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "MyattenModel.h"
#import "NoteModel.h"
#import "NoteHandlle.h"

//#import "JGTeamMemberManager.h"
//#import "JGReturnMD5Str.h"
#import "JGLAddActiivePlayModel.h"
#import "JGLActiveAddPlayTableViewCell.h"
#import "JGLActiveChooseSTableViewCell.h"
@interface JGLAddActivePlayViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
    UITableView* _tableChoose;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    
    
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGLAddActivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择打球人";
    
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    _dataArray       = [[NSMutableArray alloc]init];
    if (_dataKey.count == 0) {
        _dataKey         = [[NSMutableArray alloc]init];
    }
    if (_dictFinish.count == 0) {
        _dictFinish      = [[NSMutableDictionary alloc]init];
    }
    if (_arrMobile.count == 0) {
        _arrMobile       = [[NSMutableArray alloc]init];
    }
    if (_dataUserKey.count == 0) {
        _dataUserKey     = [[NSMutableArray alloc]init];
    }
    if (_allMostArray.count == 0) {
        _allMostArray    = [[NSMutableArray alloc]init];
    }
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    [self uiConfig];
    //    [self createHeadSearch];
    [self createBtn];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
    [_tableView reloadData];
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)finishClick
{
    _blockSurePlayer(_dictFinish,_dataKey,_arrMobile,_dataUserKey,_allMostArray);
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)createHeadSearch
//{
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchResultsUpdater = self;
//    _searchController.searchBar.barTintColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
//    _searchController.dimsBackgroundDuringPresentation = NO;
//    _searchController.hidesNavigationBarDuringPresentation = NO;
//    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
//    _searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
//    _searchController.searchBar.placeholder = @"输入队友昵称搜索";
//    _tableView.tableHeaderView = _searchController.searchBar;
//    _searchController.searchBar.delegate = self;
//}
//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//
//}
//




-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375 - 40*4*screenWidth/375 - 54*screenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLActiveAddPlayTableViewCell class] forCellReuseIdentifier:@"JGLActiveAddPlayTableViewCell"];
    _tableView.tag = 1001;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
    _tableChoose = [[UITableView alloc]initWithFrame:CGRectMake(0, screenHeight -15*screenWidth/375 - 40*4*screenWidth/375 - 54*screenWidth/375 - 64, screenWidth, 40*4*screenWidth/375) style:UITableViewStylePlain];
    _tableChoose.delegate = self;
    _tableChoose.dataSource = self;
    _tableChoose.tag = 1002;
    [self.view addSubview:_tableChoose];
    [_tableChoose registerClass:[JGLActiveChooseSTableViewCell class] forCellReuseIdentifier:@"JGLActiveChooseSTableViewCell"];
    _tableChoose.scrollEnabled = NO;
    
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    //    [dict setObject:[NSNumber numberWithInteger:] forKey:@"activityKey"];
    [dict setObject:_model.timeKey forKey:@"activityKey"];
    [dict setObject:_model.userKey forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [dict setObject:_model.teamKey forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:[_model.teamKey integerValue] activityKey:[_model.timeKey integerValue] userKey:[_model.userKey integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if (_page == 0)
        {
            //清除数组数据  signUpInfoKey
            [_dataArray removeAllObjects];
        }
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //                [model setValue:[dict objectForKey:@"name"] forKey:@"userName"];
                model.userName = model.name;
                [_dataArray addObject:model];
            }
            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:_dataArray]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            [_tableView reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 1001 ? 50*ScreenWidth/375 : 40*ScreenWidth/375;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 1001 ?[self.listArray[section] count] : 4;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableView.tag == 1001 ?[self.listArray count] : 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1001) {
        if ([self.listArray[section] count] == 0) {
            return nil;
        }else{
            return self.keyArray[section];
        }
    }
    else{
        return nil;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1001) {
        JGLActiveAddPlayTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLActiveAddPlayTableViewCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JGLAddActiivePlayModel *model = self.listArray[indexPath.section][indexPath.row];
        cell.labelName.text = model.userName;
        [cell.imgvIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
        cell.imgvIcon.layer.cornerRadius = 6*screenWidth/375;
        cell.imgvIcon.layer.masksToBounds = YES;
        
        
        NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
        
        if ([Helper isBlankString:str]==NO) {
            cell.imgvState.image=[UIImage imageNamed:@"gou_x"];
        }else{
            cell.imgvState.image=[UIImage imageNamed:@"gou_w"];
        }
        
        return cell;
    }
    else{
        JGLActiveChooseSTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLActiveChooseSTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
            cell.imgvDel.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";
        }
        else{
            cell.labelTitle.font = [UIFont systemFontOfSize:14*screenWidth/375];
            cell.imgvDel.hidden = NO;
            
            if (_dataKey.count != 0) {
                if (_dataKey.count > indexPath.row - 1) {
                    if (![Helper isBlankString:_dataKey[indexPath.row-1]]) {
                        cell.labelTitle.text = [_dictFinish objectForKey:_dataKey[indexPath.row-1]];
                    }else{
                        cell.labelTitle.text = @"请添加打球人";
                    }
                }
                else{
                    cell.labelTitle.text = @"请添加打球人";
                }
            }
            else{
                cell.labelTitle.text = @"请添加打球人";
            }
            
        }
        return cell;
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1001) {
        
        NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
        //选择当前行，查询对应的name，如果为空加入字典，否则删除
        if ([Helper isBlankString:str]) {
            if (_dictFinish.count < 3) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] != [[self.listArray[indexPath.section][indexPath.row] userKey] integerValue]) {
                    [_dictFinish setObject:[self.listArray[indexPath.section][indexPath.row] userName] forKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
                    [_dataKey addObject:[self.listArray[indexPath.section][indexPath.row] timeKey]];
                    [_dataUserKey addObject:[self.listArray[indexPath.section][indexPath.row] userKey]];
                    [_allMostArray addObject:[self.listArray[indexPath.section][indexPath.row] almost]];
                    if (![Helper isBlankString:[self.listArray[indexPath.section][indexPath.row] mobile]]) {
                        [_arrMobile addObject:[self.listArray[indexPath.section][indexPath.row] mobile]];
                    }
                    else
                    {
                        [_arrMobile addObject:@"0"];
                    }
                }
                else{
                    [[ShowHUD showHUD]showToastWithText:@"您不能添加自己" FromView:self.view];
                }
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"您最多只能添加四个人一起打球" FromView:self.view];
            }
        }
        else{
            [_dictFinish removeObjectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
            [_dataKey removeObject:[self.listArray[indexPath.section][indexPath.row] timeKey]];
            [_dataUserKey removeObject:[self.listArray[indexPath.section][indexPath.row] userKey]];
            [_allMostArray removeObject:[self.listArray[indexPath.section][indexPath.row] almost]];
            [_arrMobile removeObject:[self.listArray[indexPath.section][indexPath.row] mobile]];
        }
        [_tableView reloadData];
        [_tableChoose reloadData];
    }
    else{
        if (indexPath.row - 1 < _dictFinish.count) {
            [_dictFinish removeObjectForKey:_dataKey[indexPath.row-1]];
            [_dataKey removeObjectAtIndex:indexPath.row-1];
            [_dataUserKey removeObjectAtIndex:indexPath.row-1];
            [_arrMobile removeObjectAtIndex:indexPath.row-1];
            [_allMostArray removeObjectAtIndex:indexPath.row-1];
            
            [_tableView reloadData];
            [_tableChoose reloadData];
        }
    }
    
}



// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1001) {
        //  改变索引颜色
        _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
        NSInteger number = [_listArray count];
        return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    }
    else{
        return nil;
    }
    
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView.tag == 1001) {
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        
        if (![_listArray[index] count]) {
            
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    }
    else
    {
        return 0;
    }
    
}


@end
