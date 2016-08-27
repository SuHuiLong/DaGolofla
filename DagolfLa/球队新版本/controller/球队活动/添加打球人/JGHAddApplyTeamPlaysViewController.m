//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddApplyTeamPlaysViewController.h"
#import "JGMenberTableViewCell.h"

#import "JGMemManageController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"



#import "ChatDetailViewController.h"
#import "JGTeamMemberManager.h"
#import "JGReturnMD5Str.h"

@interface JGHAddApplyTeamPlaysViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
}

@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGHAddApplyTeamPlaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"球队成员";
    _keyArray = [[NSMutableArray alloc]init];
    _listArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    
    
    
    [self uiConfig];
    
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGMenberTableViewCell class] forCellReuseIdentifier:@"JGMenberTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"4372" forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    NSString *para = [JGReturnMD5Str getTeamMemberListWithTeamKey:[@4372 integerValue] userKey:[DEFAULF_USERID integerValue]];
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
    JGMenberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMenberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell showData:_dataArray[indexPath.row]];
    
    if (_listArray.count != 0) {
        [cell showData:_listArray[indexPath.section][indexPath.row] andPower:nil];
    }
    if (screenWidth == 320) {
        cell.moneyLabel.frame = CGRectMake((screenWidth - 80)*screenWidth/320, 10*screenWidth/320, 60*screenWidth/320, 24*screenWidth/320);
    }
    else if (screenWidth == 375)
    {
        cell.moneyLabel.frame = CGRectMake((screenWidth - 80)*screenWidth/375, 13*screenWidth/375, 60*screenWidth/375, 24*screenWidth/375);
    }
    else
    {
        cell.moneyLabel.frame = CGRectMake((screenWidth - 130)*screenWidth/375, 13*screenWidth/375, 60*screenWidth/375, 24*screenWidth/375);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //嘉宾回调
//    if (_isGest == YES) {
//        _blockTMemberPeople(_listArray[indexPath.section][indexPath.row]);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    //其他
//    else{
//        if ([_power rangeOfString:@"1002"].location != NSNotFound) {
//            if (_isEdit) {
//                
//                JGLTeamMemberModel *model = _listArray[indexPath.section][indexPath.row];
//                NSInteger key = [model.userKey integerValue];
//                NSString *name = model.userName;
//                NSString *mobie = model.mobile;
//                self.block(key, name, mobie);
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                if (_teamMembers == 1) {
//                    JGLTeamMemberModel *model = _listArray[indexPath.section][indexPath.row];
//                    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
//                    //设置聊天类型
//                    vc.conversationType = ConversationType_PRIVATE;
//                    //设置对方的id
//                    vc.targetId = [NSString stringWithFormat:@"%@", model.userKey];
//                    //设置对方的名字
//                    //            vc.userName = model.userName;
//                    //设置聊天标题
//                    vc.title = model.userName;
//                    //设置不现实自己的名称  NO表示不现实
//                    vc.displayUserNameInCell = NO;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }else if (_teamManagement == 1){
//                    JGMemManageController* menVc = [[JGMemManageController alloc]init];
//                    menVc.model = _listArray[indexPath.section][indexPath.row];
//                    menVc.power = _power;
//                    menVc.teamKey = _teamKey;
//                    menVc.dictAccount = _dataAccountDict;
//                    menVc.deleteBlock = ^(){
//                        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//                        [_tableView.header beginRefreshing];
//                        [_tableView reloadData];
//                    };
//                    [self.navigationController pushViewController:menVc animated:YES];
//                }
//            }
//        }else{
//            
//        }
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
