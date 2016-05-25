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
#import "JGHTeamActivityImageCell.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGHLaunchActivityModel.h"
#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"
#import "JGPreviewTeamViewController.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGNewCreateTeamTableViewController ()<UITableViewDelegate, UITableViewDataSource, JGHTeamActivityImageCellDelegate, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate,JGHTeamContactTableViewCellDelegate, JGCostSetViewControllerDelegate,JGHConcentTextViewControllerDelegate>
{

    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;

@property (nonatomic, strong)JGHLaunchActivityModel *model;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)NSMutableDictionary *paraDic; //参数字典

@end

@implementation JGNewCreateTeamTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.titleField.text = self.detailModel.name;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGHLaunchActivityModel alloc]init];
        self.dataDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg"];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44) style:(UITableViewStylePlain)];
        [self.launchActivityTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        [self.launchActivityTableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"lbVSTF"];

        

        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 20, screenWidth, 44);
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
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换
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
//    self.titleField.textColor = [UIColor whiteColor];
//    self.titleField.font = [UIFont systemFontOfSize:15];
    self.titleField.placeholder = @"请输入球队名";
        [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 50, 50)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:@"relogo"] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    
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
- (void)replaceWithPicture:(UIButton *)Btn{
    if (Btn.tag == 333) {
        //球场列表
        
    }
    [self didSelectPhotoImage:Btn];
}

- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //更换头像
        [self didSelectPhotoImage:btn];
    }
}
#pragma mark -- 预览按钮
- (void)createPreviewBtn{
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight -44, screenWidth, 44)];
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
}
#pragma mark -- 预览界面
- (void)previewBtnClick:(UIButton *)btn{
    
    
    [self.paraDic setObject:self.titleField.text forKey:@"name"];
    
    
    
    

    
    
//    for (NSInteger i = 0; i < 2; i ++) {
//        UITextField *tF = [self.creatTeamV viewWithTag:233 + i];
//        if (tF.tag == 233) {
//            [self.paraDic setObject:tF.text forKey:@"userName"];
//        }else if (tF.tag == 234){
//            [self.paraDic setObject:tF.text forKey:@"userMobile"];
//        }else{
//        }    }
//    
//    
//    
//    [self.paraDic setObject:@0 forKey:@"timeKey"];
//    
//    [self.paraDic setObject:self.creatTeamV.teamNmaeTV.text forKey:@"name"];
//    
//    [self.paraDic setObject:@"iOS" forKey:@"createUserName"];
//    
//    [self.paraDic setObject:@"AAA" forKey:@"notice"];
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    [self.paraDic setObject:[user objectForKey:@"userId"] forKey:@"createUserKey"];
//    
//    self.teamDetailModel.check = 0;

    
    
    JGPreviewTeamViewController *preVC = [[JGPreviewTeamViewController alloc] init];
    [self.navigationController pushViewController:preVC animated:YES];
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
//    [dic setObject:@(self.detailModel.timeKey) forKey:@"teamKey"];
//    [dic setObject:@0 forKey:@"state"];
//    [dic setObject:@"2016-12-11 10:00:00" forKey:@"createTime"];
//    [dic setObject:@0 forKey:@"timeKey"];
//    
//    [[JsonHttp jsonHttp] httpRequest:@"team/reqJoinTeam" JsonKey:@"teamMemeber" withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
//        NSLog(@"error *** %@", errType);
//    } completionBlock:^(id data) {
//        NSLog(@"%@", data);
//    }];
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
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 20, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 20;
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
    }else if (section == 2){
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight -10;
    }else if (indexPath.section == 3){
        return [self calculationLabelHeight:self.detailModel.info] + 40 * screenWidth / 320;
        
    }else{
        return 44;
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 320 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
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
    }else if (indexPath.section == 2){
        JGDisplayInfoTableViewCell *contactCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"Display"];
        contactCell.promptLB.text = @"球队简介";
        contactCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contactCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
        contactCell.contentLB.text = self.detailModel.info;
        contactCell.contentLB.frame = CGRectMake(10, 35  * screenWidth / 320, screenWidth - 20  * screenWidth / 320, [self calculationLabelHeight:self.detailModel.info]);
        return contactCell;
    }else if (indexPath.section == 1){
        
        JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"lbVSlb"];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            launchActivityCell.promptLB.text = @"成立日期";
        }else{
            launchActivityCell.promptLB.text = @"所在地区";
        }
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return launchActivityCell;
    }else{
        JGApplyMaterialTableViewCell *launchActivityCell = [self.launchActivityTableView dequeueReusableCellWithIdentifier:@"lbVSTF"];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            launchActivityCell.labell.text = @"真实姓名";
            launchActivityCell.textFD.placeholder = @"请输入真实姓名";
        }else{
            launchActivityCell.labell.text = @"联系方式";
            launchActivityCell.textFD.placeholder = @"请输入手机号";
        }
        return launchActivityCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    //时间选择
                    DateTimeViewController *dataCtrl = [[DateTimeViewController alloc]init];
                    [dataCtrl setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                        if (indexPath.row == 0) {
                            [self.model setValue:dateStr forKey:@"startDate"];
                        }else{
                            [self.model setValue:dateStr forKey:@"endDate"];
                        }
                        
                        JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                        launchActivityCell.contentLB.text = dateStr;
//                        NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//                        [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];

                    [self.navigationController pushViewController:dataCtrl animated:YES];
                }else{
                    //地区选择
                    TeamAreaViewController* areaVc = [[TeamAreaViewController alloc]init];
                    areaVc.teamType = @10;
                    areaVc.callBackCity = ^(NSString* strPro, NSString* strCity, NSNumber* cityId){
//                        [self.model setValue:[NSString stringWithFormat:@"%@-%@", strPro, strCity] forKey:@"activityAddress"];
                        JGLableAndLableTableViewCell *launchActivityCell = [self.launchActivityTableView cellForRowAtIndexPath:indexPath];
                        launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%@ %@", strPro, strCity];
//                        NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//                        [self.launchActivityTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [self.navigationController pushViewController:areaVc animated:YES];
                }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            JGHConcentTextViewController *introVC = [[JGHConcentTextViewController alloc] init];
            introVC.delegate = self;
            [self.navigationController pushViewController:introVC animated:YES];
        }
        
        /**
         JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
         
         concentTextCtrl.itemText = @"内容";
         concentTextCtrl.delegate = self;
         concentTextCtrl.contentTextString = _model.activityInfo;
         [self.navigationController pushViewController:concentTextCtrl animated:YES];
         */
    }
    
//    [self.launchActivityTableView reloadData];
}

#pragma mark -- 添加内容详情代理  JGHConcentTextViewControllerDelegate
- (void)didSelectSaveBtnClick:(NSString *)text{
    NSLog(@"%@", text);
//    [self.paraDic setObject:text forKey:@"info"];
    
}
#pragma mark --添加活动头像－－JGHTeamActivityImageCellDelegate
-(void)didSelectPhotoImage:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
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
                // @{@"nType":@"1", @"tag":@"dagolfla", @"data":@"test"};
                _headerImage = (UIImage *)Data;
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"11010" forKey:@"data"];
                [dict setObject:@"1" forKey:@"nType"];
                [dict setObject:@"team" forKey:@"tag"];
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObject:UIImageJPEGRepresentation(_headerImage, 0.7)];
                
                [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {
                    NSLog(@"errType===%@", errType);
                } completionBlock:^(id data) {
                    NSLog(@"data===%@", data);
                }];
            }
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

//- (void)didSelectSaveBtnClick:(NSString *)text{
//    [self.model setValue:text forKey:@"activityInfo"];
//    [self.launchActivityTableView reloadData];
//}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
}

#pragma mark -- 联系人代理
- (void)inputTextString:(NSString *)string{
    _contcat = string;
}
#pragma mark -- 费用代理
- (void)inputMembersCost:(NSString *)membersCost guestCost:(NSString *)guestCost{
    self.model.guestCost = guestCost;
    self.model.membersCost = membersCost;
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

