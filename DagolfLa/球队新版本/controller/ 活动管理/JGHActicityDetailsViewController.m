//
//  JGHActicityDetailsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActicityDetailsViewController.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGHHeaderLabelCell.h"
#import "JGTeamApplyViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "SXPickPhoto.h"
#import "BallParkViewController.h"
#import "JGHCostListTableViewCell.h"
#import "JGTeamActivityViewController.h"
#import "JGHTeamMembersViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTableViewCell.h"
#import "UMSocial.h"
#import "ShareAlert.h"
#import "UMSocialData.h"
#import "ShareAlert.h"
#import "UMSocialConfig.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "CommuniteTableViewCell.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialControllerService.h"

#import "EnterViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGHTeamContactTableViewCell.h"
#import "DateTimeViewController.h"
#import "JGCostSetViewController.h"
#import "JGHConcentTextViewController.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;

@interface JGHActicityDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, JGCostSetViewControllerDelegate, JGHConcentTextViewControllerDelegate, UITextFieldDelegate>
{
    NSInteger _isTeamMember;//是否是球队成员 1 － 不是
    NSString *_userName;//用户在球队的真实姓名
    NSArray *_titleArray;//标题数组
    NSInteger _isEditor;//是否编辑0，1-已编辑
}

@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源
@property (nonatomic, strong)NSMutableArray *subDataArray;//费用说明数据源
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)UIButton *editorBtn;

@end

@implementation JGHActicityDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/activity/%td_background.jpg", [_model.timeKey integerValue]];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    
    if (_isEditor == 0) {
        //我的球队活动
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
    }else{
        self.editorBtn.backgroundColor = [UIColor colorWithHexString:@"#F59A2C"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        self.subDataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *bgImage = nil;
    UIImage *headerImage = nil;
    _isEditor = 0;
    _titleArray = @[@"活动开始时间", @"活动结束时间", @"报名截止时间"];
    
    self.imgProfile = [[UIImageView alloc] initWithImage:bgImage];
    self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
    self.imgProfile.userInteractionEnabled = YES;
    self.teamActibityNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44)];
    UINib *tableViewNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:tableViewNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    UINib *addressNib = [UINib nibWithNibName:@"JGTeamActivityWithAddressCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:addressNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    UINib *deetailsNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:deetailsNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];
    UINib *costListNib = [UINib nibWithNibName:@"JGHCostListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:costListNib forCellReuseIdentifier:JGHCostListTableViewCellIdentifier];
    UINib *tableNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    UINib *contactNib = [UINib nibWithNibName:@"JGHTeamContactTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:contactNib forCellReuseIdentifier:JGHTeamContactCellIdentifier];
    [self.teamActibityNameTableView registerNib:tableNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    self.teamActibityNameTableView.dataSource = self;
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teamActibityNameTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.teamActibityNameTableView];
    [self.view addSubview:self.imgProfile];
    
    //顶部图
    self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.imgProfile addSubview:self.titleView];
    
    //渐变图
    UIImageView *gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
    [gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.titleView addSubview:gradientImage];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    
    //活动名称输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 17, screenWidth - 128, 30)];
    self.titleField.text = _model.name;
    self.titleField.tag = 123;
    self.titleField.delegate = self;
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:16 * screenWidth / 320];
    //点击更换背景
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64, 10, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 65, 65)];
    [self.headPortraitBtn setImage:headerImage forState:UIControlStateNormal];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.tag = 740;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(85, 180, 70, 25)];
    self.addressBtn.tag = 333;
    [self.addressBtn setTitle:_model.ballName forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addressBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect address = self.addressBtn.frame;
    self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
    
    [self.imgProfile addSubview:self.addressBtn];
    
    [self createEditorBtn];//
    
    [self dataSet];
}
#pragma mark -- 下载数据 －－－
- (void)dataSet{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //球队活动
    [dict setValue:[NSString stringWithFormat:@"%td", [_model.timeKey integerValue]] forKey:@"activityKey"];
    [dict setValue:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            if ([data objectForKey:@"teamMember"]) {
                dict = [data objectForKey:@"teamMember"];
                _userName = [dict objectForKey:@"userName"];//获取用户在球队的真实姓名
            }else{
                _isTeamMember = 1;//非球队成员
                [self.editorBtn setBackgroundColor:[UIColor lightGrayColor]];
            }
            
            [self.model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            
            [_subDataArray removeAllObjects];
            if ([self.model.memberPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球队队员资费", [self.model.memberPrice floatValue]]];
            }
            
            if ([self.model.guestPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-普通嘉宾资费", [self.model.guestPrice floatValue]]];
            }
            
            if ([self.model.billNamePrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场记名会员资费", [self.model.billNamePrice floatValue]]];
            }
            
            if ([self.model.billPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场无记名会员资费", [self.model.billPrice floatValue]]];
            }
            
            [self.teamActibityNameTableView reloadData];
        }else{
            
        }
    }];
}
#pragma mark -- 跳转分组页面
- (void)pushGroupCtrl:(UIButton *)btn{
    JGTeamGroupViewController *teamCtrl = [[JGTeamGroupViewController alloc]init];
    teamCtrl.teamActivityKey = [_model.timeKey integerValue];
    
    [self.navigationController pushViewController:teamCtrl animated:YES];
}
#pragma mark -- 获取球场地址
- (void)replaceWithPicture:(UIButton *)Btn{
    //球场列表
    BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
    [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
        NSLog(@"%@----%ld", balltitle, (long)ballid);
        self.model.ballKey = *(&(ballid));
        self.model.ballName = balltitle;
        _isEditor = 1;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGRect address = self.addressBtn.frame;
        self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
        [self.addressBtn setTitle:self.model.ballName forState:UIControlStateNormal];
    }];
    
    [self.navigationController pushViewController:ballCtrl animated:YES];
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //更换背景
        [self SelectPhotoImage:btn];
    }else if (btn.tag == 740){
        [self SelectPhotoImage:btn];
    }
}
#pragma mark --添加活动头像
-(void)SelectPhotoImage:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                self.model.bgImage = _headerImage;
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                }
                
                _isEditor = 1;
                [self.teamActibityNameTableView reloadData];
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                _isEditor = 1;
                self.model.bgImage = _headerImage;
                //设置背景
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
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

#pragma mark -- 保存按钮
- (void)createEditorBtn{
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    self.editorBtn = [[UIButton alloc]initWithFrame:CGRectMake( 0, screenHeight-44, screenWidth, 44)];
    [self.editorBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.editorBtn.backgroundColor = [UIColor lightGrayColor];
    [self.editorBtn addTarget:self action:@selector(editonAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editorBtn];
}

#pragma mark -- 保存
- (void)editonAttendBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    if (_isEditor == 0) {
        [[ShowHUD showHUD]showToastWithText:@"未修改信息，无需保存！" FromView:self.view];
        return;
    }else{
        if (self.titleField.text.length == 0) {
            [[ShowHUD showHUD]showToastWithText:@"活动名称不能为空！" FromView:self.view];
            return;
        }
        
        if (self.model.beginDate == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动开始时间不能为空！" FromView:self.view];
            return;
        }
        
        if (self.model.endDate == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动结束时间不能为空！" FromView:self.view];
            return;
        }
        
        if (self.model.signUpEndTime == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动报名截止时间不能为空！" FromView:self.view];
            return;
        }
        
        if ([self.model.beginDate compare:self.model.endDate] > 0) {
            [[ShowHUD showHUD]showToastWithText:@"活动开始时间不能大于结束时间！" FromView:self.view];
            return;
        }
        
        if (self.model.userMobile.length != 11) {
            [[ShowHUD showHUD]showToastWithText:@"手机号码格式不正确！" FromView:self.view];
            return;
        }
        
        if (self.model.ballName == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动地址不能为空！" FromView:self.view];
            return;
        }
        
        if (self.model.info == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动说明不能为空！" FromView:self.view];
            return;
        }
        
        if (self.model.memberPrice < 0) {
            [[ShowHUD showHUD]showToastWithText:@"请填写活动会员价！" FromView:self.view];
            return;
        }
        
        if (self.model.guestPrice <= 0) {
            [[ShowHUD showHUD]showToastWithText:@"请填写活动嘉宾价！" FromView:self.view];
            return;
        }
        
        if (self.model.userName == nil) {
            [[ShowHUD showHUD]showToastWithText:@"活动联系人不能为空！" FromView:self.view];
            return;
        }
        
        [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"%td", _model.teamKey] forKey:@"teamKey"];//球队key
        [dict setObject:[NSString stringWithFormat:@"%td", [_model.timeKey integerValue]] forKey:@"timeKey"];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//用户key
        [dict setObject:self.model.name forKey:@"name"];//活动名字
        [dict setObject:self.model.signUpEndTime forKey:@"signUpEndTime"];//活动报名截止时间
        [dict setObject:self.model.beginDate forKey:@"beginDate"];//活动开始时间
        [dict setObject:self.model.endDate forKey:@"endDate"];//活动结束时间
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.ballKey] forKey:@"ballKey"];//球场id
        [dict setObject:self.model.ballName forKey:@"ballName"];//球场名称
        //    [dict setObject:@"" forKey:@"ballGeohash"];//球场坐标
        [dict setObject:self.model.info forKey:@"info"];//活动简介
        [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.memberPrice floatValue]] forKey:@"memberPrice"];//会员价
        [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.guestPrice floatValue]] forKey:@"guestPrice"];//嘉宾价
        if ([self.model.billNamePrice floatValue] >= 0.0) {
            [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.billNamePrice floatValue]] forKey:@"billNamePrice"];//
        }
        
        if ([self.model.billPrice floatValue] >= 0.0) {
            [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.billPrice floatValue]] forKey:@"billPrice"];//
        }
        
        NSLog(@"%@", self.model.billPrice);
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.maxCount] forKey:@"maxCount"];//最大人员数
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)_model.isClose] forKey:@"isClose"];//活动是否结束 0 : 开始 , 1 : 已结束
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        [dict setObject:currentTime forKey:@"createTime"];//活动创建时间
        [dict setObject:self.model.userName forKey:@"userName"];//联系人
        [dict setObject:self.model.userMobile forKey:@"userMobile"];//联系人
        
        _isEditor = 0;
        //发布活动
        [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivity" JsonKey:@"teamActivity" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"%@", errType);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
                [Helper alertViewWithTitle:@"活动更新失败！" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
                return ;
            }
            
            if (self.model.bgImage) {
                NSMutableArray *imageArray = [NSMutableArray array];
                
                [imageArray addObject:UIImageJPEGRepresentation(self.model.bgImage, 1.0)];
                
                NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
                // 上传图片
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
                [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
                
                [dict setObject:[NSString stringWithFormat:@"%@_background" ,strTimeKey] forKey:@"data"];
                [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
                [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                    NSLog(@"errType===%@", errType);
                } completionBlock:^(id data) {
                    NSLog(@"data == %@", data);
                    if ([[data objectForKey:@"code"] integerValue] == 1) {
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"活动更新成功!" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:commitAction];
                        //获取主线层
                        if ([NSThread isMainThread]) {
                            NSLog(@"Yay!");
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            NSLog(@"Humph, switching to main");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self presentViewController:alertController animated:YES completion:nil];
                            });
                        }
                        
                    }
                }];
            }else{
                [[ShowHUD showHUD]showToastWithText:@"活动更新成功!" FromView:self.view];
                //获取主线层
                if ([NSThread isMainThread]) {
                    NSLog(@"Yay!");
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"Humph, switching to main");
                    dispatch_async(dispatch_get_main_queue(), ^{
                    });
                }
            }
        }];
    }
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        //参赛费用列表
        return _subDataArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }else if (section == 5){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_subDataArray.count > 0) {
            [costListCell configCostData:_subDataArray[indexPath.row]];
        }
        
        return costListCell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *windowReuseIdentifier = @"SectionOneCell";
    if (section == 0) {
        UITableViewCell *launchImageActivityCell = nil;
        launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!launchImageActivityCell) {
            
            launchImageActivityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
        }
        
        launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return (UIView *)launchImageActivityCell;
    }else if (section == 1 || section == 2) {
        
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *timeCellBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, launchActivityCell.frame.size.height)];
        timeCellBtn.tag = section + 100;
        [timeCellBtn addTarget:self action:@selector(getTimeAndAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        [launchActivityCell addSubview:timeCellBtn];
        if (section == 2) {
            launchActivityCell.underline.hidden = YES;
        }else{
            launchActivityCell.underline.hidden = NO;
        }
        
        [launchActivityCell configTitlesString:_titleArray[section-1]];
        
        [launchActivityCell configTimeString:_model andTag:section];
        
        return launchActivityCell;

    }else if (section == 3){
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *timeCellBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        timeCellBtn.tag = section + 100;
        [timeCellBtn addTarget:self action:@selector(editorCostClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell addSubview:timeCellBtn];
        return (UIView *)headerCell;
    }else if (section == 4){
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [applyListBtn addTarget:self action:@selector(getTeamActivitySignUpList:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell addSubview:applyListBtn];
        [headerCell congiftitles:@"分组管理"];
        [headerCell congifCount:self.model.sumCount andSum:self.model.maxCount];
        return (UIView *)headerCell;
    }else if (section == 5){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, detailsCell.frame.size.height)];
        [detailsBtn addTarget:self action:@selector(pushDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
        detailsBtn.tag = section + 100;
        [detailsCell addSubview:detailsBtn];
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return (UIView *)detailsCell;
    }else if (section == 6){
        JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
        contactCell.tetfileView.tag = 234;
        contactCell.tetfileView.delegate = self;
        contactCell.contactLabel.text = @"人员限制";
        contactCell.contentView.backgroundColor = [UIColor whiteColor];
        if (self.model.name != nil) {
            contactCell.tetfileView.text = [NSString stringWithFormat:@"%td", self.model.maxCount];
        }
        
        contactCell.tetfileView.placeholder = @"请输入最大人员限制数";
        return contactCell.contentView;
    }else if (section == 7){
        JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
        contactCell.tetfileView.tag = 345;
        contactCell.tetfileView.delegate = self;
        contactCell.contactLabel.text = @"联系人";
        contactCell.contentView.backgroundColor = [UIColor whiteColor];
        if (self.model.name != nil) {
            contactCell.tetfileView.text = self.model.userName;
        }
        
        contactCell.tetfileView.placeholder = @"请输入联系人";
        contactCell.tetfileView.keyboardType = UIKeyboardTypeDefault;
        return contactCell.contentView;
    }else{
        JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
        contactCell.tetfileView.tag = 456;
        contactCell.tetfileView.delegate = self;
        contactCell.contactLabel.text = @"联系人电话";
        contactCell.contentView.backgroundColor = [UIColor whiteColor];
        if (self.model.name != nil) {
            contactCell.tetfileView.text = self.model.userMobile;
        }
        
        contactCell.tetfileView.placeholder = @"请输入最大人员限制数";
        return contactCell.contentView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 修改时间地点
- (void)getTimeAndAddressClick:(UIButton *)btn{
    DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
    [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
        if (btn.tag == 101) {
            [self.model setValue:dateStr forKey:@"beginDate"];
        }else{
            [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"signUpEndTime"];
        }
        
        _isEditor = 1;
        [self.teamActibityNameTableView reloadData];
    }];
    [self.navigationController pushViewController:dataCtrl animated:YES];
}
#pragma mark -- 修改价格
- (void)editorCostClick:(UIButton *)btn{
    JGCostSetViewController *costView = [[JGCostSetViewController alloc]initWithNibName:@"JGCostSetViewController" bundle:nil];
    costView.delegate = self;
    [self.navigationController pushViewController:costView animated:YES];
}
#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    _isEditor = 1;
    [self.model setValue:text forKey:@"info"];
    [self.teamActibityNameTableView reloadData];
}
#pragma mark -- 费用代理
- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost andRegisteredPrice:(NSString *)registeredPrice andBearerPrice:(NSString *)bearerPrice{
    _isEditor = 1;
    NSLog(@"%@", [Helper returnNumberForString:guestCost]);
    NSLog(@"%@", [Helper returnNumberForString:membersCost]);
    NSLog(@"%@", [Helper returnNumberForString:registeredPrice]);
    NSLog(@"%@", [Helper returnNumberForString:bearerPrice]);
    self.model.guestPrice = [Helper returnNumberForString:guestCost];
    self.model.memberPrice = [Helper returnNumberForString:membersCost];
    self.model.billNamePrice = [Helper returnNumberForString:registeredPrice];
    self.model.billPrice = [Helper returnNumberForString:bearerPrice];
    
    [_subDataArray removeAllObjects];
    if ([self.model.memberPrice floatValue] > 0) {
        [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球队队员资费", [self.model.memberPrice floatValue]]];
    }
    
    if ([self.model.guestPrice floatValue] > 0) {
        [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-普通嘉宾资费", [self.model.guestPrice floatValue]]];
    }
    
    if ([self.model.billNamePrice floatValue] > 0) {
        [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场记名会员资费", [self.model.billNamePrice floatValue]]];
    }
    
    if ([self.model.billPrice floatValue] > 0) {
        [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场无记名会员资费", [self.model.billPrice floatValue]]];
    }
    
    [self.teamActibityNameTableView reloadData];
}
#pragma mark -- 详情页面
- (void)pushDetailSCtrl:(UIButton *)btn{
    JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
    concentTextCtrl.itemText = @"活动详情";
    concentTextCtrl.delegate = self;
    concentTextCtrl.contentTextString = _model.info;
    [self.navigationController pushViewController:concentTextCtrl animated:YES];
}
#pragma mark -- 查看已报名人列表
- (void)getTeamActivitySignUpList:(UIButton *)btn{
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_model.timeKey integerValue];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 234) {
        if (self.model.maxCount != [textField.text integerValue]) {
            _isEditor = 1;
        }
        self.model.maxCount = [textField.text integerValue];
    }else if (textField.tag == 345) {
        if (![self.model.userName isEqualToString:textField.text]) {
            _isEditor = 1;
        }
        self.model.userName = textField.text;
    }else if (textField.tag == 456){
        if (![self.model.userMobile isEqualToString:textField.text]) {
            _isEditor = 1;
        }
        self.model.userMobile = textField.text;
    }else if (textField.tag == 123){
        if (![self.model.name isEqualToString:textField.text]) {
            _isEditor = 1;
        }
        self.model.name = textField.text;
    }
    if (_isEditor == 1) {
        self.editorBtn.backgroundColor = [UIColor colorWithHexString:@"#F59A2C"];
    }
    
}
#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _teamActibityNameTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.headPortraitBtn.hidden = NO;
            self.addressBtn.hidden = NO;
        }
    }
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
