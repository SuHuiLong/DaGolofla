//
//  JGDPrivateAccountViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrivateAccountViewController.h"
#import "JGHTradRecordViewController.h"
#import "JGHWithdrawViewController.h"
#import "JGLBankListViewController.h"
#import "JGDCertificationViewController.h"
#import "JGDSubMitPayPasswordViewController.h"
#import "JGLAddBankCardViewController.h"

#import "JGDSetBusinessPWDViewController.h"

@interface JGDPrivateAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) NSNumber *hasUserRealName;
@property (nonatomic, strong) NSNumber *isSetPayPassWord;
@property (nonatomic, strong) NSNumber *hasUserBankCard;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIButton *takeMoneyButton;

@end

@implementation JGDPrivateAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"old_Nav_bg"] forBarMetrics:UIBarMetricsDefault];

    self.tabBarController.tabBar.hidden = YES;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBalance" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errtype == %@", errType);
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([[data objectForKey:@"hasWithDraw"] integerValue] == 0) {
                self.takeMoneyButton.hidden = YES;
            }else{
                self.takeMoneyButton.hidden = NO;
            }
            self.money = [data objectForKey:@"money"];
            self.hasUserRealName = [data objectForKey:@"hasUserRealName"];
            self.isSetPayPassWord = [data objectForKey:@"isSetPayPassWord"];
            self.hasUserBankCard = [data objectForKey:@"hasUserBankCard"];
            self.name = [data objectForKey:@"name"];
            
            self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.money floatValue]];
            
            UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
            if ([[data objectForKey:@"hasUserRealName"] integerValue] == 0) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                imageV.image = [UIImage imageNamed:@"zhezhao1"];
                imageV.userInteractionEnabled = YES;
                [imageV addGestureRecognizer:gest];
                [self.view addSubview:imageV];
            
            }else if ( [[data objectForKey:@"isSetPayPassWord"] integerValue] == 0){
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                imageV.image = [UIImage imageNamed:@"zhezhao2"];
                imageV.userInteractionEnabled = YES;
                [imageV addGestureRecognizer:gest];
                [self.view addSubview:imageV];

            }else{
                
            }
        }
    }];
}

- (void)removeView:(UITapGestureRecognizer *)gest{
    [gest.view removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人帐户";
    [self creatTableV];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // 去黑线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"parentTopBackgroupd"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    // Do any additional setup after loading the view.
}

- (void)creatTableV{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 298 * ScreenWidth / 375) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 160 *ScreenWidth / 375)];
    view.image = [UIImage imageNamed:@"account_bg"];
//    view.backgroundColor = [UIColor colorWithHexString:@"#32B14D"];
    self.tableView.tableHeaderView = view;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 * ScreenWidth / 375, 20 * ScreenWidth / 375, 150 * ScreenWidth / 375, 30 * ScreenWidth / 375)];
    label.text = @"帐户余额（元）";
    label.font = [UIFont systemFontOfSize:14 * ScreenWidth / 375];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * ScreenWidth / 375, 40 * ScreenWidth / 375, screenWidth - 20 * ScreenWidth / 375, 80 * ScreenWidth / 375)];
    self.moneyLabel.text = @"¥0.00";
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:40 * ScreenWidth / 375];
    self.moneyLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.moneyLabel];
    
    self.takeMoneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.takeMoneyButton.frame = CGRectMake(120 * ScreenWidth / 375, 136 * ScreenWidth / 375, 135 * ScreenWidth / 375, 48 * ScreenWidth / 375) ;
    [self.takeMoneyButton setBackgroundImage:[UIImage imageNamed:@"tixiananniu"] forState:(UIControlStateNormal)];
//    [button setImage:[UIImage imageNamed:@"tixiananniu"] forState:(UIControlStateNormal)];
    [self.takeMoneyButton addTarget:self action:@selector(takeMoney:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sysCell"];
    
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.takeMoneyButton aboveSubview:self.tableView];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 * ScreenWidth / 375;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40 * ScreenWidth / 375;
    }else{
        return 10 * ScreenWidth / 375;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"交易记录";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"银行卡";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"中国银行";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHTradRecordViewController *tradRecordCtrl = [[JGHTradRecordViewController alloc]init];
        [self.navigationController pushViewController:tradRecordCtrl animated:YES];
    }else{
        
        if (([self.hasUserRealName integerValue] == 0)||([self.hasUserRealName integerValue] == 2)) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否前往实名认证" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                
            }];
            UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JGDCertificationViewController *createCertVc = [[JGDCertificationViewController alloc] init];
                [self.navigationController pushViewController:createCertVc animated:YES];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            JGLBankListViewController* userVc = [[JGLBankListViewController alloc]init];
            [self.navigationController pushViewController:userVc animated:YES];
        }
    }
}


#pragma mark -----提现

- (void)takeMoney:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    
    if (([self.hasUserRealName integerValue] == 0)||([self.hasUserRealName integerValue] == 2)) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否前往实名认证" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGDCertificationViewController *createCertVc = [[JGDCertificationViewController alloc] init];
            [self.navigationController pushViewController:createCertVc animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ( [self.isSetPayPassWord integerValue] == 0){
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否前往设置交易密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGDSetBusinessPWDViewController *setPassWord = [[JGDSetBusinessPWDViewController alloc] init];
            [self.navigationController pushViewController:setPassWord animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else if ( [self.hasUserBankCard integerValue] == 0){
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否前往添加银行卡" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGLAddBankCardViewController* addVc = [[JGLAddBankCardViewController alloc]init];
            addVc.realName = self.name;
            [self.navigationController pushViewController:addVc animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        JGHWithdrawViewController *withdrawCtrl = [[JGHWithdrawViewController alloc]init];
        withdrawCtrl.balance = self.money;
        withdrawCtrl.realName = self.name;
        [self.navigationController pushViewController:withdrawCtrl animated:YES];
    }
    
    btn.userInteractionEnabled = YES;
}

#pragma mark -----添加银行卡

- (void)addBank{
    
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
