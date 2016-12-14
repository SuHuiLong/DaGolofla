//
//  JGLSelfScoreViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieSelfScoreViewController.h"
#import "JGHScoresViewController.h"

#import "JGLCaddieSelfAddPlayerViewController.h"
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
@interface JGLCaddieSelfScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    BOOL _isOpen[3];//控制表开合
    NSString* _strBall;//球场名
    NSInteger _ballId;//存球场id
    NSMutableArray* _dataBallArray;//球场对应数据
    NSString* _strDateBegin;//球场时间
//    JGLTeeChooseView* _chooseView;//tee台视图
//    BOOL _isTee;//是否选择了Tee台
//    NSString* _strTee;//用来记录选择的Tee台
    NSNumber* _numTimeKeyLogo;//记录球场头像
//    NSMutableDictionary* _teeDictChoose;//记录选择的t台存放数组
    
//    NSMutableDictionary *_dictPeo,*_dictFri,*_dictAdd;
    NSMutableDictionary* _dictArea; //选择的分区
//    BOOL _isClickArea;//首次进入后则默认选择前两个区域，
    
    NSMutableArray *_selectAreaArray;//记录选择的区域0-1
    
}
@property (strong, nonatomic) UITableView* tableView;

@property (strong, nonatomic)NSMutableArray *palyArray;

@property (strong, nonatomic)JGLTeeChooseView* chooseView;//tee台视图

@end

@implementation JGLCaddieSelfScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记分";
    self.palyArray = [NSMutableArray array];
    
    NSMutableDictionary *defDict = [NSMutableDictionary dictionary];
    [defDict setObject:_userNamePlayer forKey:UserName];
    [defDict setObject:_userKeyPlayer forKey:UserKey];
    if (_userMobilePlayer != nil) {
        [defDict setObject:_userMobilePlayer forKey:Mobile];
    }
    
    if (_sex == 0) {
        [defDict setObject:@"红T" forKey:@"tTaiwan"];
    }else{
        [defDict setObject:@"蓝T" forKey:@"tTaiwan"];
    }
    
    [defDict setObject:@1 forKey:@"userType"];
    [self.palyArray addObject:defDict];
    
    _selectAreaArray = [NSMutableArray array];
    
    _dataBallArray = [[NSMutableArray alloc]init];
    
    NSString* str = [Helper returnCurrentDateString];
    NSArray* arr = [str componentsSeparatedByString:@" "];///截断时间，存入字符串
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
    
    NSInteger selectCount = 0;
    for (int i=0; i<_selectAreaArray.count; i++) {
        NSInteger select = [_selectAreaArray[i] integerValue];
        if (select == 1) {
            selectCount += 1;
        }
    }
    
    if (_dataBallArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"球场信息不全！" FromView:self.view];
        return;
    }
    
    if (selectCount == 2) {
        
        NSArray *areaArray = _dataBallArray[0];
        for (int i=0; i<_selectAreaArray.count; i++) {
            NSInteger select = [_selectAreaArray[i] integerValue];
            if (select == 1) {
                if ([dict objectForKey:@"region1"]) {
                    //2
                    [dict setObject:areaArray[i] forKey:@"region2"];
                }else{
                    //1
                    [dict setObject:areaArray[i] forKey:@"region1"];
                }
            }
        }
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请选择2个球场区域" FromView:self.view];
        return;
    }
    
    if (![Helper isBlankString:_strDateBegin]) {
        [dict setObject:[NSString stringWithFormat:@"%@ 00:00:00",_strDateBegin] forKey:@"createTime"];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请选择打球时间" FromView:self.view];
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"ballKey"];
    [dict setObject:@02 forKey:@"srcKey"];//
    [dict setObject:@(0) forKey:@"srcType"];//活动传1，罗开创说的
    
    //球童记分必须包含自己
    NSMutableDictionary *selfDict = [NSMutableDictionary dictionary];
    [selfDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [selfDict setObject:@1 forKey:@"userType"];
    [selfDict setObject:@"蓝T" forKey:@"tTaiwan"];
    [selfDict setObject:_userNamePlayer forKey:UserName];
    [self.palyArray addObject:selfDict];
    
    for (int i=0; i<_palyArray.count; i++) {
        NSMutableDictionary *palDict = [NSMutableDictionary dictionary];
        palDict = _palyArray[i];
        [palDict setObject:@1 forKey:@"userType"];
        [self.palyArray replaceObjectAtIndex:i withObject:palDict];
    }
    
    //球童必须第一位
    [self.palyArray exchangeObjectAtIndex:0 withObjectAtIndex:self.palyArray.count-1];
    
    [dict setObject:self.palyArray forKey:@"userList"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/createScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        btn.userInteractionEnabled = YES;
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-118*ProportionAdapter) style:UITableViewStylePlain];
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
            [cell.iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"ball" andTeamKey:[_numTimeKeyLogo integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        }
        else{
            cell.labelTitle.text = @"请选择球场";
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
        
        NSLog(@"%td", indexPath.row);
        if ([[_selectAreaArray objectAtIndex:indexPath.row] integerValue] == 0) {
            
            cell.imgvState.image = [UIImage imageNamed:@"wuGou"];
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
        }else if (indexPath.row -1 < self.palyArray.count) {
            JGLPlayerNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *cellDict = self.palyArray[indexPath.row -1];
            
            cell.labelName.text = [cellDict objectForKey:UserName];
            [cell showTee:[cellDict objectForKey:@"tTaiwan"]];
            
            return cell;
        }else{
            JGLChangePlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChangePlayerTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
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
        return self.palyArray.count +2;
    }
    else{
        return 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chooseView != nil)  {
        [_chooseView removeFromSuperview];
        _chooseView = nil;
    }
    
    if (indexPath.section == 0) {
        //球场
        BallParkViewController* ballVc = [[BallParkViewController alloc]init];
        ballVc.type1=1;
        ballVc.callback1=^(NSDictionary *dict, NSNumber *num){
            [_dataBallArray removeAllObjects];
            [_selectAreaArray removeAllObjects];
            
            if (dict.count != 0) {
                //添加默认勾选区域，2个全勾，其他不勾
                NSArray *ballAreasArray = [dict objectForKey:@"ballAreas"];
                if (ballAreasArray.count == 2) {
                    [_selectAreaArray addObject:@1];
                    [_selectAreaArray addObject:@1];
                }else{
                    for (int i=0; i<ballAreasArray.count; i++) {
                        [_selectAreaArray addObject:@0];
                    }
                }
                
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"tAll"]];
                _numTimeKeyLogo = num;
            }
            [_tableView reloadData];
        };
        [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
            _strBall = balltitle;
            _ballId = ballid;
        }];
        [self.navigationController pushViewController:ballVc animated:YES];
    }else if (indexPath.section == 1) {
        NSLog(@"%td", indexPath.row);
        
        
        //        if (selectCount >= 2) {
        //            [[ShowHUD showHUD]showToastWithText:@"请先取消一项，再点选 !" FromView:self.view];
        //        }else{
        if ([[_selectAreaArray objectAtIndex:indexPath.row] integerValue] == 0) {
            
            
            [_selectAreaArray replaceObjectAtIndex:indexPath.row withObject:@1];
        }else{
            
            [_selectAreaArray replaceObjectAtIndex:indexPath.row withObject:@0];
            
        }
        
        //最多勾选2个
        NSInteger selectCount = 0;
        for (int i=0; i<_selectAreaArray.count; i++) {
            selectCount += [_selectAreaArray[i] integerValue];
        }
        
        if (selectCount > 2) {
            [_selectAreaArray replaceObjectAtIndex:indexPath.row withObject:@0];
            [[ShowHUD showHUD]showToastWithText:@"请先取消一项，再点选 !" FromView:self.view];
        }
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        //        }
        
    }else if (indexPath.section == 2){
        
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @1;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            _strDateBegin = dateStr;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:dateVc animated:YES];
    }else{
        
        if (![Helper isBlankString:_strBall]) {
            NSLog(@"%td", indexPath.row);
            
            if (_chooseView != nil) {
                [_chooseView removeFromSuperview];
                _chooseView = nil;
            }else{
                if (indexPath.row -1 < self.palyArray.count) {
                    JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                    [tableView addSubview:_chooseView];
                    
                    __weak JGLCaddieSelfScoreViewController *weakSelf = self;
                    _chooseView.blockTeeName = ^(NSString *strT){
                        NSLog(@"%td",indexPath.row);
                        //替换T台
                        NSMutableArray *preCopyArray = [weakSelf.palyArray mutableCopy];
                        NSMutableDictionary *preDict = weakSelf.palyArray[indexPath.row -1];
                        [preDict setObject:strT forKey:@"tTaiwan"];
                        [preCopyArray replaceObjectAtIndex:indexPath.row -1 withObject:preDict];
                        weakSelf.palyArray = [preCopyArray mutableCopy];
                        
                        [weakSelf.chooseView removeFromSuperview];
                        weakSelf.chooseView = nil;
                        
                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:3];
                        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                        [weakSelf.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                    
                }else{
                    JGLCaddieSelfAddPlayerViewController* addVc = [[JGLCaddieSelfAddPlayerViewController alloc]init];
                    addVc.blockSurePlayer = ^(NSMutableArray *array){
                    
                        for (int i=0; i<array.count; i++) {
                            NSMutableDictionary *palyDict = [NSMutableDictionary dictionary];
                            palyDict = array[i];
                            
                            if ([palyDict objectForKey:@"tTaiwan"]) {
//                                break;
                            }else{
                                if ([[palyDict objectForKey:@"sex"] integerValue] == 0) {
                                    [palyDict setObject:@"红T" forKey:@"tTaiwan"];
                                }else{
                                    [palyDict setObject:@"蓝T" forKey:@"tTaiwan"];
                                }
                            }
                            
                            [palyDict setObject:@1 forKey:@"userType"];
                            
                            [array replaceObjectAtIndex:i withObject:palyDict];
                        }
                        
                        _palyArray = array;
                        
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                    
                    addVc.palyArray = _palyArray;
                    [self.navigationController pushViewController:addVc animated:YES];
                }
            }
        }else{
            [[ShowHUD showHUD]showToastWithText:@"请先选择球场" FromView:self.view];
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
