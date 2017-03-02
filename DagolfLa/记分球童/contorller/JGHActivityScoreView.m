//
//  JGHActivityScoreView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityScoreView.h"
#import "JGLTeeChooseView.h"
#import "JGLAddActiivePlayModel.h"
#import "JGLChooseScoreModel.h"
#import "JGLChoosesScoreTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "JGLPlayDateTableViewCell.h"
#import "JGLPlayerNameTableViewCell.h"
#import "JGLChangePlayerTableViewCell.h"

@interface JGHActivityScoreView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString* _strBall;//球场名
    NSInteger _ballId;//存球场id
    NSMutableArray* _dataBallArray;//球场对应数据
    NSString* _strDateBegin;//球场时间
    
    NSMutableArray *_selectAreaArray;//记录选择的区域0-1
    
}

@property (strong, nonatomic) UITableView* tableView;

@property (retain, nonatomic) NSMutableArray *palyArray;

@property (strong, nonatomic) NSMutableDictionary *teeDictChoose;//记录选择的t台存放数组

@property (nonatomic, retain)JGLTeeChooseView* chooseView;//tee台视图

@property (nonatomic, retain)UIButton *scoreBtn;

@end

@implementation JGHActivityScoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _dataBallArray  = [[NSMutableArray alloc]init];
        
        _teeDictChoose = [[NSMutableDictionary alloc]init];
        
        _selectAreaArray = [NSMutableArray array];
        
        _palyArray = [NSMutableArray array];
        
        NSString* str = [Helper returnCurrentDateString];
        NSArray* arr = [str componentsSeparatedByString:@" "];
        _strDateBegin = arr[0];
        [self uiConfig];
        [self createScoreBtn];
        
    }
    return self;
}

#pragma mark -- 下载数据
- (void)reloadData:(JGLChooseScoreModel *)model{
    _model = model;
    [self getBallCode];
    [self getUserInfo];
}

-(void)getUserInfo
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_model.timeKey forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    //    [dict setObject:_model.teamKey forKey:@"teamKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
            [model setValuesForKeysWithDictionary:[data objectForKey:@"teamMember"]];
            model.select = 1;
            model.remark = model.userName;
            if ([model.sex integerValue] == 0) {
                model.tTaiwan = @"红T";
            }else{
                model.tTaiwan = @"蓝T";
            }
            
            [_palyArray addObject:model];
            
            [_tableView reloadData];
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
            
            //添加默认勾选区域，2个全勾，其他不勾
            NSArray *ballAreasArray = [data objectForKey:@"ballAreas"];
            if (ballAreasArray.count == 2) {
                [_selectAreaArray addObject:@1];
                [_selectAreaArray addObject:@1];
                
                [_scoreBtn setBackgroundColor:[UIColor orangeColor]];
                _scoreBtn.userInteractionEnabled = YES;
            }else{
                for (int i=0; i<ballAreasArray.count; i++) {
                    [_selectAreaArray addObject:@0];
                }
            }
            
            [_tableView reloadData];
        }
//        else{
//            [Helper alertViewWithTitle:@"球场整修中" withBlock:^(UIAlertController *alertView) {
//                [self presentViewController:alertView animated:YES completion:nil];
//            }];
//        }
    }];
    
}


-(void)createScoreBtn
{
    _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scoreBtn.backgroundColor = [UIColor lightGrayColor];
    _scoreBtn.userInteractionEnabled = NO;
    [_scoreBtn setTitle:@"开始记分" forState:UIControlStateNormal];
    [_scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _scoreBtn.layer.masksToBounds = YES;
    [_scoreBtn addTarget:self action:@selector(professionalScore:) forControlEvents:UIControlEventTouchUpInside];
    _scoreBtn.layer.cornerRadius = 8*ScreenWidth/375;
    //btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*ScreenWidth/375 - 64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _scoreBtn.frame = CGRectMake(10*ScreenWidth/375, self.frame.size.height - 54*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self addSubview:_scoreBtn];
}
#pragma mark -- 开始记分
- (void)professionalScore:(UIButton *)btn{
    if (_dataBallArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"球场信息不全！" FromView:self];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (![Helper isBlankString:_strDateBegin]) {
        [dict setObject:[NSString stringWithFormat:@"%@ 00:00:00",_strDateBegin] forKey:@"createTime"];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请选择打球时间" FromView:self];
        return;
    }
    
    NSInteger selectCount = 0;
    for (int i=0; i<_selectAreaArray.count; i++) {
        NSInteger select = [_selectAreaArray[i] integerValue];
        if (select == 1) {
            selectCount += 1;
        }
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
        [[ShowHUD showHUD]showToastWithText:@"请选择2个球场区域" FromView:self];
        return;
    }
    
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"ballKey"];
    [dict setObject:_model.timeKey forKey:@"srcKey"];//
    [dict setObject:@(1) forKey:@"srcType"];//活动传1，罗开创说的
    
    NSMutableArray *userArray = [NSMutableArray array];
    
    for (int i=0; i<_palyArray.count; i++) {
        JGLAddActiivePlayModel *model = _palyArray[i];
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        [userDict setObject:model.userKey forKey:@"userKey"];
        [userDict setObject:model.remark forKey:UserName];
        if (model.mobile != nil) {
            [userDict setObject:model.mobile forKey:Mobile];
        }
        
        [userDict setObject:model.tTaiwan forKey:@"tTaiwan"];
        
        [userArray addObject:userDict];
    }
    
    [dict setObject:userArray forKey:@"userList"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/createScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            _blockSelectActivityScore([data objectForKey:@"scorekey"]);
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
            }
        }
    }];
    
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64 -60*ProportionAdapter) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
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
        cell.viewLine.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
        
        if ([[_selectAreaArray objectAtIndex:indexPath.row] integerValue] == 0) {
            
            cell.imgvState.image = [UIImage imageNamed:@"wuGou"];
        }else{
            
            cell.imgvState.image = [UIImage imageNamed:@"yigouxuan"];
        }
        
        NSArray *allValues = [_dataBallArray objectAtIndex:indexPath.section-1];
        //将数组显示至每行
        cell.textLabel.text = [allValues objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
//        cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
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
        }else if (indexPath.row -1 <_palyArray.count){
            JGLPlayerNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"%td", indexPath.row);
            [cell configJGLAddActiivePlayModel:_palyArray[indexPath.row -1]];
            
            return cell;
        }
        else
        {
            
            JGLChangePlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChangePlayerTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (_dataBallArray.count > 0) {
            return 1;
        }
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
        //        if (_dataBallArray.count != 0) {
        //            return [_dataBallArray[0] count];
        //        }
        //        else{
        //            return 0;
        //        }
        return _selectAreaArray.count;
    }
    else if (section == 3)
    {
        return _palyArray.count +2;
    }
    else{
        return 1;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (_chooseView != nil) {
      //  [_chooseView removeFromSuperview];
        //_chooseView = nil;
    //}
    
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1) {
        
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
            [[ShowHUD showHUD]showToastWithText:@"请先取消一项，再点选 !" FromView:self];
        }
        
        if (selectCount == 2) {
            [_scoreBtn setBackgroundColor:[UIColor orangeColor]];
            _scoreBtn.userInteractionEnabled = YES;
        }else{
            [_scoreBtn setBackgroundColor:[UIColor lightGrayColor]];
            _scoreBtn.userInteractionEnabled = NO;
        }
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else if (indexPath.section == 2)
    {
        _blockSelectActivityScoreDate();
    }
    else{
        if (indexPath.row == 0) {
            
        }else{
            if (indexPath.row  == _palyArray.count + 1) {
                _blockSelectActivityScorePalyer(_palyArray, _model);
            }else{
                if (_chooseView != nil) {
                    [_chooseView removeFromSuperview];
                    _chooseView = nil;
                }else{
                    JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                    [tableView addSubview:_chooseView];
                    __weak JGHActivityScoreView *weakSelf = self;
                    _chooseView.blockTeeName = ^(NSString *strT){
                        
                        JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
                        NSLog(@"indexPath.row -1 == %td", indexPath.row -1);
                        model = _palyArray[indexPath.row -1];
                        model.tTaiwan = strT;
                        
                        [weakSelf.chooseView removeFromSuperview];
                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:3];
                        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                        [weakSelf.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                }
                
            }
        }
    }
}

#pragma mark -- 打球人
- (void)reloadPalyerArray:(NSMutableArray *)palerArray{
    //分配T台信息
    //存在T台数据，保留；否则重新设置默认T台数据
    for (int i=0; i<palerArray.count; i++) {
        JGLAddActiivePlayModel *newModel = [[JGLAddActiivePlayModel alloc]init];
        newModel = palerArray[i];
        //是否存在T台数据
        if (newModel.tTaiwan == nil) {
            //填充默认T台
            if ([newModel.sex integerValue] == 0) {
                newModel.tTaiwan = @"红T";
            }else{
                newModel.tTaiwan = @"蓝T";
            }
        }
    }
    
    _palyArray = [palerArray mutableCopy];
    
    _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64 -60*ProportionAdapter);
    [_tableView reloadData];
}
#pragma mark --刷新时间
-(void)reloadTime:(NSString *)time{
    _strDateBegin = time;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
