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

#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"

#import "MeselfModel.h"
#import "JobChooseViewController.h"
#import "DateTimeViewController.h"
#define kUpDateData_URL @"user/updateUserInfo.do"
#import <RongIMKit/RongIMKit.h>
#import "UserDataInformation.h"
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
    NSMutableArray* _arrayPage;
    NSMutableArray* _arrayChange;
    
    BOOL _birIsClick;
    BOOL _jobIsClick;
    
    NSString* _strPIC;
}



@end

@implementation SelfViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"user/queryById.do" parameter:@{@"userId":_str} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        _model = nil;
        
        if ([[dict objectForKey:@"success"]boolValue]) {
            _model = [[MeselfModel alloc] init];
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
        }else {
        }
        [_tableView reloadData];
        
    } failed:^(NSError *error) {
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
            [cell.iconImage sd_setImageWithURL:[Helper imageIconUrl:_model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
        }
        else
        {
            if (_arrayPage.count != 0) {
                cell.iconImage.image = [UIImage imageWithData:_arrayPage[0]];
            }
            else{
                [cell.iconImage sd_setImageWithURL:[Helper imageIconUrl:_model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
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
        //        NSArray* array = @[@"对所有人开放",@"对球队成员开放",@"仅自己可见",@"对部分好友开放"];
        //        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        if (indexPath.row == 5 || indexPath.row == 9)
        //        {
        //            cell.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        //            return cell;
        //        }
        //        else
        //        {
        //            cell.textLabel.text = array[indexPath.row - 10];
        //            cell.textLabel.font = [UIFont systemFontOfSize:14];
        //            cell.tintColor = [UIColor greenColor];
        //            current = [_userModel.infoState integerValue]+10;
        //
        //            if (indexPath.row == current) {
        //                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //            }
        //            else{
        //                cell.accessoryType = UITableViewCellAccessoryNone;
        //            }
        //
        //            return cell;
        //        }
        
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

//- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
//
//{
//
//    if(indexPath.row==current && current >= 10)
//    {
//        return UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        return UITableViewCellAccessoryNone;
//    }
//}
//

//选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row >= 10) {
    //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //        if(indexPath.row==current){
    //            return;
    //        }
    //        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:current inSection:0];
    //        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    //        if (newCell.accessoryType == UITableViewCellAccessoryNone)
    //        {
    //            newCell.accessoryType= UITableViewCellAccessoryCheckmark;
    //        }
    //        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    //        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
    //        {
    //            oldCell.accessoryType = UITableViewCellAccessoryNone;
    //        }
    //        current=indexPath.row;
    //        NSInteger index = current-10;
    //        NSNumber* num = [NSNumber numberWithInteger:index];
    //        [self post:@{@"userId":_str,@"infoState":num}];
    //    }else
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
                [self post:@{@"userId":_str,@"workId":[NSNumber numberWithInteger:jobid]}];
                ////NSLog(@"%@",_arrayChange);
            }];
            [self.navigationController pushViewController:jobVc animated:YES];
        }else{
            _birIsClick = YES;
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            dateVc.typeIndex = @5;
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                [_arrayChange replaceObjectAtIndex:0 withObject:dateStr];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [self post:@{@"userId":_str,@"birthdays":_arrayChange[0]}];
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
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [selestSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self usePhonCamera];
    }else if (buttonIndex == 1) {
        [self usePhonePhoto];
    }
}
#pragma mark - 调用相机
- (void)usePhonCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 调用相册
- (void)usePhonePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_arrayPage removeAllObjects];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _photoData = UIImageJPEGRepresentation(image, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_arrayPage addObject:_photoData];
    
    [[PostDataRequest sharedInstance] postDataAndImageRequest:kUpDateData_URL parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} imageDataArr:_arrayPage success:^(id respondsData) {
        //[MBProgressHUD hideHUDForView:self.view  animated:NO];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
            [user synchronize];
            [self synchronizeUserInfoRCIM];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    } failed:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }];
    
    
}
////融云
//-(void)requestRCIMWithToken:(NSString *)token{
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40*ScreenWidth/375, 40*ScreenWidth/375);
//    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];
//    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
//    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
//    [[RCIM sharedRCIM] setUserInfoDataSource:[UserDataInformation sharedInstance]];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:[UserDataInformation sharedInstance]];
//    NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:@"userId"]];
//    NSString *str2=[NSString stringWithFormat:@"%@",[user objectForKey:@"userName"]];
//    NSString *str3=[NSString stringWithFormat:@"http://139.196.9.49:8081/small_%@",[user objectForKey:@"pic"]];
//    RCUserInfo *userInfo=[[RCUserInfo alloc] initWithUserId:str1 name:str2 portrait:str3];
//    [RCIM sharedRCIM].currentUserInfo=userInfo;
//    [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
//    //            [RCIM sharedRCIM].receiveMessageDelegate=self;
//    // 快速集成第二步，连接融云服务器
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        //自动登录   连接融云服务器
//        [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
//        
//    }error:^(RCConnectErrorCode status) {
//        // Connect 失败
//        //NSLog(@"连接失败");
//    }tokenIncorrect:^() {
//        // Token 失效的状态处理
//        //NSLog(@"失效token");
//    }];
//}
- (void)synchronizeUserInfoRCIM {
    
    [[RCIM sharedRCIM] refreshUserInfoCache:[self userInfoModel] withUserId:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
}

- (RCUserInfo*)userInfoModel {
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
//    [[UserDataInformation sharedInstance].userInfor.userId stringValue]
//    [UserDataInformation sharedInstance].userInfor.userName
    userInfo.userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    userInfo.name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    userInfo.portraitUri = [NSString stringWithFormat:@"%@",[Helper imageIconUrl:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]]];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
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
    ////NSLog(@"%@",dict);
    [[PostDataRequest sharedInstance] postDataRequest:kUpDateData_URL parameter:dict success:^(id respondsData) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        //                [alertView show];
        
    } failed:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        
    }];
    
    
}


@end
