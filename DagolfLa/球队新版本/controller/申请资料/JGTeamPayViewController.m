//
//  JGTeamPayViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamPayViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGApplyMaterialTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>


@interface JGTeamPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation JGTeamPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费";
    [self creatTableView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // Do any additional setup after loading the view.
}


- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 280 * screenWidth/320) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 44 * screenWidth/320;
    [self.tableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"cellLB"];
    [self.tableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cellTF"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:self.tableView];
    
    self.titleArray = [NSArray arrayWithObjects:@"球队", @"缴费人", @"联系方式", nil];
    self.contentArray = [NSArray arrayWithObjects:self.name, [self.detailDic objectForKey:@"userName"], [self.detailDic objectForKey:@"mobile"], nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70 * screenWidth/320)];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [payBtn setTitle:@"立即缴费" forState:(UIControlStateNormal)];
    payBtn.frame = CGRectMake(10 * screenWidth/320, 20 * screenWidth/320, screenWidth - 20 * screenWidth/320, 40 * screenWidth/320);
    payBtn.backgroundColor = [UIColor colorWithHexString:@"#f39800"];
    payBtn.clipsToBounds = YES;
    payBtn.layer.cornerRadius = 6.f;
    [payBtn addTarget:self action:@selector(payBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tableView.tableFooterView addSubview:payBtn];
}


#pragma mark -- 立即付款

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
        JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%@.00",cell.textFD.text] forKey:@"money"];
//    [dict setObject:@0.01 forKey:@"money"];
    [dict setObject:@1 forKey:@"orderType"];
    [dict setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"srcKey"]; // teammember's timekey
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
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

- (void)notice:(id)not{
    //跳转分组页面
//    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
//    groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
//    [self.navigationController pushViewController:groupCtrl animated:YES];
}

#pragma mark -- 支付宝

- (void)zhifubaoPay{
    NSLog(@"支付宝支付");
    JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%@.00",cell.textFD.text] forKey:@"money"];
//    [dict setObject:@0.01 forKey:@"money"];
    [dict setObject:@1 forKey:@"orderType"];
    [dict setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"srcKey"]; // teammember's timekey
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {

            
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"陈公");
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
            } else {
                NSLog(@"支付失败");
            }
        }];
    }];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JGLableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellLB"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.promptLB.text = self.titleArray[indexPath.row];
        cell.contentLB.text = self.contentArray[indexPath.row];
        cell.contentLB.textColor = [UIColor blackColor];
        cell.contentLB.textAlignment = NSTextAlignmentRight;
        return cell;
    }else{
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTF"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labell.text = @"缴费金额";
        cell.textFD.placeholder = @"请输入应缴金额";
        cell.textFD.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
