//
//  JGHScoreView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoreView.h"
#import "JGLTeeChooseView.h"
#import "JGLChooseBallTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "JGLPlayDateTableViewCell.h"
#import "JGLPlayerNameTableViewCell.h"
#import "JGLChangePlayerTableViewCell.h"

@interface JGHScoreView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString* _strBall;//球场名
    NSInteger _ballId;//存球场id
    NSMutableArray* _dataBallArray;//球场对应数据
    NSString* _strDateBegin;//球场时间
    
    NSInteger _numTimeKeyLogo;//记录球场头像
    
    NSMutableArray *_selectAreaArray;//记录选择的区域0-1
    
}
@property (strong, nonatomic) UITableView* tableView;

@property (nonatomic, retain)NSMutableArray *preListArray;

@property (nonatomic, retain)JGLTeeChooseView *chooseView;//tee台视图

@property (nonatomic, retain)UIButton *scoreBtn;

@end

@implementation JGHScoreView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.preListArray = [NSMutableArray array];
        
        NSMutableDictionary *selfDict = [NSMutableDictionary dictionary];
        [selfDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserName] forKey:UserName];
        [selfDict setObject:DEFAULF_USERID forKey:UserKey];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:Mobile]) {
            [selfDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:Mobile] forKey:@"userMobile"];
        }
        
        NSInteger sex;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sex"]) {
            sex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue];
        }
        
        if (sex == 0) {
            [selfDict setObject:@"红T" forKey:@"tTaiwan"];
        }else{
            [selfDict setObject:@"蓝T" forKey:@"tTaiwan"];
        }
        
        [selfDict setObject:@0 forKey:@"sourceKey"];// 自己
        
        [self.preListArray addObject:selfDict];
        
        _selectAreaArray = [NSMutableArray array];
        
        _dataBallArray = [[NSMutableArray alloc]init];
        
        NSString* str = [Helper returnCurrentDateString];
        NSArray* arr = [str componentsSeparatedByString:@" "];///截断时间，存入字符串
        _strDateBegin = arr[0];
        [self uiConfig];
        [self createScoreBtn];
    }
    return self;
}

- (void)reloadDataBallArray:(NSArray *)dataBallArray andSelectAreaArray:(NSArray *)selectAreaArray andNumTimeKeyLogo:(NSInteger)numTimeKeyLogo{
    _dataBallArray = [dataBallArray mutableCopy];
    _selectAreaArray = [selectAreaArray mutableCopy];
    _numTimeKeyLogo = numTimeKeyLogo;
    [_scoreBtn setBackgroundColor:[UIColor orangeColor]];
    _scoreBtn.userInteractionEnabled = YES;
    [self.tableView reloadData];
}
- (void)reloadBallName:(NSString *)ballName andBallId:(NSInteger)ballID{
    _strBall = ballName;
    _ballId = ballID;
    NSIndexPath *indexBall = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexBall];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)reloadTime:(NSString *)time{
    _strDateBegin = time;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
- (void)reloadPalyerArray:(NSArray *)palerArray{
    self.preListArray = [palerArray mutableCopy];
    
    //判断是否包含红、蓝T
    NSArray *tTaiwanArray = [NSArray array];
    if (_dataBallArray.count > 1) {
        tTaiwanArray = _dataBallArray[1];
    }
    
    NSMutableArray *copyPreListArray = [self.preListArray mutableCopy];
    //默认T台--自己除外
    for (int i=1; i<self.preListArray.count; i++) {
        NSMutableDictionary *preDict = [self.preListArray[i] mutableCopy];
        if (![preDict objectForKey:@"tTaiwan"]) {
            if ([preDict objectForKey:@"sex"]) {
                if ([[preDict objectForKey:@"sex"] integerValue] == 0) {
                    [preDict setObject:@"红T" forKey:@"tTaiwan"];
                }else{
                    [preDict setObject:@"蓝T" forKey:@"tTaiwan"];
                }
            }else{
                if (tTaiwanArray.count == 0) {
                    [preDict setObject:[tTaiwanArray objectAtIndex:0] forKey:@"tTaiwan"];
                }else{
                    [preDict setObject:@"蓝T" forKey:@"tTaiwan"];
                }
            }
        }
        
        [copyPreListArray replaceObjectAtIndex:i withObject:preDict];
    }
    
    self.preListArray = [copyPreListArray mutableCopy];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)createScoreBtn
{
    _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_scoreBtn setTitle:@"开始记分" forState:UIControlStateNormal];
    [_scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _scoreBtn.layer.masksToBounds = YES;
    [_scoreBtn setBackgroundColor:[UIColor lightGrayColor]];
    _scoreBtn.userInteractionEnabled = NO;
    [_scoreBtn addTarget:self action:@selector(professionalScore:) forControlEvents:UIControlEventTouchUpInside];
    _scoreBtn.layer.cornerRadius = 8*ScreenWidth/375;
    _scoreBtn.frame = CGRectMake(10*ScreenWidth/375, self.frame.size.height - 54*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self addSubview:_scoreBtn];
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
        [[ShowHUD showHUD]showToastWithText:@"球场信息不全！" FromView:self];
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
        [[ShowHUD showHUD]showToastWithText:@"请选择2个球场区域" FromView:self];
        return;
    }
    
    if (![Helper isBlankString:_strDateBegin]) {
        [dict setObject:[NSString stringWithFormat:@"%@ 00:00:00",_strDateBegin] forKey:@"createTime"];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请选择打球时间" FromView:self];
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"ballKey"];
    [dict setObject:@0 forKey:@"srcKey"];//
    [dict setObject:@(0) forKey:@"srcType"];//活动传1，罗开创说的
    [dict setObject:self.preListArray forKey:@"userList"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/createScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        btn.userInteractionEnabled = YES;
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            _blockSelectScore([data objectForKey:@"scorekey"]);
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
            }
        }
    }];
}
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64 -54*ProportionAdapter) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
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
            [cell.iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"ball" andTeamKey:_numTimeKeyLogo andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
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
        }else if (indexPath.row -1 < self.preListArray.count) {
            JGLPlayerNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *cellDict = self.preListArray[indexPath.row -1];
            
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
        return self.preListArray.count +2;
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
        _blockSelectBall();
    }else if (indexPath.section == 1) {
        NSLog(@"%td", indexPath.row);
        
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
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if (indexPath.section == 2){
        _blockSelectTime();
    }else{
        
        if (![Helper isBlankString:_strBall]) {
            NSLog(@"%td", indexPath.row);
            
            if (_chooseView != nil) {
                [_chooseView removeFromSuperview];
                _chooseView = nil;
            }else{
                if (indexPath.row -1 < self.preListArray.count) {
                    JGLPlayerNameTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    _chooseView = [[JGLTeeChooseView alloc]initWithFrame:CGRectMake(screenWidth - 120*screenWidth/375,  cell.frame.origin.y - [_dataBallArray[1] count]* 40*screenWidth/375, 100*screenWidth/375, [_dataBallArray[1] count]* 40*screenWidth/375) withArray:_dataBallArray[1]];
                    [tableView addSubview:_chooseView];
                    
                    __weak JGHScoreView *weakSelf = self;
                    _chooseView.blockTeeName = ^(NSString *strT){
                        NSLog(@"%td",indexPath.row);
                        //替换T台
                        NSMutableArray *preCopyArray = [weakSelf.preListArray mutableCopy];
                        NSMutableDictionary *preDict = weakSelf.preListArray[indexPath.row -1];
                        [preDict setObject:strT forKey:@"tTaiwan"];
                        [preCopyArray replaceObjectAtIndex:indexPath.row -1 withObject:preDict];
                        weakSelf.preListArray = [preCopyArray mutableCopy];
                        
                        [weakSelf.chooseView removeFromSuperview];
                        weakSelf.chooseView = nil;
                        
                        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:3];
                        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                        [weakSelf.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                    
                }else{
                    _blockSelectPalyer(self.preListArray);
                }
            }
        }else{
            [[ShowHUD showHUD]showToastWithText:@"请先选择球场" FromView:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
