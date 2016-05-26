//
//  JGHAddInvoiceViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHAddInvoiceViewControllerDelegate <NSObject>

- (void)backAddressKey:(NSString *)addressKey;

@end

@interface JGHAddInvoiceViewController : ViewController

//发票抬头
@property (weak, nonatomic) IBOutlet UITextField *invoiceHeader;

//开票内容
@property (weak, nonatomic) IBOutlet UITextField *contact;

//邮寄地址
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressBtn:(UIButton *)sender;

//发票类型
//文具类
@property (weak, nonatomic) IBOutlet UIButton *stationeryBtn;
- (IBAction)stationeryBtn:(UIButton *)sender;

//办公用品
@property (weak, nonatomic) IBOutlet UIButton *OfficeBtn;
- (IBAction)OfficeBtn:(UIButton *)sender;

//餐饮
@property (weak, nonatomic) IBOutlet UIButton *foodBtn;
- (IBAction)foodBtn:(UIButton *)sender;

//勾选图片位置约束
//顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;
//顶部
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageBottomConstraint;

//确定
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitBtn:(UIButton *)sender;

@property (weak, nonatomic)id <JGHAddInvoiceViewControllerDelegate> delegate;

@property (copy, nonatomic)NSString *invoiceKey;

@end
