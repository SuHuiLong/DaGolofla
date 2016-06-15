
//
//  JGHLaunchActivityViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "BallParkViewController.h"
#import "JGHSaveAndSubmitBtnCell.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static NSString *const JGHSaveAndSubmitBtnCellIdentifier = @"JGHSaveAndSubmitBtnCell";
static CGFloat ImageHeight  = 210.0;

@interface JGHLaunchActivityViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate,UITextFieldDelegate, JGCostSetViewControllerDelegate, JGHSaveAndSubmitBtnCellDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;//标题数组
    NSInteger _photos;//跳转相册问题
    
    NSMutableDictionary* dictData;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像


@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址
@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@end

@implementation JGHLaunchActivityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    self.model.headerImage = self.headPortraitBtn.imageView.image;
    
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    if (_model.name) {
        self.titleField.text = _model.name;
    }
    
    if (_model.ballName) {
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGRect address = self.addressBtn.frame;
        self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
        [self.addressBtn setTitle:self.model.ballName forState:UIControlStateNormal];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (_photos == 1) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.dataDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];

        _dataDict = [[NSMutableDictionary alloc]init];
        UIImage *image = [UIImage imageNamed:ActivityBGImage];
        self.model.bgImage = image;
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
        UINib *contactNib = [UINib nibWithNibName:@"JGHTeamContactTableViewCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:contactNib forCellReuseIdentifier:JGHTeamContactCellIdentifier];
        
        UINib *saveAndsubmitNib = [UINib nibWithNibName:@"JGHSaveAndSubmitBtnCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:saveAndsubmitNib forCellReuseIdentifier:JGHSaveAndSubmitBtnCellIdentifier];
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 10, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.imgProfile addSubview:self.titleView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _photos = 1;
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换背景
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64, 0, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.placeholder = @"请输入活动名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 65, 65)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:TeamLogoImage] forState:UIControlStateNormal];
    self.model.headerImage = [UIImage imageNamed:TeamLogoImage];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(85, 180, 70, 25)];
    self.addressBtn.tag = 333;
    [self.addressBtn setTitle:@"请添加地址" forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addressBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgProfile addSubview:self.addressBtn];
    
    if (self.model.name != nil) {
        self.titleField.text = _model.name;
        [self.addressBtn setTitle:_model.ballName forState:UIControlStateNormal];
    }else{
         [self.titleField becomeFirstResponder];
    }
    _titleArray = @[@[], @[@"活动开始时间", @"活动结束时间", @"报名截止时间"], @[@"费用说明", @"人员限制", @"活动说明"], @[@"联系电话"]];
    
//    [self.model setValuesForKeysWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"TeamActivityArray"]];
    
}

- (void)replaceWithPicture:(UIButton *)Btn{
    //球场列表
    BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
    [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
        NSLog(@"%@----%ld", balltitle, (long)ballid);
        self.model.ballKey = *(&(ballid));
        self.model.ballName = balltitle;
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
    }
}
#pragma mark -- 提示信息
- (void)alertviewString:(NSString *)string{
    [Helper alertViewNoHaveCancleWithTitle:string withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 10, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 10;
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
        return 3;
    }else if (section == 2){
        return 3;
    }else if (section == 4){
        return 1;
    }else{
        return 2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight -10;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 4) {
        return 20;
    }else{
        return 10;
    }
}
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
    }else if (indexPath.section == 3){
        JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
        if (indexPath.row == 1) {
            contactCell.contactLabel.text = @"联系人电话";
            contactCell.tetfileView.placeholder = @"请输入联系人电话";
            contactCell.tetfileView.tag = 123;
            if (self.model.name != nil) {
                contactCell.tetfileView.text = self.model.userMobile;
            }
        }else{
            contactCell.contactLabel.text = @"联系人";
            contactCell.tetfileView.keyboardType = UIKeyboardTypeDefault;
            contactCell.tetfileView.placeholder = @"请输入联系人姓名";
            if (self.model.name != nil) {
                contactCell.tetfileView.text = self.model.userName;
            }
            
            contactCell.tetfileView.tag = 23;
        }
        
        contactCell.tetfileView.delegate = self;
        
        return contactCell;
    }else if (indexPath.section == 4){
        JGHSaveAndSubmitBtnCell *saveCell = [tableView dequeueReusableCellWithIdentifier:JGHSaveAndSubmitBtnCellIdentifier];
        saveCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        saveCell.delegate = self;
        return saveCell;
    }else{
        if (indexPath.row == 1 && indexPath.section == 2) {
            JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
            contactCell.tetfileView.delegate = self;
            contactCell.tetfileView.tag = 234;
            contactCell.contactLabel.text = @"人员限制";
            if (self.model.name != nil) {
                contactCell.tetfileView.text = [NSString stringWithFormat:@"%td", self.model.maxCount];
            }
            
            contactCell.tetfileView.placeholder = @"请输入最大人员限制数";
            return contactCell;
        }else{
            
            JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *str = _titleArray[indexPath.section];
            if (indexPath.row == [str count]-1) {
                launchActivityCell.underline.hidden = YES;
            }else{
                launchActivityCell.underline.hidden = NO;
            }
            
            [launchActivityCell configTitlesString:str[indexPath.row]];
            
            [launchActivityCell configContionsStringWhitModel:self.model andIndexPath:indexPath];
            
            return launchActivityCell;
             
        }
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _photos = 1;
    if (indexPath.section == 1) {
        //时间选择
        DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
        [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            if (indexPath.row == 0) {
                [self.model setValue:dateStr forKey:@"beginDate"];
                [_dataDict setObject:dateStr forKey:@"activityBeginDate"];
            }else if(indexPath.row == 1){
                [self.model setValue:dateStr forKey:@"endDate"];
                [_dataDict setObject:dateStr forKey:@"activityEndDate"];
            }else{
                [self.model setValue:dateStr forKey:@"signUpEndTime"];
                [_dataDict setObject:dateStr forKey:@"activityEignUpEndTime"];
            }
            
            NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:dataCtrl animated:YES];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            JGCostSetViewController *costView = [[JGCostSetViewController alloc]initWithNibName:@"JGCostSetViewController" bundle:nil];
            costView.delegate = self;
            [self.navigationController pushViewController:costView animated:YES];
        }else if (indexPath.row == 2){
            JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
            
            concentTextCtrl.itemText = @"内容";
            concentTextCtrl.delegate = self;
            concentTextCtrl.contentTextString = _model.info;
            
            [self.navigationController pushViewController:concentTextCtrl animated:YES];
        }
    }
    
    [self.launchActivityTableView reloadData];
}
#pragma mark --保存代理
- (void)SaveBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    
    if (self.titleField.text.length != 0) {
        [dict setObject:self.model.name forKey:@"name"];//活动名字
    }
    
    if (self.model.beginDate != nil) {
        [dict setObject:self.model.beginDate forKey:@"beginDate"];//活动开始时间

    }
    
    if (self.model.endDate != nil) {
        [dict setObject:self.model.endDate forKey:@"endDate"];//活动结束时间
    }
    
    if (self.model.signUpEndTime != nil) {
        [dict setObject:self.model.signUpEndTime forKey:@"signUpEndTime"];//活动报名截止时间

    }
    
    
    if (self.model.userMobile.length == 11) {
        [dict setObject:self.model.userMobile forKey:@"userMobile"];//联系人

    }
    
    if (self.model.ballName != nil) {
        [dict setObject:self.model.ballName forKey:@"ballName"];//球场名称

    }
    
    if (self.model.info != nil) {
        [dict setObject:self.model.info forKey:@"info"];//活动简介

    }
    
    if (self.model.memberPrice > 0) {
        [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.memberPrice floatValue]] forKey:@"memberPrice"];//会员价
    }
    
    if (self.model.guestPrice > 0) {
        [dict setObject:[NSString stringWithFormat:@"%.2f", [self.model.guestPrice floatValue]] forKey:@"guestPrice"];//嘉宾价
    }
    
    if (self.model.userName != nil) {
        [dict setObject:self.model.userName forKey:@"userName"];//联系人

    }
    
    if (self.model.maxCount > 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.maxCount] forKey:@"maxCount"];//最大人员数
    }
    if (self.model.ballKey != 0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.ballKey] forKey:@"ballKey"];//球场id

    }

    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:_model];
    [userdef setObject:dict forKey:@"TeamActivityArray"];
    [userdef synchronize];
    [[ShowHUD showHUD]hideAnimationFromView:self.view];
    [Helper alertViewWithTitle:@"活动保存成功！" withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}

#pragma mark --提交代理
- (void)SubmitBtnClick:(UIButton *)btn{
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
        [[ShowHUD showHUD]showToastWithText:@"活动开始时间不能为空！" FromView:self.view];
        
        [self alertviewString:@"活动报名截止时间不能为空！"];
        return;
    }
    
    if ([self.model.beginDate compare:self.model.endDate] > 0) {
        [[ShowHUD showHUD]showToastWithText:@"活动开始时间不能大于结束时间！" FromView:self.view];
        return;
    }
    
    if ([self.model.signUpEndTime compare:self.model.endDate] > 0) {
        [[ShowHUD showHUD]showToastWithText:@"活动报名截止时间不能大于活动结束时间！" FromView:self.view];
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
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamKey] forKey:@"teamKey"];//球队key
    [dict setObject:@0 forKey:@"timeKey"];
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
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.maxCount] forKey:@"maxCount"];//最大人员数
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_model.isClose] forKey:@"isClose"];//活动是否结束 0 : 开始 , 1 : 已结束
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    [dict setObject:currentTime forKey:@"createTime"];//活动创建时间
    [dict setObject:self.model.userName forKey:@"userName"];//联系人
    [dict setObject:self.model.userMobile forKey:@"userMobile"];//联系人
    
    //发布活动
    [[JsonHttp jsonHttp]httpRequest:@"team/createTeamActivity" JsonKey:@"teamActivity" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
            [Helper alertViewWithTitle:@"活动发布失败！" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            
            return ;
        }
        
        NSMutableArray *imageArray = [NSMutableArray array];
        
        [imageArray addObject:UIImageJPEGRepresentation(self.model.bgImage, 0.7)];
        
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
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"活动创建成功!" preferredStyle:UIAlertControllerStyleAlert];
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
    }];
}
#pragma mark --添加活动头像
-(void)SelectPhotoImage:(UIButton *)btn{
    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _photos = 1;
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
                    self.model.bgImage = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.model.headerImage = _headerImage;
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                }
                
                [self.launchActivityTableView reloadData];
                _photos = 1;
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
                //设置背景
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                    self.model.bgImage = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.model.headerImage = _headerImage;
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                }
            }
            _photos = 1;
        }];
    }];
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    NSLog(@"%@", destinationURL);
    NSLog(@"%@", connection);
}

#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    [self.model setValue:text forKey:@"info"];
    [_dataDict setObject:text forKey:@"activityContext"];
    [self.launchActivityTableView reloadData];
}
#pragma mark -- 费用代理
- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost{
    NSLog(@"guestCost == %@", [Helper returnNumberForString:guestCost]);
    self.model.guestPrice = [Helper returnNumberForString:guestCost];
    self.model.memberPrice = [Helper returnNumberForString:membersCost];
    [_dataDict setObject:guestCost forKey:@"activityGuestCost"];
    [_dataDict setObject:membersCost forKey:@"activityMembersCost"];
    [self.launchActivityTableView reloadData];
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 234) {
        self.model.maxCount = [textField.text integerValue];
    }else if (textField.tag == 23) {
        self.model.userName = textField.text;
    }else if (textField.tag == 123){
        self.model.userMobile = textField.text;
    }else if (textField.tag == 345){
        self.model.name = textField.text;
    }
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
