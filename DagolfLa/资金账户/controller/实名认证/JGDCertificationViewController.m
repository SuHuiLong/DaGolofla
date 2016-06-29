//
//  JGDSetPayPasswordViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCertificationViewController.h"
#import "JGDSetPayPasswordTableViewCell.h"

#import "CommonCrypto/CommonDigest.h"
#import "SXPickPhoto.h"


@interface JGDCertificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

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
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 550 * screenWidth / 375)];
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
    return 4;
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
    }else if (indexPath.row == 2) {
        cell.LB.text = @"证件号码";
        cell.txFD.placeholder = @"请如实填写";
    }else{
        cell.LB.text = @"证件照片";
        cell.txFD = nil;
        
        UIImageView *frontImageV = [[UIImageView alloc] initWithFrame:CGRectMake(110 * screenWidth / 375, 17 * screenWidth / 375, 180 * screenWidth / 375, 113 * screenWidth / 375)];
        frontImageV.tag = 601;
        frontImageV.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:frontImageV];
        UIGestureRecognizer *gR1 =[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto:)];
        [frontImageV addGestureRecognizer:gR1];
        
        UIImageView *behindImageV = [[UIImageView alloc] initWithFrame:CGRectMake(110 * screenWidth / 375, 157 * screenWidth / 375, 180 * screenWidth / 375, 113 * screenWidth / 375)];
        behindImageV.tag = 602;
        behindImageV.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:behindImageV];
        UIGestureRecognizer *gR2 =[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto:)];
        [behindImageV addGestureRecognizer:gR2];
    }
    return cell;
}



- (void)addPhoto:(UIGestureRecognizer *)gestureR{
    
    if (gestureR.view.tag == 601) {

    }else if (gestureR.view.tag == 602){
        //更换背景
        [self SelectPhotoImage:gestureR.view];
    }else if (gestureR.view.tag == 740){
        
        [self SelectPhotoImage:gestureR.view];
    }
}

#pragma mark --添加活动头像
-(void)SelectPhotoImage:(UIView *)imageV{
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
//                _headerImage = (UIImage *)Data;
                if (imageV.tag == 601) {
//                    self.imgProfile.image = _headerImage;
//                    
//                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 0.7)] forKey:@"headerImage"];
                    
                }else if (imageV.tag == 602){
//                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
//                    self.headPortraitBtn.layer.masksToBounds = YES;
//                    self.headPortraitBtn.layer.cornerRadius = 8.0;
//                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 0.7)] forKey:@"headPortraitBtn"];
                    
                }
                
//                [self.launchActivityTableView reloadData];
                //                _photos = 1;
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
//                _headerImage = (UIImage *)Data;
                
                //设置背景
                if (imageV.tag == 601) {
//                    self.imgProfile.image = _headerImage;
//                    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
//                    self.imgProfile.layer.masksToBounds = YES;
//                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 1.0)] forKey:@"headerImage"];
                    
                }else if (imageV.tag == 602){
                    //头像
//                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
//                    self.headPortraitBtn.layer.masksToBounds = YES;
//                    self.headPortraitBtn.layer.cornerRadius = 8.0;
//                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 1.0)] forKey:@"headPortraitBtn"];
                    
                }
                
            }
            //            _photos = 1;
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10  * screenWidth / 375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        return 280 * screenWidth / 375;
    }else{
        return 44 * screenWidth / 375;
    }
}

- (void)comitBtnClick{
    
    
    JGDSetPayPasswordTableViewCell *cell1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell2 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell3 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    JGDSetPayPasswordTableViewCell *cell4 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (![cell3.txFD.text isEqualToString:cell4.txFD.text]) {
        [[ShowHUD showHUD]showToastWithText:@"密码输入不一致" FromView:self.view];
        return;
    }
    if ([cell3.txFD.text length] < 6) {
        [[ShowHUD showHUD]showToastWithText:@"密码长度不能小于六位" FromView:self.view];
        return;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:cell1.txFD.text forKey:@"checkCode"];
    [dict setObject:[JGDCertificationViewController md5HexDigest:cell2.txFD.text] forKey:@"oldPassWord"];
    [dict setObject:[JGDCertificationViewController md5HexDigest:cell3.txFD.text] forKey:@"newPassWord"];
    
     [[JsonHttp jsonHttp]httpRequest:[NSString stringWithFormat:@"user/updatePayPassWord"] JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"恭喜您提交成功" FromView:self.view];
            [self performSelector:@selector(pop) withObject:self afterDelay:1];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}


- (void)pop{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
