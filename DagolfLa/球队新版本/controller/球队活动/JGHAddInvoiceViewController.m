//
//  JGHAddInvoiceViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//新增发票

#import "JGHAddInvoiceViewController.h"
#import "JGHConcentTextViewController.h"
//#import "InvoiceModel.h"

@interface JGHAddInvoiceViewController ()<JGHConcentTextViewControllerDelegate>

@property (nonatomic, assign)NSInteger invoiceType;//1－文具,2－办公,3－餐饮


@end

@implementation JGHAddInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发票信息";
    self.view.backgroundColor = [UIColor colorWithHexString:TB_BG_Color];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 8.0;
    
    _invoiceType = 1;
    
    if (self.invoiceKey) {
        [self loadInvoiceData];
        [self loadAddressData];
    }
}
#pragma mark -- 获取地址信息
- (void)loadAddressData{
    
}
#pragma mark -- 获取发票信息
- (void)loadInvoiceData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@244 forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"invoice/getInvoiceList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"err==%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data==%@", data);
        NSArray *array = [data objectForKey:@""];
        for (NSDictionary *dict in array) {
            if ([_invoiceKey isEqualToString:[data objectForKey:@"timeKey"]]) {
                _invoiceHeader.text = [dict objectForKey:@"name"];
                _contact.text = [dict objectForKey:@"info"];
                if ([[data objectForKey:@"type"] integerValue] == 1) {
                    self.imageConstraint.constant = 14;
                }else if ([[data objectForKey:@"type"] integerValue] == 2){
                    self.imageConstraint.constant = 45;
                }else{
                    self.imageConstraint.constant = 71;
                }
            }
        }
    }];
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

- (IBAction)commitBtn:(UIButton *)sender {
    if (_invoiceHeader.text.length == 0) {
        _invoiceHeader.layer.borderColor = [UIColor redColor].CGColor;
        _invoiceHeader.layer.borderWidth= 1.0f;
        return;
    }
    
    if (_contact.text.length == 0) {
        _contact.layer.borderColor = [UIColor redColor].CGColor;
        _contact.layer.borderWidth= 1.0f;
        return;
    }
    
    if (_addressBtn.currentTitle.length == 0) {
        _addressBtn.layer.borderColor = [UIColor redColor].CGColor;
        _addressBtn.layer.borderWidth= 1.0f;
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@244 forKey:@"userKey"];//用户Key
    [dict setObject:@0 forKey:@"timeKey"];//timeKey
    [dict setObject:@"个人发票" forKey:@"name"];//发票名称
    [dict setObject:_invoiceHeader.text forKey:@"title"];//发票抬头
    [dict setObject:_contact.text forKey:@"info"];//发票抬头
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_invoiceType] forKey:@"type"];//发票类型
    
    if (_invoiceKey) {
        [[JsonHttp jsonHttp]httpRequest:@"invoice/updateInvoice" JsonKey:@"invoice" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
        }];
    }else{
        //创建发票
        [[JsonHttp jsonHttp]httpRequest:@"invoice/createInvoice" JsonKey:@"invoice" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"err == %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([data objectForKey:@"packSuccess"]) {
                if (self.delegate) {
                    //返回字典key
                    [self.delegate backAddressKey:[data objectForKey:@"invoiceKey"]];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //错误
            }
        }];
    }
}

- (IBAction)OfficeBtn:(UIButton *)sender {
    self.imageConstraint.constant = 45;
    _invoiceType = 2;
}
- (IBAction)stationeryBtn:(UIButton *)sender {
    self.imageConstraint.constant = 14;
    _invoiceType = 1;
}
- (IBAction)foodBtn:(UIButton *)sender {
    self.imageConstraint.constant = 71;
    _invoiceType = 3;
}
- (IBAction)addressBtn:(UIButton *)sender {
    JGHConcentTextViewController *addressCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
    addressCtrl.delegate = self;
    addressCtrl.contentTextString = _addressBtn.currentTitle;
    [self.navigationController pushViewController:addressCtrl animated:YES];
}

#pragma mark --地址输入文本代理
- (void)didSelectSaveBtnClick:(NSString *)text{
    [_addressBtn setTitle:text forState:UIControlStateNormal];
}

@end
