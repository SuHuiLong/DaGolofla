//
//  JGTeamPhotoViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamPhotoViewController.h"
#import "JGTeamCreatePhotoController.h"

#import "JGTeamPhotoCollectionViewCell.h"
@interface JGTeamPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView* _collectionView;
}
@end

@implementation JGTeamPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队相册";
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"创建相册" style:UIBarButtonItemStylePlain target:self action:@selector(createClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self uiConfig];
}

-(void)createClick
{
    JGTeamCreatePhotoController* phoVc = [[JGTeamCreatePhotoController alloc]init];
    phoVc.title = @"创建相册";
    phoVc.isManage = NO;
    [self.navigationController pushViewController:phoVc animated:YES];
}



-(void)uiConfig
{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [self.view addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.bounces = NO;
//    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize = CGSizeMake(0, 0);
    //注册cell
    [_collectionView registerNib: [UINib nibWithNibName:@"JGTeamPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JGTeamPhotoCollectionViewCell"];
}

#pragma mark -- uicollection方法
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGTeamPhotoCollectionViewCell *cell = [[JGTeamPhotoCollectionViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGTeamPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.manageBtn addTarget:self action:@selector(manageClick) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)manageClick
{
    JGTeamCreatePhotoController* phoVc = [[JGTeamCreatePhotoController alloc]init];
    phoVc.title = @"球队相册管理";
    phoVc.isManage = YES;
    [self.navigationController pushViewController:phoVc animated:YES];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160*ScreenWidth/375, 150*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
