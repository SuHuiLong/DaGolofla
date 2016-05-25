//
//  JGPhotoAlbumViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPhotoAlbumViewController.h"

#import "JGTeamMemberController.h"

#import "JGPhotoShowCollectionViewCell.h"
#import "JGPhotoTimeReusableView.h"

#import "JGLUpdataPhotoController.h"
@interface JGPhotoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView* _collectionView;
}

@property (strong, nonatomic) JGPhotoTimeReusableView *headView;
@end

@implementation JGPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Helper isBlankString:_strTitle]) {
        self.title = _strTitle;
    }
    else
    {
        self.title = @"球队相册";
    }
    
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    [self uiConfig];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@214 forKey:@"albumKey"];
    [dict setObject:@0 forKey:@"offset"];


    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMediaList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        
    }];
    
    
}

-(void)upDataClick
{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@0 forKey:@"timeKey"];
    [dict setObject:@527 forKey:@"userKey"];
    [dict setObject:@214 forKey:@"albumKey"];
    [dict setObject:@1 forKey:@"mediaType"];
    
    
    [dict setObject:@"2016-12-11 10:00:00" forKey:@"createTime"];
    [[JsonHttp jsonHttp]httpRequest:@"team/createTeamMedia" JsonKey:@"teamMedia" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        
    }];
    
    
}


-(void)uiConfig
{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=1.f;
    
    
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
    [_collectionView registerNib: [UINib nibWithNibName:@"JGPhotoShowCollectionViewCell"
                                                 bundle:nil] forCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell"];
    /**
     *  如果是使用的xib文件则使用这个方法，    //获取含有UICollectionReusableView的Nib文件,
     UINib *headerNib = [UINib nibWithNibName: @"HeaderCollectionReusableView" bundle: [NSBundle mainBundle]];
     */
    //获取含有UICollectionReusableView的class文件。
    [_collectionView registerClass:[JGPhotoTimeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView"];
}



#pragma mark -- uicollection方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(screenWidth, 25*ScreenWidth/375);
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //设置SectionHeader
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        _headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView"forIndexPath:indexPath];
        
        
        _headView.timeLabel.text = [NSString stringWithFormat:@"2016年5月%ld号",(long)indexPath.section];
        _headView.backgroundColor = [UIColor lightGrayColor];
        return _headView;
    }
    return nil;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.iconImgv.hidden = YES;
        cell.addBtn.hidden = NO;
        return cell;
    }
    else
    {
        JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.iconImgv.hidden = NO;
        cell.addBtn.hidden = YES;
        return cell;
    }
    
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(81*ScreenWidth/375, 84*ScreenWidth/375);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     球队成员跳转暂时关闭
     */
//    JGTeamMemberController* teamVc = [[JGTeamMemberController alloc]init];
//    [self.navigationController pushViewController:teamVc animated:YES];
    
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@[@223] forKey:@"timeKeyList"];
    [dict setObject:@527 forKey:@"userKey"];

    [[JsonHttp jsonHttp]httpRequest:@"team/batchDeleteTeamMedia" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        
    }];
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
