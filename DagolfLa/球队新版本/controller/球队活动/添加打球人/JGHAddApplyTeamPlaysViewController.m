//
//  JGHAddApplyTeamPlaysViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddApplyTeamPlaysViewController.h"
#import "JGMenberTableViewCell.h"

#import "PYTableViewIndexManager.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "MyattenModel.h"
#import "NoteModel.h"
#import "NoteHandlle.h"

#import "ChatDetailViewController.h"
#import "JGTeamMemberManager.h"
#import "JGReturnMD5Str.h"
#import "JGLFriendAddTableViewCell.h"

@interface JGHAddApplyTeamPlaysViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    NSMutableDictionary* _dictData;
    
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGHAddApplyTeamPlaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加球友";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    if (_dictFinish.count == 0) {
        _dictFinish      = [[NSMutableDictionary alloc]init];
    }
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    _dictData        = [[NSMutableDictionary alloc]init];
    [self uiConfig];
    [self createHeadSearch];
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

-(void)finishAction
{
    //    for (int i = 0; i < _dictFinish.count; i ++) {
    //        if ([DEFAULF_USERID integerValue] == [[_dictFinish allKeys][i] integerValue]) {
    //            [[ShowHUD showHUD]showToastWithText:@"您不能选择自己，请重新添加" FromView:self.view];
    //            [_dictFinish removeObjectForKey:[_dictFinish allKeys][i]];
    //            [_tableView reloadData];
    //            return;
    //        }
    //    }
    
    _blockFriendDict(_dictFinish);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createHeadSearch
{
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.barTintColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    _searchController.searchBar.placeholder = @"输入队友昵称搜索";
    _tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchBar.delegate = self;
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_dictData setObject:searchBar.text forKey:@"userName"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
}





-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLFriendAddTableViewCell class] forCellReuseIdentifier:@"JGLFriendAddTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
//    NSString *para = [JGReturnMD5Str getTeamMemberListWithTeamKey:[_teamKey integerValue] userKey:[DEFAULF_USERID integerValue]];
//    [dict setObject:para forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMemberList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
                [_keyArray removeAllObjects];
                [_listArray removeAllObjects];
                [_dataAccountDict removeAllObjects];
                
            }
            //数据解析
            for (NSDictionary *dataDic in [data objectForKey:@"teamMemberList"]) {
                JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            
            self.listArray = [[NSMutableArray alloc]initWithArray:[JGTeamMemberManager archiveNumbers:_dataArray]];
            
            if (![Helper isBlankString:[data objectForKey:@"accountUserKey"]]) {
                [_dataAccountDict setObject:[data objectForKey:@"accountUserKey"] forKey:@"accountUserKey"];
            }
            if (![Helper isBlankString:[data objectForKey:@"accountUserMobile"]]) {
                [_dataAccountDict setObject:[data objectForKey:@"accountUserMobile"] forKey:@"accountUserMobile"];
            }
            if (![Helper isBlankString:[data objectForKey:@"accountUserName"]]) {
                [_dataAccountDict setObject:[data objectForKey:@"accountUserName"] forKey:@"accountUserName"];
            }
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            
            
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewNoHaveCancleWithTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"packResultMsg"]] withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    }];

    
    
    
    
    [_dictData setObject:DEFAULF_USERID forKey:@"userId"];
    [_dictData setObject:@0 forKey:@"otherUserId"];
    [_dictData setObject:@0 forKey:@"page"];
    [_dictData setObject:@0 forKey:@"rows"];
    
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"team/getTeamMemberList" parameter:_dictData success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *array = [dict objectForKey:@"rows"];
            NSMutableArray *allFriarr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                MyattenModel *model = [[MyattenModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if (![model.userName isEqualToString:@""]) {
                    
                    NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
                    if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
                        
                    }else{
                        model.userName = modell.userremarks;
                    }
                    [allFriarr addObject:model];
                    [_dictData removeObjectForKey:@"userName"];
                    //                [self.keyArray addObject:model.userName];
                }
            }
            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:allFriarr]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            
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
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count];
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.listArray[section] count] == 0) {
        return nil;
    }else{
        return self.keyArray[section];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGLFriendAddTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLFriendAddTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyattenModel *model = self.listArray[indexPath.section][indexPath.row];
    NoteModel *modell = [NoteHandlle selectNoteWithUID:model.otherUserId];
    if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
        
    }else{
        model.userName = modell.userremarks;
    }
    cell.myModel = model;
    
    
    
    NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
    
    if ([Helper isBlankString:str]==NO) {
        cell.imgvState.image=[UIImage imageNamed:@"gou_x"];
    }else{
        cell.imgvState.image=[UIImage imageNamed:@"gou_w"];
    }
    return cell;
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dictFinish.count != 0) {
        if (_dictFinish.count >= _lastIndex) {
            [[ShowHUD showHUD]showToastWithText:@"您最多只能选择3个人" FromView:self.view];
            
        }
        else{
            NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
            if ([Helper isBlankString:str]==YES) {
                
                [_dictFinish setObject:[self.listArray[indexPath.section][indexPath.row] userName] forKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
                
            }else{
                [_dictFinish removeObjectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
            }
            
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else{
        if (_dictFinish.count >= _lastIndex) {
            [[ShowHUD showHUD]showToastWithText:@"您最多只能选择3个人" FromView:self.view];
            
        }
        else{
            NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
            if ([Helper isBlankString:str]==YES) {
                
                [_dictFinish setObject:[self.listArray[indexPath.section][indexPath.row] userName] forKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
                
            }else{
                [_dictFinish removeObjectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
            }
            
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}



// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [_listArray count];
    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (![_listArray[index] count]) {
        
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        return index;
    }
}


@end
