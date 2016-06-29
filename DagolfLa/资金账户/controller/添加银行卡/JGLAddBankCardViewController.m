//
//  JGLAddBankCardViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLAddBankCardViewController.h"

#import "JGLAddBankNewsTableViewCell.h"
#import "JGLBankTypeView.h"

#import "MBProgressHUD.h"

@interface JGLAddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tableView;
    NSArray* _arrayTitle;
    NSArray* _arrayPlaceHolder;
    //输入的姓名和银行卡号
    NSString* _strName, *_strNum;
    //银行名
    NSString* _strBank;
    NSInteger _cardType;
    
    MBProgressHUD* _progress;
    
    NSInteger _isClick;
    
    JGLBankTypeView* _alert;
}
@end

@implementation JGLAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrayTitle = @[@[@"持卡人姓名"],@[@"选择银行",@"银行卡号"]];
    _arrayPlaceHolder = @[@"请填写真实姓名",@"请填写银行卡号"];
    self.title = @"添加银行卡";
    
    _isClick = NO;
    [self uiConfig];
    [self createBtn];
    
}


-(void)createBtn
{
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor orangeColor];
    [btnDelete setTitle:@"提交" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:17];
    btnDelete.frame = CGRectMake(10*screenWidth/375, 44*3*screenWidth/375 + 30*screenWidth/375, screenWidth-20*screenWidth/375, 44*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    [btnDelete addTarget:self action:@selector(addBankCardClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --添加提交的点击事件
-(void)addBankCardClick
{
    if (_isClick == YES) {
        [_alert dismissAlert];
        _isClick = NO;
    }
    
    [self.view endEditing:YES];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    
    
    
    [dict setObject:@0 forKey:@"timeKey"];
    //isPureNumandCharacters
    if (![Helper isBlankString:_strName]) {
        [dict setObject:_strName forKey:@"name"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请重新输入您的姓名" FromView:self.view];
        return;
    }
    if (![Helper isBlankString:_strNum]) {
        if ([Helper isPureNumandCharacters:_strNum]) {
            [dict setObject:_strNum forKey:@"cardNumber"];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:@"请重新输入银行卡号" FromView:self.view];
            return;
        }
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请重新输入银行卡号" FromView:self.view];
        return;
    }
    
    if (![Helper isBlankString:_strBank]) {
        [dict setObject:[NSNumber numberWithInteger:_cardType] forKey:@"cardType"];
        [dict setObject:_strBank forKey:@"backName"];
    }
    else{
        [[ShowHUD showHUD]showToastWithText:@"请选择银行" FromView:self.view];
        return;
    }
    
    
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在添加...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    [[JsonHttp jsonHttp] httpRequest:@"user/addBankCard" JsonKey:@"userBankCard" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@",errType);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } completionBlock:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _refreshBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20*screenWidth/375 + 44*3*screenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
}


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*screenWidth/375;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 2;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"JGLAddBankNewsTableViewCell";
    JGLAddBankNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JGLAddBankNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelTitle.text = _arrayTitle[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textField.userInteractionEnabled = NO;
        if ([Helper isBlankString:_strBank]) {
            cell.textField.text = @"选择您要添加的银行";
        }
        else{
            cell.textField.text = _strBank;
            
        }
    }
    else{
        cell.textField.hidden = NO;
        cell.textField.userInteractionEnabled = YES;
        if (indexPath.row == 0) {
            cell.textField.tag = 1001;
        }
        else{
            cell.textField.tag = 1002;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    cell.textField.placeholder = _arrayPlaceHolder[indexPath.section];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 0) {
        if (_isClick == NO) {
            NSInteger height ;
            if (screenWidth == 320) {
                height = 25;
            }
            else if (screenWidth == 375)
            {
                height = 20;
            }
            else{
                height = 15;
            }
            _isClick = YES;
            _alert = [[JGLBankTypeView alloc]initWithFrame:CGRectMake(0, screenHeight - 44*screenWidth/375*8-height, screenWidth, screenHeight)];
            [self.view addSubview:_alert];
            [_alert setCallBackTitle:^(NSInteger index,NSString* strBank) {
                _cardType = index;
                _strBank = strBank;
                _isClick = NO;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }];
        }
    }
}


#pragma mark --textfield
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_isClick == YES) {
        [_alert dismissAlert];
        _isClick = NO;
    }
    
    if (textField.tag == 1001) {
        _strName = textField.text;
    }
    else{
        _strNum = textField.text;
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

@end
