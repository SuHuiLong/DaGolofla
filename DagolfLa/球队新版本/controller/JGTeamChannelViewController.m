//
//  JGTeamChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelViewController.h"
#import "JGTeamChannelTableView.h"

@interface JGTeamChannelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIScrollView *topView;

@property (nonatomic, strong)JGTeamChannelTableView *tableView;
@property (nonatomic, strong)NSMutableArray *firstSectionArray;
@property (nonatomic, strong)NSMutableArray *secondSectionArray;

@end

@implementation JGTeamChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
    self.topView.backgroundColor = [UIColor orangeColor];

    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 130, screenWidth, 30);
    [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 130, screenWidth, screenHeight - 130) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.firstSectionArray = [NSMutableArray arrayWithObjects:@"我的球队", @"球队活动", @"球队大厅", nil];
    self.secondSectionArray = [NSMutableArray arrayWithObjects:@"1我的球队", @"1球队活动", @"1球队大厅", nil];
//    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)team:(UIButton *)button{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.firstSectionArray.count;
    }else if (section == 1){
        return self.secondSectionArray.count;
    }else{
        return 0;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"first"];
        cell.textLabel.text = self.firstSectionArray[indexPath.row];
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"second"];
    }
    return cell;
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
