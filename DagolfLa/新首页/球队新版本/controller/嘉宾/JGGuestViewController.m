//
//  JGGuestViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGGuestViewController.h"

@interface JGGuestViewController ()

@end

@implementation JGGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.title = @"嘉宾参赛码";
    
    [self drawView];
    
    // Do any additional setup after loading the view.
}


- (void)drawView{
    UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 100 * ProportionAdapter)];
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 36 * ProportionAdapter, 287 * ProportionAdapter, 60 * ProportionAdapter)];
    NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:@"参赛码：021576"];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, mutaStr.length - 4)];
    label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    label.attributedText = mutaStr;
        [self.view addSubview:label];
    
    UILabel *introduceLB = [[UILabel alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 125 * ProportionAdapter, screenWidth - 30, 60 * ProportionAdapter)];
    introduceLB.numberOfLines = 0;
    introduceLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    introduceLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    NSMutableAttributedString *intrStr = [[NSMutableAttributedString alloc] initWithString:@"说明：系统为每个活动生成唯一“嘉宾参赛码”，嘉宾在我的球队-嘉宾通道中输入该码，可直达嘉宾报名页，完成活动报名与付款。"];
    [intrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6cb8ff"] range:NSMakeRange(25, 9)];
    introduceLB.attributedText = intrStr;
    [self.view addSubview:introduceLB];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guestAct)];
    introduceLB.userInteractionEnabled = YES;
    [introduceLB addGestureRecognizer:tapGR];
}

- (void)guestAct{
    NSLog(@"-------*********-------");
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
