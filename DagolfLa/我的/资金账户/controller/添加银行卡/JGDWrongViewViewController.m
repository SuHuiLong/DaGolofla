//
//  JGDWrongViewViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDWrongViewViewController.h"
#import "JGLAddBankCardViewController.h"

@interface JGDWrongViewViewController ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UILabel *seconLB;

@end

@implementation JGDWrongViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 107) / 2, 100 * ProportionAdapter, 107 * ProportionAdapter, 111 * ProportionAdapter)];
    
    imageV.image = [UIImage imageNamed:@"cry"];
    
    [self.view addSubview:imageV];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"信息输入有误，请重新输入！"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32B14D"] range:NSMakeRange(8, 4)];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(50 * ProportionAdapter, 230 * ProportionAdapter, screenWidth - 100 * ProportionAdapter, 30 * ProportionAdapter)];
    [addBtn setAttributedTitle:str forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(addBankCardClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBtn];
    
    // Do any additional setup after loading the view.
}

- (void)addBankCardClick{
//    JGLAddBankCardViewController *addVC = [[JGLAddBankCardViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
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
