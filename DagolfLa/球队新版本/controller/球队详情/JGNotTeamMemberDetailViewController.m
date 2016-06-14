//
//  JGNotTeamMemberDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGNotTeamMemberDetailViewController.h"
#import "JGTeamCreatePhotoController.h" //相册
#import "JGTeamActivityViewController.h" //活动
#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGImageAndLabelAndLabelTableViewCell.h"
#import "ChatDetailViewController.h"
#import "JGTeamDeatilWKwebViewController.h"

#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"
#import "JGApplyMaterialViewController.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGNotTeamMemberDetailViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate>
{
  
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@end

@implementation JGNotTeamMemberDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.titleField.text = [self.detailDic objectForKey:@"name"];
    
    NSString *head = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@.jpg@100w_100h", [self.detailDic objectForKey:@"timeKey"]];
    NSString *headUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@.jpg@120w_120h", [self.detailDic objectForKey:@"timeKey"]];
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@_background.jpg", [self.detailDic objectForKey:@"timeKey"]];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    [[SDImageCache sharedImageCache] removeImageForKey:head fromDisk:YES];
    [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
    
    // 球队头像
    [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.userInteractionEnabled = NO;

    // 球队背景图片
    [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:TeamBGImage]];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    

    
}

- (instancetype)init{
    if (self == [super init]) {
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
        [self.launchActivityTableView registerClass:[JGImageAndLabelAndLabelTableViewCell class] forCellReuseIdentifier:@"iamgeVCell"];

        
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
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
    [gradientImage setImage:[UIImage imageNamed:@"tableHeaderBGImage"]];
    [self.titleView addSubview:gradientImage];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64, 0, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"详情" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(64, 17, screenWidth - 128, 30)];
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.font = [UIFont systemFontOfSize:18 * screenWidth / 320];

    self.titleField.textAlignment = NSTextAlignmentCenter;
//    self.titleField.font = [UIFont systemFontOfSize:15];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 50, 50)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:@"relogo"] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    

    
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
        // 球队详情
        JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
        
        
        
        wkVC.detailString = [self.detailDic objectForKey:@"details"];
        wkVC.teamName = [self.detailDic objectForKey:@"name"];
        [self.navigationController pushViewController:wkVC animated:YES];
//        [self didSelectPhotoImage:btn];
    }
}

#pragma mark -- 预览
- (void)createPreviewBtn{
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(41 * screenWidth / 320, screenHeight -44, screenWidth - 40, 44)];
    [previewBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
    
    UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight -44, 40 * screenWidth / 320, 44)];
    [askBtn setTitle:@"咨询" forState:UIControlStateNormal];
    askBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [askBtn addTarget:self action:@selector(askBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askBtn];
    
}
#pragma mark -- 申请加入
- (void)previewBtnClick:(UIButton *)btn{

    JGApplyMaterialViewController *applyVC = [[JGApplyMaterialViewController alloc] init];
    applyVC.teamKey = [[self.detailDic objectForKey:@"timeKey"] integerValue];
    [self.navigationController pushViewController:applyVC animated:YES];

}

#pragma mark -- 咨询
- (void)askBtnClick:(UIButton *)btn{
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = [NSString stringWithFormat:@"%@",[self.detailDic objectForKey:@"answerKey"]];
    //设置对方的名字
    //    vc.userName = model.conversationTitle;
    //设置聊天标题
    vc.title = [self.detailDic objectForKey:@"answerName"];
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];
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
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight -10;
    }else if (indexPath.section == 3){
//        return [self calculationLabelHeight:[self.detailDic objectForKey:@"info"]] + 40 * screenWidth / 320;
        return 40 * screenWidth / 320;
    }else{
        return 40 * screenWidth / 320;
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
    return 10;
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
        
        JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"iamgeVCell" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchActivityCell.promptLB.text = @"球队简介";
        launchActivityCell.imageV.image = [UIImage imageNamed:@"qdjj"];
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return launchActivityCell;
        
//        JGDisplayInfoTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"Display"];
//        contactCell.promptLB.text = @"球队简介";
//        contactCell.promptLB.frame = CGRectMake(10 * screenWidth / 320, 0, 100 * screenWidth / 320, 30 * screenWidth / 320);
//        contactCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
//        contactCell.contentLB.text = [self.detailDic objectForKey:@"info"];
//        contactCell.contentLB.frame = CGRectMake(10, 35  * screenWidth / 320, screenWidth - 20  * screenWidth / 320, [self calculationLabelHeight:[self.detailDic objectForKey:@"info"]]);
//        return contactCell;
    }else if (indexPath.section == 1){
        
        JGLableAndLableTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                launchActivityCell.promptLB.text = @"球队队长";
                launchActivityCell.contentLB.text = [self.detailDic objectForKey:@"captainName"];
                break;
            case 1:
                launchActivityCell.promptLB.text = @"所属地区";
                launchActivityCell.contentLB.text = [self.detailDic objectForKey:@"crtyName"];
                break;
            case 2:
                launchActivityCell.promptLB.text = @"成立时间";
                
                launchActivityCell.contentLB.text = [Helper returnDateformatString:[self.detailDic objectForKey:@"establishTime"]];
                break;
            case 3:
                launchActivityCell.promptLB.text = @"球队规模";
                launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%@人", [self.detailDic objectForKey:@"userSum"]];
                break;
            default:
                break;
        }
        
        
        return launchActivityCell;
    }else{
        JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"iamgeVCell" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            launchActivityCell.promptLB.text = @"赛事活动";
            launchActivityCell.imageV.image = [UIImage imageNamed:@"hd-2"];
        }else{
            launchActivityCell.promptLB.text = @"球队相册";
        }
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return launchActivityCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
 
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            JGTeamActivityViewController *activity = [[JGTeamActivityViewController alloc] init];
            activity.isMEActivity = 1;
            activity.timeKey = [[self.detailDic objectForKey:@"timeKey"] integerValue];
            [self.navigationController pushViewController:activity animated:YES];
            
        }else{
            
            JGTeamCreatePhotoController *photo = [[JGTeamCreatePhotoController alloc] init];
            [self.navigationController pushViewController:photo animated:YES];
        }
        
       
    }else if (indexPath.section == 3){
        JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
        wkVC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamDetails.html?key=%@", [self.detailDic objectForKey:@"timeKey"]];;
        wkVC.teamName = [self.detailDic objectForKey:@"name"];
        [self.navigationController pushViewController:wkVC animated:YES];
    }
    
    [self.launchActivityTableView reloadData];
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
                [dict setObject:@"11010" forKey:@"data"];//文件名||文件名+_background==>teamKey
                [dict setObject:@"1" forKey:@"nType"];
                [dict setObject:@"dagolfla" forKey:@"tag"];
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

