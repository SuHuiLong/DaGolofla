//
//  JGHAddInvoiceViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHAddInvoiceViewControllerDelegate <NSObject>

- (void)backAddressKey:(NSString *)addressKey andInvoiceName:(NSString *)name;

@end

@interface JGHAddInvoiceViewController : ViewController
//tou
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)btn1:(UIButton *)sender;
- (IBAction)btn2:(UIButton *)sender;
- (IBAction)btn3:(UIButton *)sender;
- (IBAction)btn4:(UIButton *)sender;

//提示
@property (weak, nonatomic) IBOutlet UILabel *promptlabel;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;

//确定
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitBtn:(UIButton *)sender;


@property (weak, nonatomic)id <JGHAddInvoiceViewControllerDelegate> delegate;

@property (copy, nonatomic)NSString *invoiceKey;
//地址
- (IBAction)addreeBtn:(UIButton *)sender;

@property (nonatomic, strong)NSMutableDictionary *addressDict;

@property (weak, nonatomic) IBOutlet UILabel *addressName;//地址联系人名字

@property (weak, nonatomic) IBOutlet UILabel *addressNumber;//地址联系人号码

@property (weak, nonatomic) IBOutlet UILabel *addressDetails;//地址详情

@end
