//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLFriendAddViewController.h"
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

@interface JGLFriendAddViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
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

@implementation JGLFriendAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"球友添加";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    
    if (_playArray.count == 0) {
        _playArray = [NSMutableArray array];
    }
    
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    _dictData        = [[NSMutableDictionary alloc]init];
    [self uiConfig];
    [self createHeadSearch];
}
- (void)viewWillDisappear:(BOOL)animated {//隐藏搜索框
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{//展示搜索框
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
    [_tableView reloadData];
}

-(void)finishAction
{
    _playArrayBlock(_playArray);
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
    [_dictData setObject:searchBar.text forKey:@"searchStr"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
}





-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLFriendAddTableViewCell class] forCellReuseIdentifier:@"JGLFriendAddTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
//1.0的借口，可能要替换
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [_dictData setObject:DEFAULF_USERID forKey:@"userKey"];
//    [_dictData setObject:@0 forKey:@"otherUserId"];
//    [_dictData setObject:@0 forKey:@"page"];
//    [_dictData setObject:@0 forKey:@"rows"];
    [_dictData setObject: [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"userFriend/getUserFriendList" JsonKey:nil withData:_dictData requestMethod:@"GET" failedBlock:^(id errType) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } completionBlock:^(id data) {
        //拿到数据，model接手后存入数组排序
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            NSArray *array = [data objectForKey:@"list"];
            NSMutableArray *allFriarr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                MyattenModel *model = [[MyattenModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if (model.userName) {
                    if ([model.userName isEqualToString:@""]) {
                        model.userName = @"该用户名暂无用户名";
                    }
                    [allFriarr addObject:model];
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
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
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

    cell.myModel = model;
    
    NSInteger isContains;
    isContains = 0;
    for (int i=0; i<self.playArray.count; i++) {
        MyattenModel *palyModel = [[MyattenModel alloc]init];
        palyModel = self.playArray[i];
        
        //判断Key 是否相等
        if (palyModel.friendUserKey) {
            if ([palyModel.friendUserKey integerValue] == [model.friendUserKey integerValue]) {
                isContains = 1;
                [self.playArray replaceObjectAtIndex:i withObject:model];
            }
        }else{
            if ([palyModel.otherUserId integerValue] == [model.friendUserKey integerValue]) {
                isContains = 1;
                [self.playArray replaceObjectAtIndex:i withObject:model];
            }
        }
        
    }
    
    cell.imgvState.image=[UIImage imageNamed:@"gou_w"];
    if (isContains == 1) {
        cell.imgvState.image=[UIImage imageNamed:@"gou_x"];
    }else{
        cell.imgvState.image=[UIImage imageNamed:@"gou_w"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyattenModel *model = [[MyattenModel alloc]init];
    model = self.listArray[indexPath.section][indexPath.row];
    
    NSInteger isContains;
    isContains = 0;
    for (int i=0; i<self.playArray.count; i++) {
        MyattenModel *palyModel = [[MyattenModel alloc]init];
        palyModel = self.playArray[i];
        
        if ([palyModel.friendUserKey integerValue] == [model.friendUserKey integerValue]) {
            isContains = 1;
        }
    }
    
    if (isContains == 0) {
        if (_playArray.count >= _lastIndex) {
            [[ShowHUD showHUD]showToastWithText:@"您最多只能选择三个人" FromView:self.view];
        }else{
            [self.playArray addObject:model];
        }
    }else{
        NSMutableArray *modelArray = self.playArray;
        for (int i=0; i<self.playArray.count; i++) {
            MyattenModel *palyModel = [[MyattenModel alloc]init];
            palyModel = self.playArray[i];
            
            if ([palyModel.friendUserKey integerValue] == [model.friendUserKey integerValue]) {
                [modelArray removeObjectAtIndex:i];
            }
        }
        
        self.playArray = [modelArray mutableCopy];
    }
    
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
