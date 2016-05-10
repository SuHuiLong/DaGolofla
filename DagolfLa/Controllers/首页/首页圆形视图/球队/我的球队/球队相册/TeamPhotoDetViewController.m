//
//  TeamPhotoDetViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/11/27.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamPhotoDetViewController.h"
#import "TeamBrowseViewController.h"


#import "PostDataRequest.h"
#import "Helper.h"

#import "TeamPhotoDeModel.h"
#import "TeamPhotoCollectionViewCell.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"


#import "TeamPhotoAddViewController.h"

#import "TeamPhotoEditViewController.h"

//数据
//#define LINE_COUNT 4
@interface TeamPhotoDetViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    int indexBtn;
    
    UICollectionView* _collectionView;
    NSMutableArray* _dataArray;
    NSMutableArray* _picsArr;
    NSMutableArray* _arrId;
    UILabel* _label;
    NSInteger _page;
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end

@implementation TeamPhotoDetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _page = 1;
    if ([_forrevent integerValue] != 3 && [_forrevent integerValue] != 5) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(tianJClick)];
        self.navigationItem.rightBarButtonItem = item;
        item.tintColor = [UIColor whiteColor];
    }
    
    self.title = _model.photoGroupsName;
    
    _dataArray = [[NSMutableArray alloc]init];
    _picsArr = [[NSMutableArray alloc]init];
    _arrId = [[NSMutableArray alloc]init];
    
    _scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    
    [self uiConfig];
}

-(void)tianJClick
{
    TeamPhotoAddViewController* teamVc = [[TeamPhotoAddViewController alloc]init];
    teamVc.groupId = _model.photoGroupsId;
    ////NSLog(@"%@",_model.photoGroupsId);
    [self.navigationController pushViewController:teamVc animated:YES];
}

-(void)uiConfig
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [self.view addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    _collectionView.scrollEnabled = YES;
    _collectionView.alwaysBounceVertical = YES;//允许collection个数不是满屏幕的时候调用刷新
    //注册cell
    [_collectionView registerNib: [UINib nibWithNibName:@"TeamPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TeamPhotoCollectionViewCell"];

    _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(head1Rereshing)];
    _collectionView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(foot1Rereshing)];
    [_collectionView.header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    ////NSLog(@"%@",_model.photoGroupsTeamId);
    ////NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    ////NSLog(@"%@",_model.photoGroupsId);
    
    ////NSLog(@"%@",[NSNumber numberWithInt:page]);
    [[PostDataRequest sharedInstance] postDataRequest:@"photos/queryByphotos.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@12,@"groupId":_model.photoGroupsId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"teamTeamId":_model.photoGroupsTeamId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
                [_picsArr removeAllObjects];
                [_arrId removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamPhotoDeModel *model = [[TeamPhotoDeModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
                [_picsArr addObject:model.photoPic];
                [_arrId addObject:model.photosId];
            }
            
            if (_dataArray.count == 0) {
                _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
                _label.text = @"您的相册还没有图片,请点击右上角添加按钮添加图片";
                [self.view addSubview:_label];
            }
            else
            {
                _label.hidden = YES;
            }
            _page++;
            [_collectionView reloadData];
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_collectionView reloadData];
        if (isReshing) {
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)head1Rereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)foot1Rereshing
{
    [self downLoadData:_page isReshing:NO];
}

    
    
    
#pragma mark -- uicollection方法
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPhotoCollectionViewCell *cell = [[TeamPhotoCollectionViewCell alloc]init];
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TeamPhotoCollectionViewCell"forIndexPath:indexPath];
    [cell showData:_dataArray[indexPath.row]];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80*ScreenWidth/375, 85*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPhotoEditViewController *teamVc = [[TeamPhotoEditViewController alloc] initWithIndex:indexPath.row selectImages:_picsArr];
    teamVc.photoId = _model.photoGroupsId;
    teamVc.arrayId = [[NSMutableArray alloc]init];
    teamVc.forrevent = _forrevent;
    if (_dataArray.count != 0) {
        for (int i = 0; i < _dataArray.count; i++) {
            [teamVc.arrayId addObject:_arrId[i]];
        }
    }

    [self.navigationController pushViewController:teamVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
