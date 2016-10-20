//
//  JGLTeamSignUpSuccViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamSignUpSuccViewController.h"
#import "JGLSignSuccFinishViewController.h"
#import "JGLMyTeamModel.h"
@interface JGLTeamSignUpSuccViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tabeleView;
    NSMutableArray* _dataArray;
    BOOL _isHide;//控制球队列表的展示和隐藏
    int _page;
    NSString* _strTeamName;//球队的名称
    UILabel* _labelBallName;
    UITextField* _textFieldName, *_textFieldMobile;
    NSNumber * _teamKey;
}
@end

@implementation JGLTeamSignUpSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _isHide = YES;//等于yes的时候隐藏，否则显示
    _dataArray = [[NSMutableArray alloc]init];
    _strTeamName = @"请选择球队";
    self.title = @"球队报名";
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    [self createSignTeam];
    [self createContectTeam];
    [self createNameTeam];
    [self createBtn];
    
    _tabeleView = [[UITableView alloc]initWithFrame:CGRectMake(90*ProportionAdapter, 54*ProportionAdapter, screenWidth - 100*ProportionAdapter, 200*ProportionAdapter) style:UITableViewStylePlain];
    _tabeleView.dataSource = self;
    _tabeleView.delegate = self;
    [self.view addSubview:_tabeleView];
    _tabeleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabeleView.hidden = YES;
    [self headerRefreshing];
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)finishClick:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    //    JGLSignSuccFinishViewController* finVc = [[JGLSignSuccFinishViewController alloc]init];
    //    [self.navigationController pushViewController:finVc animated:YES];
    
    if ([_strTeamName isEqualToString:@"请选择球队"] == YES) {
        [[ShowHUD showHUD]showToastWithText:@"您的球队尚未选择" FromView:self.view];
        btn.userInteractionEnabled = YES;
        return;
    }
    if ([Helper isBlankString:_textFieldName.text]) {
        [[ShowHUD showHUD]showToastWithText:@"报名人姓名尚未填写" FromView:self.view];
        btn.userInteractionEnabled = YES;
        return;
    }
    if ([Helper isBlankString:_textFieldMobile.text]) {
        [[ShowHUD showHUD]showToastWithText:@"报名人手机号尚未填写" FromView:self.view];
        btn.userInteractionEnabled = YES;
        return;
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:self.matchKey forKey:@"matchKey"];
    [dict setObject:_textFieldName.text forKey:@"userName"];
    [dict setObject:_textFieldMobile.text forKey:@"userMobile"];
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"match/joinMatch" JsonKey:nil withData:dict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            JGLSignSuccFinishViewController *succVC = [[JGLSignSuccFinishViewController alloc] init];
            [self.navigationController pushViewController:succVC animated:YES];
            
            //                        [self scoresResult];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
            
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                
            }
        }
        btn.userInteractionEnabled = YES;
    }];
}

-(void)createNameTeam
{
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 87*ProportionAdapter, 80*ProportionAdapter, 20*ProportionAdapter)];
    labelName.text = @"报名人";
    labelName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:labelName];
    
    
    _textFieldName = [[UITextField alloc]initWithFrame:CGRectMake(90*ProportionAdapter, 80*ProportionAdapter, screenWidth - 100*ProportionAdapter, 34*ProportionAdapter)];
    _textFieldName.delegate = self;
    _textFieldName.borderStyle = UITextBorderStyleNone;
    _textFieldName.placeholder = @"请输入报名人姓名";
    [self.view addSubview:_textFieldName];
    _textFieldName.backgroundColor = [UIColor whiteColor];
    _textFieldName.layer.cornerRadius = 8;
    _textFieldName.layer.masksToBounds = YES;
    
    //    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 34*ProportionAdapter, screenWidth-100*ProportionAdapter, 1*ProportionAdapter)];
    //    view.backgroundColor = [UIColor darkGrayColor];
    //    [_textFieldName addSubview:view];
    
}

-(void)createContectTeam
{
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 147*ProportionAdapter, 80*ProportionAdapter, 20*ProportionAdapter)];
    labelName.text = @"手机号";
    labelName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:labelName];
    
    
    _textFieldMobile = [[UITextField alloc]initWithFrame:CGRectMake(90*ProportionAdapter, 140*ProportionAdapter, screenWidth - 100*ProportionAdapter, 34*ProportionAdapter)];
    _textFieldMobile.delegate = self;
    _textFieldMobile.borderStyle = UITextBorderStyleNone;
    _textFieldMobile.placeholder = @"请输入报名人手机号码";
    [self.view addSubview:_textFieldMobile];
    _textFieldMobile.backgroundColor = [UIColor whiteColor];
    _textFieldMobile.layer.cornerRadius = 8;
    _textFieldMobile.layer.masksToBounds = YES;
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 34*ProportionAdapter, screenWidth-100*ProportionAdapter, 1*ProportionAdapter)];
    view.backgroundColor = [UIColor darkGrayColor];
    [_textFieldMobile addSubview:view];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 220*ProportionAdapter, screenWidth - 20*ProportionAdapter, 20*ProportionAdapter)];
    label.text = @"提交完成后，即可在球队内部发起赛事报名！";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:label];
    
}
-(void)createSignTeam
{
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 27*ProportionAdapter, 80*ProportionAdapter, 20*ProportionAdapter)];
    labelName.text = @"报名球队";
    labelName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:labelName];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(90*ProportionAdapter, 20*ProportionAdapter, screenWidth - 100*ProportionAdapter, 34*ProportionAdapter);
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 6*ProportionAdapter;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(hideTableClick:) forControlEvents:UIControlEventTouchUpInside];
    //selectright
    _labelBallName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 140*ProportionAdapter, 34*ProportionAdapter)];
    _labelBallName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    _labelBallName.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    _labelBallName.text = _strTeamName;
    _labelBallName.layer.cornerRadius = 6*ProportionAdapter;
    _labelBallName.layer.masksToBounds = YES;
    [btn addSubview:_labelBallName];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 140*ProportionAdapter, 0, 40*ProportionAdapter, 34*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"selectright"];
    [btn addSubview:imgv];
    
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyAdoptTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0){
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [data objectForKey:@"teamList"]) {
                JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page++;
            [_tabeleView reloadData];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
}
#pragma mark 开始进入刷新状态
- (void)headerRefreshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

-(void)hideTableClick:(UIButton *)btn
{
    if (_isHide == YES) {
        _tabeleView.hidden = NO;
        _isHide = NO;
    }
    else{
        _tabeleView.hidden = YES;
        _isHide = YES;
    }
}
#pragma mark --tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JGLMyTeamModel* model = _dataArray[indexPath.row];
    cell.textLabel.text = model.name;//表示这个数组里买呢有多少区。区里面有多少行
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLMyTeamModel* model = _dataArray[indexPath.row];
    _labelBallName.text = model.name;
    _strTeamName = model.name;
    _tabeleView.hidden = YES;
    _isHide = YES;
    _teamKey = model.teamKey;
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
