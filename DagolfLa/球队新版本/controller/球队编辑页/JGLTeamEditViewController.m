//
//  JGNotTeamMemberDetailViewController.m
//  DagolfLa
//
//  Created by lq on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamEditViewController.h"

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"

#import "SXPickPhoto.h"
#import "JGCostSetViewController.h"

#import "JGLTeamEditTableViewCell.h"
#import "JGTeamAdressTableViewCell.h"
#import "JGTeamEIntroTableViewCell.h"
#import "JGTeamMemberController.h"
#import "SDImageCache.h"

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGLTeamEditViewController ()<UITableViewDelegate, UITableViewDataSource, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
    
    
    NSString* _strInfo, * _strName;
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, assign) NSInteger userKey;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation JGLTeamEditViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.titleField.text = [self.detailDic objectForKey:@"name"];
    
    if (_isFirst) {
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        self.headPortraitBtn.layer.masksToBounds = YES;
        self.headPortraitBtn.layer.cornerRadius = 8.0;
        
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:TeamBGImage]];
        self.isFirst = NO;
    }else{
        
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.isFirst = YES;
        self.dataDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg"];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight  * screenWidth / 375);
        self.imgProfile.userInteractionEnabled = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        self.imgProfile.tag = 520;
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStylePlain)];
//        [self.launchActivityTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
//        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        [_launchActivityTableView registerNib:[UINib nibWithNibName:@"JGLTeamEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLTeamEditTableViewCell"];
        [_launchActivityTableView registerNib:[UINib nibWithNibName:@"JGTeamAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGTeamAdressTableViewCell"];
        [_launchActivityTableView registerNib:[UINib nibWithNibName:@"JGTeamEIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGTeamEIntroTableViewCell"];
        
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
    [gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.titleView addSubview:gradientImage];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10 * screenWidth / 375, 44 * screenWidth / 375, 44 * screenWidth / 375);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64 * screenWidth / 375, 10 * screenWidth / 375, 54 * screenWidth / 375, 44 * screenWidth / 375);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13 * screenWidth / 375];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64 * screenWidth / 375, 17 * screenWidth / 375, screenWidth - 138 * screenWidth / 375, 30 * screenWidth / 375)];
    self.titleField.backgroundColor = [UIColor clearColor];
//    self.titleField.font = [UIFont systemFontOfSize:15 * screenWidth / 375];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.font = [UIFont systemFontOfSize:15 * screenWidth / 375];

//    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.delegate = self;
    
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 * screenWidth / 375, 150 * screenWidth / 375, 50 * screenWidth / 375, 50 * screenWidth / 375)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:@"relogo"] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    self.headPortraitBtn.tag = 522;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@[], @[@"球队队长", @"所属地区", @"成立时间"], @[@"对外联系人"], @[@"球队简介"]];
    
    
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
    }else if (btn.tag == 520 || (btn.tag == 522)){
        //更换头像
        [self didSelectPhotoImage:btn];
    }
}

#pragma mark -- 保存
- (void)createPreviewBtn{
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 375, screenHeight -80 * screenWidth / 375, screenWidth - 20 * screenWidth / 375, 44 * screenWidth / 375)];
    [previewBtn setTitle:@"保存" forState:UIControlStateNormal];
    previewBtn.clipsToBounds = YES;
    previewBtn.layer.cornerRadius = 6.f;
    previewBtn.layer.borderColor = [[UIColor redColor] CGColor];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.launchActivityTableView addSubview:previewBtn];
}
#pragma mark -- 保存编辑操作
- (void)previewBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"teamKey"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    [dic setObject:@(self.userKey) forKey:@"answerKey"];
    NSLog(@"%@",_titleField.text);
    [dic setObject:self.titleField.text forKey:@"name"];
    
    JGTeamEIntroTableViewCell * cell = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [dic setObject:cell.textView.text forKey:@"info"];
    
    [[JsonHttp jsonHttp] httpRequest:@"team/updateTeam" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        [Helper alertViewNoHaveCancleWithTitle:@"保存失败，请稍后再试" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    } completionBlock:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
        [Helper alertViewNoHaveCancleWithTitle:@"保存成功" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        
//  注释
        
    }];
}

#pragma mark --编辑框的代理方法
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    _strInfo = textView.text;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _strName = textField.text;
    return YES;
}

#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+(ImageHeight  * screenWidth / 375))*screenWidth)/(ImageHeight  * screenWidth / 375);
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, (ImageHeight  * screenWidth / 375)+ABS(yOffset));
        self.imgProfile.frame = f;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0  * screenWidth / 375, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 0  * screenWidth / 375;
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
        return ImageHeight  * screenWidth / 375 - 10  * screenWidth / 375;
    }else if (indexPath.section == 3){
//        return [self calculationLabelHeight:self.detailModel.info] + 40 * screenWidth / 320;
        return 150  * screenWidth / 375;
    }else{
        return 45  * screenWidth / 375;
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 375 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * screenWidth / 375;
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
    }
    else if (indexPath.section == 1)
    {
        JGLTeamEditTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamEditTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.titleLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 375];
        if (indexPath.row == 0) {
            cell.textField.text = [self.detailDic objectForKey:@"captainName"];
        }else if (indexPath.row == 1){
            cell.textField.text = [self.detailDic objectForKey:@"crtyName"];
        }else{
            cell.textField.text = [Helper returnDateformatString:[self.detailDic objectForKey:@"establishTime"]];
        }
        cell.textField.font = [UIFont systemFontOfSize:15  * screenWidth / 375];

        cell.textField.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        JGTeamAdressTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGTeamAdressTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@", [self.detailDic objectForKey:@"answerName"], [self.detailDic objectForKey:@"answerMobile"]];
        cell.titleLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 375];
        cell.detailLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 375];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else
    {
        JGTeamEIntroTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGTeamEIntroTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.textView.text = [self.detailDic objectForKey:@"info"];
        cell.textView.delegate = self;
        
        cell.titleLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 375];
        cell.textView.font = [UIFont systemFontOfSize:15  * screenWidth / 375];

        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //            JGTeamMemberController *costView = [[JGTeamMemberController alloc]initWithNibName:@"JGCostSetViewController" bundle:nil];
            //            costView.delegate = self;
            JGTeamMemberController *memVC = [[JGTeamMemberController alloc] init];
            memVC.teamKey = [self.detailDic objectForKey:@"timeKey"];
            memVC.isEdit = YES;
            memVC.block = ^(NSInteger key, NSString* name, NSString *mobie){
                
                JGTeamAdressTableViewCell* cell = [self.launchActivityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
                cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@", name, mobie];
                self.userKey = key;
            };
            [self.navigationController pushViewController:memVC animated:YES];
        }
        
        /**
         JGHConcentTextViewController *concentTextCtrl = [[JGHConcentTextViewController alloc]initWithNibName:@"JGHConcentTextViewController" bundle:nil];
         
         concentTextCtrl.itemText = @"内容";
         concentTextCtrl.delegate = self;
         concentTextCtrl.contentTextString = _model.activityInfo;
         [self.navigationController pushViewController:concentTextCtrl animated:YES];
         */
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
                self.headPortraitBtn.imageView.image = (UIImage *)Data;
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
                if (btn.tag == 520) {
                    self.imgProfile.image = (UIImage *)Data;
                    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
                    self.imgProfile.layer.masksToBounds = YES;
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
                    [dict setObject:[NSString stringWithFormat:@"%@_background" ,[self.detailDic objectForKey:@"timeKey"]] forKey:@"data"];
                    [dict setObject:TYPE_TEAM_HEAD forKey:@"nType"];
                    [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dict andDataArray:[NSArray arrayWithObject:UIImageJPEGRepresentation(self.imgProfile.image, 0.7)] failedBlock:^(id errType) {
                        NSLog(@"errType===%@", errType);
                    } completionBlock:^(id data) {

                        NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@_background.jpg@400w_150h", [self.detailDic objectForKey:@"timeKey"]];
                        [[SDImageCache sharedImageCache] removeImageForKey:bgUrl];
//                        [[SDImageCache sharedImageCache]removeImageForKey:bgUrl fromDisk:YES withCompletion:^{
//                        }];

                    }];
                    
                }else if (btn.tag == 522){
                    //头像
                    [self.headPortraitBtn setImage:(UIImage *)Data forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                    
                    NSNumber* strTimeKey = [self.detailDic objectForKey:@"timeKey"];
                    // 上传图片
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:strTimeKey forKey:@"data"];
                    [dict setObject:TYPE_TEAM_HEAD forKey:@"nType"];
                    [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
                    
                    [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:[NSArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)] failedBlock:^(id errType) {
                        NSLog(@"errType===%@", errType);
                    } completionBlock:^(id data) {
                        NSString *head = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/661.jpg@100w_100h"];
                        NSString *headUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@.jpg@120w_120h", [self.detailDic objectForKey:@"timeKey"]];
                        [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
                        [[SDImageCache sharedImageCache] removeImageForKey:head fromDisk:YES];
//                        [[SDImageCache sharedImageCache]removeImageForKey:headUrl fromDisk:YES withCompletion:^{
//                        }];
                        
                    }];
                }
                //测试数据
                //                self.headerImage = (UIImage *)Data;
                //                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                //                [dict setObject:@"11010" forKey:@"data"];
                //                [dict setObject:@"1" forKey:@"nType"];
                //                [dict setObject:@"team" forKey:@"tag"];
                //                NSMutableArray *array = [NSMutableArray array];
                //                [array addObject:UIImageJPEGRepresentation(_headerImage, 0.7)];
                //
                //                [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {
                //                    NSLog(@"errType===%@", errType);
                //                } completionBlock:^(id data) {
                //                    NSLog(@"data===%@", data);
                //                }];
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

