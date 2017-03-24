//
//  MakePhotoTextSelectHeaderViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextSelectHeaderViewController.h"
#import "MakePhotoTextViewController.h"
#import "MakePhotoTextViewModel.h"
#import "MSSCollectionViewCell.h"
#import "MakePhotoTextSelectFromAllViewController.h"
@interface MakePhotoTextSelectHeaderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    UICollectionView *_collectionView;
}

@end

@implementation MakePhotoTextSelectHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavagationView];
    [self createCollectionView];
    [self createSelectFromAll];
}
//创建上导航
-(void)createNavagationView{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.title = @"选择封面";

}
//创建colletionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5 , 5 , 5 , 5 );
    flowLayout.itemSize = CGSizeMake((screenWidth - 20)/3, (screenWidth - 20)/3);
    flowLayout.minimumLineSpacing = 5 ;
    flowLayout.minimumInteritemSpacing = 5 ;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 ) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //cell注册
    [_collectionView registerClass:[MSSCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
}
//从所有中选择按钮
-(void)createSelectFromAll{
    //从所有中选择按钮
    UIButton *selectFromAllBtn = [Factory createButtonWithFrame:CGRectMake(0, screenHeight - 64 - kHvertical(51), screenWidth, kHvertical(51)) titleFont:kHorizontal(18) textColor:RGB(50,177,77)  backgroundColor:WhiteColor target:self selector:@selector(selectFromAll) Title:@"从所有照片中选择"];

    [self.view addSubview:selectFromAllBtn];
    
    
}

#pragma mark - initData

#pragma mark - Action
//左按钮点击
-(void)leftBtnClick{

    [self.navigationController popViewControllerAnimated:YES];
}
//从所有中选择按钮点击
-(void)selectFromAll{
    __weak typeof(self) weakself = self;
    MakePhotoTextSelectFromAllViewController *vc = [[MakePhotoTextSelectFromAllViewController alloc] init];
    vc.teamTimeKey = _teamTimeKey;
    [vc SetSelectPhotoBlock:^(NSMutableArray *mArray) {
        [weakself blockPopBack:mArray[0][0]];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//block返回
-(void)blockPopBack:(NSNumber *)timeKey{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MakePhotoTextViewController class]]) {
            [self.navigationController popToViewController:vc animated:false];
            if (_selectBlock!=nil) {
                _selectBlock(timeKey);
            }
            return;
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - ClollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCollectionViewCell" forIndexPath:indexPath];
    if (cell)
    {
        JGPhotoListModel *model = self.dataArray[indexPath.item];
        [cell configModel:model];
        cell.imageView.tag = indexPath.item + 100;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JGPhotoListModel *model = self.dataArray[indexPath.item];
    if (model.isSelect) {
        model.isSelect = false;
        [self.dataArray replaceObjectAtIndex:indexPath.item withObject:model];
        [_collectionView reloadData];
    }else{
        for (int i =0; i<self.dataArray.count; i++) {
            JGPhotoListModel *Model = self.dataArray[i];
            if (Model.isSelect) {
                Model.isSelect = false;
            }
            [self.dataArray replaceObjectAtIndex:i withObject:Model];
        }
        model.isSelect = true;
        [self.dataArray replaceObjectAtIndex:indexPath.item withObject:model];
        [_collectionView reloadData];
        [self blockPopBack:model.timeKey];
    }
}

//设置block
-(void)setSelectHeaderImageBlock:(selectHeaderImageBlock)selectBlock{
    self.selectBlock = selectBlock;
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
