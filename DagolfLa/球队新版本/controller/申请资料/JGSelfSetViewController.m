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
@interface JGSelfSetViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *secondTableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)NSMutableDictionary *paraDic;

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



#pragma mark ------提及
- (void)complete{
    BOOL isLength = YES;
    [self.view endEditing:YES];
    NSArray *array = [NSArray arrayWithObjects:@"userName", @"sex", @"mobile", @"almost", nil];
    
    for (int i = 0; i < 4; i ++) {
        
        if (i == 1) {
            //            JGButtonTableViewCell *cell = self.secondTableView.visibleCells[i];
            //            [self.paraDic setObject:@([cell.button.titleLabel.text  integerValue]) forKey:array[i]];
            
        }else{
            
            JGApplyMaterialTableViewCell *cell = self.secondTableView.visibleCells[i];
            
            if (i == 2) {
                if (cell.textFD.text.length == 11 && [Helper isPureNumandCharacters:cell.textFD.text]) {
                    NSLog(@"11数字");
                    [self.paraDic setObject:cell.textFD.text  forKey:array[i]];
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
        return 4;
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
    }else if (indexPath.section == 0 && indexPath.row == 3){
        JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.labell.text = @"差点";
        cell.labell.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
#warning ------
        cell.textFD.delegate = self;
        cell.textFD.tag = 1000;
        if ([self.memeDic objectForKey:@"almost"]) {
            if ([[self.memeDic objectForKey:@"almost"] floatValue] == -10000) {
                cell.textFD.placeholder = @"请输入你的差点";
                cell.textFD.text = @"";
            }else{
                cell.textFD.text = [NSString stringWithFormat:@"%.0f",[[self.memeDic objectForKey:@"almost"] floatValue]];
            }
            
            return cell;
        }else{
            cell.textFD.placeholder = @"请输入你的差点";
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
        }else if (i == 3){
            JGApplyMaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textFD.text = [NSString stringWithFormat:@"%.1f",[[self.memeDic objectForKey:@"almost"] floatValue]];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1000){
        NSLog(@"差点");
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"almost_system_setting"] integerValue]) {
            //队员、球友
            if ([[user objectForKey:@"almost_system_setting"] integerValue] == 1) {
                //不可以编辑
                //[textField canResignFirstResponder];
                [LQProgressHud showInfoMsg:@"您启用了君高差点系统，无法手动更改。\n可移步『系统设置』关闭该系统。"];
                return NO;
            }else{
                return YES;
            }
        }else{
            //嘉宾
            return YES;
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.tag == 1000) {
        NSCharacterSet *cs;
        if(textField)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:ALMOSTNUMBERS] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if(!basicTest)
            {
                [[ShowHUD showHUD]showToastWithText:@"请输入整数数字" FromView:self.view];
                return NO;
            }
        }
        //其他的类型不需要检测，直接写入
        return YES;
    }else{
        return YES;
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
