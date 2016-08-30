
//
//  JGDGuestPayViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDGuestPayViewController.h"
#import "JGDGuestTableViewCell.h"
#import "JGTeamAcitivtyModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JGTeamChannelViewController.h"


@interface JGDGuestPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JGTeamAcitivtyModel * model;
@property (nonatomic, strong) NSMutableArray *costArray;

@property (nonatomic, strong) NSMutableDictionary *teamSignUpDic;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *almostTF;
@property (nonatomic, strong) UITextField *mobileTF;
@property (nonatomic, strong) NSMutableDictionary *infoDic;
@property (nonatomic, strong) UILabel *footLB;
@property (nonatomic, assign) float money;
@property (nonatomic, strong) NSNumber *infoKey;

@end

@implementation JGDGuestPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动报名";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData{
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [dic setObject:self.activityKey forKey:@"activityKey"];
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"activity"]) {
                self.model = [[JGTeamAcitivtyModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
                [self createTableView];
            }
            if ([data objectForKey:@"costList"]) {
                self.costArray = [data objectForKey:@"costList"];
            }
            
            [self.teamSignUpDic setObject:[[data objectForKey:@"activity"] objectForKey:@"teamKey"] forKey:@"teamKey"];
            [self.teamSignUpDic setObject:[[data objectForKey:@"activity"] objectForKey:@"timeKey"] forKey:@"activityKey"];
            [self.teamSignUpDic setObject:@0 forKey:@"userKey"];
            [self.teamSignUpDic setObject:@1 forKey:@"isOnlinePay"];
            [self.teamSignUpDic setObject:self.model.guestSubsidyPrice forKey:@"guestSubsidyPrice"];
            
            
            [self.infoDic setObject:[[data objectForKey:@"activity"] objectForKey:@"teamKey"] forKey:@"teamKey"];
            [self.infoDic setObject:[[data objectForKey:@"activity"] objectForKey:@"timeKey"] forKey:@"activityKey"];
            [self.infoDic setObject:@0 forKey:@"userKey"];
            [self.infoDic setObject:@0 forKey:@"timeKey"];
            
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
}


- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 117 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50 * ProportionAdapter;
    [self.tableView registerClass:[JGDGuestTableViewCell class] forCellReuseIdentifier:@"JGDGuestTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createView];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.costArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDGuestTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JGDGuestTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = [self.costArray[indexPath.row] objectForKey:@"costName"];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/人", [self.costArray[indexPath.row] objectForKey:@"money"]]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [[[self.costArray[indexPath.row] objectForKey:@"money"] stringValue] length])];
    cell.priceLB.attributedText = attri;
    //    if (indexPath.row == 0) {
    //        cell.titleLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    //        cell.priceLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    //        cell.selectView.image = [UIImage imageNamed:@"bkx"];
    //    }else{
    cell.selectView.image = [UIImage imageNamed:@"xuan_w"];
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    JGDGuestTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectView.image = [UIImage imageNamed:@"xuan_z"];
    [self.teamSignUpDic setObject:[self.costArray[indexPath.row] objectForKey:@"costType"] forKey:@"type"];
    self.money = [[self.costArray[indexPath.row] objectForKey:@"money"] floatValue];
    NSInteger subsidy = [self.model.guestSubsidyPrice integerValue];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台补贴费用%td元 实付金额：%.2f", subsidy, [[self.costArray[indexPath.row] objectForKey:@"money"] floatValue] - subsidy]];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6, [[NSString stringWithFormat:@"%td", subsidy] length])];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attriStr.length - [[NSString stringWithFormat:@"%.2f", self.money] length], [[NSString stringWithFormat:@"%.2f", self.money] length])];
    
    self.footLB.attributedText = attriStr;
}

- (void)createView{
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 430 * ProportionAdapter)];
    firstView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 69 * ProportionAdapter, 69 * ProportionAdapter)];
    iconView.backgroundColor = [UIColor orangeColor];
    [iconView sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:self.model.teamKey andIsSetWidth:YES andIsBackGround:NO]  placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    iconView.layer.cornerRadius = 6 * ProportionAdapter;
    iconView.clipsToBounds = YES;
    
    [firstView addSubview:iconView];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 18 * ProportionAdapter, screenWidth - 95 * ProportionAdapter, 20 * ProportionAdapter)];
    titleLB.text = self.model.name;
    titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:titleLB];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 45 * ProportionAdapter, screenWidth - 100 * ProportionAdapter, 1 * ProportionAdapter)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [firstView addSubview:lineView];
    
    UIImageView *coordinateView = [[UIImageView alloc] initWithFrame:CGRectMake(93 * ProportionAdapter, 57 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
    coordinateView.image = [UIImage imageNamed:@"juli"];
    [firstView addSubview:coordinateView];
    
    UILabel *ballName = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 55 * ProportionAdapter, screenWidth - 120 * ProportionAdapter, 20 * ProportionAdapter)];
    ballName.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    ballName.textColor = [UIColor colorWithHexString:@"#666666"];
    ballName.text = self.model.ballName;
    [firstView addSubview:ballName];
    
    UIView *longLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * ProportionAdapter, screenWidth, 1 * ProportionAdapter)];
    longLineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [firstView addSubview:longLineView];
    
    NSArray *timeArray = [NSArray arrayWithObjects:@"活动开球时间", @"报名截止时间", @"活动球场地址", nil];
    for (int i = 0; i < 3; i ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 105 * ProportionAdapter + i * 35 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.text = timeArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [firstView addSubview:titleLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150 * ProportionAdapter, 105 * ProportionAdapter + i * 35 * ProportionAdapter, 200 * ProportionAdapter, 20 * ProportionAdapter)];
        if (i == 2) {
            label.numberOfLines = 0;
            [label setFrame:CGRectMake(150 * ProportionAdapter, 105 * ProportionAdapter + i * 35 * ProportionAdapter, 200 * ProportionAdapter, 40 * ProportionAdapter)];
            if (self.model.ballAddress.length <= 13) {
                label.text = [NSString stringWithFormat:@"%@\n ", self.model.ballAddress];
            }else{
                label.text = self.model.ballAddress;
            }
        }else{
            if (self.model.beginDate && self.model.signUpEndTime) {
                i == 0 ? (label.text = [self.model.beginDate substringWithRange:NSMakeRange(0, self.model.beginDate.length - 3)]) : (label.text = [self.model.signUpEndTime substringWithRange:NSMakeRange(0, self.model.signUpEndTime.length - 8)]);
            }
            
        }
        label.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [firstView addSubview:label];
    }
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 230 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
    secondView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [firstView addSubview:secondView];
    
    UILabel *personInfoLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 255 * ProportionAdapter, 100 * ProportionAdapter, 20)];
    personInfoLB.text = @"个人信息";
    personInfoLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:personInfoLB];
    
    UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 295 * ProportionAdapter, 50 * ProportionAdapter, 20 * ProportionAdapter)];
    nameLB.text = @"姓名";
    nameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:nameLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 295 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
    self.nameTF.placeholder = @"请输入姓名";
    self.nameTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:self.nameTF];
    
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 315 * ProportionAdapter, 100 * ProportionAdapter, 1 * ProportionAdapter)];
    nameLine.backgroundColor = [UIColor colorWithHexString:@"#313131"];
    [firstView addSubview:nameLine];
    
    UILabel *sexLB = [[UILabel alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 295 * ProportionAdapter, 150 * ProportionAdapter, 20 * ProportionAdapter)];
    sexLB.text = @"男            女";
    sexLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:sexLB];
    
    UIButton *boyBtn = [[UIButton alloc] initWithFrame:CGRectMake(230 * ProportionAdapter, 297 * ProportionAdapter, 15 * ProportionAdapter, 15 * ProportionAdapter)];
    [boyBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:(UIControlStateNormal)];
    [boyBtn addTarget:self action:@selector(changeSex:) forControlEvents:(UIControlEventTouchUpInside)];
    boyBtn.tag = 201;
    [firstView addSubview:boyBtn];
    
    UIButton *girlBtn = [[UIButton alloc] initWithFrame:CGRectMake(295 * ProportionAdapter, 297 * ProportionAdapter, 15 * ProportionAdapter, 15 * ProportionAdapter)];
    [girlBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:(UIControlStateNormal)];
    [girlBtn addTarget:self action:@selector(changeSex:) forControlEvents:(UIControlEventTouchUpInside)];
    girlBtn.tag = 202;
    [firstView addSubview:girlBtn];
    
    
    UILabel *almostLB = [[UILabel alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 340 * ProportionAdapter, 50 * ProportionAdapter, 20 * ProportionAdapter)];
    almostLB.text = @"差点";
    almostLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:almostLB];
    
    self.almostTF = [[UITextField alloc] initWithFrame:CGRectMake(90 *ProportionAdapter, 340 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
    self.almostTF.placeholder = @"请输入差点";
    self.almostTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.almostTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:self.almostTF];
    
    UIView *almostLine = [[UIView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 360 * ProportionAdapter, 100 * ProportionAdapter, 1 * ProportionAdapter)];
    almostLine.backgroundColor = [UIColor colorWithHexString:@"#313131"];
    [firstView addSubview:almostLine];
    
    UILabel *mobileLB = [[UILabel alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 340 * ProportionAdapter, 50 * ProportionAdapter, 20 * ProportionAdapter)];
    mobileLB.text = @"手机号";
    mobileLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:mobileLB];
    
    self.mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(260 *ProportionAdapter, 340 * ProportionAdapter, 100 * ProportionAdapter, 20 * ProportionAdapter)];
    self.mobileTF.placeholder = @"请输入手机号";
    self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:self.mobileTF];
    
    UIView *mobileLine = [[UIView alloc] initWithFrame:CGRectMake(260 * ProportionAdapter, 360 * ProportionAdapter, 100 * ProportionAdapter, 1 * ProportionAdapter)];
    mobileLine.backgroundColor = [UIColor colorWithHexString:@"#313131"];
    [firstView addSubview:mobileLine];
    
    
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 390 * ProportionAdapter, screenWidth, 1 * ProportionAdapter)];
    secondLineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [firstView addSubview:secondLineView];
    
    
    
    
    UILabel *payTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 400 * ProportionAdapter, 300 * ProportionAdapter, 20 * ProportionAdapter)];
    payTitleLB.text = @"请根据实际情况选择付费方式";
    payTitleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [firstView addSubview:payTitleLB];
    
    self.tableView.tableHeaderView = firstView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 117 * ProportionAdapter, screenWidth, 60 * ProportionAdapter)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIView *footlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1 * ProportionAdapter)];
    footlineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [footView addSubview:footlineView];
    
    self.footLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 1 * ProportionAdapter, 260 * ProportionAdapter, 50 * ProportionAdapter)];
    NSInteger subsidy = [self.model.guestSubsidyPrice integerValue];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平台补贴费用%td元 实付金额：0", subsidy]];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6, [[NSString stringWithFormat:@"%td", subsidy] length])];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attriStr.length - 1, 1)];
    
    self.footLB.attributedText = attriStr;
    self.footLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [footView addSubview:self.footLB];
    
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payBtn.frame = CGRectMake(270 * ProportionAdapter, 1 * ProportionAdapter, screenWidth - 270 * ProportionAdapter, 60 * ProportionAdapter);
    payBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [payBtn setTitle:@"报名并支付" forState:(UIControlStateNormal)];
    payBtn.titleEdgeInsets = UIEdgeInsetsMake(10 * ProportionAdapter, 3 * ProportionAdapter, 15 * ProportionAdapter, 0);
    payBtn.titleLabel.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [payBtn addTarget:self action:@selector(payAct) forControlEvents:(UIControlEventTouchUpInside)];
    [footView addSubview:payBtn];
}


- (void)changeSex:(UIButton *)button{
    
    UIButton *button1 = [self.view viewWithTag:201];
    UIButton *button2 = [self.view viewWithTag:202];
    
    if (button.tag == 201) {
        [_teamSignUpDic setObject:@1 forKey:@"sex"];
        [button1 setImage:[UIImage imageNamed:@"xuan_z"] forState:(UIControlStateNormal)];
        [button2 setImage:[UIImage imageNamed:@"xuan_w"] forState:(UIControlStateNormal)];
    }else{
        [_teamSignUpDic setObject:@0 forKey:@"sex"];
        [button1 setImage:[UIImage imageNamed:@"xuan_w"] forState:(UIControlStateNormal)];
        [button2 setImage:[UIImage imageNamed:@"xuan_z"] forState:(UIControlStateNormal)];
        
    }
}

#pragma mark ------- 报名并支付

- (void)payAct{
    
    if (([self.nameTF.text length] == 0) || ([self.almostTF.text length] == 0) || ([self.mobileTF.text length] == 0)) {
        [[ShowHUD showHUD]showToastWithText: @"信息填写不完整" FromView:self.view];
        return;
    }else{
        [self.infoDic setObject:self.nameTF.text forKey:@"userName"];
        
        [self.teamSignUpDic setObject:self.nameTF.text forKey:@"name"];
        [self.teamSignUpDic setObject:self.mobileTF.text forKey:@"mobile"];
        [self.teamSignUpDic setObject:self.almostTF.text forKey:@"almost"];
    }
    
    if (![self.teamSignUpDic objectForKey:@"type"]) {
        [[ShowHUD showHUD]showToastWithText: @"请选择付费方式" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSArray arrayWithObject:self.teamSignUpDic] forKey:@"teamSignUpList"];
    [dic setObject:self.infoDic forKey:@"info"];
    [[JsonHttp jsonHttp] httpRequest:@"team/doTeamActivitySignUp" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"infoKey"]) {
                self.infoKey = [data objectForKey:@"infoKey"];
                [self payBtn];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
    }];
}

- (NSMutableArray *)costArray{
    if (!_costArray) {
        _costArray = [[NSMutableArray alloc] init];
    }
    return  _costArray;
}

- (NSMutableDictionary *)teamSignUpDic{
    if (!_teamSignUpDic) {
        _teamSignUpDic = [[NSMutableDictionary alloc] init];
        [_teamSignUpDic setObject:@1 forKey:@"sex"];
    }
    return _teamSignUpDic;
}

- (NSMutableDictionary *)infoDic{
    if (!_infoDic) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}


- (void)payBtn{
    
    [self.view endEditing:YES];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加微信支付请求
        [self weChatPay];
    }];
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加支付宝支付请求
        [self zhifubaoPay];
    }];
    
    UIAlertController *_actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [_actionView addAction:weiChatAction];
    [_actionView addAction:zhifubaoAction];
    [_actionView addAction:cancelAction];
    [self presentViewController:_actionView animated:YES completion:nil];
}


#pragma mark -- 微信支付
- (void)weChatPay{
    NSLog(@"微信支付");
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:self.money] forKey:@"money"];
    //    [dict setObject:@0.01 forKey:@"money"];
    [dict setObject:@2 forKey:@"orderType"];
    [dict setObject: self.infoKey forKey:@"srcKey"]; // teammember's timekey
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:@"请检查您的网络" FromView:self.view];
    } completionBlock:^(id data) {
        NSDictionary *dict = [data objectForKey:@"pay"];
        //微信
        
        if ([data objectForKey:@"packSuccess"]) {
            
            if (dict) {
                PayReq *request = [[PayReq alloc] init];
                request.openID       = [dict objectForKey:@"appid"];
                request.partnerId    = [dict objectForKey:@"partnerid"];
                request.prepayId     = [dict objectForKey:@"prepayid"];
                request.package      = [dict objectForKey:@"Package"];
                request.nonceStr     = [dict objectForKey:@"noncestr"];
                request.timeStamp    =[[dict objectForKey:@"timestamp"] intValue];
                request.sign         = [dict objectForKey:@"sign"];
                
                [WXApi sendReq:request];
            }
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        
        
    }];
}

#pragma mark -- 微信支付成功后返回的通知

- (void)notice:(NSNotification *)not{
    NSInteger secess = [[not.userInfo objectForKey:@"secess"] integerValue];
    if (secess == 1) {
        
        [[ShowHUD showHUD]showToastWithText:@"支付成功" FromView:self.view];
        [self performSelector:@selector(popToChannel) withObject:self afterDelay:TIMESlEEP];
        
    }else if (secess == 2){
        [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
    }
}


- (void)popToChannel{
    if ([NSThread isMainThread]) {
        NSLog(@"Yay!");
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGTeamChannelViewController class]]) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        NSLog(@"Humph, switching to main");
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[JGTeamChannelViewController class]]) {
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        });
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -- 支付宝

- (void)zhifubaoPay{
    NSLog(@"支付宝支付");
    //    JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:self.money]  forKey:@"money"];
    //    [dict setObject:@0.01 forKey:@"money"];
    [dict setObject:@2 forKey:@"orderType"];
    [dict setObject:self.infoKey forKey:@"srcKey"]; // teammember's timekey
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[ShowHUD showHUD]showToastWithText:@"支付成功！" FromView:self.view];
                //跳转分组页面
                [self performSelector:@selector(popToChannel) withObject:self afterDelay:TIMESlEEP];
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
                [[ShowHUD showHUD]showToastWithText:@"网络异常，支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
                [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
            } else {
                NSLog(@"支付失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            }
            
            
        }];
    }];
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
