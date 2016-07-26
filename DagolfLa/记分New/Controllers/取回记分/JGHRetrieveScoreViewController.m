//
//  JGHRetrieveScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRetrieveScoreViewController.h"
#import "JGHRetrieveScoreModel.h"
#import "JGDHistoryScoreViewController.h"

@interface JGHRetrieveScoreViewController ()<UITextFieldDelegate>
{
    NSString *_invitationCode;//  邀请码
    NSInteger _editor;
    JGHRetrieveScoreModel *_model;
}

@end

@implementation JGHRetrieveScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.noView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"取回记分";
    _editor = 0;
    _model = [[JGHRetrieveScoreModel alloc]init];
    
    self.titleTop.constant = 20*ProportionAdapter;
    self.titleLeft.constant = 10*ProportionAdapter;
    self.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.bodyView.layer.cornerRadius = 8.0;
    self.bodyView.layer.masksToBounds = YES;

    self.bodyTop.constant = 10*ProportionAdapter;
    self.bodyLeft.constant = 10*ProportionAdapter;
    self.bodyRight.constant = 10*ProportionAdapter;
    
    self.bodyRight.constant = 10*ProportionAdapter;

    NSLayoutConstraint *submitHConstraint = [NSLayoutConstraint constraintWithItem:self.submitBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25*ProportionAdapter];
    NSLayoutConstraint *submitWConstraint = [NSLayoutConstraint constraintWithItem:self.submitBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60*ProportionAdapter];
    NSArray *submitArray = [NSArray arrayWithObjects:submitHConstraint, submitWConstraint,nil];
    [self.view addConstraints:submitArray];
    self.submitBtnTop.constant = 30*ProportionAdapter;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3.0;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.submitBtnDwon.constant = 15*ProportionAdapter;
    
    self.propmtLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    
    //failKey
    self.failKeyTop.constant = 25*ProportionAdapter;
//    self.failKey.secureTextEntry = YES;
    self.failKey.delegate = self;
    NSLayoutConstraint *failKeyHConstraint = [NSLayoutConstraint constraintWithItem:self.failKey attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:36*ProportionAdapter];
    NSLayoutConstraint *failKeyWConstraint = [NSLayoutConstraint constraintWithItem:self.failKey attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:160*ProportionAdapter];
    NSArray *failKeyArray = [NSArray arrayWithObjects:failKeyHConstraint, failKeyWConstraint,nil];
    [self.view addConstraints:failKeyArray];

    self.propmtLeft.constant = 10*ProportionAdapter;
    self.propmtTop.constant = 20*ProportionAdapter;
    self.propmtRight.constant = 10*ProportionAdapter;
    self.propmtDown.constant = 10*ProportionAdapter;
    
    self.noViewLeft.constant = 10*ProportionAdapter;
    self.noViewRight.constant = 10*ProportionAdapter;
    
    self.noDataLabelTop.constant = 8*ProportionAdapter;
    self.noDataLabelDown.constant = 10*ProportionAdapter;
    self.noDataLabel.font = [UIFont systemFontOfSize:13.0 *ProportionAdapter];
    
    self.eventViewTop.constant = 18 *ProportionAdapter;
    self.eventView.layer.cornerRadius = 8.0;
    self.eventView.layer.masksToBounds = YES;
    
    self.eventName.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.nameTop.constant = 8*ProportionAdapter;
    self.nameAndTimeTop.constant = 6*ProportionAdapter;
    self.nameAndTime.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.addressTop.constant = 6*ProportionAdapter;
    self.addressDown.constant = 8*ProportionAdapter;
    
    self.address.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    NSLayoutConstraint *inScoressWConstraint = [NSLayoutConstraint constraintWithItem:self.inScoress attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80*ProportionAdapter];
    NSArray *inScoressArray = [NSArray arrayWithObjects:inScoressWConstraint,nil];
    [self.view addConstraints:inScoressArray];
    self.inScoress.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.inScoress.layer.cornerRadius = 3*ProportionAdapter;
    self.inScoress.layer.masksToBounds = YES;
    self.inScoressBtnTop.constant = 10*ProportionAdapter;
    self.inScoressBtnDwon.constant = 15 *ProportionAdapter;
    self.inScoressViewTop.constant = 10*ProportionAdapter;
    
    self.eventView.layer.cornerRadius = 8.0;
    self.eventView.layer.masksToBounds = YES;

    self.inScoresView.layer.cornerRadius = 8.0;
    self.inScoresView.layer.masksToBounds = YES;
    self.inScoresView.hidden = YES;
    
    self.noView.hidden = YES;
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
#pragma mark -- UITextFliaView
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = textField.text.length + string.length - range.length;
    if (length >= 1) {
        _editor = 1;
        [self.submitBtn setBackgroundColor:[UIColor orangeColor]];
        return YES;
    }else{
        if (length < 1) {
            _editor = 0;
            [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#D4D4D4"]];
            return YES;
        }
        _editor = 0;
        [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#D4D4D4"]];
        return NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _invitationCode = textField.text;
    NSLog(@"%@", _invitationCode);

}

#pragma mark -- 确定
- (IBAction)submitBtnClick:(UIButton *)sender {
    [self.failKey resignFirstResponder];
    self.failKey.text = @"";
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#D4D4D4"]];
    
    if (_editor != 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //    [dict setObject:DEFAULF_USERID forKey:@"userKey"];//  用户key
        [dict setObject:@([_invitationCode integerValue]) forKey:@"invitationCode"];//  邀请码
        [[JsonHttp jsonHttp]httpRequest:@"score/getUserScoreByInvitationCode" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"packSuccess"] boolValue] == 1) {
                if ([data objectForKey:@"score"]) {
                    [_model setValuesForKeysWithDictionary:[data objectForKey:@"score"]];
                    
                    [self configData];
                }
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    self.noView.hidden = NO;
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    
                }
            }
        }];
    }
    
    _editor = 0;
}
#pragma mark -- 配置记分卡数据
- (void)configData{
    self.noView.hidden = YES;
    self.eventView.layer.borderWidth = 1;
    self.eventView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.inScoresView.hidden = NO;
    if (iPhone5) {
        self.propmtTop.constant = (155+10+10+10)*ProportionAdapter;
    }else{
        self.propmtTop.constant = (155+10+10)*ProportionAdapter;
    }
    
    self.eventName.text = _model.title;
    self.nameAndTime.text = [NSString stringWithFormat:@"%@  %@", _model.userName, _model.createtime];
    self.address.text = _model.ballName;
}

#pragma mark -- 放入记分卡
- (IBAction)inScoressBtnClick:(UIButton *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];//  用户key
    [dict setObject:_invitationCode forKey:@"invitationCode"];//  邀请码
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/receiveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //32169
            [[ShowHUD showHUD]showToastWithText:@"放入记分成功！" FromView:self.view];
            [self performSelector:@selector(pop) withObject:self afterDelay:1];

        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
