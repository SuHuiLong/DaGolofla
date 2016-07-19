//
//  JGHRetrieveScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRetrieveScoreViewController.h"

@interface JGHRetrieveScoreViewController ()

@end

@implementation JGHRetrieveScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleTop.constant = 26*ProportionAdapter;
    self.titleLeft.constant = 10*ProportionAdapter;
    self.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    NSLayoutConstraint *bodyHConstraint = [NSLayoutConstraint constraintWithItem:self.bodyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:130*ProportionAdapter];
    NSArray *bodyArray = [NSArray arrayWithObjects:bodyHConstraint, nil];
    [self.view addConstraints:bodyArray];

    self.bodyTop.constant = 10*ProportionAdapter;
    self.bodyLeft.constant = 10*ProportionAdapter;
    self.bodyRight.constant = 10*ProportionAdapter;
    
    self.bodyRight.constant = 25*ProportionAdapter;

    NSLayoutConstraint *submitHConstraint = [NSLayoutConstraint constraintWithItem:self.submitBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60*ProportionAdapter];
    NSLayoutConstraint *submitWConstraint = [NSLayoutConstraint constraintWithItem:self.submitBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:130*ProportionAdapter];
    NSArray *submitArray = [NSArray arrayWithObjects:submitHConstraint, submitWConstraint,nil];
    [self.view addConstraints:submitArray];
    self.submitBtnTop.constant = 30*ProportionAdapter;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 8.0;
    
    //failKey
    NSLayoutConstraint *failKeyHConstraint = [NSLayoutConstraint constraintWithItem:self.failKey attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:21*ProportionAdapter];
    NSLayoutConstraint *failKeyWConstraint = [NSLayoutConstraint constraintWithItem:self.failKey attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:158*ProportionAdapter];
    NSArray *failKeyArray = [NSArray arrayWithObjects:failKeyHConstraint, failKeyWConstraint,nil];
    [self.view addConstraints:failKeyArray];

    self.propmtLeft.constant = 10*ProportionAdapter;
    self.propmtTop.constant = 10*ProportionAdapter;
    self.propmtRight.constant = 10*ProportionAdapter;
    self.propmtDown.constant = 10*ProportionAdapter;
    
    self.noViewLeft.constant = 10*ProportionAdapter;
    self.noViewRight.constant = 10*ProportionAdapter;
    self.noViewDown.constant = 10*ProportionAdapter;
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

- (IBAction)submitBtnClick:(UIButton *)sender {
}
@end
