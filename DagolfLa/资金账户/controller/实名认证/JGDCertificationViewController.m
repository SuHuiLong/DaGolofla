//
//  JGDSetPayPasswordViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCertificationViewController.h"
#import "JGDSetPayPasswordTableViewCell.h"
#import "JGDShowCertViewController.h"

#import "CommonCrypto/CommonDigest.h"
#import "SXPickPhoto.h"


@interface JGDCertificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@property (nonatomic, strong) UIButton *frontBtn;
@property (nonatomic, strong) UIButton *behindBtn;
@end

@implementation JGDCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self creatTable];
    // Do any additional setup after loading the view.
}

- (void)creatTable{
    
    self.pickPhoto = [[SXPickPhoto alloc]init];
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 506 * screenWidth / 375)];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.scrollEnabled = NO;
    [self.tableV registerClass:[JGDSetPayPasswordTableViewCell class] forCellReuseIdentifier:@"setPayPass"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 120 * screenWidth / 375)];
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextBtn.frame = CGRectMake(10 * screenWidth / 375, 25 * screenWidth / 375, screenWidth - 20 * screenWidth / 375, 40 * screenWidth / 375);
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [nextBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [nextBtn addTarget:self action:@selector(comitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 6.f * screenWidth / 375;
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [view addSubview:nextBtn];
    
    self.tableV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableV.tableFooterView = view;
    [self.view addSubview:self.tableV];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDSetPayPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setPayPass"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.txFD.frame = CGRectMake(110 * screenWidth / 375, 0, screenWidth - 160 * screenWidth / 375, 44 * screenWidth / 375);
    if (indexPath.row == 0) {
        cell.LB.text = @"真实姓名";
        cell.txFD.placeholder = @"请如实填写";
        
    }else if (indexPath.row == 1) {
        cell.LB.text = @"证件类型";
        cell.txFD.text = @"身份证";
        cell.txFD.userInteractionEnabled = NO;
        //    }else if (indexPath.row == 2) {
        //        cell.LB.text = @"证件号码";
        //        cell.txFD.placeholder = @"请如实填写";
    }else{
        cell.LB.text = @"证件号码";
        cell.txFD.placeholder = @"请如实填写";
        //        cell.LB.text = @"证件照片";
        //        [cell.txFD removeFromSuperview];
        //        cell.userInteractionEnabled = YES;
        //
        //        self.frontBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        self.frontBtn.frame = CGRectMake(110 * screenWidth / 375, 17 * screenWidth / 375, 180 * screenWidth / 375, 113 * screenWidth / 375);
        //        self.frontBtn.tag = 601;
        //        [self.frontBtn setImage:[UIImage imageNamed:@"positive"] forState:(UIControlStateNormal)];
        //
        //        [self.frontBtn addTarget:self action:@selector(addPhoto:) forControlEvents:(UIControlEventTouchUpInside)];
        //        [cell.contentView addSubview:self.frontBtn];
        //
        //        self.behindBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        self.behindBtn.frame = CGRectMake(110 * screenWidth / 375, 157 * screenWidth / 375, 180 * screenWidth / 375, 113 * screenWidth / 375);
        //        self.behindBtn.tag = 602;
        //        [self.behindBtn setImage:[UIImage imageNamed:@"reverse"] forState:(UIControlStateNormal)];
        //        [self.behindBtn addTarget:self action:@selector(addPhoto:) forControlEvents:(UIControlEventTouchUpInside)];
        //        [cell.contentView addSubview:self.behindBtn];
        
    }
    return cell;
}

//- (void)addPhoto:(UIButton *)gestureR{
//    
//    if (gestureR.tag == 601) {
//        
//        [self SelectPhotoImage:gestureR];
//    }else if (gestureR.tag == 602){
//        
//        [self SelectPhotoImage:gestureR];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//#pragma mark --添加身份证照片
//-(void)SelectPhotoImage:(UIButton *)imageV{
//    //    _photos = 10;
//    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //        _photos = 1;
//    }];
//    //拍照：
//    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        //打开相机
//        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
//            if ([Data isKindOfClass:[UIImage class]])
//            {
//                if (imageV.tag == 601) {
//                    [self.frontBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
//                }else if (imageV.tag == 602){
//                    [self.behindBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
//                }
//            }
//        }];
//    }];
//    //相册
//    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        //打开相册
//        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
//            if ([Data isKindOfClass:[UIImage class]])
//            {
//                
//                if (imageV.tag == 601) {
//                    [self.frontBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
//                }else if (imageV.tag == 602){
//                    [self.behindBtn setImage:(UIImage *)Data forState:(UIControlStateNormal)];
//                }
//                
//            }
//        }];
//    }];
//    
//    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
//    [aleVC addAction:act1];
//    [aleVC addAction:act2];
//    [aleVC addAction:act3];
//    
//    [self presentViewController:aleVC animated:YES completion:nil];
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10  * screenWidth / 375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        return 44 * screenWidth / 375;
    }else{
        return 44 * screenWidth / 375;
    }
}

- (void)comitBtnClick{
    
    
    JGDSetPayPasswordTableViewCell *cell1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell3 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    
    if ([cell1.txFD.text length] < 1) {
        [[ShowHUD showHUD]showToastWithText:@"姓名不能为空" FromView:self.view];
        return;
    }
    if ([cell3.txFD.text length] < 1) {
        [[ShowHUD showHUD]showToastWithText:@"身份证号不能为空" FromView:self.view];
        return;
    }
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"正在上传...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@1 forKey:@"type"];
    [dict setObject:cell1.txFD.text forKey:@"name"];
    [dict setObject:cell3.txFD.text forKey:@"idCard"];
    [dict setObject:DEFAULF_USERID forKey:@"timeKey"];
    
    [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"user/doRealName"] JsonKey:@"UserRealName" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [[ShowHUD showHUD]showToastWithText:@"提交失败" FromView:self.view];
        return ;
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            [[ShowHUD showHUD]showToastWithText:@"提交成功" FromView:self.view];
            [self performSelector:@selector(pop) withObject:self afterDelay:TIMESlEEP];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}



- (void)pop{
    JGDShowCertViewController *showVC = [[JGDShowCertViewController alloc] init];
    [self.navigationController pushViewController:showVC animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark  -----MD5

+(NSString *)md5HexDigest:(NSString*)Des_str
{
    
    const char *original_str = [Des_str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02x", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    return mdfiveString;
    
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
