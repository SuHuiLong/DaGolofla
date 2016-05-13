//
//  JGTeamChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelViewController.h"
#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"
#import "JGTeamDetailViewController.h"
#import "JGCreateTeamViewController.h"
#import "JGTeamDetailStylelTwoViewController.h"

#import "JGTeamPhotoViewController.h"
#import "JGLMyTeamViewController.h"
@interface JGTeamChannelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIScrollView *topView;

@property (nonatomic, strong)JGTeamChannelTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *buttonArray;

@end

@implementation JGTeamChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];

    self.topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130 * screenWidth / 320)];
    self.topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.topView];
    self.buttonArray = [NSMutableArray arrayWithObjects:@"我的球队", @"球队活动", @"球队大厅", nil];

    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, (135 + i * 35) * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
        button.tag = 200 + i;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:self.buttonArray[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   
        [self.view addSubview:button];
    }
    
    self.tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 270 * screenWidth / 320, screenWidth, (screenHeight - 270 - 64) * screenWidth / 320) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.rowHeight = 83 * screenWidth / 320;
//    self.dataArray = [NSMutableArray arrayWithObjects:@"1我的球队", @"1球队活动", @"1球队大厅", nil];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 240 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
    if ([self.dataArray count] != 0) {
        titleLB.text = @" 近期活动";
    }else{
        titleLB.text = @" 推荐球队";
    }
    
    [self.view addSubview:titleLB];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)team:(UIButton *)button{
    
    if (button.tag == 200) {
        JGLMyTeamViewController* myVc = [[JGLMyTeamViewController alloc]init];
        [self.navigationController pushViewController:myVc animated:YES];
    }else if (button.tag == 201) {
        JGTeamPhotoViewController* phoVc = [[JGTeamPhotoViewController alloc]init];
        [self.navigationController pushViewController:phoVc animated:YES];
    }else if (button.tag == 202) {
        
        JGCreateTeamViewController *creatTeamVC = [[JGCreateTeamViewController alloc] init];
        [self.navigationController pushViewController:creatTeamVC animated:YES];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.buttonArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArray count] != 0) {
        JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.nameLabel.text = self.dataArray[indexPath.row];
        cell.adressLabel.text = @"测试数据 Test";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellActivity"];
        cell.nameLabel.text = self.buttonArray[indexPath.row];
        cell.adressLabel.text = @"测试数据 Test";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGTeamDetailStylelTwoViewController *detailV = [[JGTeamDetailStylelTwoViewController alloc] init];
    [self.navigationController pushViewController:detailV animated:YES];
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
