//
//  JGDPhotoIploadViewController.m
//  DagolfLa
//
//  Created by 東 on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPhotoIploadViewController.h"
#import "SXPickPhoto.h"
#import "VipCardConfirmOrderViewController.h"

@interface JGDPhotoIploadViewController ()

@property (nonatomic, strong) UIImageView *personView;
@property (nonatomic, strong) UIImageView *certificatesView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UIImage *uploadImage;

@property (nonatomic, strong) UIButton *commitButton;
//用户未更改之前的照片数据
@property (nonatomic, strong) NSMutableDictionary* localDictPhoto;
//当前页面上的照片数据
@property (nonatomic, strong) NSMutableDictionary* dictPhoto;


@end

@implementation JGDPhotoIploadViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(poptoVipDetail)];
    self.navigationItem.leftBarButtonItem = leftBar;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.pickPhoto = [[SXPickPhoto alloc]init];
    self.localDictPhoto = [[NSMutableDictionary alloc] init];
    self.dictPhoto = [[NSMutableDictionary alloc]init];

    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 358 * ProportionAdapter)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBackView];
    
    
    UILabel *titileLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 0, 300, 51 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:17 * ProportionAdapter text:@"请上传您的照片信息" textAlignment:(NSTextAlignmentLeft)];
    [whiteBackView addSubview:titileLB];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, 51 * ProportionAdapter + i * 151 * ProportionAdapter, screenWidth, 1) labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [whiteBackView addSubview:lineLB];
    }
    
    // 用户照片
    self.personView = [[UIImageView alloc] initWithFrame:CGRectMake(142 * ProportionAdapter, 71 * ProportionAdapter, 91 * ProportionAdapter, 91 * ProportionAdapter)];

    self.personView.contentMode = UIViewContentModeScaleAspectFill;
    self.personView.clipsToBounds = YES;
    [whiteBackView addSubview:self.personView];
    
    [self dottedLine:self.personView];
    
    UIButton *personPhoto = [[UIButton alloc] initWithFrame:CGRectMake(142 * ProportionAdapter, 71 * ProportionAdapter, 91 * ProportionAdapter, 91 * ProportionAdapter)];
    [personPhoto addTarget:self action:@selector(SelectPhotoImage:) forControlEvents:(UIControlEventTouchUpInside)];
    personPhoto.backgroundColor = [UIColor clearColor];
    personPhoto.tag = 520;
    [whiteBackView addSubview:personPhoto];
    
    if ([self.infoDic objectForKey:@"picHeadURL"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@@200w_200h_2o", [self.infoDic objectForKey:@"picHeadURL"]];
        [[SDImageCache sharedImageCache] removeImageForKey:urlString fromDisk:YES withCompletion:nil];
        [self.personView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"cameraDefault"]];
        [personPhoto setImage:[UIImage imageNamed:@"photoCamera"] forState:(UIControlStateNormal)];
        
    }else{
        self.personView.image = [UIImage imageNamed:@"cameraDefault"];
    }
    
    UILabel *personLB = [Helper lableRect:CGRectMake(0, 169 * ProportionAdapter, screenWidth, 15 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:13 * ProportionAdapter text:@"请上传您的个人照片" textAlignment:(NSTextAlignmentCenter)];
    [whiteBackView addSubview:personLB];
    
    //  证件照片
    self.certificatesView = [[UIImageView alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 221 * ProportionAdapter, 135 * ProportionAdapter, 93 * ProportionAdapter)];

    self.certificatesView.contentMode = UIViewContentModeScaleAspectFill;
    self.certificatesView.clipsToBounds = YES;
    [whiteBackView addSubview:self.certificatesView];
    
    [self dottedLine:self.certificatesView];

    UIButton *certificatesPhoto = [[UIButton alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 221 * ProportionAdapter, 135 * ProportionAdapter, 93 * ProportionAdapter)];
    [certificatesPhoto addTarget:self action:@selector(SelectPhotoImage:) forControlEvents:(UIControlEventTouchUpInside)];
    certificatesPhoto.backgroundColor = [UIColor clearColor];
    certificatesPhoto.tag = 530;
    [whiteBackView addSubview:certificatesPhoto];
    
    if ([self.infoDic objectForKey:@"picCertURLs"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@@270w_186h_2o", [self.infoDic objectForKey:@"picCertURLs"]];
        [[SDImageCache sharedImageCache] removeImageForKey:urlString fromDisk:YES withCompletion:nil];
        [self.certificatesView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"cameraDefault"]];
        [certificatesPhoto setImage:[UIImage imageNamed:@"photoCamera"] forState:(UIControlStateNormal)];
    }else{
        self.certificatesView.image = [UIImage imageNamed:@"cameraDefault"];
    }
    
    UILabel *pcertificatesLB = [Helper lableRect:CGRectMake(0, 324 * ProportionAdapter, screenWidth, 15 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:13 * ProportionAdapter text:@"请上传您的证件照" textAlignment:(NSTextAlignmentCenter)];
    [whiteBackView addSubview:pcertificatesLB];
    
    
    UILabel *tipLB = [Helper lableRect:CGRectMake(10 * ProportionAdapter, 373 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:14 * ProportionAdapter text:@"图片信息仅用于球场存档，便于球场核实客户身份，为客户提供更好的服务。" textAlignment:(NSTextAlignmentLeft)];
    tipLB.numberOfLines = 0;
    [whiteBackView addSubview:tipLB];
    
    
    self.commitButton = [[UIButton alloc]initWithFrame:CGRectMake(10 * ProportionAdapter, 458 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 46 * ProportionAdapter)];
    self.commitButton.clipsToBounds = YES;
    self.commitButton.layer.cornerRadius = 6.f;
//    self.commitButton.enabled = NO;
    [self.commitButton setTitle:@"完成" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = [UIColor colorWithHexString:@"#F39800"];
    [self.commitButton addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitButton];
    
    
    if ([self.infoDic objectForKey:@"picHeadURL"]) {
        NSData *picHeadURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoDic objectForKey:@"picHeadURL"]]];
        NSData *picCertURLs = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoDic objectForKey:@"picCertURLs"]]];
        
        [_dictPhoto setObject:[NSArray arrayWithObject:picHeadURL] forKey:@"picHeadURL"];
        [_dictPhoto setObject:[NSArray arrayWithObject:picCertURLs] forKey:@"picCertURLs"];
        _localDictPhoto = [NSMutableDictionary dictionaryWithDictionary:_dictPhoto];
    }


    
    // Do any additional setup after loading the view.
}

- (void)commitBtnClick{
    
    if (![_dictPhoto objectForKey:@"picHeadURL"] || ![_dictPhoto objectForKey:@"picCertURLs"]) {
        [LQProgressHud showMessage:@"请选择照片后提交"];
        return;
    }
    NSString *sexStr = @"0";
    if ([[self.infoDic objectForKey:@"sex"] isEqualToString:@"男"]) {
        sexStr = @"1";
    }
    NSDictionary *user = @{
                           @"userKey":DEFAULF_USERID,
                           @"userName":[self.infoDic objectForKey:@"userName"],
                           @"mobile":[self.infoDic objectForKey:@"mobile"],
                           @"sex":sexStr,
                           @"certType":@"0",
                           @"certNumber":[self.infoDic objectForKey:@"certNumber"]
                           };
    
    NSMutableDictionary *luserDic = [NSMutableDictionary dictionaryWithDictionary:user];
    
    NSDictionary *certDic = @{
                              @"telphone":[self.infoDic objectForKey:@"mobile"],
                              @"checkCode":[self.infoDic objectForKey:@"checkCode"],
                              @"userKey":DEFAULF_USERID,
                              @"luinfo":luserDic
                              };
    
    if (![_localDictPhoto isEqual:_dictPhoto]) {
        [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
        
        // 上传头像
        [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:@{@"nType":TYPE_CERT, @"tag":PHOTO_DAGOLFLA} andDataArray:[_dictPhoto objectForKey:@"picHeadURL"] failedBlock:^(id errType) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            
        } completionBlock:^(id data) {
            if ([data objectForKey:@"url"]) {
                [luserDic setObject:[data objectForKey:@"url"] forKey:@"picHeadURL"];

                [self  sendCardPhoto:luserDic certDic:certDic];
            }else{
                // 失败
                [[ShowHUD showHUD]hideAnimationFromView:self.view];
            }
            
        }];
    }else{
        [luserDic setObject:[self.infoDic objectForKey:@"picHeadURL"] forKey:@"picHeadURL"];
        [luserDic setObject:[self.infoDic objectForKey:@"picCertURLs"] forKey:@"picCertURLs"];
        [self sendOtherData:certDic];
    }
    
}


//提交证件照
-(void)sendCardPhoto:(NSMutableDictionary *)luserDic certDic:(NSDictionary *)certDic{
    // 上传证件照
    [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:@{@"nType":TYPE_CERT, @"tag":PHOTO_DAGOLFLA} andDataArray:[_dictPhoto objectForKey:@"picCertURLs"] failedBlock:^(id errType) {
        
        
    } completionBlock:^(id data) {
        if ([data objectForKey:@"url"]) {
            [luserDic setObject:[data objectForKey:@"url"] forKey:@"picCertURLs"];
            //提交其余数据
            [self sendOtherData:certDic];
        }else{
            // 失败
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        }
    }];
}

//获取照片id之后提交其余数据
-(void)sendOtherData:(NSDictionary *)certDic{

    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"league/doSaveSystemLeagueUInfo" JsonKey:nil withData:certDic failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"luserKey"]) {
                NSLog(@"%@", [data objectForKey:@"luserKey"]);
            }
            
            [self poptoVipDetail];
            
        }else{
            
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    

}


- (void)poptoVipDetail{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[VipCardConfirmOrderViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark -- 上传照片

-(void)SelectPhotoImage:(UIButton *)btn{
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]]){
                
                [btn setImage:[UIImage imageNamed:@"photoCamera"] forState:(UIControlStateNormal)];
                NSData *imageData = UIImageJPEGRepresentation(self.uploadImage, 0.3);
                NSLog(@"%ld",imageData.length/1024);

                self.uploadImage = (UIImage *)Data;
                if (btn.tag == 520) {
                    self.personView.image = self.uploadImage;
        
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(self.uploadImage, 0.3)] forKey:@"picHeadURL"];
                    
                }else if (btn.tag == 530){
                    self.certificatesView.image = self.uploadImage;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(self.uploadImage, 0.3)] forKey:@"picCertURLs"];
                }
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                self.uploadImage = (UIImage *)Data;
                [btn setImage:[UIImage imageNamed:@"photoCamera"] forState:(UIControlStateNormal)];

                NSData *imageData = UIImageJPEGRepresentation(self.uploadImage, 0.3);
                NSLog(@"%ld",imageData.length/1024);
                if (btn.tag == 520) {
                    self.personView.image = self.uploadImage;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(self.uploadImage, 0.3)] forKey:@"picHeadURL"];
                }else if (btn.tag == 530){
                    self.certificatesView.image = self.uploadImage;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(self.uploadImage, 0.3)] forKey:@"picCertURLs"];
                    
                }
                
            }
            
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}


- (void)dottedLine:(UIImageView *)imageV{

    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithHexString:@"#D5D5D5"].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:imageV.bounds].CGPath;
    border.frame = imageV.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@3, @2];
    [imageV.layer addSublayer:border];
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
