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

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGLMyTeamTableViewCellIdentifier = @"JGLMyTeamTableViewCell";

@interface JGHShowMyTeamViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *showMyTeamTableView;

@end

@implementation JGHShowMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.showMyTeamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
    
    UINib *teamActivityCellNib = [UINib nibWithNibName:@"JGTeamActivityCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:teamActivityCellNib forCellReuseIdentifier:JGTeamActivityCellIdentifier];
    
    [self.showMyTeamTableView registerClass:[JGLMyTeamTableViewCell class] forCellReuseIdentifier:JGLMyTeamTableViewCellIdentifier];
    
    self.showMyTeamTableView.dataSource = self;
    self.showMyTeamTableView.delegate = self;
    self.showMyTeamTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.showMyTeamTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.showMyTeamTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.showMyTeamTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return _dataArray.count +1;
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2){
        //热门球队
        return 1;
    }
    return 1;
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
