//
//  JGHNewAddApplyTeamPlaysViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewAddApplyTeamPlaysViewController.h"
#import "JGHNewMenberTableViewCell.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "JGLTeamMemberModel.h"

#import "ChatDetailViewController.h"
#import "JGTeamMemberManager.h"
#import "JGReturnMD5Str.h"
#import "JGLAddActiivePlayModel.h"

@interface JGHNewAddApplyTeamPlaysViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
}

@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGHNewAddApplyTeamPlaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"球队成员";
    _keyArray = [[NSMutableArray alloc]init];
    _listArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self uiConfig];
    
}
#pragma mark -- 完成
- (void)completeBtnClick{
//    _blockFriendDict(_listArray[indexPath.section][indexPath.row]);
    _blockFriendArray(_allListArray);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGHNewMenberTableViewCell class] forCellReuseIdentifier:@"JGHNewMenberTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInteger:self.teamKey] forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    NSString *para = [JGReturnMD5Str getTeamMemberListWithTeamKey:self.teamKey userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:para forKey:@"md5"];
    
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
                for (int i=0; i<_allListArray.count; i++) {
                    JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
                    palyModel = _allListArray[i];
                    if (palyModel.selectID == 1 && [model.mobile isEqualToString:palyModel.mobile]) {
                        model.select = 1;
                        break;
                    }
                }
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
    JGHNewMenberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGHNewMenberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_listArray.count != 0) {
        [cell showIntentionData:_listArray[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc]init];
    model = _listArray[indexPath.section][indexPath.row];
    
    for (int i=0; i<_allListArray.count; i++) {
        JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
        palyModel = _allListArray[i];
        if ([model.mobile isEqualToString:palyModel.mobile]) {
            if (palyModel.selectID == 1) {
                //移除 勾选
                model.select = 0;
                [_allListArray removeObjectAtIndex:i];
                [_tableView reloadData];
            }else{
                [[ShowHUD showHUD]showToastWithText:@"已添加" FromView:self.view];
                
            }
            
            return;
        }
    }
    
    JGLAddActiivePlayModel *newModel = [[JGLAddActiivePlayModel alloc]init];
    newModel.userKey = model.userKey;
    newModel.mobile = model.mobile;
    newModel.sex = model.sex;
    newModel.userName = model.userName;
    newModel.almost = model.almost;
    newModel.selectID = 1;//队员
    [_allListArray addObject:newModel];
    
    model.select = 1;
    
    [_tableView reloadData];
   // _blockFriendDict(_listArray[indexPath.section][indexPath.row]);
//    [self.navigationController popViewControllerAnimated:YES];
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
