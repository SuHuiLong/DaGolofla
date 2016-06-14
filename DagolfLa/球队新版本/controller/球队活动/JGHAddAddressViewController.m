//
//  JGHAddAddressViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddAddressViewController.h"
#import "TeamAreaViewController.h"

@interface JGHAddAddressViewController ()<UITextViewDelegate>
{
    NSString *_addressString;
}
@end


@implementation JGHAddAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"地址信息";
    self.addressTextView.delegate = self;
    
    self.commitBtn.layer.cornerRadius = 8.0;
    self.commitBtn.layer.masksToBounds = YES;
    
    if (_addressTextView.text.length == 0) {
        self.textLable.hidden = NO;
    }else{
        self.textLable.hidden = YES;
    }
    
    if ([self.addressDict count] != 0) {
        NSArray *strArray = [[self.addressDict objectForKey:@"address"] componentsSeparatedByString:@"-"];
        //详细地址
        self.addressTextView.text = [strArray lastObject];
        //城市地址
        NSString *str = nil;
        for (int i=0; i<strArray.count-1; i++) {
            [str stringByAppendingString:strArray[i]];
        }
        [self.address setTitle:str forState:UIControlStateNormal];
        
        _name.text = [self.addressDict objectForKey:@"userName"];//地址联系人名字
        _number.text = [self.addressDict objectForKey:@"mobile"];//地址联系人号码
    }
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
#pragma mark -- 确定
- (IBAction)commitBtn:(UIButton *)sender {
    if (_name.text.length == 0) {
        _name.layer.borderColor = [UIColor redColor].CGColor;
        _name.layer.borderWidth= 1.0f;
        return;
    }
    
    if (_number.text.length == 0) {
        _number.layer.borderColor = [UIColor redColor].CGColor;
        _number.layer.borderWidth= 1.0f;
        return;
    }
    
    if (_addressTextView.text.length == 0) {
        _addressTextView.layer.borderColor = [UIColor redColor].CGColor;
        _addressTextView.layer.borderWidth= 1.0f;
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if ([self.addressDict count] == 0) {
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [dict setObject:@0 forKey:@"timeKey"];
        [dict setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
        [dict setObject:@"发票名称" forKey:@"name"];//地址名称
        //    [dict setObject:[userdef objectForKey:userID] forKey:@"country"];//国家
        //    [dict setObject:[userdef objectForKey:userID] forKey:@"province"];//省份
        //    [dict setObject:[userdef objectForKey:userID] forKey:@"city"];//城市
        //    [dict setObject:[userdef objectForKey:userID] forKey:@"region"];//地区
        [dict setObject:[NSString stringWithFormat:@"%@%@",_addressString, _addressTextView.text] forKey:@"address"];//地址
        [dict setObject:_name.text forKey:@"userName"];//联系人
        [dict setObject:_number.text forKey:@"mobile"];//联系电话
        [self createAddress:dict];
    }else{
        dict = self.addressDict;
        [self updateAddress:dict];
    }
    

    
}
#pragma mark -- 更新地址
- (void)updateAddress:(NSMutableDictionary *)dict{
    [[JsonHttp jsonHttp]httpRequest:@"address/updateAddress" JsonKey:@"address" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue]==1) {
            if (self.delegate) {
                [self.delegate didSelectAddressDict:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}
#pragma mark -- 创建地址
- (void)createAddress:(NSMutableDictionary *)dict{
    [[JsonHttp jsonHttp]httpRequest:@"address/createAddress" JsonKey:@"address" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue]==1) {
            if (self.delegate) {
                [dict setObject:[data objectForKey:@"timeKey"] forKey:@"timeKey"];
                [self.delegate didSelectAddressDict:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}
#pragma mark -- 选址地址
- (IBAction)address:(UIButton *)sender {
    TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
    areaVc.teamType = @10;
    areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
        _addressString = [NSString stringWithFormat:@"%@-%@-", strPro, strCity];
        [self.address setTitle:_addressString forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:areaVc animated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textLable.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.textLable.hidden = NO;
    }else{
        self.textLable.hidden = YES;
    }
}

@end
