//
//  TeamCreateViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamCreateViewController.h"
#import "Helper.h"

#import "TeamSuccessController.h"
#import "TeamCreateTableViewCell.h"
#import "TeamCreateTextViewCell.h"

#import "DateTimeViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "TeamAreaViewController.h"

#import "TeamCreateHeadTableViewCell.h"
#import "IQKeyboardManager.h"

#import "MineTeamController.h"

#import "MBProgressHUD.h"

@interface TeamCreateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
    UIScrollView* _scrollView;
    UITableView* _tableView;
    NSArray* _arrayTitle;
    
    UITextView* _textView;
    NSString* _str;
    
    UIButton* _btnLeft;
    UIButton* _btnRight;
    
    UIButton* _btnText;
    
    NSData *_photoData;
    NSMutableArray* _arrayPage;

    NSMutableDictionary* _dict;
    
    NSString* _strTime;
    NSString* _strTeamName;
    NSString* _strTeamIntro;
    BOOL _isNeedSa;
    
    NSString* _strProfince, *_strCity;
    
    NSNumber* _teamId;
    NSString* _teamName;
    MBProgressHUD* _progress;
}

@end

@implementation TeamCreateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建球队";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    
    _arrayPage = [[NSMutableArray alloc]init];
    _dict = [[NSMutableDictionary alloc]init];
    
    if (ScreenHeight < 568) {
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    
    _arrayTitle = [[NSArray alloc]init];
    _arrayTitle = @[@"球队LOGO",@"球队名称",@"成立日期",@"所在地区"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75*ScreenWidth/375+44*3*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TeamCreateTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCreateTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TeamCreateTextViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCreateTextViewCell"];
    [_tableView registerClass:[TeamCreateHeadTableViewCell class] forCellReuseIdentifier:@"TeamCreateHeadTableViewCell"];
    
    //简介视图
    [self createTextView];
    //成员申请设置
    [self createNumSet];
    //确定按钮
    [self createSure];
    
    _btnText = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnText.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_btnText];
    _btnText.hidden = YES;
    [_btnText addTarget:self action:@selector(textFieldClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)textFieldClick
{
    [self.view endEditing:YES];
    _btnText.hidden = YES;
//    [UIView animateWithDuration:0.2 animations:^{
//        _scrollView.contentOffset = CGPointMake(0, 0);
//    }];
}



//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _scrollView.scrollEnabled = YES;
    
}

-(void)createTextView
{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 90*ScreenWidth/375+44*3*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 120*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.text = @"输入球队相关介绍...";
    _textView.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_textView];
    
    
    
}


#pragma mark --textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //判断为空
    if ([Helper isBlankString:_str]) {
        textView.text = nil;
    }
    _btnText.hidden = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        _scrollView.contentOffset = CGPointMake(0, 50);
//    }];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.window.isKeyWindow) {
        [textView.window makeKeyAndVisible];
    }
    if ([Helper isBlankString:textView.text]) {
        textView.text = @"输入球队相关介绍...";
        _str = nil;
    }else {
        _str = textView.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        _btnText.hidden = YES;
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = CGPointMake(0, 0);
//        }];
    }
    _strTeamIntro = textView.text;
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
        
    }
  }
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _strTeamName = textField.text;
    [_dict setObject:textField.text forKey:@"teamName"];

}


-(void)createNumSet
{
    UILabel* labelSet = [[UILabel alloc]initWithFrame:CGRectMake(0, 210*ScreenWidth/375+44*3*ScreenWidth/375, ScreenWidth, 40*ScreenWidth/375)];
    labelSet.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:labelSet];
    labelSet.text = @"  成员设置申请";
    labelSet.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
    
    UIView *viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 250*ScreenWidth/375+44*3*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375)];
    viewBase.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewBase];
    
    //左边按钮
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeft.backgroundColor = [UIColor clearColor];
    _btnLeft.frame = CGRectMake(0, 0, ScreenWidth/2, 44*ScreenWidth/375);
    [viewBase addSubview:_btnLeft];
    [_btnLeft addTarget:self action:@selector(btn1LeftClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitle:@"管理员审批" forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 120*ScreenWidth/375, 0, 0);
    [_dict setObject:@0 forKey:@"teamType"];
    _btnLeft.tag = 123;
    
    //右边按钮
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.backgroundColor = [UIColor clearColor];
    _btnRight.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44*ScreenWidth/375);
    [viewBase addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(btn1RightClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setTitle:@"无需审批" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 120*ScreenWidth/375, 0, 0);
    _btnRight.tag = 124;
    
    
}



//约球类型点击事件
-(void)btn1LeftClick
{
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _isNeedSa = NO;
    [_dict setObject:@0 forKey:@"teamType"];
}
//约球类型点击事件
-(void)btn1RightClick
{
    [_btnLeft setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    _isNeedSa = YES;
    [_dict setObject:@1 forKey:@"teamType"];
}

-(void)createSure
{
    UIButton* btnSure = [UIButton buttonWithType:UIButtonTypeSystem];
    btnSure.frame = CGRectMake(10, 260*ScreenWidth/375+44*4*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSure.backgroundColor = [UIColor orangeColor];
    btnSure.layer.masksToBounds = YES;
    btnSure.layer.cornerRadius = 10*ScreenWidth/375;
    [_scrollView addSubview:btnSure];
    [btnSure addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --提交请求
-(void)successClick
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"teamCreteUser"];
    [_dict setObject:_textView.text forKey:@"teamSign"];

    if (![Helper isBlankString:_strTeamName] ) {
        if (![Helper isBlankString:_strTeamIntro] && ![_strTeamIntro isEqualToString:@"输入球队相关介绍..."]) {
            if (_arrayPage.count != 0) {

                [[PostDataRequest sharedInstance] postDataAndImageRequest:@"team/save.do" parameter:_dict imageDataArr:_arrayPage success:^(id respondsData) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([data objectForKey:@"success"]) {
                        _teamName = [[data objectForKey:@"rows"] objectForKey:@"teamName"];
                        _teamId = [[data objectForKey:@"rows"] objectForKey:@"teamId"];

                        [Helper alertViewWithTitle:@"发布成功" withBlockCancle:^{
                            
                        } withBlockSure:^{
                            MineTeamController *teamVc = [[MineTeamController alloc]init];
                            teamVc.popViewNumber = 2;
                            [self.navigationController pushViewController:teamVc animated:YES];
                        } withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];

                    }
                    else
                    {
                        [Helper alertViewWithTitle:[data objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
//                         alertView.tag = 1233;
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                }];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Helper alertViewWithTitle:@"您还未选择球队LOGO" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Helper alertViewWithTitle:@"您还未填写球队简介" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Helper alertViewWithTitle:@"您还未填写球队的名称" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 1000) {

        MineTeamController *teamVc = [[MineTeamController alloc]init];
        
        teamVc.popViewNumber = 2;
        
        [self.navigationController pushViewController:teamVc animated:YES];
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 1234) {
//        TeamSuccessController* sucVc = [[TeamSuccessController alloc]init];
//        sucVc.teamId = _teamId;
//        sucVc.teamName = _teamName;
//        sucVc.teamLogo = _arrayPage;
//        [self.navigationController pushViewController:sucVc animated:YES];
//    }
//    
//}
#pragma mark --tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 75*ScreenWidth/375 : 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        TeamCreateHeadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCreateHeadTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"球队LOGO";
        cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        if (_arrayPage.count != 0)
        {
             [cell.iconImage setImage:[UIImage imageWithData:_arrayPage[0]]];
        }
        else
        {
            [cell.iconImage setImage:[UIImage imageNamed:@"logo"]];
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TeamCreateTextViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCreateTextViewCell" forIndexPath:indexPath];
        cell.jiantou.hidden = YES;
        cell.chooseLabel.hidden = YES;
        cell.titleLabel.text = @"球队名称";
        cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.nameText.placeholder = @"请输入球队名称";
//        cell.nameText.text = _strTeamName;
        cell.nameText.textColor = [UIColor lightGrayColor];
        cell.nameText.tag = 1001;
        cell.nameText.delegate = self;
        return cell;
    }
    else
    {
        TeamCreateTextViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCreateTextViewCell" forIndexPath:indexPath];
        cell.nameText.hidden = YES;
        cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"成立日期";
            if (![Helper isBlankString:_strTime]) {
                cell.chooseLabel.text = _strTime;
            }
            else{
                cell.chooseLabel.text = @"请选择日期";
            }
            
        }
        else
        {
            cell.titleLabel.text = @"所在地区";
            if (![Helper isBlankString:_strCity]) {
                cell.chooseLabel.text = _strCity;
            }
            else{
                cell.chooseLabel.text = @"请选择所在地区";
            }
        }
        return cell;
        
    }
   
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
         [self usePhonePhotoAndCamera];
    }
    else if (indexPath.row == 1)
    {
        
    }
    else if (indexPath.row == 2)
    {
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @11;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            _strTime = dateStr;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            [_dict setValue:_strTime forKey:@"establishmentDates"];
        }];
        [self.navigationController pushViewController:dateVc animated:YES];
    }
    else
    {
        //地区选择
        TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
        areaVc.teamType = @10;
         areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
             _strProfince = strPro;
             _strCity = strCity;
             NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
             [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
             [_dict setValue:_strCity forKey:@"teamCrtyName"];
             [_dict setObject:cityId forKey:@"teamcrtyId"];
     
         };
        [self.navigationController pushViewController:areaVc animated:YES];
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
    //    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_arrayPage removeAllObjects];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _photoData = UIImageJPEGRepresentation(image, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_arrayPage addObject:_photoData];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
//    [_dict setObject:_photoData forKey:@"myPic"];
    
}

@end
