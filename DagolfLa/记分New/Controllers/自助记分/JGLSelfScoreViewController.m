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

#import "JGLChooseBallTableViewCell.h"
#import "ScoreTableViewCell.h"
#import "JGLPlayDateTableViewCell.h"
#import "JGLPlayerNameTableViewCell.h"
#import "JGLChangePlayerTableViewCell.h"
#define HEADER_BUTTON1_TAG 100
#define HEADER_BUTTON2_TAG 1000
#define HEADER_BUTTON3_TAG 10000
@interface JGLSelfScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    BOOL _isOpen[3];//控制表开合
}
@end

@implementation JGLSelfScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记分";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"qer" style:(UIBarButtonItemStylePlain) target:self action:@selector(activeItem)];
    self.navigationItem.rightBarButtonItem = item;
    item.tintColor = [UIColor whiteColor];
    [self uiConfig];
    [self createScoreBtn];
    
    [self getBallCode];
}

#pragma mark -- 获取球场区和T台
- (void)getBallCode{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"12" forKey:@"ballKey"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getBallCode" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
        }else{
            
        }
    }];
}

-(void)activeItem
{
    JGLChooseScoreViewController* chooseVc = [[JGLChooseScoreViewController alloc]init];
    [self.navigationController pushViewController:chooseVc animated:YES];
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
    [dict setObject:@"244" forKey:@"userKey"];
    [dict setObject:@"12" forKey:@"ballKey"];
    [dict setObject:DEFAULF_USERID forKey:@"srcKey"];
    [dict setObject:@(0) forKey:@"srcType"];
    [dict setObject:@"A区" forKey:@"region1"];
    [dict setObject:@"B区" forKey:@"region2"];
    [dict setObject:@"2016-07-20 12:30:40" forKey:@"createTime"];
    
    NSMutableArray *userArray = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"白T" forKey:@"tTaiwan"];// T台
        [dict setObject:[NSString stringWithFormat:@"%d", 244 + i] forKey:@"userKey"];//用户Key
        [dict setObject:[NSString stringWithFormat:@"dsd%d", i] forKey:@"userName"];// 用户名称
        [dict setObject:[NSString stringWithFormat:@"1872111036%d", i] forKey:@"userMobile"];// 手机号
        [userArray addObject:dict];
    }

    [dict setObject:userArray forKey:@"userList"];
//    [dict setObject:DEFAULF_USERID forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/createScore" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
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
        return cell;
    }
    else if (indexPath.section == 1 || indexPath.section == 2)
    {
        ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 3)
    {
        JGLPlayDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            JGLPlayerNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLPlayerNameTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            NSLog(@"%td",indexPath.row);
            JGLChangePlayerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChangePlayerTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
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
        return indexPath.row == 0 ? 80* screenWidth / 375 : 50* screenWidth / 375;
    }
    else{
        return 44 * screenWidth / 375;
    }
}

//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        //如果当前区为打开状态
        if (_isOpen[section])
        {
            return 3;
        }
        else//如果不等于当前打开的区号 就是合闭状态 用返回0行来模拟出闭合状态
            return 0;
    }
    else if (section == 4)
    {
        return section == 4 ? 2 : 1;
    }
    else{
        return 1;
    }
}

#pragma mark -  表开合
- (void)headerButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //根据button 获取区号
    NSInteger section = button.tag - HEADER_BUTTON1_TAG;
    
    //改变BOOL数组中 该区的开合状态
    //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
    //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
    _isOpen[section] = !_isOpen[section];
    
    //刷新某些区
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    //刷新某些特定行

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
