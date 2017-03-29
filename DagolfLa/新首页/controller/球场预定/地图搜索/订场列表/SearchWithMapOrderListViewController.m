//
//  SearchWithMapOrderListViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithMapOrderListViewController.h"
#import "JGDCourtModel.h"
#import "JGDBookCourtTableViewCell.h"
#import "JGDCourtDetailViewController.h"
@interface SearchWithMapOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

//tableView
@property(nonatomic,strong)UITableView *mainTableView;
//数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SearchWithMapOrderListViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setTintColor:WhiteColor];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];


}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createTableView];
}

//创建tableview
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView setExtraCellLineHidden];
    [self.view addSubview:mainTableView];
    [mainTableView registerClass:[JGDBookCourtTableViewCell class] forCellReuseIdentifier:@"bookCourtCell"];
    _mainTableView = mainTableView;
}

#pragma mark - initData
-(void)initData{
    //md5 加密
    NSString *md5 = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&ballKey=%@dagolfla.com", DEFAULF_USERID,_ballKey]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"ballKey":_ballKey,
                           @"md5":md5,
                           };

    NSString *latitudeStr = [NSString stringWithFormat:@"%f",_userCoord.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",_userCoord.longitude];
    
    if (latitudeStr.length>0) {
        dict = @{
                 @"userKey":DEFAULF_USERID,
                 @"ballKey":_ballKey,
                 @"md5":md5,
                 @"longitude":longitudeStr,
                 @"latitude":latitudeStr,
                 };
    }
    [[JsonHttp jsonHttp] httpRequest:@"bookball/getBookingOrderListByBallKey" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
    
    } completionBlock:^(id data) {
        if ([data objectForKey:@"list"]) {
            for (NSDictionary *dic in [data objectForKey:@"list"]) {
                JGDCourtModel *model = [[JGDCourtModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.mainTableView reloadData];
    }];
}


#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWvertical(90);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JGDBookCourtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCourtCell"];
    
    cell.model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDCourtDetailViewController *courtVC = [[JGDCourtDetailViewController alloc] init];
    courtVC.timeKey = [self.dataArray[indexPath.row] timeKey];
    [self.navigationController pushViewController:courtVC animated:YES];

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
