//
//  ScoreViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreViewController.h"
#import "MeWonderViewCell.h"

#import "DataViewController.h"
#import "ScoreByActiveViewController.h"
#import "HistoryViewController.h"
#import "ScoreByGameViewController.h"
#import "ScoreBySelfViewController.h"

#import "Setbutton.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "ScoreModel.h"

#import "MBProgressHUD.h"
#import "UITabBar+badge.h"
#import "ScoreProfessViewController.h"

#import "JGDHistoryScoreViewController.h"   // 新 历史记分卡


@interface ScoreViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIScrollView* _scrollView;
    ScoreModel *_model;
    
    UICollectionView* _collectionView;
    NSArray* _iconLabelArr;
    UIView* _viewMain;
    UIView* _viewSec;
    
    MBProgressHUD* _progressHud;
    
}
@end

@implementation ScoreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
    //    for(UIView *view in [self.view subviews])
    //    {
    //        [view removeFromSuperview];
    //    }
    self.title = @"记分";
    
    ////NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]);
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        //        _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        //        _progressHud.mode = MBProgressHUDModeIndeterminate;
        //        _progressHud.labelText = @"加载中...";
        //        [self.view addSubview:_progressHud];
        //        [_progressHud show:YES];
//        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
        [[PostDataRequest sharedInstance] postDataRequest:@"score/getMyJf.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"userMoblie":[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"]} success:^(id respondsData)
         {
             
             NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
             //             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             self.view.backgroundColor = [UIColor whiteColor];
             if ([[dict objectForKey:@"success"] integerValue] == 1) {
                 _model = [[ScoreModel alloc] init];
                 [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
             }
             
             for (int i = 0; i < 3; i ++) {
                 UILabel *lable = [_viewMain viewWithTag:500 + i];
                 if (i == 0) {
                     if (_model.sumj == nil) {
                         lable.text = @"暂无成绩";
                         lable.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
                         
                         // lable.text = [NSString stringWithFormat:@"%d",arc4random()%100];
                     }
                     else
                     {
                         lable.text = [NSString stringWithFormat:@"%@",_model.sumj];
                         lable.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
                         
                     }
                 }
                 else if (i == 1)
                 {
                     if (_model.goodj == nil) {
                         lable.text = @"暂无成绩";
                         lable.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
                         
                         // lable.text = [NSString stringWithFormat:@"%d",arc4random()%100];
                         
                     }
                     else
                     {
                         lable.text = [NSString stringWithFormat:@"%@",_model.goodj];
                         lable.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
                         
                     }
                 }
                 else
                 {
                     if (_model.nums == nil) {
                         lable.text = @"暂无排名";
                         lable.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
                         
                         // lable.text = [NSString stringWithFormat:@"%d",arc4random()%100];
                         
                     }
                     else
                     {
                         lable.text = [NSString stringWithFormat:@"%@",_model.nums];
                         lable.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
                         
                     }
                     
                 }
             }
             
             NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
             if ([user objectForKey:@"scoreballId"] != nil) {
                 
                 [Helper alertViewWithTitle:@"您上次的记分尚未完成,是否继续记分?" withBlockCancle:^{
                     
                 } withBlockSure:^{
                     ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                     simpVc.hidesBottomBarWhenPushed = YES;
                     simpVc.isSave = @10;
                     simpVc.strTitle = [user objectForKey:@"scoreObjectTitle"];
                     simpVc.strBallName = [user objectForKey:@"scoreballName"];
                     simpVc.strSite0 = [user objectForKey:@"scoreSite0"];
                     simpVc.strSite1 = [user objectForKey:@"scoreSite1"];
                     simpVc.strType = [user objectForKey:@"scoreType"];
                     simpVc.strTee = [user objectForKey:@"scoreTTaiwan"];
                     simpVc.scoreObjectId = [user objectForKey:@"scoreObjectId"];
                     simpVc.ballId = [user objectForKey:@"scoreballId"];
                     [self.navigationController pushViewController:simpVc animated:YES];
                 } withBlock:^(UIAlertController *alertView) {
                     [self presentViewController:alertView animated:YES completion:nil];
                 }];
                 
                 
                 
             }
             
         } failed:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
         }];
        
    }
    else
    {
        for (int i = 0; i < 3; i ++) {
            UILabel *lable = [_viewMain viewWithTag:500 + i];
            lable.text = @"暂无成绩";
            lable.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
        }
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
            
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
    }
}
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
//    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    //记分栏
    [self createScore];
    //统计上传栏
    [self createUpLoad];
    
    
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        EnterViewController *vc = [[EnterViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

//
-(void)createScore
{
    _viewMain = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _viewMain.backgroundColor = [UIColor colorWithRed:0.23f green:0.25f blue:0.26f alpha:1.00f];
    [_scrollView addSubview:_viewMain];
    _viewMain.userInteractionEnabled = YES;
    
    
    
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-ScreenWidth/4, ScreenWidth/11, ScreenWidth/2, ScreenWidth/2)];
    imgv.backgroundColor = [UIColor whiteColor];
    [_viewMain addSubview:imgv];
    imgv.userInteractionEnabled = YES;
    imgv.layer.cornerRadius = ScreenWidth/4;
    imgv.layer.masksToBounds = YES;
    
    
    //圆形视图上的图片
    UIButton* btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnImage.frame = CGRectMake(imgv.frame.size.width/4+10*ScreenWidth/375, imgv.frame.size.width/8+20*ScreenWidth/375, imgv.frame.size.width/2-20*ScreenWidth/375, imgv.frame.size.width/2-20*ScreenWidth/375);
    [imgv addSubview:btnImage];
    btnImage.backgroundColor = [UIColor clearColor];
    [btnImage addTarget:self action:@selector(btnImgvClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //圆形视图上的按钮
    UILabel* lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(imgv.frame.size.width/4, imgv.frame.size.width/2+20*ScreenWidth/375, imgv.frame.size.width/2, imgv.frame.size.width/4)];
    [imgv addSubview:lableTitle];
    lableTitle.backgroundColor = [UIColor clearColor];
    lableTitle.textColor = [UIColor orangeColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:23*ScreenWidth/375];
    
    
    lableTitle.text = @"个人记分";
    [btnImage setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
 
    
    for (int i = 0; i < 3; i++) {
        //记分数字
        UILabel* labelCount = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10+ i*ScreenWidth/10*3-15*ScreenWidth/375, ScreenWidth/16*11, ScreenWidth/5+30*ScreenWidth/375, ScreenWidth/8)];
        labelCount.backgroundColor = [UIColor clearColor];
        labelCount.textColor = [UIColor whiteColor];
        labelCount.textAlignment = NSTextAlignmentCenter;
        labelCount.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
        labelCount.tag = 500 + i;
    
        [_viewMain addSubview:labelCount];
        //标题
        UILabel* labelTint = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10 + i*ScreenWidth/10*3, ScreenWidth/16*11+ScreenWidth/8, ScreenWidth/5, ScreenWidth/10)];
        labelTint.textAlignment = NSTextAlignmentCenter;
        labelTint.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
        labelTint.backgroundColor = [UIColor clearColor];
        labelTint.textColor = [UIColor whiteColor];
        [_viewMain addSubview:labelTint];
        switch (i) {
            case 0:
                labelTint.text = @"平均成绩";
                break;
            case 1:
                labelTint.text = @"最佳成绩";
                break;
            case 2:
                labelTint.text = @"成绩排名";
                break;
                
            default:
                break;
        }
    }
    
}

-(void)btnImgvClick
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        ScoreBySelfViewController *scVc = [[ScoreBySelfViewController alloc]init];
        scVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scVc animated:YES];
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}

-(void)createUpLoad
{
    if (ScreenHeight >= 568) {
        _viewSec = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, ScreenHeight-ScreenWidth-64*ScreenWidth/320-49*ScreenWidth/320)];
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    else{
        _viewSec = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, 568*ScreenWidth/320-ScreenWidth-64-49)];
        _scrollView.contentSize = CGSizeMake(0, _viewMain.frame.size.height+_viewSec.frame.size.height+64*ScreenWidth/320);
    }
    [_scrollView addSubview:_viewSec];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=ScreenWidth / 8;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(ScreenWidth / 8, 0, _viewSec.frame.size.width, _viewSec.frame.size.height) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [_viewSec addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize = CGSizeMake(0, 0);
    //注册cell
    [_collectionView registerNib: [UINib nibWithNibName:@"MeWonderViewCell" bundle:nil] forCellWithReuseIdentifier:@"MeWonderViewCell"];
    
    _iconLabelArr = @[@"数据统计",@"历史记分卡",@"赛事记分",@"活动记分"];
    
    
}



#pragma mark -- uicollection方法
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString * CellIdentifier = @"GradientCell";
    //    MeWonderViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    return cell;
    
    MeWonderViewCell *cell = [[MeWonderViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeWonderViewCell"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.iconLabel.text = [NSString stringWithFormat:@"%@",_iconLabelArr[indexPath.row]];
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    NSArray* arrIcon = [[NSArray alloc]init];
    ////NSLog(@"%d",[_model.scoreType integerValue]);
    
    arrIcon = @[@"shuju",@"lishi",@"saishi",@"huodong"];
    cell.iconImage.image = [UIImage imageNamed:arrIcon[indexPath.row]];
    
    
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90*ScreenWidth/375, 120*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30*ScreenWidth/375, 5*ScreenWidth/375, 20*ScreenWidth/375, 5*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
    {
        NSArray* vcArr = [[NSArray alloc]init];
        NSArray* titleArr = [[NSArray alloc]init];
        
        vcArr = @[@"DataViewController",
                  @"JGDHistoryScoreViewController",
                  @"ScoreByGameViewController",
                  @"ScoreByActiveViewController"];
        titleArr = @[@"数据统计",@"历史记分卡",@"赛事记分",@"活动记分"];
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i<vcArr.count; i++) {
            ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
            //        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.type = i;
            vc.title = titleArr[i];
            [arr addObject:vc];
            
            
        }
        
        UIViewController *arrCtrl = arr[indexPath.row];
        arrCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:arrCtrl animated:YES];
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];

        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
    }
}


@end
