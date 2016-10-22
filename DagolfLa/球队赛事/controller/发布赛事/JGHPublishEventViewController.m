//
//  JGHPublishEventViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPublishEventViewController.h"
#import "JGTableViewCell.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "BallParkViewController.h"
#import "JGHBtnCell.h"
#import "JGHGameSetViewController.h"
#import "JGHPublishEventSaveViewController.h"
#import "JGHPublishEventModel.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static NSString *const JGHBtnCellIdentifier = @"JGHBtnCell";
static CGFloat ImageHeight  = 210.0;

@interface JGHPublishEventViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, JGHBtnCellDelegate, JGHGameSetViewControllerDelegate>
{
    NSArray *_titleArray;//标题数组
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)JGHPublishEventModel *model;

@property (nonatomic, strong)NSMutableArray *rulesArray;

@end

@implementation JGHPublishEventViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    if (_model.matchName) {
        self.titleField.text = _model.matchName;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGHPublishEventModel alloc]init];
        
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        self.rulesArray = [NSMutableArray array];
        
        UIImage *image = [UIImage imageNamed:ActivityBGImage];
        self.model.bgImage = image;
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 10 *ProportionAdapter, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        
        
        [self.imgProfile addSubview:self.titleView];
        
        UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
        UINib *contactNib = [UINib nibWithNibName:@"JGHTeamContactTableViewCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:contactNib forCellReuseIdentifier:JGHTeamContactCellIdentifier];
        
        UINib *nextBtnNib = [UINib nibWithNibName:@"JGHBtnCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:nextBtnNib forCellReuseIdentifier:JGHBtnCellIdentifier];
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.costListArray == nil) {
        self.costListArray = [NSMutableArray array];
    }
    
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
    self.titleField.placeholder = @"请输入赛事名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:17 *ProportionAdapter] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@[], @[@"开球时间", @"活动结束时间", @"报名截止时间", @"举办场地"], @[@"玩法设置"], @[@"主办方", @"联系人电话"]];
    
    [self getTimeKey];
}
#pragma mark -- 获取timeKey
- (void)getTimeKey{
    [[JsonHttp jsonHttp] httpRequest:@"globalCode/createTimeKey" JsonKey:nil withData:nil requestMethod:@"GET" failedBlock:^(id errType) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            _model.timeKey = [[data objectForKey:@"timeKey"] integerValue];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
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
        
        _gradientImage.frame = self.imgProfile.frame;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 10 *ProportionAdapter, title.size.width, title.size.height);
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
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
        return 4;
    }else if (section == 2){
        return 1;
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
        return ImageHeight -10;
    }else{
        return 44 *ProportionAdapter;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 4) {
        return 20 *ProportionAdapter;
    }else{
        return 10 *ProportionAdapter;
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
            //contactCell.contactLabel.text = @"联系人电话";
            contactCell.contactLabel.text = _titleArray[indexPath.section][indexPath.row];
            contactCell.tetfileView.placeholder = @"请输入联系人电话";
            contactCell.tetfileView.tag = 123;
            if (self.model.userMobile != nil) {
                contactCell.tetfileView.text = self.model.userMobile;
            }
        }else{
            //contactCell.contactLabel.text = @"联系人";
            contactCell.contactLabel.text = _titleArray[indexPath.section][indexPath.row];
            contactCell.tetfileView.keyboardType = UIKeyboardTypeDefault;
            contactCell.tetfileView.placeholder = @"请输入主办方名称";
            if (self.model.userName != nil) {
                contactCell.tetfileView.text = self.model.userName;
            }
            
            contactCell.tetfileView.tag = 23;
        }
        
        contactCell.tetfileView.delegate = self;
        [contactCell configConstraint];
        return contactCell;
    }else if (indexPath.section == 4){
        JGHBtnCell *saveCell = [tableView dequeueReusableCellWithIdentifier:JGHBtnCellIdentifier];
        saveCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        [saveCell configEventNextBtn];
        saveCell.delegate = self;
        return saveCell;
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
        
        if (indexPath.section == 2) {
            
        }else{
            [launchActivityCell configJGHPublishEventModel:self.model andIndexPath:indexPath];
        }
        
        return launchActivityCell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        //时间选择
        if (indexPath.row == 0) {
            JGHDatePicksViewController *datePicksCrel = [[JGHDatePicksViewController alloc]init];
            datePicksCrel.returnDateString = ^(NSString *dateString){
                NSLog(@"%@", dateString);
                [self.model setValue:dateString forKey:@"beginDate"];
                
                NSString *dayString = [self.model.beginDate componentsSeparatedByString:@" "][0];
                if (self.model.endDate == nil) {
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dayString] forKey:@"endDate"];
                }
                
                if (self.model.signUpEndTime == nil) {
                    NSDateFormatter *format=[[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyy-MM-dd"];
                    NSDate *fromdate=[format dateFromString:dayString];
                    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
                    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
                    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
                    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:fromDate];//前一天
                    //date转string
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDate = [dateFormatter stringFromDate:lastDay];
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", strDate] forKey:@"signUpEndTime"];
                }
                
                [self.launchActivityTableView reloadData];
            };
            [self.navigationController pushViewController:datePicksCrel animated:YES];
        }else if (indexPath.row == 3) {
            //球场列表
            BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
            [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
                NSLog(@"%@----%ld", balltitle, (long)ballid);
                self.model.ballKey = [NSNumber numberWithInteger:ballid];
                self.model.ballName = balltitle;
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:ballCtrl animated:YES];
        }else{
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                if(indexPath.row == 1){
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"endDate"];
                }else{
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"signUpEndTime"];
                }
                
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }
    }else if (indexPath.section == 2){
        JGHGameSetViewController *gameSetCtrl = [[JGHGameSetViewController alloc]init];
        gameSetCtrl.delegate = self;
        gameSetCtrl.rulesArray = _rulesArray;
        [self.navigationController pushViewController:gameSetCtrl animated:YES];
    }
    
    [self.launchActivityTableView reloadData];
}
#pragma mark -- 下一步
- (void)commitCabbieCert:(UIButton *)btn{
    if (self.model.matchName == nil) {
        [[ShowHUD showHUD]showToastWithText:@"活动名称不能为空！" FromView:self.view];
        return;
    }
    
    if (self.model.beginDate == nil) {
        [[ShowHUD showHUD]showToastWithText:@"活动开球时间不能为空！" FromView:self.view];
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
    
    if (self.model.ballName == nil) {
        [[ShowHUD showHUD]showToastWithText:@"活动地址不能为空！" FromView:self.view];
        return;
    }
    
    if (self.model.userName == nil) {
        [[ShowHUD showHUD]showToastWithText:@"主办方姓名不能为空！" FromView:self.view];
        return;
    }
    
    if (self.model.userMobile.length != 11) {
        [[ShowHUD showHUD]showToastWithText:@"手机号码格式不正确！" FromView:self.view];
        return;
    }
    
    if (_rulesArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请设置玩法！" FromView:self.view];
        return;
    }
    
    JGHPublishEventSaveViewController *publishCtrl = [[JGHPublishEventSaveViewController alloc]init];
    publishCtrl.rulesArray = _rulesArray;
    publishCtrl.model = _model;
    [self.navigationController pushViewController:publishCtrl animated:YES];
}

- (void)popCtrl{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --添加赛事背景
-(void)SelectPhotoImage:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                self.imgProfile.image = (UIImage *)Data;
                self.model.bgImage = (UIImage *)Data;
                
                [self.launchActivityTableView reloadData];
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                //设置背景
                self.imgProfile.image = (UIImage *)Data;
                self.model.bgImage = (UIImage *)Data;
                [self.launchActivityTableView reloadData];
            }
        }];
    }];
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 保存赛制规则
- (void)saveRulesArray:(NSMutableArray *)rulesArray{
    self.rulesArray = rulesArray;
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 23) {
        self.model.userName = textField.text;
    }else if (textField.tag == 123){
        self.model.userMobile = textField.text;
    }else if (textField.tag == 345){
        self.model.matchName = textField.text;
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
