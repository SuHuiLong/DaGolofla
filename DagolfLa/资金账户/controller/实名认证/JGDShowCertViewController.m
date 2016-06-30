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

@interface JGDShowCertViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageVOne;
@property (nonatomic, strong) UIImageView *imageVTwo;

@end

@implementation JGDShowCertViewController

- (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:YES];

//    if ([[self.userRealDic objectForKey:@"state"] integerValue]== 2) {
//        self.tableView.frame = CGRectMake(0, 0, screenWidth, 368 * screenWidth / 375);
//        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, screenWidth, 110 * screenWidth / 375);
//        [self.tableView reloadData];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableV]; 
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // Do any additional setup after loading the view.
}


- (void)creatTableV{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 294 * screenWidth / 375) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"LBVSLB"];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * screenWidth / 375)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(80 * screenWidth / 375, 20 * screenWidth / 375, 32 * screenWidth / 375, 32 * screenWidth / 375)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130 * screenWidth / 375, 20 * screenWidth / 375, 200 * screenWidth / 375, 30 * screenWidth / 375)];
    
    if ([[self.userRealDic objectForKey:@"state"] integerValue]== 1) {
        imageV.image = [UIImage imageNamed:@"yigouxuan16"];
        label.text = @"您已通过实名认证";
        
    }else if ([[self.userRealDic objectForKey:@"state"] integerValue]== 2) {
        view.frame = CGRectMake(0, 0, screenWidth, 110 * screenWidth / 375);
        self.tableView.frame = CGRectMake(0, 0, screenWidth, 324 * screenWidth / 375);

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
   
    }else if ([[self.userRealDic objectForKey:@"state"] integerValue]== 0){
        imageV.image = [UIImage imageNamed:@"shenhezhong"];
        label.text = @"审核中，请耐心等待";
    }
    
    [view addSubview:imageV];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2    ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 1) {
        return 170 * screenWidth / 375;
    }else{
        return 44 * screenWidth / 375;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGLableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBVSLB"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.promptLB.text = @"真实姓名";
        cell.contentLB.text = [self.userRealDic objectForKey:@"name"];
        cell.contentLB.textAlignment = NSTextAlignmentRight;
//    }else if (indexPath.row == 1) {
//        cell.promptLB.text = @"身份证号";
//        cell.contentLB.text = [self.userRealDic objectForKey:@"cardNumber"];
//        cell.contentLB.textAlignment = NSTextAlignmentRight;
    }else{
        cell.promptLB.text = @"证件照片";
        [cell.contentLB removeFromSuperview];
        
        self.imageVOne = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 375, 44 * screenWidth / 375, 173 * screenWidth / 375, 113 * screenWidth / 375)];
        
        self.imageVTwo = [[UIImageView alloc] initWithFrame:CGRectMake(193 * screenWidth / 375, 44 * screenWidth / 375, 173 * screenWidth / 375, 113 * screenWidth / 375)];

        NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/userReal/%@_positive.jpg", DEFAULF_USERID];
        NSString *bgUrll = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/userReal/%@_back.jpg", DEFAULF_USERID];
        [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
        [[SDImageCache sharedImageCache] removeImageForKey:bgUrll fromDisk:YES];
        
        [self.imageVOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/userReal/%@_positive.jpg", DEFAULF_USERID]]];
        [self.imageVTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/userReal/%@_back.jpg", DEFAULF_USERID]]];
        
        UIImageView *imageBurl1 = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 375, 44 * screenWidth / 375, 173 * screenWidth / 375, 113 * screenWidth / 375)];
        UIVisualEffectView *visaV1 = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]];
        [imageBurl1 addSubview:visaV1];
        visaV1.frame = imageBurl1.bounds;
        imageBurl1.alpha = 0.95;
        
        UIImageView *imageBurl2 = [[UIImageView alloc] initWithFrame:CGRectMake(193 * screenWidth / 375, 44 * screenWidth / 375, 173 * screenWidth / 375, 113 * screenWidth / 375)];
        UIVisualEffectView *visaV2 = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]];
        [imageBurl2 addSubview:visaV2];
        visaV2.frame = imageBurl2.bounds;
        imageBurl2.alpha = 0.95;
        
        [cell addSubview:imageBurl1];
        [cell addSubview:imageBurl2];
        
        [cell.contentView addSubview:self.imageVOne];
        [cell.contentView addSubview:self.imageVTwo];
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
