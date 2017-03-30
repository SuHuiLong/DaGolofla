//
//  JGHTeamShadowViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHTeamShadowViewController.h"
#import "JGTeamCreatePhotoController.h"

#import "JGTeamPhotoCollectionViewCell.h"
#import "JGPhotoAlbumViewController.h"

#import "JGLPhotoAlbumModel.h"

#import "JGDDPhotoAlbumViewController.h"
#import "JGHPhotoShadowCollectionViewCell.h"

static NSString *const JGHPhotoShadowCollectionViewCellIdentifier = @"JGHPhotoShadowCollectionViewCell";

@interface JGHTeamShadowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView* _collectionView;
    NSInteger _page;
    NSMutableArray* _dataArray;
}

@end

@implementation JGHTeamShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    self.title = @"球队掠影";
    _dataArray = [[NSMutableArray alloc]init];
    
    [self uiConfig];
}


-(void)uiConfig
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44 * ProportionAdapter - 15*screenWidth/375) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [self.view addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    //    _collectionView.bounces = NO;
    //    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize = CGSizeMake(0, 0);
    
    //注册cell
    [_collectionView registerClass:[JGHPhotoShadowCollectionViewCell class] forCellWithReuseIdentifier:JGHPhotoShadowCollectionViewCellIdentifier];

    
    _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_collectionView.mj_header beginRefreshing];
}

// 设置footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableView = footerview;
        
        
        UILabel *oneLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
        oneLable.text = @"照片太多，手机上传太慢？！";
        oneLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        oneLable.textColor = [UIColor colorWithHexString:Ba0_Color];
        oneLable.textAlignment = NSTextAlignmentCenter;
        [footerview addSubview:oneLable];
        
        UILabel *twoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
        twoLable.text = @"我们提供了PC端导入工具，海量照片，一键导入！";
        twoLable.textAlignment = NSTextAlignmentCenter;
        twoLable.textColor = [UIColor colorWithHexString:Ba0_Color];
        twoLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        [footerview addSubview:twoLable];
        
        UILabel *threeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 *ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
        threeLable.text = @"PC端登录地址：http://keeper.dagolfla.com";
        threeLable.textColor = [UIColor colorWithHexString:Ba0_Color];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:threeLable.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:B31_Color] range:NSMakeRange(8, threeLable.text.length-8)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
        threeLable.attributedText = attributedString;
        
        threeLable.textAlignment = NSTextAlignmentCenter;
        threeLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        [footerview addSubview:threeLable];
        
    }
    return reusableView;
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //[dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@(page) forKey:@"off"];
    [[JsonHttp jsonHttp]httpRequest:@"index/getRecommendAlbumList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_collectionView.mj_header endRefreshing];
        }else {
            [_collectionView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            
            _page++;
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"albumList"])
            {
                
                JGLPhotoAlbumModel *model = [[JGLPhotoAlbumModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            
            //[_collectionView reloadData];
        }else {
            [[ShowHUD showHUD]showToastWithText:[dict objectForKey:@"message"] FromView:self.view];
        }
        
        [_collectionView reloadData];
        if (isReshing) {
            [_collectionView.mj_header endRefreshing];
        }else {
            [_collectionView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
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
    JGHPhotoShadowCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGHPhotoShadowCollectionViewCellIdentifier forIndexPath:indexPath];
    if (_dataArray.count >0) {
        [cell configData:_dataArray[indexPath.item]];
    }
    
    return cell;
}
-(void)manageClick:(UIButton *)btn
{
    JGTeamCreatePhotoController* phoVc = [[JGTeamCreatePhotoController alloc]init];
    phoVc.title = @"球队相册管理";
    phoVc.isManage = YES;
    //phoVc.teamKey = _teamKey;
    phoVc.isShowMem = [_dataArray[btn.tag - 10000] power];
    phoVc.numPhotoKey = [_dataArray[btn.tag - 10000] mediaKey];
    phoVc.timeKey = [_dataArray[btn.tag - 10000] timeKey];
    phoVc.titleStr = [_dataArray[btn.tag - 10000] name];
    phoVc.createBlock = ^(void){
        _collectionView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.mj_header beginRefreshing];
        [_collectionView reloadData];
    };
    [self.navigationController pushViewController:phoVc animated:YES];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((screenWidth -18*ProportionAdapter)/2, 150*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6*ProportionAdapter, 6*ProportionAdapter, 6*ProportionAdapter, 6*ProportionAdapter);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGDDPhotoAlbumViewController *phoVc = [[JGDDPhotoAlbumViewController alloc] init];
    //    JGPhotoAlbumViewController* phoVc = [[JGPhotoAlbumViewController alloc]init];
    JGLPhotoAlbumModel *model = [[JGLPhotoAlbumModel alloc]init];
    model = _dataArray[indexPath.item];
    
    phoVc.strTitle = model.name;
    phoVc.albumKey = model.timeKey;
    //phoVc.power = [NSString stringWithFormat:@"%@", model.power];
    //phoVc.state = [_dictMember objectForKey:@"state"];
    phoVc.teamTimeKey = model.teamKey;
    //phoVc.dictMember = _dictMember;
    phoVc.userKey = model.userKey;
    
    [self.navigationController pushViewController:phoVc animated:YES];

    
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
