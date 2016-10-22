//
//  JGHPublishEventSaveViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPublishEventSaveViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGHPublishEventModel.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "BallParkViewController.h"
#import "JGHSaveAndSubmitBtnCell.h"
#import "JGHGameRoundsViewController.h"
#import "JGHPublicLevelCell.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static NSString *const JGHSaveAndSubmitBtnCellIdentifier = @"JGHSaveAndSubmitBtnCell";
static NSString *const JGHPublicLevelCellIdentifier = @"JGHPublicLevelCell";

static CGFloat ImageHeight  = 210.0;

@interface JGHPublishEventSaveViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate, JGCostSetViewControllerDelegate, JGHSaveAndSubmitBtnCellDelegate>
{
    NSArray *_titleArray;//标题数组
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
    
    NSArray *_levelArray;//公开政策
    NSInteger _selectLevel;//选择的公开政策
}
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonatomic, strong)UIView *titleView;//顶部导航
@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@end

@implementation JGHPublishEventSaveViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    if (_model.matchName) {
        self.titleField.text = _model.matchName;
    }
    
    if (_model.bgImage != nil) {
        self.imgProfile.image = _model.bgImage;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.titleView = [[UIView alloc]init];
        _selectLevel = 0;
        UIImage *image = [UIImage imageNamed:ActivityBGImage];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
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
        
        UINib *saveAndsubmitNib = [UINib nibWithNibName:@"JGHSaveAndSubmitBtnCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:saveAndsubmitNib forCellReuseIdentifier:JGHSaveAndSubmitBtnCellIdentifier];
        
        UINib *publicLevelCellNib = [UINib nibWithNibName:@"JGHPublicLevelCell" bundle: [NSBundle mainBundle]];
        [self.launchActivityTableView registerNib:publicLevelCellNib forCellReuseIdentifier:JGHPublicLevelCellIdentifier];
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
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.placeholder = @"请输入活动名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    self.titleField.userInteractionEnabled = NO;
    [self.titleView addSubview:self.titleField];
    
    if (self.model.matchName != nil) {
        self.titleField.text = _model.matchName;
    }else{
        [self.titleField becomeFirstResponder];
    }
    _titleArray = @[@"", @"比赛轮次设置", @"费用设置", @"对所有人公开", @"赛事说明"];
    
    _levelArray = @[@"对所有人公开", @"仅对参与球队公开", @"仅对参与及被邀请方公开"];
}

- (void)replaceWithPicture:(UIButton *)Btn{
    //球场列表
    BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
    
    [self.navigationController pushViewController:ballCtrl animated:YES];
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 提示信息
- (void)alertviewString:(NSString *)string{
    [Helper alertViewNoHaveCancleWithTitle:string withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg{
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
    if (section == 3) {
        return 3;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 30 *ProportionAdapter;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }else if (section == 4){
        return 20 *ProportionAdapter;
    }else{
        return 10 *ProportionAdapter;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHPublicLevelCell *publicCell = [tableView dequeueReusableCellWithIdentifier:JGHPublicLevelCellIdentifier];
    publicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [publicCell configJGHPublicLevelCell:_levelArray[indexPath.row] andSelect:(indexPath.row == _selectLevel)?1:0];
    return publicCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectLevel = indexPath.row;
    [self.launchActivityTableView reloadData];
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
    }else if (section == 5){
        JGHSaveAndSubmitBtnCell *saveCell = [tableView dequeueReusableCellWithIdentifier:JGHSaveAndSubmitBtnCellIdentifier];
        saveCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        saveCell.delegate = self;
        return saveCell;
    }else{
        JGTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier];
        
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [activityCell configTitlesString:_titleArray[section]];
        NSLog(@"section ==%ld", (long)section);
        if (section == 1) {
            activityCell.underline.hidden = NO;
        }else{
            activityCell.underline.hidden = YES;
        }
        
        UIButton *cellBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44 *ProportionAdapter)];
        cellBtn.tag = 100 + section;
        [cellBtn addTarget:self action:@selector(didSelectCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        [activityCell addSubview:cellBtn];
        
        return (UIView *)activityCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

#pragma mark -- cell点击事件

- (void)didSelectCellBtn:(UIButton *)btn{
    if (btn.tag == 101) {
        JGHGameRoundsViewController *gameRoundsCtrl = [[JGHGameRoundsViewController alloc]init];
//        NSMutableArray *array = [NSMutableArray array];
//        [array addObject:_rulesArray];
//        gameRoundsCtrl.rulesArray = array;
        gameRoundsCtrl.timeKey = _model.timeKey;
        gameRoundsCtrl.rulesTimeKey = [_rulesArray[0] objectForKey:@"timeKey"];
        [self.navigationController pushViewController:gameRoundsCtrl animated:YES];
    }else if (btn.tag == 102){
        JGCostSetViewController *costSetCtrl = [[JGCostSetViewController alloc]init];
        costSetCtrl.delegate = self;
        if (self.costListArray.count > 0) {
            costSetCtrl.costListArray = _costListArray;
            costSetCtrl.isEditor = 1;
        }
        
        [self.navigationController pushViewController:costSetCtrl animated:YES];
    }else{
        JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
        
        concentTextCtrl.itemText = @"内容";
        concentTextCtrl.delegate = self;
        concentTextCtrl.contentTextString = _model.info;
        
        [self.navigationController pushViewController:concentTextCtrl animated:YES];
    }
}

#pragma mark --保存代理
- (void)SaveBtnClick:(UIButton *)btn{
    [self pushAndSaveEvent:btn andCatory:0];
}

#pragma mark --提交代理
- (void)SubmitBtnClick:(UIButton *)btn{
    [self pushAndSaveEvent:btn andCatory:1];
}
- (void)pushAndSaveEvent:(UIButton *)btn andCatory:(NSInteger)catory{
    [self.view endEditing:YES];
    if (self.model.info == nil) {
        [[ShowHUD showHUD]showToastWithText:@"活动说明不能为空！" FromView:self.view];
        return;
    }
    
    if (self.costListArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请填写活动资费！" FromView:self.view];
        return;
    }
    
//    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *matchDict = [NSMutableDictionary dictionary];
    [matchDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [matchDict setObject:_model.userName forKey:@"userName"];
    [matchDict setObject:_model.userMobile forKey:@"userMobile"];
    [matchDict setObject:_model.matchName forKey:@"matchName"];
    [matchDict setObject:_model.signUpEndTime forKey:@"signUpEndTime"];
    if (_model.beginDate.length == 16) {
        [matchDict setObject:[NSString stringWithFormat:@"%@:00", _model.beginDate] forKey:@"beginDate"];
    }else{
        [matchDict setObject:_model.beginDate forKey:@"beginDate"];
    }
    
    [matchDict setObject:_model.endDate forKey:@"endDate"];
    [matchDict setObject:_model.ballKey forKey:@"ballKey"];
    [matchDict setObject:_model.ballName forKey:@"ballName"];
    [matchDict setObject:_model.info forKey:@"info"];
    [matchDict setObject:@(_model.timeKey) forKey:@"timeKey"];
    [matchDict setObject:@(_selectLevel) forKey:@"openType"];
    
    NSDictionary *roundDict = self.rulesArray[0];
    [matchDict setObject:[roundDict objectForKey:@"name"] forKey:@"matchTypeName"];
    [matchDict setObject:[roundDict objectForKey:@"timeKey"] forKey:@"matchTypeKey"];
    //区分保存、发布
    if (catory == 0) {
        [matchDict setObject:@0 forKey:@"state"];
    }else{
        [matchDict setObject:@1 forKey:@"state"];
    }
    //过滤资费类型
    NSMutableArray *costArray = [NSMutableArray array];
    
    for (int i=0; i < _costListArray.count; i++) {
        NSDictionary *dict = _costListArray[i];
        NSString *costName = [dict objectForKey:@"costName"];
        if (![costName isEqualToString:@""]) {
            [costArray addObject:_costListArray[i]];
        }
    }
    
    [postDict setObject:matchDict forKey:@"match"];
    [postDict setObject:costArray forKey:@"costList"];
    [postDict setObject:_rulesArray forKey:@"ruleList"];
    //发布赛事
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"match/createMatch" JsonKey:nil withData:postDict failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
            [Helper alertViewWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
            
            return ;
        }
        
        if (self.model.bgImage) {
            NSMutableArray *imageArray = [NSMutableArray array];
            [imageArray addObject:UIImageJPEGRepresentation(self.model.bgImage, 0.7)];
            
//            NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
            // 上传图片
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:TYPE_MATCH_HEAD forKey:@"nType"];
            [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
            
            [dict setObject:[NSString stringWithFormat:@"%td", self.model.timeKey] forKey:@"data"];
            [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                NSLog(@"errType===%@", errType);
            } completionBlock:^(id data) {
                NSLog(@"data == %@", data);
                if ([[data objectForKey:@"code"] integerValue] == 1) {
                    [self popSeeussulCtrl];
                }else{
                    [[ShowHUD showHUD]showToastWithText:@"图片上传失败！" FromView:self.view];
                    [self performSelector:@selector(popCtrl) withObject:self afterDelay:TIMESlEEP];
                }
            }];
        }else{
            [self popSeeussulCtrl];
        }
    }];
}
- (void)popCtrl{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建成功提示
- (void)popSeeussulCtrl{
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"赛事成功!" preferredStyle:UIAlertControllerStyleAlert];
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
#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    [self.model setValue:text forKey:@"info"];
    //    [_dataDict setObject:text forKey:@"activityContext"];
    [self.launchActivityTableView reloadData];
}
#pragma mark -- 费用代理
- (void)costList:(NSMutableArray *)costArray{
    self.costListArray = costArray;
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
