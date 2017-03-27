//
//  JGDCreatTeamViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//


#import "JGDCreatTeamViewController.h"
#import "JGApplyMaterialTableViewCell.h"

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

#import "JGDCreatTeamTableViewCell.h"
#import "JGDDoubleTextfiledTableViewCell.h"


static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGDCreatTeamViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate,JGHConcentTextViewControllerDelegate>
{
    
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
    
    NSMutableDictionary* _dictPhoto;
    
    BOOL _wasKeyboardManagerEnabled;
    
    UIImageView *_gradientImage;
}

@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, strong)UIButton *headPortraitBtn;//头像
@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;


@property (nonatomic, strong)UIImage *headerImage;



@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

//@property (nonatomic, strong)NSMutableDictionary *paraDic; //参数字典

@property (nonatomic, strong) NSArray *tilteArray;
@property (nonatomic, strong) NSArray *iconArray;

@end

@implementation JGDCreatTeamViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

    
}
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:NO];
    self.navigationController.navigationBarHidden = NO;
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
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight * ProportionAdapter);
        self.imgProfile.userInteractionEnabled = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleToFill;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight * ProportionAdapter)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];

        
        [self.launchActivityTableView registerClass:[JGDCreatTeamTableViewCell class] forCellReuseIdentifier:@"JGDCreatTeamTableViewCell"];
        [self.launchActivityTableView registerClass:[JGDDoubleTextfiledTableViewCell class] forCellReuseIdentifier:@"JGDDoubleTextfiledTableViewCell"];

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
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10 * ProportionAdapter, 44  * ProportionAdapter, 44 * ProportionAdapter);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth - 70 * ProportionAdapter, 10  * ProportionAdapter, 60 * ProportionAdapter, 44 * ProportionAdapter);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];

    
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20   * ProportionAdapter, 150  * ProportionAdapter, 50   * ProportionAdapter, 50  * ProportionAdapter)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:TeamLogoImage] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.tag = 740;
    self.headPortraitBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgProfile addSubview:self.headPortraitBtn];
    

    [self createPreviewBtn];
    

}


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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10  * ProportionAdapter, screenHeight - 72  * ProportionAdapter, screenWidth- 20  * ProportionAdapter, 40  * ProportionAdapter)];
    view.userInteractionEnabled = YES;
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth / 2, 40   * ProportionAdapter)];
    [previewBtn setTitle:@"保存" forState:UIControlStateNormal];
    previewBtn.tag = 2001;
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#f39800"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:previewBtn];
    
    UIButton *commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth / 2 - 10 , 0, screenWidth / 2, 40 * ProportionAdapter)];
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

    JGDCreatTeamTableViewCell * cell1 = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.detailDic setObject:cell1.teamNameTF.text forKey:@"name"];
    
    JGDDoubleTextfiledTableViewCell *cell2 = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    [self.detailDic setObject:cell2.firstTF.text forKey:@"userName"];
    [self.detailDic setObject:cell2.secondTF.text forKey:@"userMobile"];

    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (btn.tag == 2001) {
        
        [user setObject:self.detailDic forKey:@"cacheCreatTeamDic"];
        [user synchronize];
        [LQProgressHud showMessage:@"保存成功"];
//        [Helper alertViewNoHaveCancleWithTitle:@"保存成功" withBlock:^(UIAlertController *alertView) {
//            [self.navigationController presentViewController:alertView animated:YES completion:nil];
//        }];
        
    }else{
        
        
        for (NSString *key in [self.detailDic allKeys]) {
            if ([[self.detailDic objectForKey:key] isEqualToString:@""] && ![key isEqualToString:@"info"]) {
                [LQProgressHud showMessage:@"请补全资料后提交"];
                return;
            }
        }
        
        
        [self.detailDic setObject:@"" forKey:@"notice"];
        [self.detailDic setObject:@0 forKey:@"timeKey"];
        [self.detailDic setObject:[user objectForKey:@"userId"] forKey:@"createUserKey"];
        [self.detailDic setObject:@"1" forKey:@"check"];
        [self.detailDic setObject:[user objectForKey:@"userName"] forKey:@"createUserName"];
        NSDate *dateNew = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSString * dateString = [dm stringFromDate:dateNew];
        [self.detailDic setObject:dateString forKey:@"createtime"];
        [user setObject:self.detailDic forKey:@"cacheCreatTeamDic"];
        [user setObject:_dictPhoto forKey:@"teamPhotoDic"];
        
        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
        progress.mode = MBProgressHUDModeIndeterminate;
        progress.labelText = @"正在发布...";
        [self.view addSubview:progress];
        [progress show:YES];
        
        
        [[JsonHttp jsonHttp] httpRequest:@"globalCode/createTimeKey" JsonKey:nil withData:nil requestMethod:@"GET" failedBlock:^(id errType) {
            if ([NSThread isMainThread]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [self.detailDic removeObjectForKey:@"notice"];
                [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    [self.detailDic removeObjectForKey:@"notice"];
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
                    [self.detailDic removeObjectForKey:@"notice"];
                    [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                        [self.detailDic removeObjectForKey:@"notice"];
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
                            [self.detailDic removeObjectForKey:@"notice"];
                            [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                [self.detailDic removeObjectForKey:@"notice"];
                                [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                            });
                        }
                    } completionBlock:^(id data) {
                        
                        if ([[data objectForKey:@"code"] integerValue] == 1) {
                            
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            
                            [self.detailDic setObject:strTimeKey forKey:@"timeKey"];
                            //  创建球队
                            [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:self.detailDic requestMethod:@"POST" failedBlock:^(id errType) {
                                if ([NSThread isMainThread]) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                    [self.detailDic removeObjectForKey:@"notice"];
                                    [[ShowHUD showHUD]showToastWithText:@"球队创建失败，请稍后再试" FromView:self.view];
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                        [self.detailDic removeObjectForKey:@"notice"];
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
                                    
                                    [LQProgressHud showMessage:@"球队创建成功"];
                                    [self.navigationController popViewControllerAnimated:YES];

                                    
//                                    [Helper alertViewNoHaveCancleWithTitle:@"球队创建成功" withBlock:^(UIAlertController *alertView) {
//                                        [self.navigationController popViewControllerAnimated:YES];
//                                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
//                                        
//                                    }];
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
                                        [self.detailDic removeObjectForKey:@"notice"];
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
                                [self.detailDic removeObjectForKey:@"notice"];
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
                        [self.detailDic removeObjectForKey:@"notice"];
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


#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+(ImageHeight  * ProportionAdapter))*screenWidth)/(ImageHeight  * ProportionAdapter);
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, (ImageHeight  * ProportionAdapter)+ABS(yOffset));
        self.imgProfile.frame = f;
        
        _gradientImage.frame = self.imgProfile.frame;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 0;
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

    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        return (ImageHeight * ProportionAdapter) + 10 * ProportionAdapter;
    }else if (indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7) {
        return 10 * ProportionAdapter;
    }else{
        return 45 * ProportionAdapter;
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20 * ProportionAdapter , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 50 * ProportionAdapter;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    UILabel *footLB = [Helper lableRect:CGRectMake(12 * ProportionAdapter, 14 * ProportionAdapter, screenWidth - 12 * ProportionAdapter, 15 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:14 * ProportionAdapter text:@"   注：为了球队能够顺利创建，请务必输入真实信息。" textAlignment:(NSTextAlignmentLeft)];
    return footLB;
}



#pragma mark -------cellForROwAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7) {
        UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
        emptyCell.backgroundColor = [UIColor clearColor];
        emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return emptyCell;
    }
    
    if (indexPath.row == 9) {
        JGDDoubleTextfiledTableViewCell *tfcell = [tableView dequeueReusableCellWithIdentifier:@"JGDDoubleTextfiledTableViewCell"];
        tfcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tfcell.firstTF.text = [self.detailDic objectForKey:@"userName"];
        tfcell.secondTF.text = [self.detailDic objectForKey:@"userMobile"];
        return tfcell;
    }
    
    JGDCreatTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDCreatTeamTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = self.tilteArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    if (indexPath.row == 1) {
        cell.teamNameTF.placeholder = @"请输入球队名称";
        cell.teamNameTF.text = [self.detailDic objectForKey:@"name"];
    }else{
        cell.teamNameTF.hidden = YES;
        //  3 4 6
        switch (indexPath.row) {
            case 3:
                cell.detailLB.text = [Helper stringFromDateString:[self.detailDic objectForKey:@"establishTime"] withFormater:@"yyyy年MM月dd日"];
                break;
                
            case 4:
                cell.detailLB.text = [self.detailDic objectForKey:@"crtyName"];
                break;
            
            case 6:
                cell.detailLB.text = [self.detailDic objectForKey:@"info"];
                break;
                
            default:
                break;
        }
        
        
    }
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 3) {
            //时间选择
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            dataCtrl.typeIndex = @1;
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                
                JGDCreatTeamTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                
                launchActivityCell.detailLB.text = [Helper returnDateformatString:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
                [self.detailDic setObject:[NSString stringWithFormat:@"%@ 00:00:00", dateStr] forKey:@"establishTime"];
            }];
            
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }else if (indexPath.row == 4) {
            //地区选择
            TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
            areaVc.teamType = @10;
            areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
                
                JGDCreatTeamTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                launchActivityCell.detailLB.text = [NSString stringWithFormat:@"%@ %@", strPro, strCity];
                [self.detailDic setObject:[NSString stringWithFormat:@"%@ %@", strPro, strCity] forKey:@"crtyName"];
            };
            [self.navigationController pushViewController:areaVc animated:YES];
        }else if (indexPath.row == 6) {
            JGHConcentTextViewController *introVC = [[JGHConcentTextViewController alloc] init];
            introVC.delegate = self;
            introVC.contentTextString = [self.detailDic objectForKey:@"info"];
            [self.navigationController pushViewController:introVC animated:YES];
        }

        
}

#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    
    JGDCreatTeamTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:6 inSection:0]];
    
    launchActivityCell.detailLB.text = text;
    
    [self.detailDic setObject:text forKey:@"info"];
    
    
}


- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    NSLog(@"%@", destinationURL);
    NSLog(@"%@", connection);
}

- (NSMutableDictionary *)detailDic{
    if (!_detailDic) {
        _detailDic = [[NSMutableDictionary alloc] init];
        [_detailDic setObject:@"" forKey:@"info"];
        [_detailDic setObject:@"" forKey:@"crtyName"];
        [_detailDic setObject:@"" forKey:@"establishTime"];
        [_detailDic setObject:@"" forKey:@"userName"];
        [_detailDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:Mobile] forKey:@"userMobile"];
        [_detailDic setObject:@"" forKey:@"name"];

    }
    return _detailDic;
}


- (NSArray *)tilteArray{
    if (!_tilteArray) {
        _tilteArray = [NSArray arrayWithObjects:@"", @"球队名称", @"", @"成立日期", @"所在地区", @"", @"球队简介", @"", @"申请人资料", @"", nil];
    }
    return _tilteArray;
}

- (NSArray *)iconArray{
    if (!_iconArray) {
        _iconArray = [NSArray arrayWithObjects:@"", @"icn_teamname", @"", @"icn_time", @"icn_address", @"", @"icn_teamintr", @"", @"icn_detail", @"", nil];

    }
    return _iconArray;
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

