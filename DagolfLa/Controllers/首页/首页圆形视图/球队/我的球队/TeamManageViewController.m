//
//  TeamManageViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamManageViewController.h"
#import "TeamLogoHeadCell.h"
#import "TeamNameTableViewCell.h"
#import "TeamIntroduceViewCell.h"
#import "TeamIntroCViewController.h"
#import "TeamNumViewController.h"
#import "TeamApplyViewController.h"

#import "TeamAreaViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "MBProgressHUD.h"

#import "TeamPhotoViewController.h"
#import "TeamActivePostController.h"
@interface TeamManageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    BOOL _isBianji;
    UIBarButtonItem* _rightBtn;
    
    UITableView* _tableView;
    NSArray* _arrayTitle;
    
    UIButton* _btnBase;
    
    NSMutableDictionary* _dict;
    
    //存储照片
    NSData *_photoData;
    NSMutableArray* _arrayPage;
    //选择的城市
    NSString* _strProfince, *_strCity;
    //简介
    NSString* _strIntro;
    
    //球队名
    NSString* _strName;
    
    UIScrollView* _scrollView;
}
@end

@implementation TeamManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队管理";
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    if (ScreenHeight >= 480) {
        _scrollView.contentSize = CGSizeMake(0, 490);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(0, ScreenHeight);
    }
    
    
    _arrayPage = [[NSMutableArray alloc]init];

    if ([_state integerValue] == 1 || [_state integerValue] == 4) {
        _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bianjiClick)];
        _rightBtn.tintColor = [UIColor whiteColor];
        
        self.navigationItem.rightBarButtonItem = _rightBtn;
    }
    
    
    _dict = [[NSMutableDictionary alloc]init];
    
    [self createTableView];
    _tableView.userInteractionEnabled = NO;
    [self createBtn];
    
    _btnBase = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBase.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _btnBase.hidden = YES;
    [self.view addSubview:_btnBase];
    [_btnBase addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick
{
    _btnBase.hidden = YES;
    [self.view endEditing:YES];
}
-(void)bianjiClick
{
    _btnBase.hidden = YES;
    [self.view endEditing:YES];
    if (_isBianji == YES) {
        
        
        _tableView.userInteractionEnabled = NO;
        _rightBtn.title = @"编辑";
        _isBianji = NO;
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:_teamId forKey:@"teamId"];
        if (![Helper isBlankString:_strName]) {
            [dict setObject:_strName forKey:@"teamName"];
        }
        if (![Helper isBlankString:_strCity]) {
            [dict setObject:_strCity forKey:@"teamCrtyName"];
        }
        if (_arrayPage.count != 0) {
            [[PostDataRequest sharedInstance]postDataAndImageRequest:@"team/update.do" parameter:dict imageDataArr:_arrayPage success:^(id respondsData) {
                NSDictionary* dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[dictD objectForKey:@"success"]integerValue] == 1) {
                    ////NSLog(@"修改成功");
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dictD objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            
            } failed:^(NSError *error) {
                
            }];
        }
        else
        {
            [[PostDataRequest sharedInstance]postDataRequest:@"team/update.do" parameter:dict success:^(id respondsData) {
                NSDictionary* dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[dictD objectForKey:@"success"]integerValue] == 1) {
                    
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dictD objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                
            } failed:^(NSError *error) {
                
            }];
        }
        
        
        
        
    }
    else{
        _tableView.userInteractionEnabled = YES;
        _rightBtn.title = @"保存";
        _isBianji = YES;
    }
   
}

-(void)createTableView
{
    _arrayTitle = [[NSArray alloc]init];
    _arrayTitle = @[@"球队名称",@"球队位置",@"球队简介",@"球队成员",@"球队活动",@"球队相册",@"申请审批"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 85*ScreenWidth/375+50*ScreenWidth/375*7) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.bounces = NO;
    
    [_scrollView addSubview:_tableView];
    [_tableView registerClass:[TeamLogoHeadCell class] forCellReuseIdentifier:@"TeamLogoHeadCell"];
    [_tableView registerClass:[TeamNameTableViewCell class] forCellReuseIdentifier:@"TeamNameTableViewCell"];
    [_tableView registerClass:[TeamIntroduceViewCell class] forCellReuseIdentifier:@"TeamIntroduceViewCell"];

}
//创建标下的两个按钮
-(void)createBtn
{
    //退出球队
    UIButton* btnQuit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnQuit.frame = CGRectMake(10*ScreenWidth/375, 95*ScreenWidth/375+50*ScreenWidth/375*7, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [btnQuit setTitle:@"退出球队" forState:UIControlStateNormal];
    [btnQuit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnQuit.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:btnQuit];
    [btnQuit addTarget:self action:@selector(quitTeamClick) forControlEvents:UIControlEventTouchUpInside];
    btnQuit.layer.cornerRadius = 8*ScreenWidth/375;
    btnQuit.layer.masksToBounds = YES;
    
    
    ////NSLog(@"%@",_state);
    //解散球队
    if ([_state integerValue] == 1)
    {
        UIButton* btnDisMiss = [UIButton buttonWithType:UIButtonTypeSystem];
        btnDisMiss.frame = CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375+50*ScreenWidth/375*8, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
        [btnDisMiss setTitle:@"解散球队" forState:UIControlStateNormal];
        [btnDisMiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnDisMiss.backgroundColor = [UIColor orangeColor];
        [_scrollView addSubview:btnDisMiss];
        [btnDisMiss addTarget:self action:@selector(disMissClick) forControlEvents:UIControlEventTouchUpInside];
        btnDisMiss.layer.cornerRadius = 8*ScreenWidth/375;
        btnDisMiss.layer.masksToBounds = YES;
    }
}


//退出按钮
-(void)quitTeamClick
{
    if ([_state integerValue] == 1) {
        
        if (_teamNumCount != 0) {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"您需要先指定一个队长才能退出" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //球队成员
                TeamNumViewController* numVc = [[TeamNumViewController alloc]init];
                numVc.teamId = _teamId;
                numVc.teamStatus = _state;
                numVc.teamType = @10;
                numVc.isExit = @1;
                numVc.teamNumCount = _teamNumCount;
                numVc.callBackNumber = ^{
                    
                    //POST
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                    
                    [dict setValue:@10 forKey:@"teamType"];
                    [dict setValue:_teamId forKey:@"teamTeamId"];
                    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]forKey:@"teamfrindUser"];
                    [dict setObject:@"您已经退出了这个球队" forKey:@"context"];
                    [dict setObject:_teamUserId forKey:@"userId"];
                    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/deleteUser.do" parameter:dict success:^(id respondsData) {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[dict objectForKey:@"success"] boolValue]) {
                            
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert show];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else {
                            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];
                        }
                    } failed:^(NSError *error) {
                        
                        
                    }];
                    
                    
                    [Helper alertViewWithTitle:@"提示" withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                };
               [self.navigationController pushViewController:numVc animated:YES];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];


        }
        else
        {
            
            [self disMissClick];
        }
        
    }
    else
    {
        //POST
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        
        [dict setValue:@10 forKey:@"teamType"];
        [dict setValue:_teamId forKey:@"teamTeamId"];
        [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"teamfrindUser"];
        [dict setObject:@"您已经退出了这个球队" forKey:@"context"];
        [dict setObject:_teamUserId forKey:@"userId"];
        [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/deleteUser.do" parameter:dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failed:^(NSError *error) {
            
            
        }];

    }
    
}

#pragma mark --解散球队点击事件
//解散按钮
-(void)disMissClick
{
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要解散球队?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [_dict setValue:_teamId forKey:@"id"];
        [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        [_dict setValue:@"球队队长已经解散了这个球队" forKey:@"context"];
        [[PostDataRequest sharedInstance] postDataRequest:@"team/delete.do" parameter:_dict success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 85*ScreenWidth/375 : 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TeamLogoHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamLogoHeadCell" forIndexPath:indexPath];
        if (_arrayPage.count != 0) {
            cell.iconImage.image = [UIImage imageWithData:_arrayPage[0]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TeamNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamNameTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _arrayTitle[indexPath.row-1];
        cell.textF.tag = 1001;
        cell.textF.delegate = self;
        if (![Helper isBlankString:_strTeamName]) {
            cell.textF.placeholder = _strTeamName;
        }
        return cell;
    }
    else
    {
        TeamIntroduceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamIntroduceViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _arrayTitle[indexPath.row-1];
        if (indexPath.row == 2) {
            if (![Helper isBlankString:_strCity]) {
                cell.detroLabel.text = _strCity;
            }
            else{
                if (![Helper isBlankString:_strCity]) {
                    cell.detroLabel.text = _strCity;
                }
                else
                {
                    cell.detroLabel.text = @"请选择所在地区";
                }
                
            }
        }
        else if (indexPath.row == 3)
        {
            if (![Helper isBlankString:_strIntro]) {
                cell.detroLabel.text = _strIntro;
            }
            else{
                cell.detroLabel.text = _strInMess;
            }
        }
        else if (indexPath.row == 4)
        {
            cell.detroLabel.text = @"球队成员";
        }
        else if (indexPath.row == 5)
        {
            cell.detroLabel.hidden = YES;
        }
        else if (indexPath.row == 6)
        {
            cell.detroLabel.hidden = YES;
        }
        else
        {
            cell.detroLabel.text = @"审批列表";
        }
        return cell;
    }
    return nil;
}

#pragma mark --输入框代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _btnBase.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _strName = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
// 分割线两端顶头
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}
// 分割线两端顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            //logo
            [self usePhonePhotoAndCamera];
        }
            break;
        case 1:
        {
            //名称
        }
            break;
        case 2:
        {
            //地区选择
            TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
            areaVc.blockCity = ^(NSString* strPro, NSString* strCity){
                _strProfince = strPro;
                _strCity = strCity;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dict setValue:_strCity forKey:@"teamCrtyName"];
                
            };
            [self.navigationController pushViewController:areaVc animated:YES];
        }
            break;
        case 3:
        {
            //简介
            TeamIntroCViewController* teamVc = [[TeamIntroCViewController alloc]init];
            teamVc.introBlock = ^(NSString* str){
                _strIntro = str;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dict setValue:_strCity forKey:@"teamCrtyName"];

            };
            teamVc.teamId = _teamId;
            [self.navigationController pushViewController:teamVc animated:YES];
        }
            break;
        case 4:
        {
            //球队成员
            TeamNumViewController* numVc = [[TeamNumViewController alloc]init];
            numVc.teamId = _teamId;
            numVc.teamStatus = _state;
            [self.navigationController pushViewController:numVc animated:YES];
        }
            break;
        case 5:
        {
            //活动
            TeamActivePostController* teamVc = [[TeamActivePostController alloc]init];
            teamVc.teamId = _teamId;
            [self.navigationController pushViewController:teamVc animated:YES];
        }
            break;
        case 6:
        {
            //相册
            TeamPhotoViewController* teamVc = [[TeamPhotoViewController alloc]init];
            teamVc.teamId = _teamId;
            teamVc.teamPhotoTitle = _strTeamName;
            [self.navigationController pushViewController:teamVc animated:YES];
            
        }
            break;
        case 7:
        {
            //审批
            TeamApplyViewController* appVc = [[TeamApplyViewController alloc]init];
            appVc.teamId = _teamId;
            [self.navigationController pushViewController:appVc animated:YES];

        }
            break;
            
        default:
            break;
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
