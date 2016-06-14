//
//  JGHAddInvoiceViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//新增发票

#import "JGHAddInvoiceViewController.h"
#import "JGHConcentTextViewController.h"
#import "JGHAddAddressViewController.h"

@interface JGHAddInvoiceViewController ()<JGHAddAddressViewControllerDelegate>
{
    NSInteger _invoiceType;
}

@property (nonatomic, strong)NSArray *invoiceTypeArray;//1－文具,2－办公,3－餐饮

@end

@implementation JGHAddInvoiceViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发票信息";
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 8.0;
    self.addressDict = [NSMutableDictionary dictionary];
//    self.invocieAndAddressDcit = [NSMutableDictionary dictionary];
    _invoiceType = 1;
    
    self.image1.hidden = NO;
    
//    if (_invoiceKey) {
//        [self loadInvoiceData];//获取发票数据
//        
//    }
}
//#pragma mark -- 获取发票信息
//- (void)loadInvoiceData{
//    _textField.text = [self.invocieAndAddressDcit objectForKey:@"title"];
//    //                _contact.text = [dict objectForKey:@"title"];
//    _invoiceType = [[self.invocieAndAddressDcit objectForKey:@"type"] integerValue];
//    if (_invoiceType == 1) {
//        self.image1.hidden = NO;
//    }else if (_invoiceType == 2){
//        self.image2.hidden = NO;
//    }else if (_invoiceType == 3){
//        self.image3.hidden = NO;
//    }else{
//        self.image4.hidden = NO;
//    }
//    
//    self.addressName.text = [self.invocieAndAddressDcit objectForKey:@"userName"];//地址联系人名字
//    self.addressNumber.text = [self.invocieAndAddressDcit objectForKey:@"mobile"];//地址联系人号码
//    self.addressDetails.text = [self.invocieAndAddressDcit objectForKey:@"address"];//地址详情
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 确定按钮
- (IBAction)commitBtn:(UIButton *)sender {
    //发票抬头
    if (_textField.text.length == 0) {
        _textField.layer.borderColor = [UIColor redColor].CGColor;
        _textField.layer.borderWidth= 1.0f;
        return;
    }
    //发票邮寄地址
    if (self.addressName.text.length == 0) {
        [Helper alertViewWithTitle:@"请输入邮寄地址！" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
        return;
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
    [dict setObject:@0 forKey:@"timeKey"];//timeKey
    [dict setObject:@"个人发票" forKey:@"name"];//发票名称
    [dict setObject:_textField.text forKey:@"title"];//发票抬头
//    [dict setObject: forKey:@"info"];//发票内容
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_invoiceType] forKey:@"type"];//发票类型
    
    if (_invoiceKey) {//修改
        [[JsonHttp jsonHttp]httpRequest:@"invoice/updateInvoice" JsonKey:@"invoice" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if (self.delegate) {
                    //返回字典key
                    [self.delegate backAddressKey:_invoiceKey andInvoiceName:_textField.text andAddressKey:[self.addressDict objectForKey:@"timeKey"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                //错误
            }
        }];
    }else{
        //创建发票
        [[JsonHttp jsonHttp]httpRequest:@"invoice/createInvoice" JsonKey:@"invoice" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"err == %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if (self.delegate) {
                    //返回字典key
                    _invoiceKey = [data objectForKey:@"invoiceKey"];
                    [self.delegate backAddressKey:_invoiceKey andInvoiceName:_textField.text andAddressKey:[self.addressDict objectForKey:@"timeKey"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                //错误
            }
        }];
    }
}

- (IBAction)btn1:(UIButton *)sender {
    _invoiceType = 1;
    self.image1.hidden = NO;
    
    self.image2.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
}

- (IBAction)btn2:(UIButton *)sender {
    _invoiceType = 2;
    self.image2.hidden = NO;
    
    self.image1.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
}

- (IBAction)btn3:(UIButton *)sender {
    _invoiceType = 3;
    self.image3.hidden = NO;
    
    self.image2.hidden = YES;
    self.image1.hidden = YES;
    self.image4.hidden = YES;
}

- (IBAction)btn4:(UIButton *)sender {
    _invoiceType = 4;
    self.image4.hidden = NO;
    
    self.image1.hidden = YES;
    self.image2.hidden = YES;
    self.image3.hidden = YES;
}
#pragma mark -- 地址
- (IBAction)addreeBtn:(UIButton *)sender {
    JGHAddAddressViewController *addressCtrl = [[JGHAddAddressViewController alloc]initWithNibName:@"JGHAddAddressViewController" bundle:nil];
    addressCtrl.delegate = self;
    addressCtrl.addressDict = self.addressDict;
    [self.navigationController pushViewController:addressCtrl animated:YES];
}
#pragma mark -- JGHAddAddressViewControllerDelegate 地址代理
- (void)didSelectAddressDict:(NSMutableDictionary *)addressDict{
    self.addressDict = addressDict;
    self.addressName.text = [self.addressDict objectForKey:@"userName"];//地址联系人名字
    self.addressNumber.text = [self.addressDict objectForKey:@"mobile"];//地址联系人号码
    self.addressDetails.text = [self.addressDict objectForKey:@"address"];//地址详情
}

@end
