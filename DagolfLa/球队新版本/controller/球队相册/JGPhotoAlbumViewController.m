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
    
    self.title = @"球队相册";
    
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    [self uiConfig];
    
}

-(void)upDataClick
{
    JGTeamMemberController* teamVc = [[JGTeamMemberController alloc]init];
    [self.navigationController pushViewController:teamVc animated:YES];
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
    return 40;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //设置SectionHeader
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        _headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JGPhotoTimeReusableView"forIndexPath:indexPath];
        
        
        _headView.timeLabel.text = [NSString stringWithFormat:@"2016年5月%d号",indexPath.section];
        _headView.backgroundColor = [UIColor lightGrayColor];
        return _headView;
    }
    return nil;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGPhotoShowCollectionViewCell *cell = [[JGPhotoShowCollectionViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGPhotoShowCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
    
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
    JGLUpdataPhotoController* upVc = [[JGLUpdataPhotoController alloc]init];
    [self.navigationController pushViewController:upVc animated:YES];
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
