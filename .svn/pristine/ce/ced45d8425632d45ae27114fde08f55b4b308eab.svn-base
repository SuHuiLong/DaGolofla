//
//  ScreenViewController.m
//  DagolfLa
//
//  Created by 東 on 16/3/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ScreenViewController.h"
#import "ScreenTableViewCell.h"

@interface ScreenViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *array;

@end

@implementation ScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20*ScreenWidth/375 * 2 + 44*ScreenWidth/375 * 5) style:(UITableViewStylePlain)];
    [self.view addSubview: self.tableView];
    self.title = @"通知消息";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44*ScreenWidth/375;
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    
    self.array = [NSArray arrayWithObjects:@"约球消息", @"球队消息", @"悬赏消息", @"赛事消息",  nil];
    // Do any additional setup after loading the view.
}


// tableView 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [self.array count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *identifier = @"identifier";
    ScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ScreenTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    [cell.mySwitch addTarget:self action:@selector(mySwitchAc:) forControlEvents:(UIControlEventValueChanged)];
    if (indexPath.section == 0) {
        cell.myLabel.text = @"拒绝接受所有消息";

        return cell;
    }else{
        cell.myLabel.text = self.array[indexPath.row];
        return cell;
    }
    
}

- (void)mySwitchAc: (UISwitch *)mySwitch{
    
}

//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    CGFloat height = 0;
    //    if (section != 0) {
    //        height = 10*ScreenWidth/375;
    //    }
    return 20*ScreenWidth/375;
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
