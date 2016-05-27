//
//  JGPreviewTeamViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPreviewTeamViewController.h"
#import "JGTeamCreatePhotoController.h" //相册
#import "JGTeamActivityViewController.h" //活动

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "JGHTeamActivityImageCell.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGPreviewTeamViewController ()<UITableViewDelegate, UITableViewDataSource, JGHTeamActivityImageCellDelegate, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;


@property (nonatomic, strong)UIImage *headerImage;


@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@end

@implementation JGPreviewTeamViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    self.titleField.text = [self.detailDic objectForKey:@"name"];
    
    
    
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
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 98) style:(UITableViewStylePlain)];
        [self.launchActivityTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        
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
    
    //输入框
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.font = [UIFont systemFontOfSize:15];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 50, 50)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:@"relogo"] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    self.headPortraitBtn.userInteractionEnabled = NO;

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
        [self didSelectPhotoImage:btn];
    }
}

#pragma mark -- 预览
- (void)createPreviewBtn{
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 98, screenWidth, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [saveBtn addTarget:self action:@selector(saveBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 44, screenWidth, 44)];
    [previewBtn setTitle:@"提交" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
}

- (void)saveBtnBtnClick: (UIButton *)btn{
    [Helper alertViewNoHaveCancleWithTitle:@"保存成功" withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
}

#pragma mark -- 提交
- (void)previewBtnClick:(UIButton *)btn{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *Dic =[user objectForKey:@"cacheCreatTeamDic"];
    [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:Dic requestMethod:@"POST" failedBlock:^(id errType) {

    } completionBlock:^(id data) {

        if ([data objectForKey:@"packSuccess"]) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];
            [user synchronize];
        }
    }];
    [Helper alertViewNoHaveCancleWithTitle:@"球队创建提交成功" withBlock:^(UIAlertController *alertView) {
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    [self.navigationController popViewControllerAnimated:YES];

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
        return 2;
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
        return [self calculationLabelHeight:[self.detailDic objectForKey:@"info"]] + 40 * screenWidth / 320;
        
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
        JGDisplayInfoTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"Display"];
        contactCell.promptLB.text = @"球队简介";
        
        contactCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
        contactCell.contentLB.text = [self.detailDic objectForKey:@"info"];
        contactCell.contentLB.frame = CGRectMake(10, 35  * screenWidth / 320, screenWidth - 20  * screenWidth / 320, [self calculationLabelHeight:[self.detailDic objectForKey:@"info"]]);
        return contactCell;
    }else if (indexPath.section == 1){
        
        JGLableAndLableTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                launchActivityCell.promptLB.text = @"所属地区";
                launchActivityCell.contentLB.text = [self.detailDic objectForKey:@"crtyName"];
                break;
            case 1:
                launchActivityCell.promptLB.text = @"成立时间";
                launchActivityCell.contentLB.text = [self.detailDic objectForKey:@"establishTime"];
                break;
//            case 2:
//                launchActivityCell.promptLB.text = @"球队队长";
//                launchActivityCell.contentLB.text = self.detailModel.establishTime;
//                break;
//            case 3:
//                launchActivityCell.promptLB.text = @"球队规模";
//                launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%td人", self.detailModel.userSum];
//                break;
            default:
                break;
        }
        
        
        return launchActivityCell;
    }else{
        JGLableAndLableTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            launchActivityCell.promptLB.text = @"赛事活动";
        }else{
            launchActivityCell.promptLB.text = @"球队相册";
        }
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return launchActivityCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            JGTeamActivityViewController *activity = [[JGTeamActivityViewController alloc] init];
            [self.navigationController pushViewController:activity animated:YES];
            
        }else{
            
            JGTeamCreatePhotoController *photo = [[JGTeamCreatePhotoController alloc] init];
            [self.navigationController pushViewController:photo animated:YES];
        }
    }
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


