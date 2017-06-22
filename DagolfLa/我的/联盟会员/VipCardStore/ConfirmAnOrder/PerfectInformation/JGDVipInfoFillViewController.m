//
//  JGDVipInfoFillViewController.m
//  DagolfLa
//
//  Created by 東 on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDVipInfoFillViewController.h"
#import "JGDInfoTextFieldTableViewCell.h"
#import "JGDTakeCodeTableViewCell.h"
#import "JGDPickerView.h"

//#import "JGDPhotoIploadViewController.h"
#import "VipCardConfirmOrderViewController.h"

@interface JGDVipInfoFillViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSArray *placeholderArray;
@property (nonatomic, strong) NSArray *inputArray;

@property (nonatomic, assign) NSInteger timeNumber;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isAllFilled;
@end

@implementation JGDVipInfoFillViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(poptoVipDetail)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isAllFilled = NO;
    self.title = @"会员信息";
    self.infoTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.infoTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.scrollEnabled = false;
    [self.view addSubview:self.infoTableView];
    
    [self.infoTableView registerClass:[JGDInfoTextFieldTableViewCell class] forCellReuseIdentifier:@"infoTextField"];
    [self.infoTableView registerClass:[JGDTakeCodeTableViewCell class] forCellReuseIdentifier:@"TakeCode"];
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(10 * ProportionAdapter, 388 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 46 * ProportionAdapter)];
    self.nextButton.clipsToBounds = YES;
    self.nextButton.layer.cornerRadius = 6.f;
    self.nextButton.enabled = NO;
    [self.nextButton setTitle:@"完成" forState:UIControlStateNormal];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#A0A0A0"];
    [self.nextButton addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    self.placeholderArray = @[@[@"请输入会员姓名"], @[@"请选择会员性别"], @[@"请选择证件类型", @"请输入证件号"], @[@"请输入会员手机号", @"请输入验证码"]];
    if (self.inputModel.userKey) {
        self.inputArray = @[@[self.inputModel.userName], @[self.inputModel.sex ? @"男" : @"女"], @[@"身份证", self.inputModel.certNumber], @[self.inputModel.mobile, @""]];
    }else{
        self.inputArray = @[@[@""], @[@""], @[@"身份证", @""], @[@"", @""]];
    }
    self.timeNumber = 60;

    // Do any additional setup after loading the view.
}

#pragma mark -- 完成 --

- (void)previewBtnClick:(UIButton *)commitBtn{
    
    [self.view endEditing:YES];
    [self allInfoIsFilled];
    
    NSArray *keyArray = [NSArray arrayWithObjects:@"userName", @"sex", @"certType", @"certNumber", @"mobile", @"checkCode", nil];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [[self.infoTableView visibleCells] count]; i ++) {
        if (i < [[self.infoTableView visibleCells] count] - 1) {
            JGDInfoTextFieldTableViewCell *icell = [self.infoTableView visibleCells][i];
            [infoDic setObject:icell.infoTextField.text forKey:keyArray[i]];
            
        }else{
            JGDTakeCodeTableViewCell *icell = [self.infoTableView visibleCells][i];
            [infoDic setObject:icell.txFD.text forKey:keyArray[i]];

        }
    }

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:[infoDic objectForKey:@"mobile"] forKey:@"telphone"];
    [dataDic setObject:[infoDic objectForKey:@"checkCode"] forKey:@"checkCode"];
    [dataDic setObject:DEFAULF_USERID forKey:@"userKey"];
    commitBtn.userInteractionEnabled = NO;
    
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doCheckCreateSystemLeagueUserSms" JsonKey:nil withData:dataDic failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        commitBtn.userInteractionEnabled = YES;
        
    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        commitBtn.userInteractionEnabled = YES;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self sendOtherData:infoDic];
            /*
             移除审核上传照片
             JGDPhotoIploadViewController * photoVC = [[JGDPhotoIploadViewController alloc] init];
             photoVC.infoDic = infoDic;
             if (self.inputModel.userKey) {
             [photoVC.infoDic setObject:self.inputModel.picHeadURL forKey:@"picHeadURL"];
             [photoVC.infoDic setObject:self.inputModel.picCertURLs forKey:@"picCertURLs"];
             }
             [self.navigationController pushViewController:photoVC animated:YES];
            */
        }else{

            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    
}

//获取照片id之后提交其余数据
-(void)sendOtherData:(NSDictionary *)infoDic{
    NSString *sexStr = @"0";
    if ([[infoDic objectForKey:@"sex"] isEqualToString:@"男"]) {
        sexStr = @"1";
    }
    NSDictionary *user = @{
                           @"userKey":DEFAULF_USERID,
                           @"userName":[infoDic objectForKey:@"userName"],
                           @"mobile":[infoDic objectForKey:@"mobile"],
                           @"sex":sexStr,
                           @"certType":@"0",
                           @"certNumber":[infoDic objectForKey:@"certNumber"]
                           };
    
    NSMutableDictionary *luserDic = [NSMutableDictionary dictionaryWithDictionary:user];
    
    NSDictionary *certDic = @{
                              @"telphone":[infoDic objectForKey:@"mobile"],
                              @"checkCode":[infoDic objectForKey:@"checkCode"],
                              @"userKey":DEFAULF_USERID,
                              @"luinfo":luserDic
                              };

    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"league/doSaveSystemLeagueUInfo" JsonKey:nil withData:certDic failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:true];
        }else{
            
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 1) {
            JGDTakeCodeTableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"TakeCode"];
            tcell.txFD.placeholder = @"请输入验证码";
            tcell.txFD.delegate = self;
            [tcell.takeBtn addTarget:self action:@selector(codeGet:) forControlEvents:(UIControlEventTouchUpInside)];
            return tcell;

        }else{
            JGDInfoTextFieldTableViewCell *icell = [tableView dequeueReusableCellWithIdentifier:@"infoTextField"];
            icell.infoTextField.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
            icell.infoTextField.text = self.inputArray[indexPath.section][indexPath.row];
            icell.infoTextField.delegate = self;
            icell.infoTextField.keyboardType = UIKeyboardTypeNumberPad;
            icell.accessoryType = UITableViewCellAccessoryNone;
            return icell;
        }
        
    } else if (indexPath.section == 2) {
        
        JGDInfoTextFieldTableViewCell *icell = [tableView dequeueReusableCellWithIdentifier:@"infoTextField"];
        icell.infoTextField.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
        icell.infoTextField.text = self.inputArray[indexPath.section][indexPath.row];
        icell.infoTextField.delegate = self;
        
        if (indexPath.row == 1) {
            icell.infoTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        } else if (indexPath.row == 0){
            
            icell.accessoryType = UITableViewCellAccessoryNone;
            icell.infoTextField.text = @"身份证";
            icell.infoTextField.enabled = NO;
            
        }
        return icell;
        
    }else{
        
        JGDInfoTextFieldTableViewCell *icell = [tableView dequeueReusableCellWithIdentifier:@"infoTextField"];
        icell.infoTextField.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
        icell.infoTextField.text = self.inputArray[indexPath.section][indexPath.row];
        icell.infoTextField.delegate = self;
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            icell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            icell.infoTextField.enabled = NO;
            
        }else{
            icell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return icell;
    }

}

- (void)codeGet:(UIButton *)btn{

    JGDTakeCodeTableViewCell *tcell = (JGDTakeCodeTableViewCell *)[[btn superview] superview];
    JGDInfoTextFieldTableViewCell *photoCell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];

    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    if (photoCell.infoTextField.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"发送中..." FromView:self.view];
    tcell.takeBtn.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [codeDict setObject:photoCell.infoTextField.text forKey:@"telphone"];
    //
    [codeDict setObject:@"0086" forKey:@"countryCode"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"league/doSendCreateSystemLeagueUserSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        tcell.takeBtn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
        }else{
            tcell.takeBtn.userInteractionEnabled = YES;
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    
    
}

- (void)autoMove {
    
    JGDTakeCodeTableViewCell *tcell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    
    _timeNumber--;
    [tcell.takeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    tcell.takeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [tcell.takeBtn setTitle:[NSString stringWithFormat:@"(%tds)后重新获取", _timeNumber] forState:UIControlStateNormal];
    
    if (_timeNumber == 0) {
        [tcell.takeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        tcell.takeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [tcell.takeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timeNumber = 60;
        
        tcell.takeBtn.userInteractionEnabled = YES;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDInfoTextFieldTableViewCell *icell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1) {
    
        JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        pickView.dataArray = @[@"男", @"女"];
        pickView.blockStr = ^(NSString *string){
            icell.infoTextField.text = string;
            [self allInfoIsFilled];
        };
        [self.view addSubview:pickView];

    }else if ((indexPath.section == 2) && (indexPath.row == 0)) {

//        JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        pickView.dataArray = @[@"驾驶证", @"身份证", @"护照"];
//        pickView.blockStr = ^(NSString *string){
//            icell.infoTextField.text = string;
//            [self allInfoIsFilled];
//        };
//        [self.view addSubview:pickView];

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self allInfoIsFilled];
}

- (void)allInfoIsFilled{
    self.isAllFilled = YES;
    
   
    for (UITableViewCell *cell in [self.infoTableView visibleCells]) {
        
        if ([cell isKindOfClass:[JGDInfoTextFieldTableViewCell class]]) {
            JGDInfoTextFieldTableViewCell *infoCell =(JGDInfoTextFieldTableViewCell *)cell;
            
            if ([infoCell.infoTextField.text isEqualToString:@""]) {
                // 灰
                //                [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#A0A0A0"]];
                self.isAllFilled = NO;
            }
        }else if ([cell isKindOfClass:[JGDTakeCodeTableViewCell class]]) {
            JGDTakeCodeTableViewCell *codeCell = (JGDTakeCodeTableViewCell *)cell;
            if ([codeCell.txFD.text isEqualToString:@""]) {
                // 灰
                //                [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#A0A0A0"]];
                self.isAllFilled = NO;
            }
        }
    }
    
    
    if (self.isAllFilled) {
        [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
        self.nextButton.enabled = YES;
    }else{
        [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#A0A0A0"]];
        self.nextButton.enabled = NO;
    }
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ((section == 0) || (section == 1)) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001;
}

- (void)poptoVipDetail{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[VipCardConfirmOrderViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

//- (NSMutableArray *)inputArray{
//    if (!_inputArray) {
//        _inputArray = [[NSMutableArray alloc] init];
//    }
//    return _inputArray;
//}

-(void)dealloc
{
    _timer = nil;
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
