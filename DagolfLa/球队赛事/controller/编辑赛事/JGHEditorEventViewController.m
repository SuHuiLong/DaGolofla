//
//  JGHEditorEventViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEditorEventViewController.h"
#import "JGHPublishEventModel.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGTableViewCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGHPublicLevelCell.h"
#import "JGHConcentTextViewController.h"
#import "JGCostSetViewController.h"
#import "JGHGameRoundsViewController.h"
#import "JGHEditorGameRoundsViewController.h"
#import "BallParkViewController.h"
#import "DateTimeViewController.h"

static CGFloat ImageHeight  = 210.0;
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGHPublicLevelCellIdentifier = @"JGHPublicLevelCell";

@interface JGHEditorEventViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHConcentTextViewControllerDelegate, JGCostSetViewControllerDelegate>

{
    NSArray *_titleArray;//标题数组
    NSInteger _photos;//跳转相册问题
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
    
    NSArray *_levelArray;//公开等级
    
    NSInteger _isEditor;//1-编辑；0-无
    //花都分
}

@property (nonatomic, strong)UITableView *editorEventTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIButton *applyBtn;

@end

@implementation JGHEditorEventViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    if (_model.matchName != nil) {
        self.titleField.text = _model.matchName;
    }
    
    if (_isEditor == 1) {
        self.applyBtn.backgroundColor = [UIColor colorWithHexString:@"#F59A2C"];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {        
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        
        UIImage *image = [UIImage imageNamed:ActivityBGImage];
        self.model.bgImage = image;
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.editorEventTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        [self.view addSubview:self.editorEventTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 10 *ProportionAdapter, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        
        [self.imgProfile addSubview:self.titleView];
        
        UINib *contactNib = [UINib nibWithNibName:@"JGHTeamContactTableViewCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:contactNib forCellReuseIdentifier:JGHTeamContactCellIdentifier];
        
        UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
        
        UINib *teamActivityDetailsCellNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:teamActivityDetailsCellNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];
        
        UINib *publicLevelCellNib = [UINib nibWithNibName:@"JGHPublicLevelCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:publicLevelCellNib forCellReuseIdentifier:JGHPublicLevelCellIdentifier];

        self.editorEventTableView.dataSource = self;
        self.editorEventTableView.delegate = self;
        self.editorEventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.editorEventTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [replaceBtn addTarget:self action:@selector(selectPhotoImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.placeholder = @"请输入赛事名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@"", @[@"开球时间", @"报名截止时间", @"活动结束时间", @"举办场地"], @[@"玩法设置"], @[@"主办方", @"联系人电话"], @[@"比赛轮次设置", @"费用设置"], @[@"对所有人公开"], @[@"赛事说明"]];
    
    _levelArray = @[@"对所有人公开", @"仅对参与球队公开", @"仅对参与及被邀请方公开"];
    
    [self createEditorBtn];
}
- (void)configJGHPublishEventModelReloadTable:(JGHPublishEventModel *)model andCostlistArray:(NSMutableArray *)costListArray{
    _model = model;
    self.costListArray = costListArray;
    [self.editorEventTableView reloadData];
}
#pragma mark -- 保存按钮
- (void)createEditorBtn{
    self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake( 0, screenHeight-44, screenWidth, 44)];
    [self.applyBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor lightGrayColor];
    self.applyBtn.enabled = NO;
    [self.applyBtn addTarget:self action:@selector(editonAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.applyBtn];
}
#pragma mark -- 发布赛事
- (void)editonAttendBtnClick:(UIButton *)btn{
    
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = self.editorEventTableView.contentOffset.y;
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
    }else if (section == 4){
        return 2;
    }else if (section == 5){
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight -10;
    }else if (indexPath.section == 6){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.editorEventTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }else{
        return 44 *ProportionAdapter;
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
    }else if (indexPath.section == 1){
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 3) {
            launchActivityCell.underline.hidden = YES;
        }else{
            launchActivityCell.underline.hidden = NO;
        }
        
        [launchActivityCell configTitlesString:_titleArray[indexPath.section][indexPath.row]];
        return launchActivityCell;
    }else if (indexPath.section == 2){
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchActivityCell.underline.hidden = YES;
        [launchActivityCell configTitlesString:_titleArray[indexPath.section][indexPath.row]];
        return launchActivityCell;
    }else if (indexPath.section == 3){
        JGHTeamContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamContactCellIdentifier];
        
        if (indexPath.row == 0) {
            contactCell.contactLabel.text = _titleArray[indexPath.section][indexPath.row];
            contactCell.tetfileView.placeholder = @"请输入主办方名称";
            contactCell.tetfileView.tag = 123;
            if (self.model.userName != nil) {
                contactCell.tetfileView.text = self.model.userName;
            }
        }else{
            contactCell.contactLabel.text = _titleArray[indexPath.section][indexPath.row];
            contactCell.tetfileView.keyboardType = UIKeyboardTypeDefault;
            contactCell.tetfileView.placeholder = @"请输入联系人电话";
            if (self.model.userMobile != nil) {
                contactCell.tetfileView.text = self.model.userMobile;
            }
            
            contactCell.tetfileView.tag = 23;
        }
        
        contactCell.tetfileView.delegate = self;
        [contactCell configConstraint];
        return contactCell;
    }else if (indexPath.section == 4){
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchActivityCell.underline.hidden = YES;
        
        [launchActivityCell configTitlesString:_titleArray[indexPath.section][indexPath.row]];
        return launchActivityCell;
    }else if (indexPath.section == 5){
        JGHPublicLevelCell *publicCell = [tableView dequeueReusableCellWithIdentifier:JGHPublicLevelCellIdentifier];
        publicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [publicCell configEditorLevelCell:_levelArray[indexPath.row] andSelect:(indexPath.row == _model.openType)?1:0];
        return publicCell;
    }else{
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return detailsCell;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            JGHDatePicksViewController *datePicksCrel = [[JGHDatePicksViewController alloc]init];
            datePicksCrel.returnDateString = ^(NSString *dateString){
                NSLog(@"%@", dateString);
                [self.model setValue:dateString forKey:@"beginDate"];
                [self setEditorBtn];
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.editorEventTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:datePicksCrel animated:YES];
        }else if (indexPath.row == 1){
            DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
            [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                if(indexPath.row == 1){
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"endDate"];
                }else{
                    [self.model setValue:[NSString stringWithFormat:@"%@ 23:59:59", dateStr] forKey:@"signUpEndTime"];
                }
                
                [self setEditorBtn];
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.editorEventTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:dataCtrl animated:YES];
        }else {
            //球场列表
            BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
            [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
                NSLog(@"%@----%ld", balltitle, (long)ballid);
                self.model.ballKey = [NSNumber numberWithInteger:ballid];
                self.model.ballName = balltitle;
                [self setEditorBtn];
                NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                [self.editorEventTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [self.navigationController pushViewController:ballCtrl animated:YES];
        }
        
    }else if (indexPath.section == 2){
        [[ShowHUD showHUD]showToastWithText:@"玩法规则不允许编辑！" FromView:self.view];
        return;
    }else if (indexPath.section == 3){
        
    }else if (indexPath.section == 4){
        if (indexPath.row == 1) {
            JGCostSetViewController *costSetCtrl = [[JGCostSetViewController alloc]init];
            costSetCtrl.delegate = self;
            if (self.costListArray.count > 0) {
                costSetCtrl.costListArray = _costListArray;
                costSetCtrl.isEditor = 1;
            }
            
            [self.navigationController pushViewController:costSetCtrl animated:YES];
        }else{
            JGHEditorGameRoundsViewController *gameRoundsCtrl = [[JGHEditorGameRoundsViewController alloc]init];
            gameRoundsCtrl.timeKey = _model.timeKey;
            gameRoundsCtrl.matchTypeKey = _model.matchTypeKey;
            [self.navigationController pushViewController:gameRoundsCtrl animated:YES];
        }
    }else if (indexPath.section == 5){
        _model.openType = indexPath.row;
        [self.editorEventTableView reloadData];
    }else{
        JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
        
        concentTextCtrl.itemText = @"内容";
        concentTextCtrl.delegate = self;
        concentTextCtrl.contentTextString = _model.info;
        
        [self.navigationController pushViewController:concentTextCtrl animated:YES];
    }
}
#pragma mark --添加赛事背景
-(void)selectPhotoImage:(UIButton *)btn{
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
                [self setEditorBtn];
                [self.editorEventTableView reloadData];
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
                [self setEditorBtn];
                [self.editorEventTableView reloadData];
            }
        }];
    }];
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 更改编辑按钮
- (void)setEditorBtn{
    _isEditor = 1;
    self.applyBtn.enabled = YES;
    self.applyBtn.backgroundColor = [UIColor colorWithHexString:@"#F59A2C"];
}
#pragma mark -- 费用代理
- (void)costList:(NSMutableArray *)costArray{
    _isEditor = 1;
    self.costListArray = costArray;
}
#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    [self.model setValue:text forKey:@"info"];
    //    [_dataDict setObject:text forKey:@"activityContext"];
    [self.editorEventTableView reloadData];
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setEditorBtn];
    if (textField.tag == 23) {
        self.model.userMobile = textField.text;
    }else if (textField.tag == 123){
        self.model.userName = textField.text;
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
