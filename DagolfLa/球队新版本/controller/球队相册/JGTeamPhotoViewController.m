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
#import "JGPhotoAlbumViewController.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "JGLPhotoAlbumModel.h"

@interface JGTeamPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView* _collectionView;
    NSInteger _page;
    NSMutableArray* _dataArray;
}
@end

@implementation JGTeamPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    self.title = @"球队相册";
    _dataArray = [[NSMutableArray alloc]init];
    
    if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"创建相册" style:UIBarButtonItemStylePlain target:self action:@selector(createClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }

    [self uiConfig];
}


-(void)createClick
{
    JGTeamCreatePhotoController* phoVc = [[JGTeamCreatePhotoController alloc]init];
    phoVc.title = @"创建相册";
    phoVc.isManage = NO;
    //传非0，1的数
    phoVc.isShowMem = @3;
    phoVc.teamKey = _teamKey;
    phoVc.createBlock = ^(void){
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
    [self.navigationController pushViewController:phoVc animated:YES];
}



-(void)uiConfig
{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375) collectionViewLayout:flowLayout];
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
    
    _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _collectionView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_collectionView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamAlbumList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"teamAlbumList"])
            {
                JGLPhotoAlbumModel *model = [[JGLPhotoAlbumModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _page++;
            [_collectionView reloadData];
        }else {
//            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
//                [self presentViewController:alertView animated:YES completion:nil];
//            }];
            [[ShowHUD showHUD]showToastWithText:[dict objectForKey:@"message"] FromView:self.view];
        }
        [_collectionView reloadData];
        if (isReshing) {
            [_collectionView.header endRefreshing];
        }else {
            [_collectionView.footer endRefreshing];
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
    
    JGTeamPhotoCollectionViewCell *cell = [[JGTeamPhotoCollectionViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGTeamPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell showData:_dataArray[indexPath.row]];

    
    /**
     *  //POWER == 0，所有人可见，隐藏image    power == 1  仅球队成员可见
     */
    if (_dictMember != nil) {
        if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
            cell.suoImage.hidden = YES;
        }
        else{
            if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
                cell.suoImage.hidden = YES;
            }
            else
            {
                cell.suoImage.hidden = NO;
            }
        }
    }
    else
    {
        if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
            cell.suoImage.hidden = YES;
        }
        else
        {
            cell.suoImage.hidden = NO;
        }
    }
    if (_powerPho != nil) {
        if ([_powerPho containsString:@"1005"] == YES) {
            cell.manageBtn.hidden = NO;
            cell.manageBtn.tag = 10000 + indexPath.row;
            [cell.manageBtn addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.manageBtn.hidden = YES;
        }
    }
    else
    {
        cell.manageBtn.hidden = YES;
    }
    
    return cell;
}
-(void)manageClick:(UIButton *)btn
{
    JGTeamCreatePhotoController* phoVc = [[JGTeamCreatePhotoController alloc]init];
    phoVc.title = @"球队相册管理";
    phoVc.isManage = YES;
    phoVc.teamKey = _teamKey;
    phoVc.isShowMem = [_dataArray[btn.tag - 10000] power];
    phoVc.numPhotoKey = [_dataArray[btn.tag - 10000] mediaKey];
    phoVc.timeKey = [_dataArray[btn.tag - 10000] timeKey];
    phoVc.titleStr = [_dataArray[btn.tag - 10000] name];
    phoVc.createBlock = ^(void){
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
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
    JGPhotoAlbumViewController* phoVc = [[JGPhotoAlbumViewController alloc]init];
    phoVc.strTitle = [_dataArray[indexPath.row] name];
    phoVc.strTimeKey = [_dataArray[indexPath.row] timeKey];
    phoVc.albumKey = [_dataArray[indexPath.row] timeKey];
    phoVc.power = _powerPho;
    phoVc.state = [_dictMember objectForKey:@"state"];
    phoVc.teamTimeKey = _teamKey;
    phoVc.dictMember = _dictMember;
    phoVc.userKey = [_dataArray[indexPath.row] userKey];
    phoVc.blockRefresh = ^(){
        _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        [_collectionView.header beginRefreshing];
        [_collectionView reloadData];
    };
    if (_dictMember != nil) {
        if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
            //需要跳转
            [self.navigationController pushViewController:phoVc animated:YES];
        }
        else{
            if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
                //需要跳转
                [self.navigationController pushViewController:phoVc animated:YES];
            }
            else
            {
                //不要需要跳转
//                [Helper alertViewWithTitle:@"此相册仅对球队成员开放，请先加入球队再行观看" withBlock:^(UIAlertController *alertView) {
//                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
//                }];
                [[ShowHUD showHUD]showToastWithText:@"此相册仅对球队成员开放，请先加入球队再行观看" FromView:self.view];
                
            }
        }
    }
    else
    {
        if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
            //需要跳转
            [self.navigationController pushViewController:phoVc animated:YES];
        }
        else
        {
            //不要需要跳转
//            [Helper alertViewWithTitle:@"此相册仅对球队成员开放，请先加入球队再行观看" withBlock:^(UIAlertController *alertView) {
//                [self.navigationController presentViewController:alertView animated:YES completion:nil];
//            }];
            [[ShowHUD showHUD]showToastWithText:@"此相册仅对球队成员开放，请先加入球队再行观看" FromView:self.view];
        }
    }
    
    
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
