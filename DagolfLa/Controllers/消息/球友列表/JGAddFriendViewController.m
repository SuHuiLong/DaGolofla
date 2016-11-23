//
//  JGAddFriendViewController.m
//  DagolfLa
//
//  Created by 東 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGAddFriendViewController.h"

@interface JGAddFriendViewController ()

@property (nonatomic, strong) UITextField *fieldTF;

@end

@implementation JGAddFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新朋友";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStyleDone) target:self action:@selector(sendAct)];
    rightBar.tintColor = [UIColor whiteColor];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    UILabel *tipLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 350 * ProportionAdapter, 16 * ProportionAdapter)];
    tipLB.text = @"你需要发送验证申请，等待对方通过";
    tipLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    tipLB.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    [self.view addSubview:tipLB];
    
    
    self.fieldTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 50 * ProportionAdapter, screenWidth, 49 * ProportionAdapter)];
    self.fieldTF.clearButtonMode = UITextFieldViewModeAlways;
    self.fieldTF.backgroundColor = [UIColor whiteColor];
    [self.fieldTF setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.fieldTF.placeholder = @"请输入验证申请";
    
    
    [self.view addSubview:self.fieldTF];
//    [self.fieldTF becomeFirstResponder];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // Do any additional setup after loading the view.
}

- (void)sendAct{
    
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
