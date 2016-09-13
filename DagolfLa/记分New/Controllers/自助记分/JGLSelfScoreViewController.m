//
//  JGLSelfScoreViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSelfScoreViewController.h"
#import "JGHScoresViewController.h"

#import "JGLAddPlayerViewController.h"
#import "JGLChooseScoreViewController.h"
#import "BallParkViewController.h"
#import "DateTimeViewController.h"

#import "JGLChooseBallTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "JGLPlayDateTableViewCell.h"
#import "JGLPlayerNameTableViewCell.h"
#import "JGLChangePlayerTableViewCell.h"

#import "JGLTeeChooseView.h"//tee台视图

#import "JGLBarCodeViewController.h"

#define HEADER_BUTTON1_TAG 100
#define HEADER_BUTTON2_TAG 1000
#define HEADER_BUTTON3_TAG 10000
@interface JGLSelfScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isOpen[3];//控制表开合
    NSString* _strBall;//球场名
    NSInteger _ballId;//存球场id
    NSMutableArray* _dataBallArray;//球场对应数据
    NSString* _strDateBegin;//球场时间
    JGLTeeChooseView* _chooseView;//tee台视图
    BOOL _isTee;//是否选择了Tee台
    NSString* _strTee;//用来记录选择的Tee台
    NSString* _strBallLogo;//记录球场头像
    NSMutableDictionary* _teeDictChoose;//记录选择的t台存放数组
    
    NSMutableDictionary *_dictPeo,*_dictFri,*_dictAdd;
    
    NSMutableDictionary* _dictArea; //选择的分区
    BOOL _isClickArea;//首次进入后则默认选择前两个区域，
    

}
@property (strong, nonatomic) UITableView* tableView;
@end

@implementation JGLSelfScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记分";
    _dataBallArray = [[NSMutableArray alloc]init];
    _dictPeo       = [[NSMutableDictionary alloc]init];
    _dictFri       = [[NSMutableDictionary alloc]init];
    _dictAdd       = [[NSMutableDictionary alloc]init];
    _teeDictChoose = [[NSMutableDictionary alloc]init];
    _dictArea      = [[NSMutableDictionary alloc]init];
    _isTee = NO;
    _isClickArea = NO;
    
    NSString* str = [Helper returnCurrentDateString];
    NSArray* arr = [str componentsSeparatedByString:@" "];
    _strDateBegin = arr[0];
    [self uiConfig];
    [self createScoreBtn];
    
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
    [dict setObject:@0 forKey:@"srcKey"];//
    [dict setObject:@(0) forKey:@"srcType"];//活动传1，罗开创说的
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
        [dict setObject:[_dictArea allValues][1] forKey:@"region2"];
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
    for (int i=0; i<_teeDictChoose.count; i++) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        if (i == 0) {
            if (![Helper isBlankString:[_teeDictChoose objectForKey:@"0"]]) {
                [dict1 setObject:[_teeDictChoose objectForKey:@"0"] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            [dict1 setObject:DEFAULF_USERID forKey:@"userKey"];//用户Key
            
            
            [dict1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] forKey:@"userName"];// 用户名称
            if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]) {
                [dict1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"userMobile"];// 手机号
            }else{
                [dict1 setObject:@"" forKey:@"userMobile"];// 手机号
            }
            
        }
        else{
            if (![Helper isBlankString:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%d",i]]]) {
                [dict1 setObject:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            NSArray* arr = [_dictPeo allKeys];
            NSString* str = [NSString stringWithFormat:@"%@",arr[i-1]];
//            if (str.length >= 11) {
            if (![Helper isBlankString:str]) {
                [dict1 setObject:str forKey:@"userKey"];//用户Key
            }
            else{
                [dict1 setObject:@0 forKey:@"userKey"];//用户Key
            }
            NSArray* arr1 = [_dictPeo allValues];
            NSString* str1 = [NSString stringWithFormat:@"%@",arr1[i-1]];
            [dict1 setObject:str1 forKey:@"userName"];// 用户名称
            if (str.length >= 11) {
                if (![Helper isBlankString:str]) {
                    [dict1 setObject:str forKey:@"userMobile"];// 手机号
                }
                else{
                    [dict1 setObject:@"" forKey:@"userMobile"];// 手机号
                }
            }
            else{
                [dict1 setObject:@"" forKey:@"userMobile"];// 手机号
            }
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
            scoresCtrl.scorekey = [data objectForKey:@"scorekey"];
//            scoresCtrl
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
    
    [_tableView registerClass:[JGLChooseBallTableViewCell class] forCellReuseIdentifier:@"JGLChooseBallTableViewCell"];
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
    [_tableView registerClass:[JGLPlayDateTableViewCell class] forCellReuseIdentifier:@"JGLPlayDateTableViewCell"];
    [_tableView registerClass:[JGLPlayerNameTableViewCell class] forCellReuseIdentifier:@"JGLPlayerNameTableViewCell"];
    [_tableView registerClass:[JGLChangePlayerTableViewCell class] forCellReuseIdentifier:@"JGLChangePlayerTableViewCell"];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLChooseBallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChooseBallTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (![Helper isBlankString:_strBall]) {
            cell.labelTitle.text = _strBall;
            [cell.iconImg sd_setImageWithURL:[Helper imageIconUrl:_strBallLogo] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        }
        else{
            cell.labelTitle.text = @"请选择球场";
        }
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
            
            cell.labelName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            return cell;

        }
        else{
            NSLog(@"%td",indexPath.row);
            if (indexPath.row - 2 < _dictPeo.count) {
                JGLPlayerNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

//                if (_teeDictChoose.count > indexPath.row) {
//                    cell.iconImgv.hidden = YES;
//                    cell.labelTee.text = @"请选择tee台";
//                }
//                else{
                    if (![Helper isBlankString:[_teeDictChoose objectForKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]]]) {
                        cell.iconImgv.hidden = NO;
                        [cell showTee:_strTee];
                    }
                    else{
                        cell.iconImgv.hidden = YES;
                        cell.labelTee.text = @"请选择tee台";
                    }
//                }
                
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
       return  60* screenWidth / 375;
    }
    else if (indexPath.section == 1){
        return _dataBallArray.count == 0 ? 0* screenWidth / 375 : 50* screenWidth / 375;
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
        //球场
        BallParkViewController* ballVc = [[BallParkViewController alloc]init];
        ballVc.type1=1;
        ballVc.callback1=^(NSDictionary *dict, NSString *str){
            [_dataBallArray removeAllObjects];
            [_dictArea removeAllObjects];
            _isClickArea = NO;
            if (dict.count != 0) {
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"tAll"]];
                _strBallLogo = str;
            }
            [_tableView reloadData];
        };
        [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
//            _labelBallName.text = balltitle;
            _strBall = balltitle;
            _ballId = ballid;
        }];
        [self.navigationController pushViewController:ballVc animated:YES];
    }
    ////NSLog(@"3");
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
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:dateVc animated:YES];
    }
    else{
        if (indexPath.row == 1) {

            if (![Helper isBlankString:_strBall]) {
                if (_isTee == NO) {
                    JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                    [tableView addSubview:_chooseView];
                    _chooseView.blockTeeName = ^(NSString *strT){
                        _strTee = strT;
                        NSLog(@"%td",indexPath.row);
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
                [[ShowHUD showHUD]showToastWithText:@"请先选择球场" FromView:self.view];
            }
            
        }
        else{
            if (indexPath.row > 0) {
                if (indexPath.row  == _dictPeo.count + 2) {
                    JGLAddPlayerViewController* addVc = [[JGLAddPlayerViewController alloc]init];
                    addVc.blockSurePlayer = ^(NSMutableDictionary *dict,NSMutableDictionary* dict1,NSMutableDictionary* dict2){
                        _dictPeo = dict;
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                    //                addVc.dictFin = _dictPeo;
                    addVc.dictPeople = _dictPeo;
                    addVc.peoAddress = _dictAdd;
                    addVc.peoFriend  = _dictFri;
                    [self.navigationController pushViewController:addVc animated:YES];
                    
                }
                else{
                    if (![Helper isBlankString:_strBall]) {
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
                        [[ShowHUD showHUD]showToastWithText:@"请先选择球场" FromView:self.view];
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
