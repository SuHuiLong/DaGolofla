//
//  JGHActivityMembersViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityMembersViewController.h"
#import "MyattenModel.h"
#import "JGLActivityMemberNumTableViewCell.h"
#import "JGLAddActiivePlayModel.h"
//#import "NoteHandlle.h"
#import "PYTableViewIndexManager.h"
#import "JGHSimpleScoreViewController.h"
#import "JGTeamAcitivtyModel.h"

#import "JGActivityMemNonmangerTableViewCell.h"

@interface JGHActivityMembersViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    NSMutableDictionary* _dictData;
    
}
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGHActivityMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"补录记分";
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];

    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    _dictData        = [[NSMutableDictionary alloc]init];
    [self uiConfig];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_dictData setObject:searchBar.text forKey:@"userName"];
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLActivityMemberNumTableViewCell class] forCellReuseIdentifier:@"JGLActivityMemberNumTableViewCell"];
    
    [_tableView registerClass:[JGActivityMemNonmangerTableViewCell class] forCellReuseIdentifier:@"JGActivityMemNonmangerTableViewCell"];

    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_activityKey] forKey:@"activityKey"];
    [dict setObject:[NSNumber numberWithInteger:_teamKey] forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:_teamKey activityKey:_activityKey userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
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
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
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
    
    JGActivityMemNonmangerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGActivityMemNonmangerTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    JGLAddActiivePlayModel *model = self.listArray[indexPath.section][indexPath.row];
    cell.nameLB.text = model.userName;
    [cell.headIconV sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    cell.headIconV.layer.cornerRadius = cell.headIconV.frame.size.height/2;
    cell.headIconV.layer.masksToBounds = YES;
    if (model.mobile) {
        cell.phoneLB.text = model.mobile;
        cell.phoneLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        cell.phoneLB.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGHSimpleScoreViewController *simpleCtrl = [[JGHSimpleScoreViewController alloc]init];
    NSLog(@"%td", indexPath.section);
    simpleCtrl.playModel = self.listArray[indexPath.section][indexPath.row];
    simpleCtrl.actModel = _activityModel;
    [self.navigationController pushViewController:simpleCtrl animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
