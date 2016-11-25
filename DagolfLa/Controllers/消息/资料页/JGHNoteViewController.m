//
//  JGHNoteViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNoteViewController.h"

@interface JGHNoteViewController ()<UITextFieldDelegate>

@property (nonatomic, retain)UITextField *noteText;

@end

@implementation JGHNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"备注";
    
    [self createNoteText];
}
#pragma mark -- 完成
- (void)complete{
    if (self.noteText.text.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入备注" FromView:self.view];
        return;
    }
}

- (void)createNoteText{
    UIView *oneview = [[UIView alloc]initWithFrame:CGRectMake(0, 10 *ProportionAdapter, screenWidth, 80 *ProportionAdapter)];
    oneview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneview];
    
    self.noteText = [[UITextField alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 20*ProportionAdapter, 30 *ProportionAdapter)];
    self.noteText.placeholder = @"请输入备注";
    self.noteText.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    self.noteText.delegate = self;
    [oneview addSubview:self.noteText];
    
    UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -50 *ProportionAdapter, 50 *ProportionAdapter, 40 *ProportionAdapter, 20*ProportionAdapter)];
    proLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    proLable.text = @"20";
    [oneview addSubview:proLable];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
