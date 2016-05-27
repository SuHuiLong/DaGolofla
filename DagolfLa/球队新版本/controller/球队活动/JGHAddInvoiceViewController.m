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
//#import "JGHIvoiceTypeCell.h"
//#import "JGInvoiceTypeTextCell.h"
//#import "JGTeamActivityDetailsCell.h"

//static NSString *const JGHIvoiceTypeCellIdentifier = @"JGHIvoiceTypeCell";
//static NSString *const JGInvoiceTypeTextCellIdentifier = @"JGInvoiceTypeTextCell";
//static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";

@interface JGHAddInvoiceViewController ()<JGHAddAddressViewControllerDelegate>
{
    NSInteger _invoiceType;//地址的高度
}

@property (nonatomic, strong)NSArray *invoiceTypeArray;//1－文具,2－办公,3－餐饮

@end

@implementation JGHAddInvoiceViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"%f", screenHeight- (self.invoiceTypeArray.count*40+40+44*3+64+3*10));
//    self.commitBtnConstraintUnder.constant = screenHeight- (self.invoiceTypeArray.count*40+222+25+_commitBtn.frame.size.height+_promptlabel.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发票信息";
    self.view.backgroundColor = [UIColor colorWithHexString:TB_BG_Color];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 8.0;
    self.addressDict = [NSMutableDictionary dictionary];
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
        NSArray *array = [data objectForKey:@"invoiceList"];
        for (NSDictionary *dict in array) {
            if ([_invoiceKey isEqualToString:[data objectForKey:@"timeKey"]]) {
                _textField.text = [dict objectForKey:@"title"];
//                _contact.text = [dict objectForKey:@"title"];
                _invoiceType = [[dict objectForKey:@"type"] integerValue];
//                if ([[data objectForKey:@"type"] integerValue] == 1) {
//                    self.imageConstraint.constant = 14;
//                }else if ([[data objectForKey:@"type"] integerValue] == 2){
//                    self.imageConstraint.constant = 45;
//                }else{
//                    self.imageConstraint.constant = 71;
//                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitBtn:(UIButton *)sender {
    
    if (_textField.text.length == 0) {
        _textField.layer.borderColor = [UIColor redColor].CGColor;
        _textField.layer.borderWidth= 1.0f;
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@244 forKey:@"userKey"];//用户Key
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
