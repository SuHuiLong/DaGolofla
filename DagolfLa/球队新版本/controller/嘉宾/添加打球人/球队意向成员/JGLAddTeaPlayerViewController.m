//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddTeaPlayerViewController.h"
#import "JGLAddTeamPlayerTableViewCell.h"


#import "JGTeamMemberManager.h"
#import "JGReturnMD5Str.h"
#import "JGLActiveChooseSTableViewCell.h"
@interface JGLAddTeaPlayerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
}

@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGLAddTeaPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"球队成员";
    _keyArray = [[NSMutableArray alloc]init];
    _listArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    if (_dictFinish.count == 0) {
        _dictFinish = [[NSMutableDictionary alloc]init];
    }
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    [self uiConfig];
    
}

-(void)finishAction
{
    _blockTMemberPeople(_dictFinish);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLAddTeamPlayerTableViewCell class] forCellReuseIdentifier:@"JGLAddTeamPlayerTableViewCell"];
    
    
    _tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    NSString *para = [JGReturnMD5Str getTeamMemberListWithTeamKey:[_teamKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:para forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMemberList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
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
            [_tableView.mj_header endRefreshing];
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
    JGLAddTeamPlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLAddTeamPlayerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_listArray.count != 0) {
        [cell showData:_listArray[indexPath.section][indexPath.row]];
    }
    JGLTeamMemberModel *model = [_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
    if (model == nil) {
        cell.stateImgv.image = [UIImage imageNamed:@""];
    }else{
        cell.stateImgv.image = [UIImage imageNamed:@"duihao"];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLTeamMemberModel *model = [_dictFinish objectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
    if (model == nil) {
        [_dictFinish setObject:self.listArray[indexPath.section][indexPath.row] forKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
    }else{
        [_dictFinish removeObjectForKey:[self.listArray[indexPath.section][indexPath.row] timeKey]];
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
