//
//  JGApplyMaterialViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGSelfSetViewController.h"
#import "JGApplyMaterialTableViewCell.h"
#import "JGButtonTableViewCell.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGTeamPayViewController.h"

#import "JGLTeamChoiseViewController.h"
@interface JGSelfSetViewController ()<UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *secondTableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)NSMutableDictionary *paraDic;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;

@end

@implementation JGSelfSetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setCellData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSelfSet) {
        self.title  = @"个人设置";
    }else{
        self.title  = @"入队申请资料";
    }
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(complete)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //    [self creatTableView];
    [self creatNewTableView];
    // Do any additional setup after loading the view.
}

- (void)pickerVieCreate{
    self.pickerView = [[UIPickerView alloc]init];
}


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1111) {
        return 3;
    }else{
        return 2;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1111) {
        return @[@"保密", @"男", @"女"][row];
    }else{
        return @[@"左手", @"右手"][row];
    }
}

//age选择器
-(void)createDataClick:(NSString *)string
{
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/3, ScreenWidth, ScreenHeight/3)];
    //    self.pickerBackView.userInteractionEnabled = YES;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        self.pickerBackView.frame = CGRectMake(0, ScreenHeight/3*2 - 49, ScreenWidth, ScreenHeight/3);
    //        self.pickerBackView.userInteractionEnabled = NO;
    //    } completion:nil];
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBackView];
    
    UIButton *_button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button1.frame = CGRectMake(20, 5, 50, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button1 addTarget:self action:@selector(buttonShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button1];
    
    
    UIButton *_button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button2.frame = CGRectMake(ScreenWidth-50, 5, 50, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button2 addTarget:self action:@selector(buttonMissClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button2];
    
    // 性别，年龄，差点的选择器
    // UIPickerView只有三个高度， heights for UIPickerView (162.0, 180.0 and 216.0)，用代码设置 pickerView.frame=cgrectmake()...
    [self setUpPickerView:1 frame:CGRectMake(screenWidth/ 2 - 50, 0, 100, 162) with:1111];
    
}
//hand选择器
-(void)createDataClickSec:(NSString *)string
{
    
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/3, ScreenWidth, ScreenHeight/3)];
    
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBackView];
    
    UIButton *_button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button1.frame = CGRectMake(20, 5, 50, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button1 addTarget:self action:@selector(buttonShowClickSec:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button1];
    
    
    UIButton *_button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button2.frame = CGRectMake(ScreenWidth-50, 5, 50, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button2 addTarget:self action:@selector(buttonMissClickSec:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button2];
    
    [self setUpPickerView:1 frame:CGRectMake(screenWidth/ 2 - 50, 0, 100, 162) with:2222];
    
}
// 根据选择器的数量和尺寸建立选择器
- (void)setUpPickerView:(NSInteger)pickerViewNumber frame:(CGRect)frame with: (NSInteger)tag
{
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.frame = frame;
    self.pickerView.tag = tag;
    
    [self.pickerBackView addSubview:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    //    [ self.pickerView. selectRow:1 inComponent:0 animated:YES];
}

- (void)buttonShowClickSec: (UIButton *)btn{
    
    
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }
    
    
    [self.paraDic setObject:@0 forKey:@"hand"];
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:5 inSection:1];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
}//buttonHand
#pragma mark --惯用手确定按钮
- (void)buttonMissClickSec: (UIButton *)btn{
    if (![self.paraDic objectForKey:@"hand"]) {
        [self.paraDic setObject:@0 forKey:@"hand"];
    }
    
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:5 inSection:1];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    if ([[self.paraDic objectForKey:@"hand"] integerValue] == 0) {
        [cell.button setTitle:@"左手" forState:(UIControlStateNormal)];
    }else if ([[self.paraDic objectForKey:@"hand"] integerValue] == 1) {
        [cell.button setTitle:@"右手" forState:(UIControlStateNormal)];
    }
}//buttonHand


- (void)buttonShowClick: (UIButton *)btn{
    
    
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }
    [self.paraDic setObject:@0 forKey:@"sex"];
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:1 inSection:0];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
}//button1

#pragma mark --性别确定按钮
- (void)buttonMissClick: (UIButton *)btn{
    if (![self.paraDic objectForKey:@"sex"]) {
        [self.paraDic setObject:@0 forKey:@"sex"];
    }
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }
    NSIndexPath *indexpat = [NSIndexPath indexPathForRow:1 inSection:0];
    JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexpat];
    if ([[self.paraDic objectForKey:@"sex"] integerValue] == 0) {
        [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
    }else if ([[self.paraDic objectForKey:@"sex"] integerValue] == 1) {
        [cell.button setTitle:@"男" forState:(UIControlStateNormal)];
    }else if ([[self.paraDic objectForKey:@"sex"] integerValue] == 2) {
        [cell.button setTitle:@"女" forState:(UIControlStateNormal)];
    }
}//button1

- (void)creatNewTableView{
    
    self.secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 26*screenWidth/320*2 + 40*screenWidth/320*11) style:UITableViewStylePlain];
    self.secondTableView.delegate = self;
    self.secondTableView.dataSource = self;
    [self.secondTableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.secondTableView registerClass:[JGButtonTableViewCell class] forCellReuseIdentifier:@"cellBtn"];
    [self.secondTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"cellLB"];
    [self.secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellSys"];

    self.titleArray = [NSArray arrayWithObjects:@[@"姓名", @"性别", @"手机号码"], @[@"行业", @"公司", @"职业",   @"常住地址", @"衣服尺码", @"惯用手"], nil];
    self.placeholderArray = [NSArray arrayWithObjects:@[@"请输入真实姓名", @"请输入", @"请输入手机号" ],@[@"请输入你的行业",@"请输入你的公司",@"请输入你的职位",@"方便活动邀请", @"统一制服制定", @"制定特殊需求"],  nil];
    [self.view addSubview: self.secondTableView];
    
}

// 创建选择性别的选择器
- (void)cellBtn{
    [self.view endEditing:YES];
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }else{
        [self createDataClick:@"lalala"];
    }
}

//
- (void)cellBtnSec{
    [self.view endEditing:YES];
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }else{
        [self createDataClickSec:@"lalla"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[self.view subviews] containsObject:self.pickerBackView]) {
        [self.pickerBackView removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        JGLTeamChoiseViewController* tcVc = [[JGLTeamChoiseViewController alloc]init];
        tcVc.dataArray = @[@"女",@"男",@"保密"];
        tcVc.introBlock = ^(NSString* strName, NSNumber* num){
            JGLableAndLableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.contentLB.text = strName;
            if ([num integerValue] == 2) {
                [self.paraDic setObject:@-1 forKey:@"sex"];
            }else{
                [self.paraDic setObject:num forKey:@"sex"];
            }
        };
        [self.navigationController pushViewController:tcVc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 5)
    {
        JGLTeamChoiseViewController* tcVc = [[JGLTeamChoiseViewController alloc]init];
        tcVc.dataArray = @[@"左手",@"右手"];
        tcVc.introBlock = ^(NSString* strName, NSNumber* num){
            JGLableAndLableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.contentLB.text = strName;
            [self.paraDic setObject:num forKey:@"hand"];

        };
        [self.navigationController pushViewController:tcVc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        JGTeamPayViewController *teamPayVC = [[JGTeamPayViewController alloc] init];
        teamPayVC.detailDic = self.memeDic;
        teamPayVC.name = [self.detailDic objectForKey:@"name"];
        [self.navigationController pushViewController:teamPayVC animated:YES];
    }else{
        return;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1111) {
        [self.paraDic setObject:@(row) forKey:@"sex"];
    }else{
        [self.paraDic setObject:@(row) forKey:@"hand"];
    }
}

#pragma mark ------提及
- (void)complete{
    BOOL isLength = YES;
    [self.view endEditing:YES];
    NSArray *array = [NSArray arrayWithObjects:@"userName", @"sex", @"mobile", nil];
    
    for (int i = 0; i < 3; i ++) {
        
        if (i == 1) {
            //            JGButtonTableViewCell *cell = self.secondTableView.visibleCells[i];
            //            [self.paraDic setObject:@([cell.button.titleLabel.text  integerValue]) forKey:array[i]];
            
        }else{
            
            JGApplyMaterialTableViewCell *cell = self.secondTableView.visibleCells[i];
            
            if (i == 2) {
                if (cell.textFD.text.length == 11 && [Helper isPureNumandCharacters:cell.textFD.text]) {
                    NSLog(@"11数字");
                }else{
                    [[ShowHUD showHUD]showToastWithText:@"请输入正确格式的手机号！" FromView:self.view];
                    return;
                }
            }else{
                if (!cell.textFD.text || ([cell.textFD.text length] == 0)) {
                    isLength = NO;
                }else{
                    [self.paraDic setObject:cell.textFD.text  forKey:array[i]];
                }
            }

        }
    }
    
    NSArray *secArray = [NSArray arrayWithObjects:@"industry", @"company", @"occupation", @"address", @"size", @"hand", nil];
    
    for (int i = 0; i < 6; i ++) {
        if (i == 5) {
            
            //            JGButtonTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            //
            //            [self.paraDic setObject:@([cell.button.titleLabel.text  integerValue]) forKey:array[i]];
            
        }else{
            
            JGApplyMaterialTableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            if (cell.textFD.text && ([cell.textFD.text length] != 0)) {
                [self.paraDic setObject:cell.textFD.text  forKey:secArray[i]];
            }
        }
    }
    
    if (isLength) {
        
        //        [self.paraDic setObject:@83 forKey:@"userKey"];   // TEST
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"almost"] != nil) {
            [self.paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"almost"] forKey:@"almost"];
        }else{
            [self.paraDic setObject:@0 forKey:@"almost"];
        }
        [self.paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
        [self.paraDic setObject:[self.memeDic objectForKey:@"timeKey"] forKey:@"timeKey"];
        [self.paraDic setObject:[self.memeDic objectForKey:@"teamKey"] forKey:@"teamKey"];

//        [self.paraDic setObject:@0 forKey:@"state"];
        
        [self.paraDic setObject:[Helper returnCurrentDateString] forKey:@"createTime"];
//        [self.paraDic setObject:@0 forKey:@"timeKey"];
        
        if (self.isSelfSet) {
            
            [[JsonHttp jsonHttp] httpRequest:@"team/updateTeamMember" JsonKey:@"newMembr" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {

            }];
            
            
        }else{
            
//            [[JsonHttp jsonHttp] httpRequest:@"team/reqJoinTeam" JsonKey:@"teamMemeber" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
//                [Helper alertViewNoHaveCancleWithTitle:@"提交失败 请稍后再试" withBlock:^(UIAlertController *alertView) {
//                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
//                }];
//            } completionBlock:^(id data) {
//                NSLog(@"%@", data);
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }];
        }
        
        [self.navigationController popViewControllerAnimated:YES];

        [Helper alertViewNoHaveCancleWithTitle:@"提交成功" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }else{
        [Helper alertViewNoHaveCancleWithTitle:@"请完善信息" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 6;
    }else{
        return 1;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"必填项";
    }else if (section == 1){
        return @"选填项";
    }else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labell.text = @"姓名";
        cell.labell.textColor = [UIColor lightGrayColor];
        if ([self.memeDic objectForKey:@"userName"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"userName"];
            return cell;

        }else{
            cell.textFD.placeholder = @"请输入姓名";
            return cell;

        }
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        
        
        JGLableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellLB" forIndexPath:indexPath];
        cell.promptLB.text = self.titleArray[indexPath.section][indexPath.row];
        cell.promptLB.textColor = [UIColor lightGrayColor];
        cell.contentLB.frame = CGRectMake(100  * screenWidth / 320, 15 * screenWidth / 320, screenWidth - 130  * screenWidth / 320, 15 * screenWidth / 320);
        if ([self.memeDic objectForKey:@"sex"]) {

            if ([[self.memeDic objectForKey:@"sex"] integerValue] == 0) {
                cell.contentLB.text = @"女";
            }else if ([[self.memeDic objectForKey:@"sex"] integerValue] == 1){
                cell.contentLB.text = @"男";
            }else{
                cell.contentLB.text = @"保密";
            }
        }else{
            cell.contentLB.text = @"请选择";
        }
        
        cell.contentLB.textAlignment = NSTextAlignmentRight;
        cell.contentLB.textColor = [UIColor blackColor];
        //        [cell.button addTarget:self action:@selector(cellBtn) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
        /*
        JGButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellBtn" forIndexPath:indexPath];
        cell.labell.text = @"性别";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button addTarget:self action:@selector(cellBtn) forControlEvents:(UIControlEventTouchUpInside)];
        if ([self.memeDic objectForKey:@"sex"]) {
            if ([self.memeDic objectForKey:@"sex"] == 0) {
                [cell.button setTitle:@"保密" forState:(UIControlStateNormal)];
            }else if ([[self.memeDic objectForKey:@"sex"] integerValue] == 1){
                [cell.button setTitle:@"男" forState:(UIControlStateNormal)];
            }else{
                [cell.button setTitle:@"女" forState:(UIControlStateNormal)];
            }
        }else{
            [cell.button setTitle:@"性别" forState:(UIControlStateNormal)];
            
        }*/
        return cell;

    }else if (indexPath.section == 0 && indexPath.row == 2){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"手机号码";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"mobile"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"mobile"];
            return cell;

        }else{
            cell.textFD.placeholder = @"请输入手机号码";
            return cell;

        }
    }else if (indexPath.section == 1 && indexPath.row == 0){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"行业";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"industry"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"industry"];
            return cell;
        }else{
            cell.textFD.placeholder = @"请输入你的行业";
            return cell;
        }

    }else if (indexPath.section == 1 && indexPath.row == 1){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"公司";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"company"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"company"];
            return cell;
        }else{
            cell.textFD.placeholder = @"请输入你的公司";
            return cell;
        }
    }else if (indexPath.section == 1 && indexPath.row == 2){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"职业";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"occupation"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"occupation"];
            return cell;
        }else{
            cell.textFD.placeholder = @"请输入你的职业";
              return cell;
        }

    }else if (indexPath.section == 1 && indexPath.row == 3){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"常住地址";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"address"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"address"];
              return cell;
        }else{
            cell.textFD.placeholder = @"请输入你的常住地址";
            return cell;

        }
    }else if (indexPath.section == 1 && indexPath.row == 4){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"衣服尺码";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.memeDic objectForKey:@"size"]) {
            cell.textFD.text = [self.memeDic objectForKey:@"size"];
            return cell;

        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textFD.placeholder = @"请输入你的衣服尺码";
             return cell;
        }

    }else if (indexPath.section == 1 && indexPath.row == 5){
        
        JGLableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellLB" forIndexPath:indexPath];
        cell.promptLB.text = self.titleArray[indexPath.section][indexPath.row];
        cell.promptLB.textColor = [UIColor lightGrayColor];
        cell.contentLB.frame = CGRectMake(100  * screenWidth / 320, 15 * screenWidth / 320, screenWidth - 130  * screenWidth / 320, 15 * screenWidth / 320);
        
        if ([self.memeDic objectForKey:@"hand"]) {
            if ([[self.memeDic objectForKey:@"hand"] integerValue]== 0) {
                cell.contentLB.text = @"左手";
            }else if ([[self.memeDic objectForKey:@"hand"] integerValue] == 1){
                cell.contentLB.text = @"右手";
            }
        }else{
            cell.contentLB.text = @"请选择";
        }
        
        cell.contentLB.textColor = [UIColor blackColor];
        cell.contentLB.textAlignment = NSTextAlignmentRight;
        //        [cell.button addTarget:self action:@selector(cellBtnSec) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        /*
        JGButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellBtn" forIndexPath:indexPath];
        cell.labell.text = @"惯用手";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button addTarget:self action:@selector(cellBtnSec) forControlEvents:(UIControlEventTouchUpInside)];
        if ([self.memeDic objectForKey:@"hand"]) {
            if ([[self.memeDic objectForKey:@"hand"] integerValue]== 0) {
                [cell.button setTitle:@"左手" forState:(UIControlStateNormal)];
            }else if ([[self.memeDic objectForKey:@"hand"] integerValue] == 1){
                [cell.button setTitle:@"右手" forState:(UIControlStateNormal)];
            }
        }else{
            [cell.button setTitle:@"请输入惯用手" forState:(UIControlStateNormal)];
            
        }
         */
        return cell;

    }else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSys"];
        cell.textLabel.text = @"球队会费支付";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
    
}



- (void)setCellData{

    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textFD.text = [self.memeDic objectForKey:@"userName"];
        }else if (i == 2){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textFD.text = [self.memeDic objectForKey:@"mobile"];
        }else if (i == 1){
            JGButtonTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.button setTitle:[self.memeDic objectForKey:@"sex"] forState:(UIControlStateNormal)];
            
        }
    }
    
    for (int i = 0; i < 6; i ++) {
        
        if (i == 0) {
            
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.textFD.text = [self.memeDic objectForKey:@"industry"];
        }else if (i == 1){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.textFD.text = [self.memeDic objectForKey:@"company"];
            
        }else if (i == 2){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.textFD.text = [self.memeDic objectForKey:@"industry"];
            
        }else if (i == 3){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.textFD.text = [self.memeDic objectForKey:@"address"];
            
        }else if (i == 4){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.textFD.text = [self.memeDic objectForKey:@"size"];
            
        }else if (i == 5){
            JGButtonTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            [cell.button setTitle:[self.memeDic objectForKey:@"hand"] forState:(UIControlStateNormal)];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 10 * screenWidth / 320;
    }else{
        return 26 * screenWidth / 320;
    }
}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
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
