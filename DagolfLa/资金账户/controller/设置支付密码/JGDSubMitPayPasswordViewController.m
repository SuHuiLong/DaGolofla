//
//  JGDSetPayPasswordViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSubMitPayPasswordViewController.h"
#import "JGDSetPayPasswordTableViewCell.h"


#import "JGDChangePasswordViewController.h" // test
#import "CommonCrypto/CommonDigest.h"

@interface JGDSubMitPayPasswordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableV;

@end

@implementation JGDSubMitPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.navigationItem.title = @"设置支付密码";
    
    [self creatTable];
    // Do any additional setup after loading the view.
}

- (void)creatTable{
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 180 * screenWidth / 375)];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerClass:[JGDSetPayPasswordTableViewCell class] forCellReuseIdentifier:@"setPayPass"];
    self.tableV.rowHeight = 44 * screenWidth / 375;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70 * screenWidth / 375)];
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextBtn.frame = CGRectMake(10 * screenWidth / 375, 25 * screenWidth / 375, screenWidth - 20 * screenWidth / 375, 40 * screenWidth / 375);
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [nextBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [nextBtn addTarget:self action:@selector(comitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 6.f * screenWidth / 375;
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:nextBtn];
    self.tableV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableV.tableFooterView = view;
    [self.view addSubview:self.tableV];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDSetPayPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setPayPass"];
    cell.txFD.secureTextEntry = YES;
    
    if (indexPath.row == 0) {
        cell.LB.text = @"设置密码";
        cell.txFD.placeholder = @"设置您的支付密码";
    }else{
        cell.LB.text = @"再输一次";
        cell.txFD.placeholder = @"再输入一次支付密码";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10  * screenWidth / 375;
}

- (void)comitBtnClick{
    
    JGDSetPayPasswordTableViewCell *cell1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell2= [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (![cell1.txFD.text isEqualToString:cell2.txFD.text]) {
        [[ShowHUD showHUD]showToastWithText:@"密码输入不一致" FromView:self.view];
        return;
    }
    
    if ([cell1.txFD.text length] < 6) {
        [[ShowHUD showHUD]showToastWithText:@"密码长度不能小于六位" FromView:self.view];
        return;
    }
        
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:self.code forKey:@"checkCode"];
    [dict setObject:[JGDSubMitPayPasswordViewController md5HexDigest:cell1.txFD.text] forKey:@"passWord"];
    
    NSString *paraStr = [JGDSubMitPayPasswordViewController dictionaryToJson:dict];
    ;
    
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *str = [JGDSubMitPayPasswordViewController md5HexDigest:[NSString stringWithFormat:@"%@dagolfla.com", paraStr]];
    
    [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"user/setPayPassWord?md5=%@",str] JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"恭喜您支付密码设置成功" FromView:self.view];
            [self performSelector:@selector(pop) withObject:self afterDelay:1];
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            
        }
    }];
    
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

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)pop{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
