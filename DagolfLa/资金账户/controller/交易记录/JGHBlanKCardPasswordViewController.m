//
//  JGHSelectBlanKCardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBlanKCardPasswordViewController.h"
#import "JGHTextFiledCell.h"
#import "JGHButtonCell.h"
#import "JGHWithdrawCell.h"
#import "JGSignUoPromptCell.h"
#import "JGDPrivateAccountViewController.h"

static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHTextFiledCellIdentifier = @"JGHTextFiledCell";
static NSString *const JGHWithdrawCellIdentifier = @"JGHWithdrawCell";

@interface JGHBlanKCardPasswordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHButtonCellDelegate>
{
    NSString *_password;//支付密码
    NSInteger _editor;//是否输入密码
}

@property (nonatomic, strong)UITableView *passwordTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHBlanKCardPasswordViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"提现";
    
    [self createPasswordTableView];
}

- (void)createPasswordTableView{
    self.passwordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.passwordTableView.delegate = self;
    self.passwordTableView.dataSource = self;
    self.passwordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *promptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.passwordTableView registerNib:promptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *catoryNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.passwordTableView registerNib:catoryNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
    UINib *cellNib = [UINib nibWithNibName:@"JGHTextFiledCell" bundle: [NSBundle mainBundle]];
    [self.passwordTableView registerNib:cellNib forCellReuseIdentifier:JGHTextFiledCellIdentifier];
    
    UINib *drawNib = [UINib nibWithNibName:@"JGHWithdrawCell" bundle: [NSBundle mainBundle]];
    [self.passwordTableView registerNib:drawNib forCellReuseIdentifier:JGHWithdrawCellIdentifier];
    
    [self.view addSubview:self.passwordTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 25* ProportionAdapter;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHWithdrawCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHWithdrawCellIdentifier];
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tradCell configWithdrawBalance:_reaplyBalance];
        
        return tradCell;
    }else if (indexPath.section == 1){
        JGHTextFiledCell *withdrawCell = [tableView dequeueReusableCellWithIdentifier:JGHTextFiledCellIdentifier];
        
        withdrawCell.selectionStyle = UITableViewCellSelectionStyleNone;
        withdrawCell.titlefileds.delegate = self;
        [withdrawCell configPayPassword];
        
        return withdrawCell;
        
    }else if (indexPath.section == 2){
        JGHButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        btnCell.delegate = self;
        [btnCell configPassword:_editor];
        
        return btnCell;
    }else{
        JGSignUoPromptCell *promptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        
        promptCell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [promptCell configPromptPasswordString:@""];//忘记密码？
//        promptCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        /**
        UIButton *passBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 70 - 20*ProportionAdapter, 10, 70, promptCell.pamaptLabel.frame.size.height - 20)];
        passBtn.backgroundColor = [UIColor redColor];
        [passBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        [promptCell addSubview:passBtn];
         */
        
        return promptCell;
    }
}
#pragma mark -- 忘记密码
- (void)forgetPassword:(UIButton *)btn{
    NSLog(@"忘记密码");
    
}

#pragma mark -- UITextFliaView
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = textField.text.length + string.length - range.length;
    if (length >= 6) {
        _editor = 1;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
        [self.passwordTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        return YES;
    }else{
        if (length < 6) {
            return YES;
        }
        return NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _password = textField.text;
    if (_password.length >= 6 ) {
        _editor = 1;
    }else{
        _editor = 0;
    }
    
    [self.passwordTableView reloadData];
}

#pragma mark --确定
- (void)selectCommitBtnClick:(UIButton *)btn{
    NSLog(@"确定");
    [self.view endEditing:YES];
    
    if (_editor == 1) {
        [[ShowHUD showHUD]showToastWithText:@"提现中..." FromView:self.view];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:[NSString stringWithFormat:@"%.2f", _reaplyBalance] forKey:@"money"];
        [dict setObject:@(_bankCardKey) forKey:@"bankCardKey"];
        [dict setObject:[Helper md5HexDigest:_password] forKey:@"payPassword"];
        
        
        
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUserWithDraw" JsonKey:nil withData:dict failedBlock:^(id errType) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];

        } completionBlock:^(id data) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [[ShowHUD showHUD]showToastWithText:@"提现成功！" FromView:self.view];
                
                if ([NSThread isMainThread]) {
                    NSLog(@"Yay!");
                    [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
                } else {
                    NSLog(@"Humph, switching to main");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
                    });
                }
                
                
            }
            else
            {
                
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                
            }
        }];
        
        
//        NSString *paraStr = [Helper dictionaryToJson:dict];
//        
//        NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"%@dagolfla.com", paraStr]];
//        
//        [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"user/doUserWithDraw?md5=%@",str] JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
//            [[ShowHUD showHUD]hideAnimationFromView:self.view];
//        } completionBlock:^(id data) {
//            [[ShowHUD showHUD]hideAnimationFromView:self.view];
//            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//                [[ShowHUD showHUD]showToastWithText:@"提现成功！" FromView:self.view];
//                
//                if ([NSThread isMainThread]) {
//                    NSLog(@"Yay!");
//                    [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
//                } else {
//                    NSLog(@"Humph, switching to main");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
//                    });
//                }
//                
//                
//            }
//            else
//            {
//                
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//                
//            }
//        }];
    }
}

#pragma mark -- 返回个人账户
- (void)pushCtrl{

    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGDPrivateAccountViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
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
