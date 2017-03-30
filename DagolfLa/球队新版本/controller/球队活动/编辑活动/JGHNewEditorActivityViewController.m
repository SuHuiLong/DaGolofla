//
//  JGHNewEditorActivityViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewEditorActivityViewController.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "SXPickPhoto.h"
#import "BallParkViewController.h"
#import "JGHDatePicksViewController.h"
#import "JGHNewActivityImageCell.h"
#import "JGHNewActivityExplainCell.h"
#import "JGHNewActivityTextCell.h"
#import "JGHNewActivitySpaceCell.h"
#import "JGHNewActivityImageAndTitleCell.h"
#import "JGHNewActivityTextAndTextCell.h"
#import "JGHActivityScoreManagerViewController.h"
#import "JGLActivityMemberSetViewController.h"
#import "JGHNewEditorSaveBtnCell.h"
#import "JGHEditorCostViewController.h"
#import "JGLPresentAwardViewController.h"

static NSString *const JGHNewEditorSaveBtnCellIdentifier = @"JGHNewEditorSaveBtnCell";
static NSString *const JGHNewActivityTextAndTextCellIdentifier = @"JGHNewActivityTextAndTextCell";
static NSString *const JGHNewActivityImageAndTitleCellIdentifier = @"JGHNewActivityImageAndTitleCell";
static NSString *const JGHNewActivitySpaceCellIdentifier = @"JGHNewActivitySpaceCell";
static NSString *const JGHNewActivityTextCellIdentifier = @"JGHNewActivityTextCell";
static NSString *const JGHNewActivityExplainCellIdentifier = @"JGHNewActivityExplainCell";
static NSString *const JGHNewActivityImageCellIdentifier = @"JGHNewActivityImageCell";

static CGFloat ImageHeight  = 210.0;

@interface JGHNewEditorActivityViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate,UITextFieldDelegate, JGHNewEditorSaveBtnCellDelegate, JGLActivityMemberSetViewControllerDelegate>
{
    NSArray *_titleArray;//标题数组
    NSArray *_imageArray;//图片数组
    //NSInteger _photos;//跳转相册问题
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
    
    BOOL _isEditor;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像


@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@end

@implementation JGHNewEditorActivityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //if (_photos == 1) {
    self.navigationController.navigationBarHidden = NO;
    //}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pickPhoto = [[SXPickPhoto alloc]init];
    self.titleView = [[UIView alloc]init];
    _costListArray = [NSMutableArray array];
    
    _isEditor = NO;
    
    UIImage *image = [UIImage imageNamed:ActivityBGImage];
    self.model.bgImage = image;
    self.imgProfile = [[UIImageView alloc] initWithImage:image];
    self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight *ProportionAdapter);
    self.imgProfile.userInteractionEnabled = YES;
    self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    self.imgProfile.layer.masksToBounds = YES;
    
    //渐变图
    _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight *ProportionAdapter)];
    [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.imgProfile addSubview:_gradientImage];
    
    [self.view addSubview:self.launchActivityTableView];
    [self.view addSubview:self.imgProfile];
    self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    
    
    [self.imgProfile addSubview:self.titleView];
    
    [self.launchActivityTableView registerClass:[JGHNewActivityTextCell class] forCellReuseIdentifier:JGHNewActivityTextCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewActivityExplainCell class] forCellReuseIdentifier:JGHNewActivityExplainCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewActivityImageCell class] forCellReuseIdentifier:JGHNewActivityImageCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewActivitySpaceCell class] forCellReuseIdentifier:JGHNewActivitySpaceCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewActivityImageAndTitleCell class] forCellReuseIdentifier:JGHNewActivityImageAndTitleCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewEditorSaveBtnCell class] forCellReuseIdentifier:JGHNewEditorSaveBtnCellIdentifier];
    
    [self.launchActivityTableView registerClass:[JGHNewActivityTextAndTextCell class] forCellReuseIdentifier:JGHNewActivityTextAndTextCellIdentifier];
    
    self.launchActivityTableView.dataSource = self;
    self.launchActivityTableView.delegate = self;
    self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.launchActivityTableView.tableFooterView = footView;
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20 *ProportionAdapter, 44*ProportionAdapter, 44*ProportionAdapter);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn bringSubviewToFront:self.imgProfile];
    [self.titleView addSubview:btn];
    //点击更换背景
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-78 *ProportionAdapter, 30*ProportionAdapter, 66*ProportionAdapter, 26*ProportionAdapter);
    replaceBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    replaceBtn.tag = 520;
    replaceBtn.layer.cornerRadius = 4.0*ProportionAdapter;
    replaceBtn.layer.masksToBounds = YES;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 135*ProportionAdapter, 65*ProportionAdapter, 65*ProportionAdapter)];
    self.headPortraitBtn.layer.cornerRadius = 8.0*ProportionAdapter;
    self.headPortraitBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headPortraitBtn.clipsToBounds = YES;
    [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.headPortraitBtn bringSubviewToFront:self.imgProfile];
    
    if (_model.teamActivityKey == 0) {
        //我的球队活动
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    }else{
        //球队活动
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    }
    
    //地址
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(85*ProportionAdapter, 180*ProportionAdapter, 70*ProportionAdapter, 25*ProportionAdapter)];
    [self.addressBtn setTitle:@"球队名称" forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.addressBtn bringSubviewToFront:self.imgProfile];
    [self.imgProfile addSubview:self.addressBtn];
    
    _titleArray = @[@[], @[@"", @"活动名称", @"活动场地", @"开球时间", @"报名截止", @"结束时间"], @[@"", @"活动成员及分组管理", @"成绩管理"], @[@"", @"费用设置", @"人数限制", @"活动奖项", @"活动说明", @""], @[@"", @"联系人资料"]];
    _imageArray = @[@[], @[@"", @"icn_eventname", @"icn_address", @"icn_time", @"icn_registration", @"icn_deadline"], @[@"", @"icn_event_group", @"icn_event_score"], @[@"", @"icn_preferential", @"icn_scale", @"icn_awards", @"icn_event_details", @""], @[@"", @"icn_detail", @"", @"", @""]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self dataSet];
    });
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else if (btn.tag == 520){
        //更换背景
        [self SelectPhotoImage:btn];
    }
}
#pragma mark -- 提示信息
- (void)alertviewString:(NSString *)string{
    [Helper alertViewNoHaveCancleWithTitle:string withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
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
        return 6;
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 6;
    }else {
        return 5;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight *ProportionAdapter;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 10*ProportionAdapter;
        }else{
            return 45*ProportionAdapter;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 10*ProportionAdapter;
        }else{
            return 45*ProportionAdapter;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 10*ProportionAdapter;
        }else if (indexPath.row == 5){
            if (_model.info.length >0) {
                CGFloat height;
                height = [Helper textHeightFromTextString:_model.info width:screenWidth -50*ProportionAdapter fontSize:15*ProportionAdapter];
                if (0< height && height < 20*ProportionAdapter) {
                    return 25*ProportionAdapter;
                }else{
                    return 40*ProportionAdapter;
                }
            }else{
                return 0;
            }
        }else{
            return 45*ProportionAdapter;
        }
    }else {
        if (indexPath.row == 0) {
            return 10*ProportionAdapter;
        }else if (indexPath.row == 3){
            return 33*ProportionAdapter;
        }else{
            return 45*ProportionAdapter;
        }
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
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            JGHNewActivitySpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivitySpaceCellIdentifier];
            spaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return spaceCell;
        }else if (indexPath.row == 1){
            JGHNewActivityTextCell *imageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityTextCellIdentifier];
            imageCell.contentText.delegate = self;
            imageCell.contentText.tag = 345;
            [imageCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row] andContent:_model.name];
            imageCell.contentText.placeholder = @"请输入活动名称";
            imageCell.contentText.delegate = self;
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;
        }else{
            JGHNewActivityImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityImageCellIdentifier];
            NSString *cellString = nil;
            
            if (indexPath.row == 2) {
                cellString = _model.ballName;
            }else if (indexPath.row == 3){
                if (_model.beginDate.length >16) {
                    cellString = [_model.beginDate substringToIndex:16];
                }else{
                    cellString = _model.beginDate;
                }
            }else if (indexPath.row == 4){
                cellString = [[_model.signUpEndTime componentsSeparatedByString:@" "]firstObject];
            }else {
                cellString = [[_model.endDate componentsSeparatedByString:@" "] firstObject];
            }
            
            [imageCell configJGHNewActivityImageCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row] andContent:cellString];
            
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            JGHNewActivitySpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivitySpaceCellIdentifier];
            spaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return spaceCell;
        }else{
            JGHNewActivityImageAndTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityImageAndTitleCellIdentifier];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                NSString *group = nil;
                if (_model.maxCount > 0) {
                    group = _titleArray[indexPath.section][indexPath.row];
                    group = [NSString stringWithFormat:@"活动成员及分组(%td/%td)", self.model.sumCount,_model.maxCount];
                    
                    [titleCell configJGHNewActivityTextCellTitle:group andImageName:_imageArray[indexPath.section][indexPath.row]];
                }else{
                    [titleCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row]];
                }
            }else{
                [titleCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row]];
            }
            
            return titleCell;
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            JGHNewActivitySpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivitySpaceCellIdentifier];
            spaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return spaceCell;
        }else if (indexPath.row == 2){
            JGHNewActivityTextCell *imageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityTextCellIdentifier];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [imageCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row] andContent:[NSString stringWithFormat:@"%@", (_model.maxCount >0)?[NSString stringWithFormat:@"%td", _model.maxCount]:@""]];
            imageCell.contentText.placeholder = @"请输入限制人数";
            imageCell.contentText.tag = 234;
            imageCell.contentText.delegate = self;
            return imageCell;
        }else if (indexPath.row == 5){
            JGHNewActivityExplainCell *imageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityExplainCellIdentifier];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [imageCell configJGHNewActivityExplainCellContent:_model.info];
            imageCell.contentLable.numberOfLines = 2;
            return imageCell;
        }else{
            JGHNewActivityImageAndTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityImageAndTitleCellIdentifier];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [titleCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row]];
            
            if (indexPath.row == 4) {
                titleCell.line.hidden = YES;
            }else{
                titleCell.line.hidden = NO;
            }
            
            return titleCell;
        }
    }else{
        if (indexPath.row == 0 || indexPath.row == 3) {
            JGHNewActivitySpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivitySpaceCellIdentifier];
            spaceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return spaceCell;
        }else if (indexPath.row == 1){
            JGHNewActivityImageAndTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityImageAndTitleCellIdentifier];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.direImageView.hidden = YES;
            [titleCell configJGHNewActivityTextCellTitle:_titleArray[indexPath.section][indexPath.row] andImageName:_imageArray[indexPath.section][indexPath.row]];
            
            return titleCell;
        }else if (indexPath.row == 2){
            JGHNewActivityTextAndTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityTextAndTextCellIdentifier];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [textCell configJGHNewActivityTextAndTextCellName:_model.userName andMobile:_model.userMobile];
            
            textCell.nameText.tag = 23;
            textCell.mobileText.tag = 123;
            textCell.nameText.delegate = self;
            textCell.mobileText.delegate = self;
            return textCell;
        }else{
            JGHNewEditorSaveBtnCell *saveCell = [tableView dequeueReusableCellWithIdentifier:JGHNewEditorSaveBtnCellIdentifier];
            saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
            saveCell.saveBtn.tag = 1000;
            saveCell.delegate = self;
            [saveCell configJGHNewEditorSaveBtnCell:_isEditor];
            
            return saveCell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            //活动球场
            BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
            [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
                NSLog(@"%@----%ld", balltitle, (long)ballid);
                _model.ballKey = *(&(ballid));
                _model.ballName = balltitle;
                
                [self reloadindexPath:indexPath];
            }];
            
            [self.navigationController pushViewController:ballCtrl animated:YES];
        }else if (indexPath.row == 3) {
            //开球时间
            JGHDatePicksViewController *datePicksCrel = [[JGHDatePicksViewController alloc]init];
            datePicksCrel.returnDateString = ^(NSString *dateString){
                NSLog(@"%@", dateString);
                _model.beginDate = dateString;
                
                [self reloadindexPath:indexPath];
            };
            [self.navigationController pushViewController:datePicksCrel animated:YES];
        }else if (indexPath.row >3){
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                if(indexPath.row == 5){
                    [_model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"endDate"];
                }else{
                    [_model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"signUpEndTime"];
                }
                
                [self reloadindexPath:indexPath];
            }];
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            JGLActivityMemberSetViewController *activityMemberCtrl = [[JGLActivityMemberSetViewController alloc]init];
            activityMemberCtrl.delegate = self;
            
            if (_model.teamActivityKey != 0) {
                activityMemberCtrl.activityKey = [NSNumber numberWithInteger:_model.teamActivityKey];
            }else{
                activityMemberCtrl.activityKey = [NSNumber numberWithInteger:[_model.timeKey integerValue]];
            }
            
            activityMemberCtrl.teamKey = [NSNumber numberWithInteger:_model.teamKey];
            [self.navigationController pushViewController:activityMemberCtrl animated:YES];
        }else if (indexPath.row == 2){
            JGHActivityScoreManagerViewController *activityScoreCtrl = [[JGHActivityScoreManagerViewController alloc]init];
            activityScoreCtrl.activityBaseModel = _model;
            [self.navigationController pushViewController:activityScoreCtrl animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 1) {
            JGHEditorCostViewController *costView = [[JGHEditorCostViewController alloc]initWithNibName:@"JGHEditorCostViewController" bundle:nil];
            if (_model.teamActivityKey != 0) {
                costView.activityKey = _model.teamActivityKey;
            }else{
                costView.activityKey = [_model.timeKey integerValue];
            }
            [self.navigationController pushViewController:costView animated:YES];
        }else if (indexPath.row == 4){
            JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
            
            concentTextCtrl.itemText = @"活动说明";
            concentTextCtrl.delegate = self;
            concentTextCtrl.isNull = 1;
            concentTextCtrl.contentTextString = _model.info;
            
            [self.navigationController pushViewController:concentTextCtrl animated:YES];
        }else if (indexPath.row == 3){
            //奖项设置
            JGLPresentAwardViewController *prizeCtrl = [[JGLPresentAwardViewController alloc]init];
            if (_model.teamActivityKey == 0) {
                prizeCtrl.activityKey = [_model.timeKey integerValue];
            }else{
                prizeCtrl.activityKey = _model.teamActivityKey;
            }
            
            prizeCtrl.teamKey = _model.teamKey;
            //prizeCtrl.isManager = 1;
            prizeCtrl.model = _model;
            [self.navigationController pushViewController:prizeCtrl animated:YES];
        }
    }
    
    //[self.launchActivityTableView reloadData];
}
#pragma mark -- 刷新区域
- (void)reloadindexPath:(NSIndexPath *)indexPath{
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [_launchActivityTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self reloadSaveBtn];
}
#pragma mark -- 刷新保存按钮 
- (void)reloadSaveBtn{
    _isEditor = YES;
    
    UIButton *btn = [self.view viewWithTag:1000];
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
    
    //NSIndexPath *savePath = [NSIndexPath indexPathForRow:4 inSection:4];
    //NSArray *indexSaveArray = [NSArray arrayWithObject:savePath];
    //[_launchActivityTableView reloadRowsAtIndexPaths:indexSaveArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 添加意向成员返回刷新数据
- (void)reloadActivityMemberData{
    [self dataSet];
}
#pragma mark -- 下载数据 －－－
- (void)dataSet{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    //self.teamActibityNameTableView.userInteractionEnabled = NO;
    
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
            
            self.costListArray = [data objectForKey:@"costList"];
            
            [_model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            _model.teamName = [data objectForKey:@"teamName"];
            
            [self.launchActivityTableView reloadData];
            
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13*ProportionAdapter]};
            CGSize size = [_model.teamName boundingRectWithSize:CGSizeMake(screenWidth - 100*ProportionAdapter, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            CGRect address = self.addressBtn.frame;
            self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25*ProportionAdapter);
            [self.addressBtn setTitle:_model.teamName forState:UIControlStateNormal];
        }else{
            
        }
    }];
    
    //self.teamActibityNameTableView.userInteractionEnabled = YES;
}
#pragma mark -- 保存
- (void)editonAttendBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];

    if (_model.name.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入活动名称" FromView:self.view];
        return;
    }
    
    if (self.model.ballName == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请选择活动场地" FromView:self.view];
        return;
    }
    
    if (self.model.beginDate == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请选择开始时间" FromView:self.view];
        return;
    }
    
    if (self.model.endDate == nil) {
        [[ShowHUD showHUD]showToastWithText:@"请选择结束时间" FromView:self.view];
        return;
    }
    
    if (self.model.userName == nil || _model.userName.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请填写联系人" FromView:self.view];
        return;
    }
    
    if (self.model.userMobile.length != 11) {
        [[ShowHUD showHUD]showToastWithText:@"请填写联系人电话" FromView:self.view];
        return;
    }
    
    [LQProgressHud showLoading:@"提交中..."];
    
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
    if (_model.info.length >0) {
        [dict setObject:_model.info forKey:@"info"];//活动简介
    }else{
        [dict setObject:@"" forKey:@"info"];//活动简介
    }
    
    if (_model.maxCount >0) {
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.maxCount] forKey:@"maxCount"];//最大人员数
    }else{
        [dict setObject:@0 forKey:@"maxCount"];//最大人员数
    }
    
    //[dict setObject:[NSString stringWithFormat:@"%ld", (long)_model.isClose] forKey:@"isClose"];//活动是否结束 0 : 开始 , 1 : 已结束
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    [dict setObject:currentTime forKey:@"createTime"];//活动创建时间
    [dict setObject:self.model.userName forKey:@"userName"];//联系人
    [dict setObject:self.model.userMobile forKey:@"userMobile"];//联系人
    
    //_isEditor = 0;
    //发布活动
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivity" JsonKey:@"teamActivity" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
            [Helper alertViewWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
            return ;
        }
        
        if (!_model.bgImage) {
            _refreshBlock();
        }
        
        if (_model.bgImage) {
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
                _refreshBlock();
                
                if ([[data objectForKey:@"code"] integerValue] == 1) {
                    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/activity/%@_background.jpg@400w_150h_2o", strTimeKey];
                    
                    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
                    
                    NSString *bggUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/activity/%@_background.jpg", strTimeKey];
                    
                    [[SDImageCache sharedImageCache] removeImageForKey:bggUrl fromDisk:YES withCompletion:nil];
                    
                    //获取主线层
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [LQProgressHud showMessage:@"活动更新成功!"];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }
            }];
        }else{
            [LQProgressHud showMessage:@"活动更新成功!"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
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
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                    self.model.bgImage = _headerImage;
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
                _headerImage = (UIImage *)Data;
                //设置背景
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                    self.model.bgImage = _headerImage;
                }
            }
        }];
    }];
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    [_model setValue:text forKey:@"info"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:3];
    [self reloadindexPath:indexPath];
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
    
    [self reloadSaveBtn];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.tag == 123 || textField.tag == 234) {
        NSCharacterSet *cs;
        if(textField)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if(!basicTest)
            {
                [[ShowHUD showHUD]showToastWithText:@"请输入数字" FromView:self.view];
                return NO;
            }
        }
        //其他的类型不需要检测，直接写入
        return YES;
    }else{
        return YES;
    }
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight*ProportionAdapter)*screenWidth)/(ImageHeight*ProportionAdapter);
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight*ProportionAdapter+ABS(yOffset));
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
        t.origin.y = yOffset;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.headPortraitBtn.hidden = NO;
            self.addressBtn.hidden = NO;
        }
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
