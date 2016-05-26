//
//  JGTeamGroupViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamGroupViewController.h"
#import "JGTeamGroupCollectionViewCell.h"
#import "JGMenberTableViewCell.h"
#import "JGGroupdetailsCollectionViewCell.h"
#import "JGHTeamMembersViewController.h"
#import "JGHPlayersModel.h"

static NSString *const JGTeamGroupCollectionViewCellIdentifier = @"JGTeamGroupCollectionViewCell";
static NSString *const JGGroupdetailsCollectionViewCellIdentifier = @"JGGroupdetailsCollectionViewCell";

@interface JGTeamGroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JGGroupdetailsCollectionViewCellDelegate>
{
    NSInteger _collectionHegith;
}

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionView *groupDetailsCollectionView;

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;//未分组数据

@property (nonatomic, strong)NSMutableArray *alreadyDataArray;//一分组数据

@end

@implementation JGTeamGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动分组";
    
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:view];
    //待分组label
    self.teamGroupAllDataArray = [NSMutableArray array];
    self.alreadyDataArray = [NSMutableArray array];
    
    UILabel *waitGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, screenWidth, 25)];
    waitGroupLabel.text = @"未分组";
    waitGroupLabel.textAlignment = NSTextAlignmentLeft;
    waitGroupLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:waitGroupLabel];

    if (iPhone5) {
        _collectionHegith = 200;
    }else{
        _collectionHegith = screenHeight/3-20;
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25, screenWidth, _collectionHegith)
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"JGTeamGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGTeamGroupCollectionViewCellIdentifier];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    //好友分组label
    UILabel *groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.collectionView.frame.size.height+waitGroupLabel.frame.size.height+5, screenWidth, 25)];
    groupLabel.text = @"好友分组";
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:groupLabel];
    //4方格
    UICollectionViewFlowLayout *gridlayout = [UICollectionViewFlowLayout new];
    gridlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.groupDetailsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, groupLabel.frame.origin.y + groupLabel.frame.size.height, screenWidth, screenHeight - groupLabel.frame.size.height-groupLabel.frame.origin.y - 64) collectionViewLayout:gridlayout];
    self.groupDetailsCollectionView.backgroundColor = [UIColor whiteColor];
    self.groupDetailsCollectionView.dataSource = self;
    self.groupDetailsCollectionView.delegate = self;
    [self.groupDetailsCollectionView registerNib:[UINib nibWithNibName:@"JGGroupdetailsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGGroupdetailsCollectionViewCellIdentifier];
    [self.view addSubview:self.groupDetailsCollectionView];
    
    [self loadData];
}
#pragma mark -- 获取报名人员列表信息
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@206 forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
        for (NSDictionary *dict in dataArray) {
            JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if (model.groupIndex == -1) {
                //为分组
                [self.teamGroupAllDataArray addObject:model];
            }else{
                //已经分组
                [self.alreadyDataArray addObject:model];
            }
            
        }
        
        [self.collectionView reloadData];
        [self.groupDetailsCollectionView reloadData];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        return CGSizeMake((screenWidth - 50)/5, (_collectionHegith - 20)/2);
    }else{
        return CGSizeMake(screenWidth/2 - 10, screenWidth/2 - 10);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.collectionView]) {
        return _teamGroupAllDataArray.count;
    }else{
        return 30;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionView.tag = indexPath.item;
    if ([collectionView isEqual:self.collectionView]) {
        JGTeamGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGTeamGroupCollectionViewCellIdentifier forIndexPath:indexPath];
        JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
        model = self.teamGroupAllDataArray[indexPath.item];
        [cell configJGHPlayersModel:model];
        return cell;
    }else{
        JGGroupdetailsCollectionViewCell *groupCell = [collectionView dequeueReusableCellWithReuseIdentifier:JGGroupdetailsCollectionViewCellIdentifier forIndexPath:indexPath];
        groupCell.delegate = self;
        groupCell.tag = indexPath.item;
//        groupCell.sction1.tag = indexPath.item*1000 + indexPath.;
//        JGHPlayersModel *model = [[JGHPlayersModel alloc]init];
        if (_alreadyDataArray.count !=0) {
//            model = _alreadyDataArray[indexPath.item];
//            [groupCell configJGHPlayersModel:model andSortIndex:indexPath.item];
            [groupCell configCellWithModelArray:_alreadyDataArray];
        }
        
        return groupCell;
    }
}
#pragma mark -- 点击头像图片的代理方法JGGroupdetailsCollectionViewCellDelegate
- (void)didSelectHeaderImage:(UIButton *)btn JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@0 forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
        [dict setObject:@278 forKey:@"oldSignUpKey"]; // 新的球队活动报名人timeKey
//        [dict setObject:<#(nonnull id)#> forKey:@"groupIndex"];// 组号
//        [dict setObject:<#(nonnull id)#> forKey:@"sortIndex"];
//        @Param(value = "newSignUpKey", require=true) Long     newSignUpKey,   // 新的球队活动报名人timeKey
//        @Param(value = "groupIndex", require=true)Integer     groupIndex,     // 组号
//        @Param(value = "sortIndex", require=true) Integer     sortIndex,      // 排序索引
        
//        [JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityGroupIndex" JsonKey:nil withData:<#(NSDictionary *)#> requestMethod:<#(NSString *)#> failedBlock:<#^(id errType)failedBlock#> completionBlock:<#^(id data)completionBlock#>
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"是否加入改组！" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:commitAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    //非管理员
    
//    JGHTeamMembersViewController *teamMemberCtrl = [[JGHTeamMembersViewController alloc]init];
//    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
//    //    if ([[userdef objectForKey:isAdmin]isEqualToString:@"1"]) {
//    //代表管理员
//    teamMemberCtrl.teamGroupAllDataArray = self.teamGroupAllDataArray;
//    //    }
//    
//    
//    [self.navigationController pushViewController:teamMemberCtrl animated:YES];
    
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
