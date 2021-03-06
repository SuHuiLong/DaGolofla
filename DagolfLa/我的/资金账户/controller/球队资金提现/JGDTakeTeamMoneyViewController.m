//
//  JGDSetPayPasswordViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDTakeTeamMoneyViewController.h"
#import "JGDSetPayPasswordTableViewCell.h"

#import "CommonCrypto/CommonDigest.h"


@interface JGDTakeTeamMoneyViewController ()<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *money;

@end

@implementation JGDTakeTeamMoneyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:self.teamKey forKey:@"teamKey"];
    
    [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"team/getTeamBalance"] JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            self.mobile = [data objectForKey:@"mobile"];
            self.money = [data objectForKey:@"money"];
            [self.tableV reloadData];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self creatTable];
    // Do any additional setup after loading the view.
}

- (void)creatTable{
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 310 * screenWidth / 375)];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerClass:[JGDSetPayPasswordTableViewCell class] forCellReuseIdentifier:@"setPayPass"];
    self.tableV.rowHeight = 44 * screenWidth / 375;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 120 * screenWidth / 375)];
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextBtn.frame = CGRectMake(10 * screenWidth / 375, 25 * screenWidth / 375, screenWidth - 20 * screenWidth / 375, 40 * screenWidth / 375);
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [nextBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [nextBtn addTarget:self action:@selector(comitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 6.f * screenWidth / 375;
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [view addSubview:nextBtn];
    
    self.tableV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableV.tableFooterView = view;
    [self.view addSubview:self.tableV];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        return 1;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDSetPayPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setPayPass"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.txFD.frame = CGRectMake(110 * screenWidth / 375, 0, screenWidth - 160 * screenWidth / 375, 44 * screenWidth / 375);
    
    if (indexPath.section == 0) {
        cell.LB.text = @"提现金额";
        cell.txFD.placeholder = [NSString stringWithFormat:@"当前可提现金额为%@元" ,self.money];
        cell.txFD.keyboardType = UIKeyboardTypeWebSearch;
    }else if (indexPath.section == 1){
        cell.LB.text = @"备注";
        cell.txFD.placeholder = [NSString stringWithFormat:@"请输入备注内容"];
    }else{
        if (indexPath.row == 1) {
            cell.LB.text = @"验证码";
            cell.txFD.placeholder = @"输入验证码";
            [cell addSubview:cell.takeBtn];
            self.codeBtn = cell.takeBtn;
            [cell.takeBtn addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
            cell.txFD.secureTextEntry = NO;
            
        }else if (indexPath.row == 0) {
            cell.LB.text = @"手机验证";
            cell.txFD.placeholder = [NSString stringWithFormat:@"发送验证码至%@", self.mobile];
            cell.txFD.userInteractionEnabled = NO;
        }
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10  * screenWidth / 375;
}

- (void)comitBtnClick:(UIButton *)btn{
    
    JGDSetPayPasswordTableViewCell *cell1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell3 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    JGDSetPayPasswordTableViewCell *cell2 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    
    if ([cell2.txFD.text length] < 3) {
        [[ShowHUD showHUD]showToastWithText:@"请输入正确的验证码" FromView:self.view];
        return;
    }
    if ([cell1.txFD.text integerValue] > [self.money integerValue]) {
        [[ShowHUD showHUD]showToastWithText:@"提现金额不能大于帐户余额" FromView:self.view];
        return;
    }
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:cell1.txFD.text forKey:@"money"];
    [dict setObject:cell2.txFD.text forKey:@"checkCode"];
    [dict setObject:self.teamKey forKey:@"teamKey"];
    
    if (cell3.txFD.text) {
        [dict setObject:cell3.txFD.text forKey:@"remark"];
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"提现中..." FromView:self.view];
    btn.userInteractionEnabled = NO;
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doTeamWithDraw" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        btn.userInteractionEnabled = YES;

    } completionBlock:^(id data) {
                
        [[ShowHUD showHUD]hideAnimationFromView:self.view];

        if ([[data objectForKey:@"packSuccess"] integerValue] == 1 ) {
            
            [LQProgressHud showMessage:@"提现成功"];
            btn.userInteractionEnabled = YES;
            [self performSelector:@selector(pop) withObject:self afterDelay:TIMESlEEP];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            btn.userInteractionEnabled = YES;

        }
    }];
}

- (void)pop{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


static int timeNumber = 60;

//设置使用的验证码
-(void)codeClick
{
    self.codeBtn.userInteractionEnabled = NO;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:self.teamKey forKey:@"teamKey"];
    
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doSendTeamWithDrawCheckCode" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            timeNumber = 60;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];

}


/**
 *  定时器
 */
- (void)autoMove {
    timeNumber--;
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        self.codeBtn.userInteractionEnabled = YES;
    }
}



#pragma mark  -----MD5

+(NSString *)md5HexDigest:(NSString*)Des_str
{
    
    const char *original_str = [Des_str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash uppercaseString];
    
    return mdfiveString;
    
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
