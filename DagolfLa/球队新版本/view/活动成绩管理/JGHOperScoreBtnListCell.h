//
//  JGHOperScoreBtnListCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHOperScoreBtnListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
- (IBAction)oneBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
- (IBAction)twoBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
- (IBAction)threeBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
- (IBAction)fourBtnClick:(UIButton *)sender;

@end
