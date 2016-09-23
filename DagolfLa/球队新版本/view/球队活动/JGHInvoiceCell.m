//
//  JGHInvoiceCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHInvoiceCell.h"
#import "InvoiceModel.h"

@implementation JGHInvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtn:(UIButton *)sender {
}

- (void)configInvoiceModel:(InvoiceModel *)model{
    //抬头
//    @property (weak, nonatomic) IBOutlet UILabel *invoiceHeader;
    self.invoiceHeader.text = model.title;
    
    //内容
//    @property (weak, nonatomic) IBOutlet UILabel *invoiceContact;
    self.invoiceContact.text = model.info;
    //地址
//    @property (weak, nonatomic) IBOutlet UILabel *invoiceAddress;
//    self.invoiceAddress.text = model.
    //类型
//    @property (weak, nonatomic) IBOutlet UILabel *invoiceType;
    if (model.type == 1) {
        self.invoiceType.text = @"文具类";
    }else if (model.type == 2){
        self.invoiceType.text = @"办公用品";
    }else{
        self.invoiceType.text = @"餐饮";
    }
}

@end
