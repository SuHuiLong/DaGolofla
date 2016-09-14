//
//  JGLSelfScoreViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieActiveScoreViewController.h"
#import "JGHScoresViewController.h"

#import "JGLChooseScoreViewController.h"
#import "BallParkViewController.h"
#import "DateTimeViewController.h"
#import "JGLAddActivePlayViewController.h"

#import "JGLChoosesScoreTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "JGLPlayDateTableViewCell.h"
#import "JGLPlayerNameTableViewCell.h"
#import "JGLChangePlayerTableViewCell.h"

#import "JGLTeeChooseView.h"//tee台视图

#define HEADER_BUTTON1_TAG 100
#define HEADER_BUTTON2_TAG 1000
#define HEADER_BUTTON3_TAG 10000
@interface JGLCaddieActiveScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isOpen[3];//控制表开合
    NSString* _strBall;//球场名
    NSInteger _ballId;//存球场id
    NSMutableArray* _dataBallArray;//球场对应数据
    NSString* _strDateBegin;//球场时间
    JGLTeeChooseView* _chooseView;//tee台视图
    BOOL _isTee;//是否选择了Tee台
    NSString* _strTee;//用来记录选择的Tee台
    NSMutableDictionary* _teeDictChoose;//记录选择的t台存放数组
    
    NSMutableDictionary *_dictPeo;//存放返回的人数字典
    NSMutableArray *_dataKeyBack, *_mobileArr,*_dataUserKey,*_allmostArray;//timeKey用于标记，手机号，userkey
    
    //传参
    NSString* _strHole1,* _strHole2;//九洞
    
    NSString* _userN, * _userM;//记录自己在活动中的姓名和手机号
    
    NSMutableDictionary* _dictArea; //选择的分区
    BOOL _isClickArea;
}
@property (strong, nonatomic) UITableView* tableView;
@end

@implementation JGLCaddieActiveScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记分";
    _dataBallArray  = [[NSMutableArray alloc]init];
    _dataKeyBack    = [[NSMutableArray alloc]init];
    _dataUserKey    = [[NSMutableArray alloc]init];
    _mobileArr      = [[NSMutableArray alloc]init];
    _teeDictChoose = [[NSMutableDictionary alloc]init];
    _dictPeo        = [[NSMutableDictionary alloc]init];
    _allmostArray   = [[NSMutableArray alloc]init];
    _dictArea       = [[NSMutableDictionary alloc]init];
    _isTee          =  NO;
    _isClickArea    =  NO;
    
    NSString* str = [Helper returnCurrentDateString];
    NSArray* arr = [str componentsSeparatedByString:@" "];
    _strDateBegin = arr[0];
    [self uiConfig];
    [self createScoreBtn];
    [self getBallCode];
    [self getUserInfo];
}
-(void)getUserInfo
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_model.timeKey forKey:@"activityKey"];
    [dict setObject:_userKeyPlayer forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (![Helper isBlankString:[[data objectForKey:@"teamMember"] objectForKey:@"userName"]]) {
                _userN = [[data objectForKey:@"teamMember"] objectForKey:@"userName"];
            }
            else{
                _userN = _userNamePlayer;
            }
            _userM = [[data objectForKey:@"teamMember"] objectForKey:@"mobile"];
            //            }
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:3];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark -- 获取球场区和T台
- (void)getBallCode{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_model.ballKey forKey:@"ballKey"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getBallCode" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            //点击事件选中后传值
            [_dataBallArray addObject:[data objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[data objectForKey:@"tAll"]];
            _strBall = _model.ballName;
            _ballId = [_model.ballKey integerValue];
            [_tableView reloadData];
        }
        else{
            [Helper alertViewWithTitle:@"球场整修中" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
        }else{
            
        }
    }];
    
}


-(void)createScoreBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"开始记分" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(professionalScore:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*ScreenWidth/375 - 64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
}
#pragma mark -- 开始记分
- (void)professionalScore:(UIButton *)btn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"ballKey"];
    [dict setObject:_model.timeKey forKey:@"srcKey"];//
    [dict setObject:@(1) forKey:@"srcType"];//活动传1，罗开创说的
    
    if (_dictArea.count < 2) {
        [[ShowHUD showHUD]showToastWithText:@"请选择两个球场分区，谢谢" FromView:self.view];
        return;
    }

    
    if (![Helper isBlankString:[_dictArea allValues][0]]) {
        [dict setObject:[_dictArea allValues][0] forKey:@"region1"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择第一九洞" FromView:self.view];
        return;
    }
    if (![Helper isBlankString:[_dictArea allValues][1]]) {
        [dict setObject:[_dictArea allValues][0] forKey:@"region2"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择第二九洞" FromView:self.view];
        return;
    }
    if (![Helper isBlankString:_strDateBegin]) {
        [dict setObject:[NSString stringWithFormat:@"%@ 00:00:00",_strDateBegin] forKey:@"createTime"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择打球时间" FromView:self.view];
        return;
    }
    
    
    
    NSMutableArray *userArray = [NSMutableArray array];
    if (_teeDictChoose.count < _dictPeo.count+1) {
        [[ShowHUD showHUD]showToastWithText:@"请选择添加成员的Tee台" FromView:self.view];
        return;
    }
    for (int i=0; i<_teeDictChoose.count + 1; i++) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        if (i == 0) {
            if (![Helper isBlankString:[_teeDictChoose allValues][i]]) {
                [dict1 setObject:[_teeDictChoose allValues][i] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            [dict1 setObject:_userKeyPlayer forKey:@"userKey"];//用户Key
            
            
            [dict1 setObject:_userN forKey:@"userName"];// 用户名称
            [dict1 setObject:_userM forKey:@"userMobile"];// 手机号
            [dict1 setObject:@1 forKey:@"userType"];// 用户名称
        }
        else if (i < _teeDictChoose.count){
            if (![Helper isBlankString:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%d",i]]]) {
                [dict1 setObject:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            
            [dict1 setObject:_allmostArray[i-1] forKey:@"almost"];
            [dict1 setObject:_dataUserKey[i-1] forKey:@"userKey"];//用户Key
            [dict1 setObject:[_dictPeo objectForKey:_dataKeyBack[i-1]] forKey:@"userName"];// 用户名称
            [dict1 setObject:_mobileArr[i-1] forKey:@"userMobile"];// 手机号
            [dict1 setObject:@1 forKey:@"userType"];// 用户名称
        }
        else{
            [dict1 setObject:DEFAULF_USERID forKey:@"userKey"];//用户Key
            [dict1 setObject:_userN forKey:@"userName"];// 用户名称
            if (_teeDictChoose.count != 0) {
                [dict1 setObject:[_teeDictChoose objectForKey:@"0"] forKey:@"tTaiwan"];// T台
            }
            [dict1 setObject:@1 forKey:@"userType"];// 用户名称
        }
        [userArray addObject:dict1];
    }
    
    [dict setObject:userArray forKey:@"userList"];
    //    [dict setObject:DEFAULF_USERID forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/createScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            JGHScoresViewController *scoresCtrl = [[JGHScoresViewController alloc]init];
            scoresCtrl.isCabbie = 1;
            scoresCtrl.scorekey = [data objectForKey:@"scorekey"];
            [self.navigationController pushViewController:scoresCtrl animated:YES];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64*screenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLChoosesScoreTableViewCell class] forCellReuseIdentifier:@"JGLChoosesScoreTableViewCell"];
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
    [_tableView registerClass:[JGLPlayDateTableViewCell class] forCellReuseIdentifier:@"JGLPlayDateTableViewCell"];
    [_tableView registerClass:[JGLPlayerNameTableViewCell class] forCellReuseIdentifier:@"JGLPlayerNameTableViewCell"];
    [_tableView registerClass:[JGLChangePlayerTableViewCell class] forCellReuseIdentifier:@"JGLChangePlayerTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLChoosesScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChoosesScoreTableViewCell" forIndexPath:indexPath];
        [cell showData:_model];
        cell.labelTime.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
        
        NSString *str = [_dictArea objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        if ([Helper isBlankString:str]) {
            //            [cell.imageView setImage:[UIImage imageNamed:@"wuGou"] forState:UIControlStateNormal];
            if (_isClickArea == NO) {
                if (indexPath.row < 2) {
                    cell.imgvState.image = [UIImage imageNamed:@"yigouxuan"];
                    [_dictArea setObject:_dataBallArray[indexPath.section-1][indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
                    
                }
                else{
                    cell.imgvState.image = [UIImage imageNamed:@"wuGou"];
                }
            }
            else{
                cell.imgvState.image = [UIImage imageNamed:@"wuGou"];
            }
            
        }else{
            
            cell.imgvState.image = [UIImage imageNamed:@"yigouxuan"];
        }
        NSArray *allValues = [_dataBallArray objectAtIndex:indexPath.section-1];
        //将数组显示至每行
        cell.textLabel.text = [allValues objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        JGLPlayDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ( [Helper isBlankString:_strDateBegin]) {
            cell.labelDate.text = @"请选择打球时间";
        }
        else{
            cell.labelDate.text = _strDateBegin;
        }
        return cell;
    }
    else{
        
        if (indexPath.row == 0) {
            JGLPlayDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayDateTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelDate.hidden = YES;
            cell.labelTitle.text = @"打球人";
            return cell;
        }
        else if (indexPath.row == 1)
        {
            JGLPlayerNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![Helper isBlankString:_strTee]) {
                cell.iconImgv.hidden = NO;
                [cell showTee:_strTee];
            }
            else{
                cell.iconImgv.hidden = YES;
                cell.labelTee.text = @"请选择tee台";
            }
            
            
            
            if ([Helper isBlankString:_userN]) {
                cell.labelName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            }
            else{
                cell.labelName.text = _userN;
            }
            return cell;
            
        }
        else{
            NSLog(@"%td",indexPath.row);
            if (indexPath.row - 2 < _dictPeo.count) {
                JGLPlayerNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSLog(@"%td",indexPath.row);
                
                if (![Helper isBlankString:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]]]) {
                    cell.iconImgv.hidden = NO;
                    [cell showTee:_strTee];
                }
                else{
                    cell.iconImgv.hidden = YES;
                    cell.labelTee.text = @"请选择tee台";
                }
                
                //                if (![Helper isBlankString:_strTee]) {
                //                    cell.iconImgv.hidden = NO;
                //                    [cell showTee:_strTee];
                //                }
                //                else{
                //                    cell.iconImgv.hidden = YES;
                //                    cell.labelTee.text = @"请选择tee台";
                //                }
                cell.labelName.text = [_dictPeo allValues][indexPath.row-2];
                return cell;
            }
            else{
                JGLChangePlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChangePlayerTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0* screenWidth / 375;
    }
    else{
        return 10* screenWidth / 375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  93 * screenWidth / 375;
    }
    else if (indexPath.section == 3){
        return indexPath.row == 0 ? 44* screenWidth / 375 : 50* screenWidth / 375;
    }
    else{
        return 44 * screenWidth / 375;
    }
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        //取出字典中的所有值 一个数组中放着三个小数组
        //根据每个区 返回行数
        if (_dataBallArray.count != 0) {
            return [_dataBallArray[0] count];
        }
        else{
            return 0;
        }
    }
    else if (section == 3)
    {
        return section == 3 ? 3 + _dictPeo.count : 1;
    }
    else{
        return 1;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_isTee == YES)  {
            [_chooseView removeFromSuperview];
            _isTee = NO;
        }
        //        //球场
    }
    else if (indexPath.section == 1) {
        if (_isTee == YES)  {
            [_chooseView removeFromSuperview];
            _isTee = NO;
        }
        NSString *str = [_dictArea objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        _isClickArea = YES;
        if (_dictArea.count == 2) {
            NSArray* arrNum = [_dictArea allKeys];
            if (indexPath.row !=  [arrNum[0] integerValue] && indexPath.row !=  [arrNum[1] integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"请先取消一项，再点选" FromView:self.view];
            }
            else{
                if ([Helper isBlankString:str]) {
                    [_dictArea setObject:_dataBallArray[indexPath.section-1][indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
                    
                }else{
                    [_dictArea removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
                }
            }
        }else{
            if ([Helper isBlankString:str]) {
                [_dictArea setObject:_dataBallArray[indexPath.section-1][indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
            }else{
                [_dictArea removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
            }
        }
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else if (indexPath.section == 2)
    {
        if (_isTee == YES)  {
            [_chooseView removeFromSuperview];
            _isTee = NO;
        }
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @1;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            _strDateBegin = dateStr;
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:2];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [self.navigationController pushViewController:dateVc animated:YES];
    }
    else{
        if (indexPath.row == 1) {
            //            [_chooseView show];
            if (_isTee == NO) {
                JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                [tableView addSubview:_chooseView];
                _chooseView.blockTeeName = ^(NSString *strT){
                    _strTee = strT;
                    [_teeDictChoose setObject:_strTee forKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]];
                    [_chooseView removeFromSuperview];
                    _isTee = NO;
                    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:3];
                    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                _isTee = YES;
            }
            else{
                [_chooseView removeFromSuperview];
                _isTee = NO;
            }
            
        }
        else{
            if (indexPath.row > 0) {
                if (indexPath.row  == _dictPeo.count + 2) {
                    JGLAddActivePlayViewController* addVc = [[JGLAddActivePlayViewController alloc]init];
                    addVc.model = _model;
                    addVc.blockSurePlayer = ^(NSMutableDictionary *dict, NSMutableArray* dataKey, NSMutableArray* arrMobile,NSMutableArray* arrUserKey,NSMutableArray* arrAllMost)
                    {
                        _dictPeo = dict;
                        _dataKeyBack = dataKey;
                        _dataUserKey = arrUserKey;
                        _allmostArray = arrAllMost;
                        _mobileArr = arrMobile;
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
//                        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        [_tableView reloadData];
                    };
                    addVc.dictFinish = _dictPeo;
                    addVc.dataKey    = _dataKeyBack;
                    addVc.arrMobile = _mobileArr;
                    addVc.dataUserKey = _dataUserKey;
                    addVc.allMostArray = _allmostArray;
                    [self.navigationController pushViewController:addVc animated:YES];
                    
                }
                else{
                    if (_isTee == NO) {
                        JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                        _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                        [tableView addSubview:_chooseView];
                        _chooseView.blockTeeName = ^(NSString *strT){
                            _strTee = strT;
                            [_teeDictChoose setObject:_strTee forKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]];
                            [_chooseView removeFromSuperview];
                            _isTee = NO;
                            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:3];
                            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                        };
                        _isTee = YES;
                    }
                    else{
                        [_chooseView removeFromSuperview];
                        _isTee = NO;
                    }
                }
            }
        }
    }
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
