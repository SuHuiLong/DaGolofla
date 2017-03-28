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

#import "JGDDPhotoAlbumViewController.h"

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
    if (_titleStr) {
        self.title = _titleStr;
    }
    _dataArray = [[NSMutableArray alloc]init];
    
    if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"所有照片" style:UIBarButtonItemStylePlain target:self action:@selector(totalPhotoView)];
        rightBtn.tintColor = [UIColor whiteColor];
        [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kWvertical(15)], NSFontAttributeName, nil] forState:UIControlStateNormal];

        self.navigationItem.rightBarButtonItem = rightBtn;
    }

    [self uiConfig];
}


-(void)uiConfig
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=10.f;

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44 * ProportionAdapter - 15*screenWidth/375) collectionViewLayout:flowLayout];
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
    
    NSString *powerStr = [_dictMember objectForKey:@"power"];
    if ([powerStr containsString:@"1005"]) {
        // 设置footerView的
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        flowLayout.footerReferenceSize = CGSizeMake(_collectionView.frame.size.width, 100 * ProportionAdapter);
    }
    
    _collectionView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _collectionView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_collectionView.header beginRefreshing];
}



#pragma mark - 下载数据
- (void)downLoadData:(NSInteger )page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:@"offset"];
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
                if (_dictMember != nil) {
                    [_dataArray addObject:[[JGLPhotoAlbumModel alloc] init]];
                }
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
#pragma mark - Action
//创建相册点击
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
//所有照片
-(void)totalPhotoView{
    JGDDPhotoAlbumViewController *phoVc = [[JGDDPhotoAlbumViewController alloc] init];
    phoVc.strTitle = @"所有照片";
    phoVc.isGetAll = true;
    phoVc.power = _powerPho;
    phoVc.state = [_dictMember objectForKey:@"state"];
    phoVc.teamTimeKey = _teamKey;
    phoVc.dictMember = _dictMember;
    phoVc.userKey = DEFAULF_USERID;
    [self.navigationController pushViewController:phoVc animated:YES];
}
//管理相册点击
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

-(void)pushDetailPhotoView:(JGLPhotoAlbumModel *)model{
    
    JGDDPhotoAlbumViewController *phoVc = [[JGDDPhotoAlbumViewController alloc] init];
    phoVc.strTitle = model.name;
    phoVc.albumKey = model.timeKey;
    phoVc.power = _powerPho;
    phoVc.state = [_dictMember objectForKey:@"state"];
    phoVc.teamTimeKey = _teamKey;
    phoVc.dictMember = _dictMember;
    phoVc.userKey = model.userKey;
    
    NSInteger power = [model.power integerValue];
    if (_dictMember != nil) {
        if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
            //需要跳转
            [self.navigationController pushViewController:phoVc animated:YES];
        }else{
            if (power == 0) {
                //需要跳转
                [self.navigationController pushViewController:phoVc animated:YES];
            }else{
                [[ShowHUD showHUD]showToastWithText:@"此相册仅对球队成员开放" FromView:self.view];
            }
        }
    }else{
        if (power == 0) {
            //需要跳转
            [self.navigationController pushViewController:phoVc animated:YES];
        }else{
            //不要需要跳转
            [[ShowHUD showHUD]showToastWithText:@"此相册仅对球队成员开放" FromView:self.view];
        }
    }

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




#pragma mark - UICollectionViewDelegate
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
    JGLPhotoAlbumModel *model = _dataArray[indexPath.row];
    [cell showData:model];


    /**
     *  //POWER == 0，所有人可见，隐藏image    power == 1  仅球队成员可见
     */
    if (_dictMember != nil) {
        if ([[_dictMember objectForKey:@"state"] integerValue] == 1) {
            cell.suoImage.hidden = YES;
        }else{
            if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
                cell.suoImage.hidden = YES;
            }else{
                cell.suoImage.hidden = NO;
            }
        }
    }else{
        if ([[_dataArray[indexPath.row] power] integerValue] == 0) {
            cell.suoImage.hidden = YES;
        }else{
            cell.suoImage.hidden = NO;
        }
    }
    if (_powerPho != nil) {
        if ([_powerPho containsString:@"1005"] == YES) {
            if (_manageInter == 1||!model.timeKey) {
                cell.manageBtn.hidden = YES;
            }else{
                cell.manageBtn.hidden = NO;
                cell.manageBtn.tag = 10000 + indexPath.row;
                [cell.manageBtn addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            cell.manageBtn.hidden = YES;
        }
    }else{
        cell.manageBtn.hidden = YES;
    }
    
    return cell;
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
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(170*ScreenWidth/375, 180*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    JGLPhotoAlbumModel *model = _dataArray[indexPath.item];
    
    if (model.name == nil) {
        [self createClick];
        return;
    }
    [self pushDetailPhotoView:model];
    
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
