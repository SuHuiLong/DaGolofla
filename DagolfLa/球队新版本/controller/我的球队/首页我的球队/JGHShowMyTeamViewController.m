//
//  JGHShowMyTeamViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowMyTeamViewController.h"
#import "JGTeamActivityCell.h"
#import "JGLMyTeamTableViewCell.h"
#import "JGHShowMyTeamHeaderCell.h"
#import "JGHAddMoreTeamTableViewCell.h"
#import "JGLMyTeamModel.h"

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGLMyTeamTableViewCellIdentifier = @"JGLMyTeamTableViewCell";
static NSString *const JGHShowMyTeamHeaderCellIdentifier = @"JGHShowMyTeamHeaderCell";
static NSString *const JGHAddMoreTeamTableViewCellIdentifier = @"JGHAddMoreTeamTableViewCell";

@interface JGHShowMyTeamViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowMyTeamHeaderCellDelegate, JGHAddMoreTeamTableViewCellDelegate>
{
    NSArray *_titleArray;
}
@property (nonatomic, strong)UITableView *showMyTeamTableView;

@property (nonatomic, strong)NSMutableArray *teamArray;

@end

@implementation JGHShowMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"球队部落";
    self.teamArray = [NSMutableArray array];
    
    _titleArray = @[@"我的球队", @"我的活动"];
    
    [self createHomeTableView];
    
    [self loadMyTeamList];
}
- (void)loadMyTeamList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
//            if (page == 0)
//            {
                //清除数组数据
//                [_dataArray removeAllObjects];
//            }
            //数据解析
            //            self.TeamArray = [data objectForKey:@"teamList"];
            for (NSDictionary *dataDic in [data objectForKey:@"teamList"]) {
                JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.teamArray addObject:model];
            }
            //            [self.TeamArray addObjectsFromArray:[data objectForKey:@"teamList"]];
//            _page++;
            [self.showMyTeamTableView reloadData];
        }else {
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
//        [_tableView reloadData];
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    }];
}
#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.showMyTeamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
    
    UINib *teamActivityCellNib = [UINib nibWithNibName:@"JGTeamActivityCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:teamActivityCellNib forCellReuseIdentifier:JGTeamActivityCellIdentifier];
    
    UINib *showMyTeamHeaderCellNib = [UINib nibWithNibName:@"JGHShowMyTeamHeaderCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:showMyTeamHeaderCellNib forCellReuseIdentifier:JGHShowMyTeamHeaderCellIdentifier];
    
    UINib *addMoreTeamTableViewCellNib = [UINib nibWithNibName:@"JGHAddMoreTeamTableViewCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:addMoreTeamTableViewCellNib forCellReuseIdentifier:JGHAddMoreTeamTableViewCellIdentifier];
    
    [self.showMyTeamTableView registerClass:[JGLMyTeamTableViewCell class] forCellReuseIdentifier:JGLMyTeamTableViewCellIdentifier];
    
    self.showMyTeamTableView.dataSource = self;
    self.showMyTeamTableView.delegate = self;
    self.showMyTeamTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.showMyTeamTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.showMyTeamTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.showMyTeamTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return _dataArray.count +1;
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;//我的球队
    }else if (section == 2){
        return 2;//我的活动
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 0;
    }
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        JGHAddMoreTeamTableViewCell *addMoreTeamTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHAddMoreTeamTableViewCellIdentifier];
        addMoreTeamTableViewCell.delegate = self;
        return addMoreTeamTableViewCell;
    }else{
        JGHShowMyTeamHeaderCell *showMyTeamHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHShowMyTeamHeaderCellIdentifier];
        showMyTeamHeaderCell.delegate = self;
        [showMyTeamHeaderCell configJGHShowMyTeamHeaderCell:_titleArray[section] andSection:section];
        return showMyTeamHeaderCell;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLMyTeamTableViewCell *myTeamTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGLMyTeamTableViewCellIdentifier];
        
        return myTeamTableViewCell;
    }else{
        JGTeamActivityCell *teamActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityCellIdentifier];
        
        return teamActivityCell;
    }
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 *ProportionAdapter;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 *ProportionAdapter;
}
#pragma mark -- 嘉宾通道
- (void)didSelectGuestsBtn:(UIButton *)guestbtn{
    NSLog(@"嘉宾通道");
    
}

#pragma mark -- 添加更多球队
- (void)didSelectAddMoreBtn:(UIButton *)btn{
    NSLog(@"添加更多球队");
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
