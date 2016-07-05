//
//  JGHSetAwardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSetAwardViewController.h"
#import "JGHAddAwardImageCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHAwardModel.h"
#import "JGHAwardCell.h"
#import "JGHActivityBaseCell.h"
#import "JGHChooseAwardViewController.h"

static NSString *const JGHAddAwardImageCellIdentifier = @"JGHAddAwardImageCell";
static NSString *const JGHAwardCellIdentifier = @"JGHAwardCell";
static NSString *const JGHActivityBaseCellIdentifier = @"JGHActivityBaseCell";

@interface JGHSetAwardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *awardTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHSetAwardViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"奖项设置";
    
    [self createAwardTableView];
    
    
}
#pragma mark -- 下载数据
- (void)loadData{
    
}
#pragma mark -- 创建工具栏
#pragma mark -- 创建TB
- (void)createAwardTableView{
    self.awardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.awardTableView.delegate = self;
    self.awardTableView.dataSource = self;
    
    UINib *addAwardImageCellNib = [UINib nibWithNibName:@"JGHAddAwardImageCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:addAwardImageCellNib forCellReuseIdentifier:JGHAddAwardImageCellIdentifier];
    
    UINib *awardCellNib = [UINib nibWithNibName:@"JGHAwardCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:awardCellNib forCellReuseIdentifier:JGHAwardCellIdentifier];
    
    UINib *activityBaseCellNib = [UINib nibWithNibName:@"JGHActivityBaseCell" bundle: [NSBundle mainBundle]];
    [self.awardTableView registerNib:activityBaseCellNib forCellReuseIdentifier:JGHActivityBaseCellIdentifier];
    
    self.awardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.awardTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.awardTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 2 + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 84 * ProportionAdapter;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            return 45 * ProportionAdapter;
        }else{
            return 110 * ProportionAdapter;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHActivityBaseCell *activityBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityBaseCellIdentifier];
        
        return activityBaseCell;
    }else{
        if (indexPath.section == _dataArray.count + 1) {
            JGHAddAwardImageCell *addAwardImageCell = [tableView dequeueReusableCellWithIdentifier:JGHAddAwardImageCellIdentifier];
            [addAwardImageCell configAddAwardImageName:@"tianjiaanniu" andTiles:@"添加奖项"];
            return addAwardImageCell;
        }else{
            JGHAwardCell *awardCell = [tableView dequeueReusableCellWithIdentifier:JGHAwardCellIdentifier];
            return awardCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (indexPath.section == _dataArray.count + 1) {
            NSLog(@"添加奖项");
            JGHChooseAwardViewController *chooseAwardCtrl = [[JGHChooseAwardViewController alloc]init];
            [self.navigationController pushViewController:chooseAwardCtrl animated:YES];
        }
    }
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
