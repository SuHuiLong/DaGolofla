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
    NSMutableDictionary* _teeDictChoose;//记录选择的t台存放数组
    
    NSMutableDictionary *_dictPeo;
    NSString* _strHole1,* _strHole2;//九洞

}
@property (strong, nonatomic) UITableView* tableView;
@end

@implementation JGLSelfScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记分";
    _dataBallArray = [[NSMutableArray alloc]init];
    _dictPeo       = [[NSMutableDictionary alloc]init];
    _teeDictChoose = [[NSMutableDictionary alloc]init];
    _isTee = NO;
    
    
    
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
    if (![Helper isBlankString:_strHole1]) {
        [dict setObject:_strHole1 forKey:@"region1"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择第一九洞" FromView:self.view];
    }
    if (![Helper isBlankString:_strHole2]) {
        [dict setObject:_strHole2 forKey:@"region2"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择第二九洞" FromView:self.view];
    }
    if (![Helper isBlankString:_strDateBegin]) {
        [dict setObject:[NSString stringWithFormat:@"%@ 00:00:00",_strDateBegin] forKey:@"createTime"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择打球时间" FromView:self.view];
    }
    
    
    
    NSMutableArray *userArray = [NSMutableArray array];
    for (int i=0; i<_teeDictChoose.count; i++) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        if (i == 0) {
            if (![Helper isBlankString:[_teeDictChoose allValues][i]]) {
                [dict1 setObject:[_teeDictChoose allValues][i] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            [dict1 setObject:DEFAULF_USERID forKey:@"userKey"];//用户Key
            
            
            [dict1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] forKey:@"userName"];// 用户名称
            [dict1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"userMobile"];// 手机号
        }
        else{
            if (![Helper isBlankString:[_teeDictChoose allValues][i]]) {
                [dict1 setObject:[_teeDictChoose allValues][i] forKey:@"tTaiwan"];// T台
            }
            else{
                [[ShowHUD showHUD]showToastWithText:@"请选择Tee台" FromView:self.view];
                return;
            }
            
            [dict1 setObject:[NSString stringWithFormat:@"%td",244+i] forKey:@"userKey"];//用户Key
            [dict1 setObject:[_dictPeo allValues][i-1] forKey:@"userName"];// 用户名称
            [dict1 setObject:[_dictPeo allKeys][i -1] forKey:@"userMobile"];// 手机号
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLChooseBallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChooseBallTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (![Helper isBlankString:_strBall]) {
            cell.labelTitle.text = _strBall;
        }
        else{
            cell.labelTitle.text = @"请选择球场";
        }
        return cell;
    }
    else if (indexPath.section == 1 || indexPath.section == 2)
    {
        ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
        
        NSArray *allValues = [_dataBallArray objectAtIndex:indexPath.section-1];
        //将数组显示至每行
        cell.textLabel.text = [allValues objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        JGLPlayDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                if (![Helper isBlankString:_strTee]) {
                    cell.iconImgv.hidden = NO;
                    [cell showTee:_strTee];
                }
                else{
                    cell.iconImgv.hidden = YES;
                    cell.labelTee.text = @"请选择tee台";
                }
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
    if (section == 1 || section == 2) {
        return 44* screenWidth / 375;
    }
    else{
        return 10* screenWidth / 375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       return  60* screenWidth / 375;
    }
    else if (indexPath.section == 4){
        return indexPath.row == 0 ? 44* screenWidth / 375 : 50* screenWidth / 375;
    }
    else{
        return 44 * screenWidth / 375;
    }
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        if (_isOpen[section])
        {
            //取出字典中的所有值 一个数组中放着三个小数组
            NSArray *allValues = [_dataBallArray objectAtIndex:section-1];
            
            //根据每个区 返回行数
            return [allValues count];
        }
        else//如果不等于当前打开的区号 就是合闭状态 用返回0行来模拟出闭合状态
            return 0;
    }
    else if (section == 4)
    {
        return section == 4 ? 3 + _dictPeo.count : 1;
    }
    else{
        return 1;
    }
}

#pragma mark -  表开合
- (void)headerButtonClick:(id)sender
{
    ////NSLog(@"%@",_strBall);
    if (_isTee == YES)  {
        [_chooseView removeFromSuperview];
        _isTee = NO;
    }
    if (![Helper isBlankString:_strBall]) {
        
        UIButton *button = (UIButton *)sender;
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        
    }
    else
    {
        ////NSLog(@"1");
    }
}





//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 43*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 1*ScreenWidth/375)];
        viewLine1.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        [headerView addSubview:viewLine1];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375);
        [headerView addSubview:btn];
        [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = HEADER_BUTTON1_TAG +  section;
        
        UIButton *buttonJt = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的tag 让其与区号产生联系
        buttonJt.tag = HEADER_BUTTON1_TAG +  section;
        //旋转或转换 CGAffineTransformIdentity意为回归原位
        buttonJt.transform = _isOpen[section]?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformIdentity;
        if (_isOpen[section]) {
            buttonJt.frame = CGRectMake(ScreenWidth-24*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375, 12*ScreenWidth/375);
        }
        else
        {
            buttonJt.frame = CGRectMake(ScreenWidth-22*ScreenWidth/375, 14*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375);
        }
        [buttonJt setBackgroundImage:[UIImage imageNamed:@"left_jt"] forState:UIControlStateNormal];
        SEL a = @selector(headerButtonClick:);
        [buttonJt addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:buttonJt];
        
        UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 60*ScreenWidth/375, 44*ScreenWidth/375)];
        headerTitleLabel.textAlignment = NSTextAlignmentLeft;
        NSArray* array = @[@"第一9洞",@"第二9洞"];
        headerTitleLabel.text = array[section-1];
        [headerView addSubview:headerTitleLabel];
        headerTitleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        
        UILabel* labelAreaDet = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 44*ScreenWidth/375)];
        labelAreaDet.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        labelAreaDet.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:labelAreaDet];
        labelAreaDet.tag = 1234 +  section;
        
        return headerView;
    }
    else{
        return nil;
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
        ballVc.callback1=^(NSDictionary *dict){
            [_dataBallArray removeAllObjects];
            if (dict.count != 0) {
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"tAll"]];
                
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
        UIButton *button = (UIButton *)[self.view viewWithTag:HEADER_BUTTON1_TAG + indexPath.section];
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        
        UILabel* label = (UILabel *)[self.view viewWithTag:1234+section];
        label.text = [NSString stringWithFormat:@"%@",_dataBallArray[indexPath.section-1][indexPath.row]];
        _strHole1 = _dataBallArray[indexPath.section-1][indexPath.row];
        
    }
    
    else if (indexPath.section == 2)
    {
        if (_isTee == YES)  {
            [_chooseView removeFromSuperview];
            _isTee = NO;
        }
        UIButton *button = (UIButton *)[self.view viewWithTag:HEADER_BUTTON1_TAG + indexPath.section];
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        //    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
        //    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        UILabel* label = (UILabel *)[self.view viewWithTag:1234+section];
        label.text = [NSString stringWithFormat:@"%@",_dataBallArray[indexPath.section-1][indexPath.row]];
        _strHole2 = _dataBallArray[indexPath.section-1][indexPath.row];
        
    }
    else if (indexPath.section == 3)
    {
        if (_isTee == YES)  {
            [_chooseView removeFromSuperview];
            _isTee = NO;
        }
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @1;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            _strDateBegin = dateStr;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:3];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:dateVc animated:YES];
    }
    else{
        if (indexPath.row == 1) {

            if (![Helper isBlankString:_strBall]) {
                if (_isTee == NO) {
                    JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[2] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[2] count]* 40*screenWidth/375) withArray:_dataBallArray[2]];
                    [tableView addSubview:_chooseView];
                    _chooseView.blockTeeName = ^(NSString *strT){
                        _strTee = strT;
                        NSLog(@"%td",indexPath.row);
                        [_teeDictChoose setObject:_strTee forKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]];
                        [_chooseView removeFromSuperview];
                        _isTee = NO;
                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:4];
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
            if (indexPath.row  == _dictPeo.count + 2) {
                JGLAddPlayerViewController* addVc = [[JGLAddPlayerViewController alloc]init];
                addVc.blockSurePlayer = ^(NSMutableDictionary *dict){
                    _dictPeo = dict;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
                    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                };
//                addVc.dictFin = _dictPeo;
//                addVc.dictPeople = _dictPeo;
                [self.navigationController pushViewController:addVc animated:YES];

            }
            else{
                if (![Helper isBlankString:_strBall]) {
                    if (_isTee == NO) {
                        JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                        _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[2] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[2] count]* 40*screenWidth/375) withArray:_dataBallArray[2]];
                        [tableView addSubview:_chooseView];
                        _chooseView.blockTeeName = ^(NSString *strT){
                            _strTee = strT;
                            [_teeDictChoose setObject:_strTee forKey:[NSString stringWithFormat:@"%td",indexPath.row - 1]];
                            [_chooseView removeFromSuperview];
                            _isTee = NO;
                            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:4];
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
