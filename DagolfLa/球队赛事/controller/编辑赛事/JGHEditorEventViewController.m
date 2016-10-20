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

static CGFloat ImageHeight  = 210.0;
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";

@interface JGHEditorEventViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSArray *_titleArray;//标题数组
    NSInteger _photos;//跳转相册问题
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
}

@property (nonatomic, strong)UITableView *editorEventTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@property (nonatomic, strong)UIImage *headerImage;

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIButton *applyBtn;

@end

@implementation JGHEditorEventViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
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
        self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        
        [self.imgProfile addSubview:self.titleView];
        
        UINib *contactNib = [UINib nibWithNibName:@"JGHTeamContactTableViewCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:contactNib forCellReuseIdentifier:JGHTeamContactCellIdentifier];
        
        UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
        
        UINib *teamActivityDetailsCellNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle: [NSBundle mainBundle]];
        [self.editorEventTableView registerNib:teamActivityDetailsCellNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];

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
//    if (self.costListArray == nil) {
//        self.costListArray = [NSMutableArray array];
//    }
    
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
    self.titleField.placeholder = @"请输入赛事名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@"", @"基本信息", @"参赛费用", @"球队比杆排位赛", @"查看报名及分组", @"查看成绩", @"对所有人公开", @"主办方", @"赛事联系人电话", @"赛事说明"];
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
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0, title.size.width, title.size.height);
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset;
        self.titleView.frame = t;
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
    return 7;
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
            //contactCell.contactLabel.text = @"联系人电话";
            contactCell.contactLabel.text = _titleArray[indexPath.row];
            contactCell.tetfileView.placeholder = @"请输入联系人姓名";
            contactCell.tetfileView.tag = 123;
//            if (self.model.name != nil) {
//                contactCell.tetfileView.text = self.model.userMobile;
//            }
        }else{
            //contactCell.contactLabel.text = @"联系人";
            contactCell.contactLabel.text = _titleArray[indexPath.row];
            contactCell.tetfileView.keyboardType = UIKeyboardTypeDefault;
            contactCell.tetfileView.placeholder = @"请输入主办方名称";
//            if (self.model.name != nil) {
//                contactCell.tetfileView.text = self.model.userName;
//            }
            
            contactCell.tetfileView.tag = 23;
        }
        
//        contactCell.tetfileView.delegate = self;
        [contactCell configConstraint];
        return contactCell;
    }else if (indexPath.section == 4){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
//        UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, detailsCell.frame.size.height)];
//        [detailsBtn addTarget:self action:@selector(pushDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
//        [detailsCell addSubview:detailsBtn];
//        detailsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return detailsCell;
    }else{
        
        JGTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        NSArray *str = _titleArray[indexPath.section];
//        if (indexPath.row == [str count]-1) {
//            launchActivityCell.underline.hidden = YES;
//        }else{
//            launchActivityCell.underline.hidden = NO;
//        }
//        
//        [launchActivityCell configTitlesString:str[indexPath.row]];
//        
//        if (indexPath.section == 2) {
//            if (indexPath.row == 0) {
//                //                    [launchActivityCell configActivityCost:_costListArray];
//            }else{
//                [launchActivityCell configActivityInfo:_model.info];
//            }
//        }else{
//            [launchActivityCell configContionsStringWhitModel:self.model andIndexPath:indexPath];
//        }
        
        return launchActivityCell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
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
