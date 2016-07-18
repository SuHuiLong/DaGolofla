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

@interface JGLScoreNewViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIScrollView* _scrollView;
    
    UICollectionView* _collectionView;
    NSArray* _iconLabelArr;
    UIView* _viewMain;
    UIView* _viewSec;
    
    MBProgressHUD* _progressHud;
    
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
    
    self.title = @"记分";
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
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
    
    
    lableTitle.text = @"自助记分";
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        JGLSelfScoreViewController* SsVc = [[JGLSelfScoreViewController alloc]init];
        [self.navigationController pushViewController:SsVc animated:YES];   
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
    
    _iconLabelArr = @[@"统计数据",@"历史记分卡"];
    
    
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

    MeWonderViewCell *cell = [[MeWonderViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeWonderViewCell"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.iconLabel.text = [NSString stringWithFormat:@"%@",_iconLabelArr[indexPath.row]];
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    NSArray* arrIcon = [[NSArray alloc]init];
    arrIcon = @[@"graph",@"cardO"];
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
    return UIEdgeInsetsMake(30*ScreenWidth/375, 8*ScreenWidth/375, 20*ScreenWidth/375, 100*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
    {
        
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
