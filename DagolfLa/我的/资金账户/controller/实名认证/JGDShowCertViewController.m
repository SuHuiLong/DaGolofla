//
//  JGDShowCertViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDShowCertViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDCertificationViewController.h"
#import "JGDPrivateAccountViewController.h"

#import "MySetViewController.h"

@interface JGDShowCertViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageVOne;
@property (nonatomic, strong) UIImageView *imageVTwo;

@end

@implementation JGDShowCertViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    if (!self.userRealDic) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
        
        [[JsonHttp jsonHttp]httpRequest:@"user/getUserRealName" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
            NSLog(@"errtype == %@", errType);
        } completionBlock:^(id data) {
            if ([data objectForKey:@"userReal"]) {
                self.userRealDic = [data objectForKey:@"userReal"];
                
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * screenWidth / 375)];
                view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(80 * screenWidth / 375, 20 * screenWidth / 375, 32 * screenWidth / 375, 32 * screenWidth / 375)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130 * screenWidth / 375, 20 * screenWidth / 375, 200 * screenWidth / 375, 30 * screenWidth / 375)];
                
                if (self.userRealDic) {
                    if ([[self.userRealDic objectForKey:@"state"] integerValue]== 1) {
                        imageV.image = [UIImage imageNamed:@"yigouxuan16"];
                        label.text = @"您已通过实名认证";
                        
                    }else {
                        view.frame = CGRectMake(0, 0, screenWidth, 110 * screenWidth / 375);
                        self.tableView.frame = CGRectMake(0, 0, screenWidth, 198 * screenWidth / 375);
                        
                        imageV.image = [UIImage imageNamed:@"shibai"];
                        label.text = @"很遗憾，认证失败";
                        label.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
                        UILabel *lablee = [[UILabel alloc] initWithFrame:CGRectMake(50 * screenWidth / 375, 50 * screenWidth / 375, 200 * screenWidth / 375, 30 * screenWidth / 375)];
                        lablee.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
                        lablee.text = @"您未通过实名认证，请整理后";
                        [view addSubview:lablee];
                        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
                        button.frame = CGRectMake(235 * screenWidth / 375, 50 * screenWidth / 375, 80 * screenWidth / 375, 30 * screenWidth / 375);
                        button.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 375];;
                        [button setTitle:@"重新认证" forState:(UIControlStateNormal)];
                        [button addTarget:self action:@selector(resetPassword) forControlEvents:(UIControlEventTouchUpInside)];
                        [button setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
                        [view addSubview:button];
                    }
                }
                [view addSubview:imageV];
                [view addSubview:label];
                self.tableView.tableHeaderView = view;
                
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableV]; 
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.navigationItem.title = @"实名认证";
    
    // Do any additional setup after loading the view.
}

- (void)backBtn{
    MySetViewController *VC = [[MySetViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}

- (void)creatTableV{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 168 * screenWidth / 375) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"LBVSLB"];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * screenWidth / 375)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(80 * screenWidth / 375, 20 * screenWidth / 375, 32 * screenWidth / 375, 32 * screenWidth / 375)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130 * screenWidth / 375, 20 * screenWidth / 375, 200 * screenWidth / 375, 30 * screenWidth / 375)];
    
    if (self.userRealDic) {
        if ([[self.userRealDic objectForKey:@"state"] integerValue]== 1) {
            imageV.image = [UIImage imageNamed:@"yigouxuan16"];
            label.text = @"您已通过实名认证";
            
        }else {
            view.frame = CGRectMake(0, 0, screenWidth, 110 * screenWidth / 375);
            self.tableView.frame = CGRectMake(0, 0, screenWidth, 198 * screenWidth / 375);
            
            imageV.image = [UIImage imageNamed:@"shibai"];
            label.text = @"很遗憾，认证失败";
            label.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
            UILabel *lablee = [[UILabel alloc] initWithFrame:CGRectMake(50 * screenWidth / 375, 50 * screenWidth / 375, 200 * screenWidth / 375, 30 * screenWidth / 375)];
            lablee.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
            lablee.text = @"您未通过实名认证，请整理后";
            [view addSubview:lablee];
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.frame = CGRectMake(235 * screenWidth / 375, 50 * screenWidth / 375, 80 * screenWidth / 375, 30 * screenWidth / 375);
            button.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 375];;
            [button setTitle:@"重新认证" forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(resetPassword) forControlEvents:(UIControlEventTouchUpInside)];
            [button setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
            [view addSubview:button];
        }
    }

    
    //    else  if ([[self.userRealDic objectForKey:@"state"] integerValue]== 2)  ([[self.userRealDic objectForKey:@"state"] integerValue]== 0){
    //        imageV.image = [UIImage imageNamed:@"shenhezhong"];
    //        label.text = @"审核中，请耐心等待";
    //    }
    
    [view addSubview:imageV];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
    
    
    UIButton *personBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [personBtn setTitle:@"查看个人帐户" forState:(UIControlStateNormal)];
    personBtn.frame = CGRectMake(10 * ProportionAdapter, 500 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter);
    personBtn.clipsToBounds = YES;
    personBtn.layer.cornerRadius = 6.f;
    personBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [personBtn addTarget:self action:@selector(privateAccount) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:personBtn];
}

- (void)privateAccount{
    JGDPrivateAccountViewController *privateVC = [[JGDPrivateAccountViewController alloc] init];
    [self.navigationController pushViewController:privateVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 1) {
        return 44 * screenWidth / 375;
    }else{
        return 44 * screenWidth / 375;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGLableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBVSLB"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.promptLB.text = @"真实姓名";
        if (self.userRealDic) {
            cell.contentLB.text = [self.userRealDic objectForKey:@"name"];
        }
        cell.contentLB.textAlignment = NSTextAlignmentRight;

    }else{
        cell.promptLB.text = @"身份证号";
        if (self.userRealDic) {
            NSMutableString *str = [NSMutableString stringWithString:[self.userRealDic objectForKey:@"idCard"]];
            cell.contentLB.text = str;
        }
        cell.contentLB.textAlignment = NSTextAlignmentRight;
    }

    
    return cell;
}

- (void)resetPassword{
    JGDCertificationViewController *setPassVC = [[JGDCertificationViewController alloc] init];
    [self.navigationController pushViewController:setPassVC animated:YES];
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
