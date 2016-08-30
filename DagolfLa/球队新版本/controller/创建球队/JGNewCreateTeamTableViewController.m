//
//  JGNotTeamMemberDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGNewCreateTeamTableViewController.h"
#import "JGApplyMaterialTableViewCell.h"

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"
#import "JGPreviewTeamViewController.h"

#import "IQKeyboardManager.h"


static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGNewCreateTeamTableViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate,JGHConcentTextViewControllerDelegate>
{
    
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
    
    NSMutableDictionary* _dictPhoto;
    
    BOOL _wasKeyboardManagerEnabled;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;


@property (nonatomic, strong)UIImage *headerImage;



@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)NSMutableDictionary *paraDic; //参数字典

@end

@implementation JGNewCreateTeamTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    if ([self.detailDic objectForKey:@"name"]) {
        self.titleField.text = [self.detailDic objectForKey:@"name"];
    }
    if (self.detailDic) {
        self.paraDic = self.detailDic;
    }
    
    //    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    //    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    //     [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (instancetype)init{
    if (self == [super init]) {
        
        self.dataDict = [NSMutableDictionary dictionary];
        _dictPhoto = [[NSMutableDictionary alloc]init];
        [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation([UIImage imageNamed:TeamLogoImage], 0.7)] forKey:@"headPortraitBtn"];
        [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation([UIImage imageNamed:TeamBGImage], 0.7)] forKey:@"headerImage"];

        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:TeamBGImage];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight * screenWidth / 320);
        self.imgProfile.userInteractionEnabled = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleToFill;
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStylePlain)];
        [self.launchActivityTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        [self.launchActivityTableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"lbVSTF"];
        
        
        
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        //        label.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.imgProfile addSubview:self.titleView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    
    
    //渐变图
    UIImageView *gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
    [gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.titleView addSubview:gradientImage];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10 * screenWidth / 320, 44 * screenWidth / 320, 44 * screenWidth / 320);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64, 10 * screenWidth / 320, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 17 * screenWidth / 320, screenWidth - 128, 30)];
    //    self.titleField.textColor = [UIColor whiteColor];
    //    self.titleField.font = [UIFont systemFontOfSize:15];
    self.titleField.placeholder = @"请输入球队名";
    self.titleField.delegate = self;
    self.titleField.textColor = [UIColor whiteColor];
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15 * screenWidth / 320] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    self.titleField.tag = 1117;
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 * screenWidth / 320, 150 * screenWidth / 320, 50 * screenWidth / 320, 50 * screenWidth / 320)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:TeamLogoImage] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.headPortraitBtn.backgroundColor = [UIColor redColor];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.tag = 740;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    //    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, 170, screenWidth-70, 30)];
    //    self.addressBtn.tag = 333;
    //    [self.addressBtn setTitle:@"请添加地址" forState:UIControlStateNormal];
    //    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [self.addressBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.imgProfile addSubview:self.addressBtn];
    
    //    _titleArray = @[@[], @[@"成立日期", @"所在地区"], @[@"球队简介"], @[@"真实姓名", @"联系方式"]];
    
    [self createPreviewBtn];
}
//- (void)replaceWithPicture:(UIButton *)Btn{
//    if (Btn.tag == 333) {
//        //球场列表
//
//    }
//    [self didSelectPhotoImage:Btn];
//}

- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //更换背景
        [self SelectPhotoImage:btn];
    }else if (btn.tag == 740){
        //头像
        [self SelectPhotoImage:btn];
    }
}

#pragma mark --添加活动头像
-(void)SelectPhotoImage:(UIButton *)btn{
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
                _headerImage = (UIImage *)Data;
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                    
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 0.7)] forKey:@"headerImage"];
                    
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 0.7)] forKey:@"headPortraitBtn"];
                    
                }
                
                [self.launchActivityTableView reloadData];
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
                // @{@"nType":@"1", @"tag":@"dagolfla", @"data":@"test"};
                _headerImage = (UIImage *)Data;
                
                //设置背景
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
                    self.imgProfile.layer.masksToBounds = YES;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 1.0)] forKey:@"headerImage"];
                    
                }else if (btn.tag == 740){
                    //头像
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                    [_dictPhoto setObject:[NSArray arrayWithObject:UIImageJPEGRepresentation(_headerImage, 1.0)] forKey:@"headPortraitBtn"];
                    
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


#pragma mark -- 保存按钮
- (void)createPreviewBtn{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, screenHeight - 42 * screenWidth / 320, screenWidth- 20 * screenWidth / 320, 40 * screenWidth / 320)];
    view.userInteractionEnabled = YES;
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth / 2, 40 * screenWidth / 320)];
    [previewBtn setTitle:@"保存" forState:UIControlStateNormal];
    previewBtn.tag = 2001;
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#f39800"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:previewBtn];
    
    UIButton *commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 10 , 0, screenWidth / 2, 40 * screenWidth / 320)];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.tag =2002;
    commitBtn.backgroundColor = [UIColor colorWithHexString:@"eb6100"];
    [commitBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commitBtn];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 6.f;
    [self.launchActivityTableView addSubview:view];
    
}

#pragma mark -- 提交创建球队
- (void)previewBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (btn.tag == 2001) {
        
        [user setObject:self.paraDic forKey:@"cacheCreatTeamDic"];
        [user synchronize];
        [Helper alertViewNoHaveCancleWithTitle:@"保存成功" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        
    }else{
        
        
        if (!self.titleField.text || ([self.titleField.text length] == 0)) {
            //    if ([[self.paraDic objectForKey:@"name"] length] > 0) {
            [Helper alertViewNoHaveCancleWithTitle:@"请填写球队名称" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }else{
            NSString *name = self.titleField.text;
            [self.paraDic setObject:name forKey:@"name"];
        }
        
        
        if ([[self.paraDic objectForKey:@"establishTime"] length] == 0) {
            [Helper alertViewNoHaveCancleWithTitle:@"请填写球队创建时间" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }
        
        
        if ([[self.paraDic objectForKey:@"crtyName"] length] == 0) {
            [Helper alertViewNoHaveCancleWithTitle:@"请填写球队所在地区" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }
        
        
        if ([[self.paraDic objectForKey:@"userName"] length] == 0) {
            [Helper alertViewNoHaveCancleWithTitle:@"请填写真实姓名" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }
        
        if ([[self.paraDic objectForKey:@"userMobile"] length] == 0) {
            
            [Helper alertViewNoHaveCancleWithTitle:@"请填写联系方式" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }
        
        if (![self.paraDic objectForKey:@"info"] || ([[self.paraDic objectForKey:@"info"] length] == 0)) {
            [Helper alertViewNoHaveCancleWithTitle:@"请完善球队信息" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            return;
        }
        
        [self.paraDic setObject:@"" forKey:@"notice"];
        [self.paraDic setObject:@0 forKey:@"timeKey"];
        [self.paraDic setObject:[user objectForKey:@"userId"] forKey:@"createUserKey"];
        [self.paraDic setObject:@"1" forKey:@"check"];
        [self.paraDic setObject:[user objectForKey:@"userName"] forKey:@"createUserName"];
        NSDate *dateNew = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSString * dateString = [dm stringFromDate:dateNew];
        [self.paraDic setObject:dateString forKey:@"createtime"];
        [user setObject:self.paraDic forKey:@"cacheCreatTeamDic"];
        [user setObject:_dictPhoto forKey:@"teamPhotoDic"];
        
        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
        progress.mode = MBProgressHUDModeIndeterminate;
        progress.labelText = @"正在发布...";
        [self.view addSubview:progress];
        [progress show:YES];
        
        
        
        
        [[JsonHttp jsonHttp] httpRequest:@"globalCode/createTimeKey" JsonKey:nil withData:nil requestMethod:@"GET" failedBlock:^(id errType) {
            if ([NSThread isMainThread]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                });
            }
        } completionBlock:^(id data) {
            
            
            NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:strTimeKey forKey:@"data"];
            [dict setObject:TYPE_TEAM_HEAD forKey:@"nType"];
            [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
            // 上传头像
            [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:[_dictPhoto objectForKey:@"headPortraitBtn"] failedBlock:^(id errType) {
                NSLog(@"errType===%@", errType);
                
                if ([NSThread isMainThread]) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                        [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                    });
                }
                
            } completionBlock:^(id data) {
                
                if ([[data objectForKey:@"code"] integerValue] == 1) {
                    
                    [dict setObject:[NSString stringWithFormat:@"%@_background" ,strTimeKey] forKey:@"data"];
                    [dict setObject:TYPE_TEAM_HEAD forKey:@"nType"];
                    // 上传背景
                    [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dict andDataArray:[_dictPhoto objectForKey:@"headerImage"] failedBlock:^(id errType) {
                        NSLog(@"errType===%@", errType);
                        if ([NSThread isMainThread]) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                            [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                            });
                        }
                    } completionBlock:^(id data) {
                        
                        if ([[data objectForKey:@"code"] integerValue] == 1) {
                            
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            
                            [self.paraDic setObject:strTimeKey forKey:@"timeKey"];
                            //  创建球队
                            [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
                                if ([NSThread isMainThread]) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                    [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                        [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                                    });
                                }
                            } completionBlock:^(id data) {
                                
                                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                                    if ([NSThread isMainThread]) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                        });
                                    }
                                    
                                    [Helper alertViewNoHaveCancleWithTitle:@"球队创建成功" withBlock:^(UIAlertController *alertView) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                                        
                                    }];
                                    [user setObject:0 forKey:@"cacheCreatTeamDic"];
                                    [user synchronize];
                                    
                                }else{
                                    if ([NSThread isMainThread]) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                        });
                                    }
                                    if ([data objectForKey:@"packResultMsg"]) {
                                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                                    }
                                }
                            }];
                            
                        }else{
                            if ([NSThread isMainThread]) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                });
                            }
                            if ([data objectForKey:@"packResultMsg"]) {
                                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                            }
                        }
                        
                    }];
                    
                }else{
                    if ([NSThread isMainThread]) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                        });
                    }
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
                
            }];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text && [textField.text length] != 0) {
        if (textField.tag == 1115) {
            [self.detailDic setObject:textField.text forKey:@"userName"];
        }else if (textField.tag == 1116){
            [self.detailDic setObject:textField.text forKey:@"userMobile"];
        }else if (textField.tag == 1117){
            [self.detailDic setObject:textField.text forKey:@"name"];
        }
    }else{
        if (textField.tag == 1115) {
            [self.detailDic setObject:@"" forKey:@"userName"];
        }else if (textField.tag == 1116){
            [self.detailDic setObject:@"" forKey:@"userMobile"];
        }else if (textField.tag == 1117){
            [self.detailDic setObject:@"" forKey:@"name"];
        }
    }
}

// 判断是否为空 然后
- (void)notNil:(NSString *)str SetValueForKey:(NSString *)key{
    if (!str || ([str length] == 0)) {
        NSLog(@"-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-");
    }else{
        [self.paraDic setValue:str forKey:key];
    }
}


#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+(ImageHeight * screenWidth / 320))*screenWidth)/(ImageHeight * screenWidth / 320);
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, (ImageHeight * screenWidth / 320)+ABS(yOffset));
        self.imgProfile.frame = f;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0 * screenWidth / 320, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 0 * screenWidth / 320;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.headPortraitBtn.hidden = NO;
            self.addressBtn.hidden = NO;
        }
    }
}
#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
    
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 3){
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return (ImageHeight * screenWidth / 320) -10 * screenWidth / 320;
    }else if (indexPath.section == 2){
        //        return [self calculationLabelHeight:[self.paraDic objectForKey:@"info"]] + 40 * screenWidth / 320;
        return 45 * screenWidth / 320;
        
    }else{
        return 45 * screenWidth / 320;
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 320 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 ) {
        return 0;
    }else if (section == 4){
        return 25 * screenWidth / 320;
    }else{
        return 10 * screenWidth / 320;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == 2) {
        //        NSString *sectionTitle=[self tableView:tableView titleForFooterInSection:section];
        
        //        UILabel *label=[[UILabel alloc] init] ;
        //        label.frame=CGRectMake(10 * screenWidth / 320, 20 * screenWidth / 320, 300 * screenWidth / 320, 15 * screenWidth / 320);
        //        label.backgroundColor=[UIColor colorWithHexString:@"#EAEAEB"];
        //        label.textColor=[UIColor lightGrayColor];
        //        label.font=[UIFont systemFontOfSize:15 * screenWidth / 320];
        //        label.text=@"申请人资料";
        //
        //        UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45 * screenWidth / 320)];
        ////        [sectionView setBackgroundColor:[UIColor colorWithHexString:@"#EAEAEB"]];
        //        sectionView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        //
        //        [sectionView addSubview:label];
        //        return sectionView;
        return nil;
    }else if (section == 4) {
        UILabel *label=[[UILabel alloc] init] ;
        label.frame=CGRectMake(10 * screenWidth / 320, 0, 300 * screenWidth / 320, 22 * screenWidth / 320);
        label.backgroundColor=[UIColor colorWithHexString:@"#EAEAEB"];
        label.textColor=[UIColor colorWithHexString:@"#f39800"];
        label.font=[UIFont systemFontOfSize:12 * screenWidth / 320];
        label.text=@"注：为了球队能够顺利创建，请务必输入真实信息";
        
        
        UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 18 * screenWidth / 320)];
        //        [sectionView setBackgroundColor:[UIColor colorWithHexString:@"#EAEAEB"]];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        
        [sectionView addSubview:label];
        return sectionView;
    }else{
        return nil;
    }
}



#pragma mark -------cellForROwAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *windowReuseIdentifier = @"SectionOneCell";
    if (indexPath.section == 0) {
        UITableViewCell *launchImageActivityCell = nil;
        launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!launchImageActivityCell) {
            
            launchImageActivityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
        }
        
        launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return launchImageActivityCell;
    }else if (indexPath.section == 2){
        
        JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"lbVSlb"];
        launchActivityCell.promptLB.text = @"球队简介";
        launchActivityCell.contentLB.text = [self.paraDic objectForKey:@"info"];
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchActivityCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
        //        contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return launchActivityCell;
        
        
    }else if (indexPath.section == 1){
        
        JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"lbVSlb"];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            launchActivityCell.promptLB.text = @"成立日期";
            if ([self.detailDic objectForKey:@"establishTime"]) {
                launchActivityCell.contentLB.text = [Helper returnDateformatString:[self.detailDic objectForKey:@"establishTime"]] ;
            }
            
        }else{
            launchActivityCell.promptLB.text = @"所在地区";
            launchActivityCell.contentLB.text = [self.detailDic objectForKey:@"crtyName"];
        }
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return launchActivityCell;
    }else{
        JGApplyMaterialTableViewCell *launchActivityCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"lbVSTF"];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                launchActivityCell.labell.text = @"申请人资料";
                launchActivityCell.labell.textColor = [UIColor lightGrayColor];
                launchActivityCell.textFD.userInteractionEnabled = NO;
                launchActivityCell.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
            }else{
                launchActivityCell.labell.text = @"真实姓名";
                launchActivityCell.textFD.placeholder = @"请输入真实姓名";
                launchActivityCell.textFD.delegate = self;
                launchActivityCell.textFD.tag = 1115;
                launchActivityCell.textFD.text = [self.detailDic objectForKey:@"userName"];
            }
            
        }else if (indexPath.section == 4){
            launchActivityCell.labell.text = @"联系方式";
            launchActivityCell.textFD.placeholder = @"请输入手机号";
            launchActivityCell.textFD.delegate = self;
            launchActivityCell.textFD.tag = 1116;
            launchActivityCell.textFD.text = [self.detailDic objectForKey:@"userMobile"];
            launchActivityCell.textFD.keyboardType = UIKeyboardTypePhonePad;
        }
        return launchActivityCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //时间选择
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            dataCtrl.typeIndex = @1;
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                
                JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                
                launchActivityCell.contentLB.text = [Helper returnDateformatString:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
                [self.detailDic setObject:[NSString stringWithFormat:@"%@ 00:00:00", dateStr] forKey:@"establishTime"];
            }];
            
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }else{
            //地区选择
            TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
            areaVc.teamType = @10;
            areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
                
                JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%@ %@", strPro, strCity];
                [self.detailDic setObject:[NSString stringWithFormat:@"%@ %@", strPro, strCity] forKey:@"crtyName"];
            };
            [self.navigationController pushViewController:areaVc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            JGHConcentTextViewController *introVC = [[JGHConcentTextViewController alloc] init];
            introVC.delegate = self;
            introVC.contentTextString = [self.paraDic objectForKey:@"info"];
            [self.navigationController pushViewController:introVC animated:YES];
        }
        
    }
    
    //    [self.launchActivityTableView reloadData];
}

#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    
    JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:0 inSection:2]];
    
    launchActivityCell.contentLB.text = text;
    
    [self.paraDic setObject:text forKey:@"info"];
    
    
}


- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    NSLog(@"%@", destinationURL);
    NSLog(@"%@", connection);
}

- (NSMutableDictionary *)detailDic{
    if (!_detailDic) {
        _detailDic = [[NSMutableDictionary alloc] init];
    }
    return _detailDic;
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

