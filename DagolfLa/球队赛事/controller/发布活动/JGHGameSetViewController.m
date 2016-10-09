//
//  JGHGameSetViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetViewController.h"
#import "JGHGameSetCell.h"

static NSString *const JGHGameSetCellIdentifier = @"JGHGameSetCell";

@interface JGHGameSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *gameSetTableView;

@end

@implementation JGHGameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"玩法设置";
    
    
    [self createGameSetTableView];
}

- (void)createGameSetTableView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 45 *ProportionAdapter)];
    UILabel *catoryLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 20 *ProportionAdapter, screenWidth - 20 *ProportionAdapter, 21 *ProportionAdapter)];
    catoryLable.text = @"选择你的比赛类型";
    catoryLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    [headerView addSubview:catoryLable];
    
    self.gameSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    self.gameSetTableView.tableHeaderView = headerView;
    
    UINib *gameSetCellNib = [UINib nibWithNibName:@"JGHGameSetCell" bundle: [NSBundle mainBundle]];
    [self.gameSetTableView registerNib:gameSetCellNib forCellReuseIdentifier:JGHGameSetCellIdentifier];

    self.gameSetTableView.dataSource = self;
    self.gameSetTableView.delegate = self;
    self.gameSetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameSetTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    [self.view addSubview:self.gameSetTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if ([[[self.queryTimeSortedArray objectAtIndex:section]objectForKey:@"key_state"]boolValue])
    {
        NSInteger counnnt = [[[self.queryTimeSortedArray objectAtIndex:section]objectForKey:@"key_array"] count];
        return counnnt;
    }
    else{
        return 0;
    }
     */
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *backCellID = @"backCellID";
//    BackOrderDetailsTableViewCell *backCell = [tableView dequeueReusableCellWithIdentifier:backCellID];
//    if (backCell == nil) {
//        backCell = [[[NSBundle mainBundle]loadNibNamed:@"BackOrderDetailsTableViewCell" owner:self options:nil]lastObject];
//    }
//    //取消选中效果
//    backCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    backCell.delegate = self;
//    backCell.selectBtn.tag = indexPath.row + indexPath.section * 1000;
//    backCell.endorseTheBackBtn.tag = indexPath.row + indexPath.section * 10000;
//    if (self.submitCount == 1) {
//        [backCell.selectBtn setTitle:@"预定" forState:UIControlStateNormal];
//    }
//    
//    FlightBaseListModel *listModel = [[FlightBaseListModel alloc]init];
//    
//    if (isSelectTimeSortedBarBtnTag == 0) {
//        NSDictionary *dict = [self.arraySubDatas objectAtIndex:indexPath.section];
//        NSArray *array = [dict objectForKey:@"key_array"];
//        listModel = array[indexPath.row];
//    }else if (isSelectTimeSortedBarBtnTag == 1 || isSelectTimeSortedBarBtnTag == 2 || isSelectTimeSortedBarBtnTag == 3){
//        NSDictionary *dict = [self.queryTimeSortedArray objectAtIndex:indexPath.section];
//        NSArray *array = [dict objectForKey:@"key_array"];
//        listModel = array[indexPath.row];
//    }else if (isSelectTimeSortedBarBtnTag == 5 || isSelectTimeSortedBarBtnTag == 4){
//        if (self.screenToArray.count != 0) {
//            NSDictionary *dict = [self.screenToArray objectAtIndex:indexPath.section];
//            NSArray *array = [dict objectForKey:@"key_array"];
//            listModel = array[indexPath.row];
//        }else{
//            NSDictionary *dict = [self.queryTimeSortedArray objectAtIndex:indexPath.section];
//            NSArray *array = [dict objectForKey:@"key_array"];
//            listModel = array[indexPath.row];
//        }
//    }
//    
//    [backCell config:listModel];
//    return backCell;
    
    JGHGameSetCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameSetCellIdentifier];
    
    return gameSetCell;
}

//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHGameSetCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameSetCellIdentifier];
    
    return gameSetCell;
}

//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30 *ProportionAdapter;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44 *ProportionAdapter;
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
