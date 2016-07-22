//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddActivePlayViewController.h"
//#import "JGMenberTableViewCell.h"

//#import "PYTableViewIndexManager.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "MyattenModel.h"
#import "NoteModel.h"
#import "NoteHandlle.h"

//#import "JGTeamMemberManager.h"
//#import "JGReturnMD5Str.h"
#import "JGLFriendAddTableViewCell.h"

@interface JGLAddActivePlayViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
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
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
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
//    _blockFriendDict(_dictFinish);
//    [self.navigationController popViewControllerAnimated:YES];
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
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[NSNumber numberWithInteger:] forKey:@"activityKey"];
    [dict setObject:_model.timeKey forKey:@"activityKey"];
    [dict setObject:_model.userKey forKey:@"userKey"];
//    [dict setObject:@0 forKey:@"offset"];
    [dict setObject:_model.teamKey forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:[_model.teamKey integerValue] activityKey:[_model.timeKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
//        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
//            JGHScoresViewController *scoresCtrl = [[JGHScoresViewController alloc]init];
//            scoresCtrl.scorekey = [data objectForKey:@"scorekey"];
//            [self.navigationController pushViewController:scoresCtrl animated:YES];
//        }else{
//            if ([data objectForKey:@"packResultMsg"]) {
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//            }
//        }
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
    
    
    
//    NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
//    
//    if ([Helper isBlankString:str]==NO) {
//        cell.imgvState.image=[UIImage imageNamed:@"gou_x"];
//    }else{
//        cell.imgvState.image=[UIImage imageNamed:@"gou_w"];
//    }
    return cell;
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_dictFinish.count < 3) {
//        NSString *str=[_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
//        if ([Helper isBlankString:str]==YES) {
//            
//            [_dictFinish setObject:[self.listArray[indexPath.section][indexPath.row] userName] forKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
//            
//        }else{
//            [_dictFinish removeObjectForKey:[self.listArray[indexPath.section][indexPath.row] otherUserId]];
//        }
//        
//        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//    else{
//        [[ShowHUD showHUD]showToastWithText:@"您最多只能选择3个人" FromView:self.view];
//    }
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
