//
//  JGHAddAddressViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHAddAddressViewControllerDelegate <NSObject>

- (void)didSelectAddressDict:(NSMutableDictionary *)addressDict;

@end

@interface JGHAddAddressViewController : ViewController

@property (nonatomic, weak)id <JGHAddAddressViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (IBAction)commitBtn:(UIButton *)sender;
//详细地址textView
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
//地址按钮
@property (weak, nonatomic) IBOutlet UIButton *address;
- (IBAction)address:(UIButton *)sender;
//电话
@property (weak, nonatomic) IBOutlet UITextField *number;
//name
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UILabel *textLable;

@property (nonatomic, strong)NSMutableDictionary *addressDict;


@end
