//
//  JGHConcentTextViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHConcentTextViewController.h"

@interface JGHConcentTextViewController ()<UITextViewDelegate>

@end

@implementation JGHConcentTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = self.itemText;
    
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5.0;
    
    self.contentText.text = self.contentTextString;
    if (self.contentTextString.length > 0) {
        self.placeholdertext.hidden = YES;
    }
}


- (IBAction)touchView:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark -- 保存方法
- (IBAction)saveBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    
    /*
    if (self.contentText.text.length >220) {
        [Helper alertViewWithTitle:@"输入内容超出限制！" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        NSLog(@"%ld", (unsigned long)_contentText.text.length);
        return;
    }
    */
    
    if (self.contentText.text.length == 0 && _isNull == 0) {
        [Helper alertViewWithTitle:@"请输入内容！" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        NSLog(@"%ld", (unsigned long)_contentText.text.length);
        return;
    }
    
    self.contentTextString = _contentText.text;
    if ([self.delegate respondsToSelector:@selector(didSelectSaveBtnClick:)]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate didSelectSaveBtnClick:self.contentText.text];
    }
}

#pragma mark -- UITextViewDelegate代理
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholdertext.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.contentText.text isEqualToString:@""]) {
        self.placeholdertext.hidden = NO;
    }else{
        self.placeholdertext.hidden = YES;
    }
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
