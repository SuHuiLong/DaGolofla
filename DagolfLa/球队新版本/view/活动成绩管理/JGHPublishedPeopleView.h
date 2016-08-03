//
//  JGHPublishedPeopleView.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHPublishedPeopleView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;//13

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
- (IBAction)selectAllBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectAllBtnWith;//50


@property (weak, nonatomic) IBOutlet UILabel *proLabel;//font 15

@property (weak, nonatomic) IBOutlet UILabel *provalue;// font 17

@property (weak, nonatomic) IBOutlet UIButton *publishedBtn;// font 17
- (IBAction)publishedBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishedBtnWith;//60



@end
