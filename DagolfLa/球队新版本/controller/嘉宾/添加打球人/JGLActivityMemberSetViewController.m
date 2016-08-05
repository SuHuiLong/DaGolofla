//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActivityMemberSetViewController.h"
#import "PYTableViewIndexManager.h"
#import "JGLGuestAddPlayerViewController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "MyattenModel.h"
#import "NoteModel.h"
#import "NoteHandlle.h"

#import "JGLAddActiivePlayModel.h"
#import "JGLGuestActiveMemberTableViewCell.h"
@interface JGLActivityMemberSetViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    
    
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGLActivityMemberSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择打球人";
    
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    [self uiConfig];
    //    [self createHeadSearch];
    [self createBtn];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
    [_tableView reloadData];
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(40*screenWidth/375, 12*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
    imgv.image = [UIImage imageNamed:@"addGes"];
    [btn addSubview:imgv];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth-40*screenWidth/375, 24*screenWidth/375)];
    label.font = [UIFont systemFontOfSize:16*screenWidth/375];
    label.textColor = [UIColor whiteColor];
    label.text = @"添加意向成员(便于预先分组)";
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    
}

-(void)finishClick
{
    JGLGuestAddPlayerViewController* addVc = [[JGLGuestAddPlayerViewController alloc]init];
    addVc.teamKey = _teamKey;
    addVc.activityKey = _activityKey;
    addVc.blockRefresh = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:addVc animated:YES];
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-15*screenWidth/375 - 54*screenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLGuestActiveMemberTableViewCell class] forCellReuseIdentifier:@"JGLGuestActiveMemberTableViewCell"];
    _tableView.tag = 1001;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    //    [dict setObject:[NSNumber numberWithInteger:] forKey:@"activityKey"];
    [dict setObject:_activityKey forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [dict setObject:_teamKey forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:[_teamKey integerValue] activityKey:[_activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if (_page == 0)
        {
            //清除数组数据  signUpInfoKey
            [_dataArray removeAllObjects];
        }
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                JGLAddActiivePlayModel *model = [[JGLAddActiivePlayModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //                [model setValue:[dict objectForKey:@"name"] forKey:@"userName"];
                model.userName = model.name;
                [_dataArray addObject:model];
            }
            self.listArray = [[NSMutableArray alloc]initWithArray:[PYTableViewIndexManager archiveNumbers:_dataArray]];
            
            _keyArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.listArray.count-1; i>=0; i--) {
                if ([self.listArray[i] count] == 0) {
                    [self.keyArray removeObjectAtIndex:i];
                    [self.listArray removeObjectAtIndex:i];
                }
            }
            [_tableView reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 1001 ? 50*ScreenWidth/375 : 40*ScreenWidth/375;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 1001 ?[self.listArray[section] count] : 4;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableView.tag == 1001 ?[self.listArray count] : 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1001) {
        if ([self.listArray[section] count] == 0) {
            return nil;
        }else{
            return self.keyArray[section];
        }
    }
    else{
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLGuestActiveMemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLGuestActiveMemberTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JGLAddActiivePlayModel *model = self.listArray[indexPath.section][indexPath.row];
    cell.nameLabel.text = model.userName;
    [cell.iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[model.userKey integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    cell.iconImgv.layer.cornerRadius = cell.iconImgv.frame.size.height/2;
    cell.iconImgv.layer.masksToBounds = YES;
    
    cell.mobileLabel.text = [self.listArray[indexPath.section][indexPath.row]mobile];
    
    if ([model.signUpInfoKey integerValue] == 0) {
        cell.moneyLabel.text = @"意向成员";
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#7fc1ff"];
    }
    else{
        NSString* strMoney = [NSString stringWithFormat:@"已付¥%@",model.payMoney];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strMoney];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e00000"] range:NSMakeRange(2, strMoney.length-2)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
        cell.moneyLabel.attributedText = attributedString;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}



// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1001) {
        //  改变索引颜色
        _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
        NSInteger number = [_listArray count];
        return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    }
    else{
        return nil;
    }
    
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView.tag == 1001) {
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        
        if (![_listArray[index] count]) {
            
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    }
    else
    {
        return 0;
    }
    
}


@end
