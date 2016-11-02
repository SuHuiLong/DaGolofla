//
//  ScoreViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "JGLScoreNewViewController.h"
#import "MeWonderViewCell.h"
#import "EnterViewController.h"
#import "JGLSelfScoreViewController.h"
#import "JGDHistoryScoreViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "JGLChooseScoreViewController.h"
#import "JGHScoresViewController.h"

#import "JGHCaddieViewController.h"
#import "JGLCaddieScoreViewController.h"
#import "JGDPlayPersonViewController.h"

@interface JGLScoreNewViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIScrollView* _scrollView;
    
    UICollectionView* _collectionView;
    NSArray* _iconLabelArr;
    UIView* _viewMain;
    UIView* _viewSec;
    
    MBProgressHUD* _progressHud;
    
    UILabel *_averageScores;//平均成绩
    UILabel *_bestResult;//最佳成绩
    UILabel *_scoresRanking;//成绩排名
}
@end

@implementation JGLScoreNewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"记分";
    [self loadData];
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    //    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}
- (void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* str = @"啥地方";
    CGFloat fl = [Helper textHeightFromTextString:str width:300 fontSize:15];
    
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
#pragma mark -- 下载数据
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
        [[JsonHttp jsonHttp]httpRequest:@"score/getUserScoreStatisticsMain" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if ([data objectForKey:@"bean"]) {
                    dict = [data objectForKey:@"bean"];
                    _averageScores.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"avgPoles"]];
                    _bestResult.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"minPoles"]];
                    _scoresRanking.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ranking"]];
                }
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}

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
    [btnImage addTarget:self action:@selector(btnImgvClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //圆形视图上的按钮
    UILabel* lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(imgv.frame.size.width/4, imgv.frame.size.width/2+20*ScreenWidth/375, imgv.frame.size.width/2, imgv.frame.size.width/4)];
    [imgv addSubview:lableTitle];
    lableTitle.backgroundColor = [UIColor clearColor];
    lableTitle.textColor = [UIColor orangeColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:23*ScreenWidth/375];
    
    lableTitle.text = @"自助记分";
    [btnImage setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    
    //平均成绩
    _averageScores = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10 -15*ScreenWidth/375, ScreenWidth/16*11, ScreenWidth/5+30*ScreenWidth/375, ScreenWidth/8)];
    _averageScores.backgroundColor = [UIColor clearColor];
    _averageScores.textColor = [UIColor whiteColor];
    _averageScores.textAlignment = NSTextAlignmentCenter;
    _averageScores.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
    _averageScores.tag = 500;
    [_viewMain addSubview:_averageScores];
    //最佳成绩
    _bestResult = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10+ScreenWidth/10*3-15*ScreenWidth/375, ScreenWidth/16*11, ScreenWidth/5+30*ScreenWidth/375, ScreenWidth/8)];
    _bestResult.backgroundColor = [UIColor clearColor];
    _bestResult.textColor = [UIColor whiteColor];
    _bestResult.textAlignment = NSTextAlignmentCenter;
    _bestResult.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
    _bestResult.tag = 501;
    [_viewMain addSubview:_bestResult];
    //成绩排名
    _scoresRanking = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10+2*ScreenWidth/10*3-15*ScreenWidth/375, ScreenWidth/16*11, ScreenWidth/5+30*ScreenWidth/375, ScreenWidth/8)];
    _scoresRanking.backgroundColor = [UIColor clearColor];
    _scoresRanking.textColor = [UIColor whiteColor];
    _scoresRanking.textAlignment = NSTextAlignmentCenter;
    _scoresRanking.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
    _scoresRanking.tag = 502;
    [_viewMain addSubview:_scoresRanking];
    
    for (int i = 0; i < 3; i++) {
        //记分数字
        //        UILabel* labelCount = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/10+ i*ScreenWidth/10*3-15*ScreenWidth/375, ScreenWidth/16*11, ScreenWidth/5+30*ScreenWidth/375, ScreenWidth/8)];
        //        labelCount.backgroundColor = [UIColor clearColor];
        //        labelCount.textColor = [UIColor whiteColor];
        //        labelCount.textAlignment = NSTextAlignmentCenter;
        //        labelCount.font = [UIFont systemFontOfSize:30*ScreenWidth/375];
        //        labelCount.tag = 500 + i;
        //        [_viewMain addSubview:labelCount];
        
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
                labelTint.text = @"球友排名";
                break;
                
            default:
                break;
        }
    }
}

-(void)btnImgvClick:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
        [[JsonHttp jsonHttp]httpRequest:@"score/getTodayScore" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"scoreKey"] integerValue] != 0) {
                [Helper alertViewWithTitle:@"您还有记分尚未完成，是否前往继续记分" withBlockCancle:^{
                    btn.userInteractionEnabled = YES;
                    if ([[data objectForKey:@"acBoolean"] integerValue] == 1) {
                        JGLChooseScoreViewController* chooVc = [[JGLChooseScoreViewController alloc]init];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                        [self.navigationController pushViewController:chooVc animated:YES];
                    }
                    else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                        JGLSelfScoreViewController* SsVc = [[JGLSelfScoreViewController alloc]init];
                        [self.navigationController pushViewController:SsVc animated:YES];
                    }
                    
                } withBlockSure:^{
                    btn.userInteractionEnabled = YES;
                    JGHScoresViewController* scrVc = [[JGHScoresViewController alloc]init];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    scrVc.scorekey = [NSString stringWithFormat:@"%@",[data objectForKey:@"scoreKey"]];
                    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                    
                    if ([userdef objectForKey:[NSString stringWithFormat:@"%@", [data objectForKey:@"scoreKey"]]]) {
                        scrVc.currentPage = [[userdef objectForKey:[NSString stringWithFormat:@"%@", [data objectForKey:@"scoreKey"]]] integerValue];
                    }
                    
                    NSLog(@"%@", [userdef objectForKey:[data objectForKey:@"scoreKey"]]);
                    [self.navigationController pushViewController:scrVc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
            else{
                btn.userInteractionEnabled = YES;
                if ([[data objectForKey:@"acBoolean"] integerValue] == 1) {
                    JGLChooseScoreViewController* chooVc = [[JGLChooseScoreViewController alloc]init];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:chooVc animated:YES];
                }
                else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    JGLSelfScoreViewController* SsVc = [[JGLSelfScoreViewController alloc]init];
                    [self.navigationController pushViewController:SsVc animated:YES];
                }
            }
            
            
        }];
    }
    else
    {
        btn.userInteractionEnabled = YES;
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
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
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _viewSec.frame.size.width, _viewSec.frame.size.height) collectionViewLayout:flowLayout];
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
    
    _iconLabelArr = @[@"统计数据",@"历史记分卡", @"球童记分"];
    
    
}



#pragma mark -- uicollection方法
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MeWonderViewCell *cell = [[MeWonderViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeWonderViewCell"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.iconLabel.text = [NSString stringWithFormat:@"%@",_iconLabelArr[indexPath.row]];
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    NSArray* arrIcon = [[NSArray alloc]init];
    arrIcon = @[@"main_shuju",@"main_jifenka", @"main_qiutong"]; // icn_qiutong
    cell.iconImage.image = [UIImage imageNamed:arrIcon[indexPath.row]];
    
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80*ScreenWidth/375, 120*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30*ScreenWidth/375, 15*ScreenWidth/375, 10*ScreenWidth/375, 15*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
    {
        if (indexPath.item == 1) {
            JGDHistoryScoreViewController *historyVC = [[JGDHistoryScoreViewController alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            [self.navigationController pushViewController:historyVC animated:YES];
        }else if (indexPath.item == 0) {
            JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
            wkVC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreList.html?userKey=%@&md5=%@",DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]]];
            wkVC.fromWitchVC = 722;
            wkVC.teamName = @"统计数据";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            [self.navigationController pushViewController:wkVC animated:YES];
        }else if (indexPath.item == 2) {
            
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:DEFAULF_USERID forKey:@"userKey"];
            [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/hasCaddieRecord" JsonKey:nil withData:dic failedBlock:^(id errType) {
                [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
            } completionBlock:^(id data) {
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    
                    if ([[data objectForKey:@"has"] integerValue] == 1) {
                        JGLCaddieScoreViewController *acdieVC = [[JGLCaddieScoreViewController alloc] init];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                        [self.navigationController pushViewController:acdieVC animated:YES];
                    }else{
                        
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        if ([def objectForKey:@"isCaddie"]) {
                            
                            JGDPlayPersonViewController *personVC = [[JGDPlayPersonViewController alloc] init];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                            [self.navigationController pushViewController:personVC animated:YES];
                            
                        }else{
                            
                            JGHCaddieViewController *caddieCtrl = [[JGHCaddieViewController alloc]initWithNibName:@"JGHCaddieViewController" bundle:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                            [self.navigationController pushViewController:caddieCtrl animated:YES];
                        }
                        
                    }
                    
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            }];            
            
        }
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
    }
}


@end
