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
    
    NSString *_power;//权限判断
    
    NSInteger _maxGroup;//当前分组数。。默认4
    
    UILabel *_waitGroupLabel;//待分组
}

@property (nonatomic, weak) UICollectionView *collectionView;//上列表

@property (nonatomic, strong) UICollectionView *groupDetailsCollectionView;//下列表

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;//未分组数据

@property (nonatomic, strong)NSMutableArray *alreadyDataArray;//已分组数据

@property (nonatomic, assign)NSInteger newTeamKey;

@end

@implementation JGTeamGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"活动分组";
    
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:view];
    //待分组label
    self.teamGroupAllDataArray = [NSMutableArray array];
    self.alreadyDataArray = [NSMutableArray array];
    _groupDetailsCollectionViewCount = 0;
    _waitGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 30)];
    _waitGroupLabel.text = @"待分组";
    _waitGroupLabel.backgroundColor = [UIColor whiteColor];
    _waitGroupLabel.textAlignment = NSTextAlignmentLeft;
    _waitGroupLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_waitGroupLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, screenWidth - 20, 1)];
    lineLabel.backgroundColor = [UIColor redColor];
    [_waitGroupLabel addSubview:lineLabel];
    
    _maxGroup = 4;

    if (iPhone5) {
        _collectionHegith = 200;
    }else{
        _collectionHegith = screenHeight/3-20;
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, screenWidth, _collectionHegith)
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"JGTeamGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGTeamGroupCollectionViewCellIdentifier];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    //提示语
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, collectionView.frame.size.height+_waitGroupLabel.frame.size.height+20, screenWidth, 12)];
    promptLabel.text = @"提示:点击任意“待添加”，实现自动分组";
    promptLabel.textColor = [UIColor colorWithHexString:Prompt_Color];
    promptLabel.backgroundColor = [UIColor colorWithHexString:BG_color];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:promptLabel];
    //好友分组label
    UILabel *groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.collectionView.frame.size.height+_waitGroupLabel.frame.size.height+30 + 10, screenWidth-90, 21)];
    groupLabel.text = @"好友分组";
    groupLabel.backgroundColor = [UIColor colorWithHexString:BG_color];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:groupLabel];
    //添加分组
    UIButton *addGroupBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 90, self.collectionView.frame.size.height+_waitGroupLabel.frame.size.height+30+10, 60, 21)];
    [addGroupBtn setTitle:@"添加分组" forState:UIControlStateNormal];
    addGroupBtn.layer.masksToBounds = YES;
    [addGroupBtn setTitleColor:[UIColor colorWithHexString:@"#7DDFFD"] forState:UIControlStateNormal];
    addGroupBtn.backgroundColor = [UIColor colorWithHexString:BG_color];
    addGroupBtn.layer.borderWidth = 1.0;
    addGroupBtn.layer.borderColor = [UIColor colorWithHexString:@"#7DDFFD"].CGColor;
    addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addGroupBtn addTarget:self action:@selector(addGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addGroupBtn];
    //4方格
    UICollectionViewFlowLayout *gridlayout = [UICollectionViewFlowLayout new];
    gridlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.groupDetailsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, groupLabel.frame.origin.y + groupLabel.frame.size.height + 10, screenWidth, screenHeight - groupLabel.frame.size.height-groupLabel.frame.origin.y - 64) collectionViewLayout:gridlayout];
    self.groupDetailsCollectionView.backgroundColor = [UIColor whiteColor];
    self.groupDetailsCollectionView.dataSource = self;
    self.groupDetailsCollectionView.delegate = self;
    [self.groupDetailsCollectionView registerNib:[UINib nibWithNibName:@"JGGroupdetailsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:JGGroupdetailsCollectionViewCellIdentifier];
    [self.view addSubview:self.groupDetailsCollectionView];
    
    
    [self loadData:0];
}
#pragma mark -- 添加分组
- (void)addGroupBtnClick:(UIButton *)btn{
    _maxGroup += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%td", _maxGroup] forKey:@"maxGroup"];
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamActivityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeamActivityMaxGroup" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        
        [self loadData:0];//刷新页面
    }];
}
#pragma mark -- 获取报名人员列表信息 1－表示分组
- (void)loadData:(NSInteger)fenzu{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamActivityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [self.alreadyDataArray removeAllObjects];
        [self.teamGroupAllDataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _power = [[data objectForKey:@"member"] objectForKey:@"power"];
            _maxGroup = [[data objectForKey:@"maxGroup"] integerValue];//获取分组数
        }else{
            [Helper alertViewNoHaveCancleWithTitle:@"暂无报名信息！" withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:^{
                }];
            }];
            
            return ;
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
        
        _waitGroupLabel.text = [NSString stringWithFormat:@"待分组:%ld(人)", (unsigned long)[self.teamGroupAllDataArray count]];
        
        if (fenzu == 1) {
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"已分组成功!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
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
        return _maxGroup;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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
        [groupCell configGroupName:@"dd"];
        if (_alreadyDataArray.count !=0) {
            [groupCell configCellWithModelArray:_alreadyDataArray];
        }
        
        return groupCell;
    }
}

#pragma mark -- 点击头像图片的代理方法JGGroupdetailsCollectionViewCellDelegate
- (void)didSelectHeaderImage:(UIButton *)btn JGGroupCell:(JGGroupdetailsCollectionViewCell *)cell{

    if ([_power containsString:@"1001"]) {
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
            NSLog(@"%ld", (long)cell.tag);
            NSLog(@"%ld", (long)model.groupIndex);
            if (model.groupIndex == cell.tag) {
                if (model.sortIndex == btn.tag) {
                    teamMemberCtrl.oldSignUpKey = model.timeKey;
                }
            }else{
                teamMemberCtrl.oldSignUpKey = -1;
            }    
        }
        
        [self.navigationController pushViewController:teamMemberCtrl animated:YES];
    }else{

        for (JGHPlayersModel *model in self.alreadyDataArray) {
            if (model.groupIndex == cell.tag) {
                if (model.sortIndex == btn.tag) {
                    [Helper alertViewNoHaveCancleWithTitle:@"该分组已被分组，如有疑问，请联系管理员！" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                    
                    return;
                }
            }
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (JGHPlayersModel *model in self.teamGroupAllDataArray) {
                if (model.userKey == [[userdef objectForKey:userID] integerValue]) {
                    [dict setObject:[NSString stringWithFormat:@"%td", model.timeKey] forKey:@"newSignUpKey"]; // 新的球队活动报名人timeKey
                }
            }
            
            [dict setObject:@-1 forKey:@"oldSignUpKey"];// 老的球队活动报名人timeKey
            
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)cell.tag] forKey:@"groupIndex"]; // 组号
            [dict setObject:[NSString stringWithFormat:@"%ld", (long)btn.tag] forKey:@"sortIndex"]; // 排序索引
            [self updateTeamActivityGroupIndex:dict];
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
            // 重新加载数据
            [self loadData:1];
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
