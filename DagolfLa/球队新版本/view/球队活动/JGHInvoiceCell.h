//
//  JGHInvoiceCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvoiceModel;

@interface JGHInvoiceCell : UITableViewCell

//抬头
@property (weak, nonatomic) IBOutlet UILabel *invoiceHeader;

//内容
@property (weak, nonatomic) IBOutlet UILabel *invoiceContact;

//地址
@property (weak, nonatomic) IBOutlet UILabel *invoiceAddress;

//类型
@property (weak, nonatomic) IBOutlet UILabel *invoiceType;
//勾选
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)selectBtn:(UIButton *)sender;

- (void)configInvoiceModel:(InvoiceModel *)model;

@end
