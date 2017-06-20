//
//  SelfViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/24.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelfViewController.h"


#import "MySelfTableViewCell.h"
#import "MyselfImpotTableViewCell.h"
#import "MyselfChooseViewCell.h"
#import "MeselfModel.h"
#import "JobChooseViewController.h"
#import "DateTimeViewController.h"
#define kUpDateData_URL @"user/updateUserInfo.do"
#import <RongIMKit/RongIMKit.h>
#import "SXPickPhoto.h"

@interface SelfViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    UIScrollView* _scrollView;
    NSInteger _contSize;
    MeselfModel *_model;
    NSInteger current;
    UIButton* _btnBack;
    
    BOOL isClick;
    
    NSMutableDictionary* _dict;
    
    NSMutableString* _str;
    
    NSData *_photoData;
    NSMutableArray* _arrayPage;//图片数组
    NSMutableArray* _arrayChange;//跟换的行业等文字
    
    BOOL _birIsClick;
    BOOL _jobIsClick;
    
    NSString* _strPIC;
}

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类



@end

@implementation SelfViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarController.tabBar.hidden = YES;

    NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
    [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
    [dictUser setObject:strMD forKey:@"md5"];

    [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"]boolValue]) {
            
            _model = [[MeselfModel alloc] init];
            [_model setValuesForKeysWithDictionary:[data objectForKey:@"user"]];
            [_tableView reloadData];
        }
    }];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBack.backgroundColor = [UIColor blackColor];
    _btnBack.hidden = YES;
    _btnBack.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_btnBack];
    _btnBack.alpha = 0.5;
    [_btnBack addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backButtonClcik{
    [self.view endEditing:YES];
    if ([_fromEnroll integerValue] == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        if (_blockRereshingMe) {
            _blockRereshingMe(_arrayPage);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



//覆盖在视图上的灰色按钮背景
-(void)backClick:(UIButton* )btn
{
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBack.hidden = YES;
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    
    _pickPhoto = [[SXPickPhoto alloc]init];
    _arrayPage = [[NSMutableArray alloc]init];
    _arrayChange = [[NSMutableArray alloc]init];
    _arrayChange = [NSMutableArray arrayWithArray:@[@"请选择日期",@"请选择行业"]];
    if (ScreenHeight <= 480) {
        _scrollView.contentSize = CGSizeMake(0, 568-64);
    }
    else{
        _scrollView.contentSize = CGSizeMake(0, ScreenHeight-64);
    }
    _scrollView.bounces = NO;
    
    _dict = [[NSMutableDictionary alloc]init];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _str = [[NSMutableString alloc]init];
    if (defaults) {
        
        _str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
        [_dict setObject:_str forKey:@"userId"];
    }
    [self uiConfig];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    _dataArray = [[NSMutableArray alloc]init];
    
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MySelfTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySelfTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyselfImpotTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyselfImpotTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyselfChooseViewCell" bundle:nil] forCellReuseIdentifier:@"MyselfChooseViewCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 9 + 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80*ScreenWidth/375;
    }
    else if (indexPath.row == 5 || indexPath.row == 10)
    {
        return 15*ScreenWidth/375;
    }
    else
    {
        return 44*ScreenWidth/375;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MySelfTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MySelfTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (isClick == NO) {
            NSString *bgUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[DEFAULF_USERID integerValue]];
            [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];

        }
        else
        {
            if (_arrayPage.count != 0) {
                cell.iconImage.image = [UIImage imageWithData:_arrayPage[0]];
            }
            else{
                NSString *bgUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[DEFAULF_USERID integerValue]];
                [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
                [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
            }
        }
        
        return cell;
    }
    //输入框
    else if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9)
    {
        MyselfImpotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyselfImpotTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textTitle.returnKeyType=UIReturnKeyDone;
        [cell.textTitle addTarget:self action:@selector(keyBoardDown:) forControlEvents:UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
        cell.textTitle.delegate = self;
        cell.labelChoose.hidden = YES;
        if(indexPath.row == 1)
        {
            cell.labelTitle.text = @"我的昵称";
            //            [cell showData:_dataArray[1]];
            if ([Helper isBlankString:_userModel.userName]) {
                cell.textTitle.placeholder = @"请输入昵称";
            } else {
                cell.textTitle.text = _userModel.userName;
            }
            cell.textTitle.tag = 101;
        }
        else
        {
            NSArray* array = @[@"差点",@"球龄",@"主场",@"个人签名"];
            cell.labelTitle.text = array[indexPath.row - 6];
            
            
            if (indexPath.row == 6) {
                NSString *str;
                if (_userModel.almost != nil) {
                   str = [NSString stringWithFormat:@"%@",_userModel.almost];
                }
                else
                {
                    str = [NSString stringWithFormat:@"0"];
                }
                if ([Helper isBlankString:str]) {
                    cell.textTitle.placeholder = @"请输入差点";
                } else {
                    cell.textTitle.text = str;
                }
                cell.textTitle.tag = 102;
                //                cell.textTitle.keyboardType = UIKeyboardTypeNumberPad;
                //                cell.textTitle.returnKeyType = UIReturnKeyDone;
            }
            else if (indexPath.row == 7)
            {
                if (_userModel.ballage == nil) {
                    cell.textTitle.placeholder = @"请输入球龄";
                } else {
                    cell.textTitle.text = [NSString stringWithFormat:@"%@",_userModel.ballage];
                }
                //球龄
                cell.textTitle.tag = 105;
            }
            else if (indexPath.row == 8)
            {
                if ([Helper isBlankString:_userModel.address]) {
                    cell.textTitle.placeholder = @"请输入主场";
                } else {
                    cell.textTitle.text = _userModel.address;
                }
                
                cell.textTitle.tag = 103;
            }
            else
            {
                if ([Helper isBlankString:_userModel.userSign]) {
                    cell.textTitle.placeholder = @"请输入个人签名";
                } else {
                    cell.textTitle.text = _userModel.userSign;
                }
                
                cell.textTitle.tag = 104;
            }
        }
        
        
        return cell;
    }
    //选择器，出生年月，行业
    else if (indexPath.row == 3 || indexPath.row == 4)
    {
        
        MyselfImpotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyselfImpotTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textTitle.hidden = YES;
        NSArray* array = @[@"出生日期",@"行业"];
        cell.labelTitle.text = array[indexPath.row - 3];
        
        
        
        if (indexPath.row == 3) {
            if (_birIsClick == NO) {
                
                NSString *str;
                if ([Helper isBlankString:_userModel.birthday]) {
                    str = @"请选择出生日期";
                } else {
                    
                    NSArray *array = [_userModel.birthday componentsSeparatedByString:@" "];
                    str = [NSString stringWithFormat:@"%@",array[0]];
                }
                
                
                if ([Helper isBlankString:str]) {
                    cell.labelChoose.text = @"请选择出生日期";
                } else {
                    cell.labelChoose.text = str;
                }
            }
            else
            {
                if ([Helper isBlankString:_arrayChange[indexPath.row-3]]) {
                    cell.labelChoose.text = @"请选择出生日期";
                } else {
                    cell.labelChoose.text = _arrayChange[indexPath.row-3];
                }
                
            }
            
        }
        else
        {
            if (_jobIsClick == NO) {
                
                NSString *str;
                if ([Helper isBlankString:_userModel.workName]) {
                    str = nil;
                } else {
                    str = _userModel.workName;
                }
                
                if ([Helper isBlankString:str]) {
                    cell.labelChoose.text = @"请输入行业";
                } else {
                    cell.labelChoose.text = str;
                }
            }
            else
            {
                
                if ([Helper isBlankString:_arrayChange[indexPath.row-3]]) {
                    cell.labelChoose.text = @"请输入行业";
                } else {
                    cell.labelChoose.text = _arrayChange[indexPath.row-3];
                }
                
            }
            
        }
        return cell;
    }
    //选择性别
    else if (indexPath.row == 2)
    {
        MyselfChooseViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyselfChooseViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.sexNumber = _userModel.sex;
        
        cell.isMen = [_userModel.sex boolValue];
        cell.isWomen = [_userModel.sex boolValue];
        
        if ([_userModel.sex intValue] == 0) {
            cell.isMen = NO;
            cell.isWomen = YES;
            [cell.btnMen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
            [cell.btnWomen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        }else{
            cell.isMen = YES;
            cell.isWomen = NO;
            [cell.btnMen setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
            [cell.btnWomen setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        }
        cell.blockSexNumber = ^(NSNumber *sexNum){
            _userModel.sex = sexNum;
        };
        
        
        return cell;
    }
    //分割
    else if (indexPath.row == 5 || indexPath.row == 10)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 5) {
            cell.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    //最下方视图
    else
    {
        return nil;
    }
    
    return nil;
}
-(void)keyBoardDown:(UITextField *)textField{
    ////NSLog(@"111111");
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 101:
        {
            [self post:@{@"userId":_str,@"userName":textField.text}];
            _userModel.userName = textField.text;
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:textField.text forKey:@"userName"];
            [user synchronize];
            [self synchronizeUserInfoRCIM];
            break;
        }
            
        case 102:
            [self post:@{@"userId":_str,@"almost":textField.text}];
            _userModel.almost = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        case 103:
            [self post:@{@"userId":_str,@"address":textField.text}];
            _userModel.address = textField.text;
            break;
        case 104:
            [self post:@{@"userId":_str,@"userSign":textField.text}];
            _userModel.userSign = textField.text;
            break;
        case 105:
            [self post:@{@"userId":_str,@"ballage":textField.text}];
            _userModel.ballage = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        default:
            break;
    }
    
}

//选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self usePhonePhotoAndCamera];
        isClick = YES;
    }
    else if (indexPath.row == 3 || indexPath.row == 4){
        if (indexPath.row == 4) {
            _jobIsClick = YES;
            JobChooseViewController *jobVc = [[JobChooseViewController alloc]init];
            [jobVc setCallback:^(NSString *jobtitle, NSInteger jobid) {
                //                [_dict setValue:[NSNumber numberWithInteger:jobid] forKey:@"workId"];
                [_arrayChange replaceObjectAtIndex:1 withObject:jobtitle];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                [self post:@{@"userId":_str,@"workId":[NSNumber numberWithInteger:jobid]}];
                [self post:@{@"userId":_str,@"workName":jobtitle}];

                ////NSLog(@"%@",_arrayChange);
            }];
            [self.navigationController pushViewController:jobVc animated:YES];
        }else{
            _birIsClick = YES;
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            dateVc.typeIndex = @5;
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
//                [_arrayChange replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
                [_arrayChange replaceObjectAtIndex:0 withObject: dateStr];

                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [self post:@{@"userId":_str,@"birthday":_arrayChange[0]}];
                //                _userModel.birthday = _arrayChange[0];
                
                NSArray* timeArr = [dateStr componentsSeparatedByString:@"-"];
                NSInteger intYear = 2016 - [timeArr[0] integerValue];
                _userModel.age = [NSNumber numberWithInteger:intYear];
                
            }];
            [self.navigationController pushViewController:dateVc animated:YES];
        }
    }else{
        
    }
}
#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            _arrayPage = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:_arrayPage];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            _arrayPage = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:_arrayPage];
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}

#pragma mark --上传图片方法
-(void)imageArray:(NSMutableArray *)array
{
    NSNumber* strTimeKey = DEFAULF_USERID;
    // 上传图片
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strTimeKey forKey:@"data"];
    [dict setObject:TYPE_USER_HEAD forKey:@"nType"];
    [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
    
    [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {

    } completionBlock:^(id data) {
        [self post:@{@"userId": DEFAULF_USERID}];
        
        NSString *headUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/user/head/%@.jpg@120w_120h", DEFAULF_USERID];
        [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES withCompletion:nil];
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        if (![Helper isBlankString:headUrl]) {
            [user setObject:headUrl forKey:@"pic"];
        }
        [user synchronize];
        [self synchronizeUserInfoRCIM];
    }];
}

- (void)synchronizeUserInfoRCIM {
    [[RCIM sharedRCIM] refreshUserInfoCache:[self userInfoModel] withUserId:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
}

- (RCUserInfo*)userInfoModel {

    RCUserInfo *userInfo = [[RCUserInfo alloc] init];

    userInfo.userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    userInfo.name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    
    userInfo.portraitUri = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/user/head/%@.jpg", DEFAULF_USERID];
    
    return userInfo;
}

#pragma mark --编辑事件
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField.tag == 101) //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 15) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:15];
            [LQProgressHud showMessage:@"超过最大字数限制"];
            return NO;
        }
    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
    _btnBack.hidden = YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag != 101) {
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 100);
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    _btnBack.hidden = NO;
}


-(void)post:(NSDictionary *)dict
{
    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
    }];
    
//    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:@"TUser" withData:dict failedBlock:^(id errType) {
//        
//    } completionBlock:^(id data) {
//        
//    }];
    
    
    
}


@end
