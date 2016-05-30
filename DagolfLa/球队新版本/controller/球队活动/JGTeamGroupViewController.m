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

@interface JGTeamGroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JGGroupdetailsCollectionViewCellDelegate, JGHTeamMembersViewControllerDelegate>
{
    NSInteger _collectionHegith;
    
    NSInteger _groupDetailsCollectionViewCount;//cell的个数,默认0
}

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionView *groupDetailsCollectionView;

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;//未分组数据

@property (nonatomic, strong)NSMutableArray *alreadyDataArray;//已分组数据

@property (nonatomic, assign)NSInteger newTeamKey;

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
    _groupDetailsCollectionViewCount = 0;
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
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamActivityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [self.alreadyDataArray removeAllObjects];
        [self.teamGroupAllDataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data count] == 2) {
                [Helper alertViewNoHaveCancleWithTitle:@"暂无报名信息！" withBlock:^(UIAlertController *alertView) {
                   [self.navigationController presentViewController:alertView animated:YES completion:^{
                       
                   }];
                }];
                
                return ;
            }
        }
        
        NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
        _groupDetailsCollectionViewCount = [dataArray count];
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
        if (_groupDetailsCollectionViewCount%4 == 0) {
            return _groupDetailsCollectionViewCount/4;
        }else{
            return _groupDetailsCollectionViewCount/4 + 1;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    collectionView.tag = indexPath.item;
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
//        NSLog(@"%ld", (long)indexPath.item);
//        NSLog(@"%ld", (long)groupCell.tag);
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
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDef objectForKey:TeamMember];
    if ([str rangeOfString:@"1001"].location != NSNotFound) {
        //管理员 -- 进入球队列表页码
        JGHTeamMembersViewController *teamMemberCtrl = [[JGHTeamMembersViewController alloc]init];
        NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.alreadyDataArray];
        [listArray addObjectsFromArray:self.teamGroupAllDataArray];
        teamMemberCtrl.teamGroupAllDataArray = listArray;
        teamMemberCtrl.delegate = self;
        //组号
        teamMemberCtrl.groupIndex = cell.tag;
        //排序索引
        teamMemberCtrl.sortIndex = btn.tag;
        // 老的球队活动报名人timeKey
        //获取老球员
        for (JGHPlayersModel *model in self.alreadyDataArray) {
            if (model.groupIndex == cell.tag) {
                if (model.sortIndex == btn.tag) {
                    teamMemberCtrl.oldSignUpKey = model.timeKey;
                }
            }else{
                teamMemberCtrl.oldSignUpKey = 0;
            }    
        }
        
        [self.navigationController pushViewController:teamMemberCtrl animated:YES];
    }else{

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSLog(@"%@", [userDef objectForKey:TeamMember]);
            [dict setObject:@0 forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
            [dict setObject:[NSString stringWithFormat:@"%td", _newTeamKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)cell.tag] forKey:@"groupIndex"]; // 组号
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)btn.tag] forKey:@"sortIndex"]; // 排序索引
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"是否加入改组！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

#pragma mark -- 更新组
- (void)updateTeamActivityGroupIndex:(NSMutableDictionary *)dict{
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityGroupIndex" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errtype === %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data === %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//            for (int i=0; i<_teamGroupAllDataArray.count; i++) {
//                JGHPlayersModel *model = _teamGroupAllDataArray[i];
//                if ((long)model.timeKey == (long)[[dict objectForKey:@"newSignUpKey"] integerValue]) {
//                    [self.teamGroupAllDataArray removeObject:model];
//                    [self.alreadyDataArray addObject:model];
//                }
//            }
            
            [self loadData];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"已分组成功!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
#pragma mark -- 管理员替换队员与分配队员代理
- (void)didSelectMembers:(NSMutableDictionary *)dict{
    [self updateTeamActivityGroupIndex:dict];
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
