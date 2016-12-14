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
@interface JGLAddActivePlayViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating, JGLActiveChooseSTableViewCellDelegate>
{
    UITableView* _tableView;
    UITableView* _tableChoose;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
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
    
    if (self.palyArray.count == 0) {
        self.palyArray = [NSMutableArray array];
    }
    
    [self downLoadData];
    
    [self uiConfig];
    
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
    _blockSurePlayer(_palyArray);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375 - 40*5*screenWidth/375 - 54*screenWidth/375 -64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLActiveAddPlayTableViewCell class] forCellReuseIdentifier:@"JGLActiveAddPlayTableViewCell"];
    _tableView.tag = 1001;
    
    _tableChoose = [[UITableView alloc]initWithFrame:CGRectMake(0, screenHeight -15*screenWidth/375 - 40*5*screenWidth/375 - 54*screenWidth/375 - 64, screenWidth, 40*5*screenWidth/375) style:UITableViewStylePlain];
    _tableChoose.delegate = self;
    _tableChoose.dataSource = self;
    _tableChoose.tag = 1002;
    [self.view addSubview:_tableChoose];
    [_tableChoose registerClass:[JGLActiveChooseSTableViewCell class] forCellReuseIdentifier:@"JGLActiveChooseSTableViewCell"];
    _tableChoose.scrollEnabled = NO;
}
#pragma mark - 下载数据
- (void)downLoadData{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    //    [dict setObject:[NSNumber numberWithInteger:] forKey:@"activityKey"];
    [dict setObject:_model.timeKey forKey:@"activityKey"];
    [dict setObject:_model.userKey forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [dict setObject:_model.teamKey forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:[_model.teamKey integerValue] activityKey:[_model.timeKey integerValue] userKey:[_model.userKey integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //记录上个页面传过来的数据--
                for (int i=0; i<_palyArray.count; i++) {
                    JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
                    palyModel = _palyArray[i];
                    
                    if (_iscabblie == 1) {
                        //球童
                        if ([model.userKey integerValue] == [_userKeyPlayer integerValue]) {
                            model.select = 1;
                            model.tTaiwan = palyModel.tTaiwan;
                            break;
                        }else{
                            //
                            if ([model.timeKey integerValue] == [palyModel.timeKey integerValue]) {
                                model.select = 1;
                                model.tTaiwan = palyModel.tTaiwan;
                                break;
                            }else{
                                model.select = 0;
                            }
                        }
                    }else{
                        //非球童
                        if ([model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
                            model.select = 1;
                            model.tTaiwan = palyModel.tTaiwan;
                            break;
                        }else{
                            //
                            if ([model.timeKey integerValue] == [palyModel.timeKey integerValue]) {
                                model.select = 1;
                                model.tTaiwan = palyModel.tTaiwan;
                                break;
                            }else{
                                model.select = 0;
                            }
                        }
                    }
                }
                
                model.remark = model.name;
                
                [_dataArray addObject:model];
            }
            
            //刷新选中的记分人
            [self returnPalyArray];
            
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
        
    }];
}
#pragma mark -- 获取已选中的记分人
- (void)returnPalyArray{
    [self.palyArray removeAllObjects];
    //添加选中的记分人
    for (int i=0; i<_dataArray.count; i++) {
        JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
        model = _dataArray[i];
        if (model.select == 1) {
            [self.palyArray addObject:model];
        }
    }
    //把自己排在第一位
    for (int i=0; i<self.palyArray.count; i++) {
        JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
        model = self.palyArray[i];
        if (_iscabblie == 1) {
            //球童
            if ([model.userKey integerValue] == [_userKeyPlayer integerValue]) {
                [self.palyArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
            }
        }else{
            //非球童
            if ([model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
                [self.palyArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
            }
        }
        
    }
    
    [_tableChoose reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 1001 ? 50*ScreenWidth/375 : 40*ScreenWidth/375;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 1001 ?[self.listArray[section] count] : 5;
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
        
        [cell configJGLAddActiivePlayModel:self.listArray[indexPath.section][indexPath.row]];
        
        return cell;
    }
    else{
        JGLActiveChooseSTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLActiveChooseSTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.deleteBtn.tag = indexPath.row -1;
        
        if (indexPath.row == 0) {
            cell.labelTitle.font = [UIFont systemFontOfSize:15*ProportionAdapter];
            cell.deleteBtn.hidden = YES;
            cell.labelTitle.text = @"已添加打球人";
        }
        else{
            if (indexPath.row -1 < _palyArray.count) {
                [cell configJGLAddActiivePlayModel:_palyArray[indexPath.row -1]];
            }else{
                cell.labelTitle.font = [UIFont systemFontOfSize:15*ProportionAdapter];
                cell.labelTitle.textColor = [UIColor lightGrayColor];
                cell.labelTitle.text = @"    请添加打球人";
                cell.deleteBtn.hidden = YES;
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1001) {
        
        JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
        model = self.listArray[indexPath.section][indexPath.row];
        
        if (_iscabblie == 1) {
            //不能取消球童扫描的客户
            if ([model.userKey integerValue] == [_userKeyPlayer integerValue]) {
                return;
            }
        }else{
            //不能取消自己
            if ([model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
                return;
            }
        }
        
        
        if (model.select == 0) {
            //计算当前选中的总数
            NSInteger selectCount = 0;
            for (int i=0; i<self.listArray.count; i++) {
                NSArray *listModelArray = self.listArray[i];
                for (int j=0; j<listModelArray.count; j++) {
                    JGLAddActiivePlayModel *actvityModel = [[JGLAddActiivePlayModel alloc]init];
                    actvityModel = listModelArray[j];
                    if (actvityModel.select == 1) {
                        selectCount += 1;
                    }
                }
            }
            
            if (selectCount >= 4) {
                [[ShowHUD showHUD]showToastWithText:@"您最多只能选择三个人！" FromView:self.view];
                return;
            }
            
            model.select = 1;
            
        }else{
            model.select = 0;
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.listArray[indexPath.section]];
        [array replaceObjectAtIndex:indexPath.row withObject:model];
        
        [self.listArray replaceObjectAtIndex:indexPath.section withObject:array];
        
        [self returnPalyArray];
        
        [_tableView reloadData];
        
    }
    else{

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

#pragma mark -- 删除
- (void)deleteActivityScorePlayrBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    if (btn.tag <= _palyArray.count -1) {
        JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
        palyModel = _palyArray[btn.tag];
        
        for (int i=0; i<self.listArray.count; i++) {
            NSArray *listModelArray = self.listArray[i];
            for (int j=0; j<listModelArray.count; j++) {
                JGLAddActiivePlayModel *actvityModel = [[JGLAddActiivePlayModel alloc]init];
                actvityModel = listModelArray[j];
                if ([actvityModel.timeKey integerValue] == [palyModel.timeKey integerValue]) {
                    //取消球童
                    //取消非球童
                    actvityModel.select = 0;
                    break;
                }else{
                    //timeKey不相同，
                    //球童：只有添加的客户，不能取消选择
                    //非球童：自己不能取消
                }
            }
        }
        [_palyArray removeObjectAtIndex:btn.tag];
        
        [_tableView reloadData];
        [_tableChoose reloadData];
    }else{
        
    }
}

@end
