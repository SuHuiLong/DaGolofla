//
//  JGHConcentTextViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHConcentTextViewControllerDelegate <NSObject>

- (void)didSelectSaveBtnClick:(NSString *)text;//

@end

@interface JGHConcentTextViewController : ViewController

//页面标题问题
@property (nonatomic, copy)NSString *itemText;

@property (nonatomic, assign)NSInteger isNull;

//保存按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
//保存按钮事件
- (IBAction)saveBtn:(UIButton *)sender;
//限制文字
@property (weak, nonatomic) IBOutlet UILabel *labelText;
//输入的内容
@property (weak, nonatomic) IBOutlet UITextView *contentText;
//存储输入的内容
@property (copy, nonatomic) NSString *contentTextString;
//占位符
@property (weak, nonatomic) IBOutlet UILabel *placeholdertext;

@property (weak, nonatomic) id <JGHConcentTextViewControllerDelegate> delegate;

@end
