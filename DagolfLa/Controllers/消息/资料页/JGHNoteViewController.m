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

@property (nonatomic, retain)UILabel *proLable;

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
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"备注";
    
    [self createNoteText];
}
#pragma mark -- 完成
- (void)complete{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_friendUserKey forKey:@"friendUserKey"];
    
    if (self.noteText.text.length == 0) {
        //        [[ShowHUD showHUD]showToastWithText:@"请输入备注" FromView:self.view];
        //        return;
        [dict setObject:@"" forKey:@"remark"];
        
    }else{
        [dict setObject:self.noteText.text forKey:@"remark"];
    }
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"userFriend/doUpdateUserRemark" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _blockRereshNote(self.noteText.text);
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)createNoteText{
    UIView *oneview = [[UIView alloc]initWithFrame:CGRectMake(0, 10 *ProportionAdapter, screenWidth, 80 *ProportionAdapter)];
    oneview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneview];
    
    self.noteText = [[UITextField alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 0, screenWidth - 20*ProportionAdapter, 40 *ProportionAdapter)];
    self.noteText.placeholder = @"请输入备注信息";
    self.noteText.font = [UIFont systemFontOfSize:16*ProportionAdapter];
    self.noteText.delegate = self;
    [oneview addSubview:self.noteText];
    
    self.proLable = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -50 *ProportionAdapter, 50 *ProportionAdapter, 40 *ProportionAdapter, 20*ProportionAdapter)];
    self.proLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.proLable.textColor = [UIColor lightGrayColor];
    self.proLable.text = @"20";
    self.proLable.textAlignment = NSTextAlignmentRight;
    [oneview addSubview:self.proLable];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.proLable.text = [NSString stringWithFormat:@"%td", 20 -[str length]];
    
    if ([str length] > 20) {
        self.proLable.text = @"0";
        textField.text = [str substringToIndex:20];
        return NO;
    }
    
    return YES;
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
