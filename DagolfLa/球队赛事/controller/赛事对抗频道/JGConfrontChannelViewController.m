//
//  JGConfrontChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/9/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGConfrontChannelViewController.h"
#import "JGHPublishEventViewController.h"
#import "JGDHotMatchTableViewCell.h"
#import "JGHEventDetailsViewController.h"

#import "JGDCheckScoreViewController.h" // 查看成绩
#import "JGDSetConfrontViewController.h" // 设置对抗

@interface JGConfrontChannelViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headBackView;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIButton *myMatchBtn;
@property (nonatomic, strong) UIButton *hotMatchBtn;
@property (nonatomic, strong) UIView *sectionHeadView;

@end

@implementation JGConfrontChannelViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"all_back"] forState:(UIControlStateNormal)];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[JGDHotMatchTableViewCell class] forCellReuseIdentifier:@"hotMatch"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(160 * ProportionAdapter, 20 * ProportionAdapter, 120 * ProportionAdapter, 30 * ProportionAdapter)];
    titleLB.text = @"赛事对抗";
    
    // 发布按钮
    UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(260 * ProportionAdapter, 20 * ProportionAdapter, 120 * ProportionAdapter, 30 * ProportionAdapter)];
    [postButton setTitle:@"发布对抗赛" forState:(UIControlStateNormal)];
    [postButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [postButton addTarget:self action:@selector(postAct) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 表头
    self.headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200 * ProportionAdapter)];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200 * ProportionAdapter)];
    imageV.backgroundColor = [UIColor orangeColor];
    imageV.userInteractionEnabled = YES;
    
    [self.headBackView addSubview:imageV];
    [self.headBackView addSubview: postButton];
    [self.headBackView addSubview:backBtn];
    [self.headBackView addSubview:titleLB];
    
    self.tableView.tableHeaderView = self.headBackView;
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60 * ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60 * ProportionAdapter)];
    self.sectionHeadView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.sectionHeadView addSubview:view];
    
    // 我的赛事
    self.myMatchBtn = [[UIButton alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 0 * ProportionAdapter, 150 * ProportionAdapter, 50 * ProportionAdapter)];
    //    [self.myMatchBtn setImage:[UIImage imageNamed:@"hotfight"] forState:(UIControlStateNormal)];
    [self.myMatchBtn setTitle:@"我的对抗赛" forState:(UIControlStateNormal)];
    [self.myMatchBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.sectionHeadView addSubview:self.myMatchBtn];
    self.myMatchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100 * ProportionAdapter);
    [self.myMatchBtn addTarget:self action:@selector(myMatchAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myMatchBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    // 热门赛事
    self.hotMatchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 0 * ProportionAdapter, 150 * ProportionAdapter, 50 * ProportionAdapter)];
    //    [self.hotMatchBtn setImage:[UIImage imageNamed:@"minefight"] forState:(UIControlStateNormal)];
    [self.hotMatchBtn setTitle:@"热门对抗赛" forState:(UIControlStateNormal)];
    [self.hotMatchBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.sectionHeadView addSubview:self.hotMatchBtn];
    self.hotMatchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100 * ProportionAdapter);
    [self.hotMatchBtn addTarget:self action:@selector(hotMatchAct:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
    
    
    
    
    return self.sectionHeadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDHotMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotMatch"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 * ProportionAdapter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        
        JGDCheckScoreViewController *checkScoreV = [[JGDCheckScoreViewController alloc] init];
        [self.navigationController pushViewController:checkScoreV animated:YES];
        
    }else if (indexPath.row == 2) {
        
        JGDSetConfrontViewController *setConfVC = [[JGDSetConfrontViewController alloc] init];
        [self.navigationController pushViewController:setConfVC animated:YES];
        
    }else{
        
        JGHEventDetailsViewController *deatilCtrl = [[JGHEventDetailsViewController alloc]init];
        [self.navigationController pushViewController:deatilCtrl animated:YES];
        
    }
    
}


//  我的对抗赛
- (void)myMatchAct:(UIButton *)btn{
    if (self.rightView.hidden == YES) {
        self.rightView.hidden = NO;
        self.leftView.hidden = YES;
    }
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.hotMatchBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@0 forKey:@"offset"];
    [dic setObject:@244 forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:@"userKey=244dagolfla.com"] forKey:@"md5"];
    
    
    [[JsonHttp jsonHttp] httpRequest:@"match/getMyMatchList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSLog(@"--mine--");
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
}

//  热门对抗赛
- (void)hotMatchAct:(UIButton *)btn{
    if (self.leftView.hidden == YES) {
        self.leftView.hidden = NO;
        self.rightView.hidden = YES;
    }
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.myMatchBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@0 forKey:@"offset"];
    [dic setObject:@244 forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:@"userKey=244dagolfla.com"] forKey:@"md5"];
    
    
    [[JsonHttp jsonHttp] httpRequest:@"match/getHotMatchList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSLog(@"--hot--");
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

// 发布赛事
- (void)postAct{
    NSLog(@" 发 布 赛 事 ");
    JGHPublishEventViewController *publishCtrl = [[JGHPublishEventViewController alloc]init];
    [self.navigationController pushViewController:publishCtrl animated:YES];
}


- (UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth / 2, 48, screenWidth / 2, 2 * ProportionAdapter)];
        _rightView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [self.sectionHeadView addSubview:_rightView];
    }
    return _rightView;
}

- (UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, screenWidth / 2, 2 * ProportionAdapter)];
        _leftView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [self.sectionHeadView addSubview:_leftView];
    }
    return _leftView;
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
