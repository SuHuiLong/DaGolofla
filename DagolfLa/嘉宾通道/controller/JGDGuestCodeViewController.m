//
//  JGDGuestCodeViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDGuestCodeViewController.h"

@interface JGDGuestCodeViewController ()

@end

@implementation JGDGuestCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"嘉宾参赛码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 100 * ProportionAdapter)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 36 * ProportionAdapter, 80 * ProportionAdapter, 30 * ProportionAdapter)];
    label.text = @"参赛码：";
    label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [whiteView addSubview:label];
    // Do any additional setup after loading the view.

    UILabel *introLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 125 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 100 * ProportionAdapter)];
    introLB.numberOfLines = 0;
    introLB.text = @"说明：系统为每个活动生成唯一“嘉宾参赛码“，嘉宾在我的球队－嘉宾通道中输入该码，可以直达嘉宾报名页，完成活动报名与付款";
    introLB.font = [UIFont systemFontOfSize: 13 * ProportionAdapter];
    [self.view addSubview:introLB];
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
