//
//  BallChooseViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BallChooseViewController.h"


#import "PostDataRequest.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "Helper.h"
#import "BallParkModel.h"
#import "YuePostViewController.h"

#define kBallPark_URL @"ballInfo/queryPage.do"

@interface BallChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _numArray;
    UITextField *_textField;
    NSInteger _page;
}
@end

@implementation BallChooseViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor=[UIColor greenColor];
    
    
    [self createTableView];
    
    [self createDaoHangTiao];
    
}

-(void)createTableView
{
    
    _dataArray = [[NSMutableArray alloc]init];
    _numArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, self.view.frame.size.height-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing1)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing1)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:kBallPark_URL parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@15,@"ballName":_textField.text} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                BallParkModel *model = [[BallParkModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model.ballName];
                [_numArray addObject:model.ballId];
            }
            _page++;
            [_tableView reloadData];
            

        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark - 下拉刷新
-(void)headerRefreshing1{
    _page=1;
    [self downLoadData:_page isReshing:YES];
}
#pragma mark - 上拉刷新
-(void)footerRefreshing1{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark --tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.row];//表示这个数组里买呢有多少区。区里面有多少行
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.navigationController popViewControllerAnimated:YES];
}



-(void)createDaoHangTiao{
    UIView *dao=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    dao.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:dao];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(10, 27, 30, 30);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.tintColor=[UIColor lightGrayColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    view.frame=CGRectMake(60, 27, ScreenWidth-130, 30);
    [self.view addSubview:view];
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:15.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    _textField=[[UITextField alloc] initWithFrame:CGRectMake(67.5, 28, ScreenWidth-145, 28)];
    _textField.tag=1000;
    _textField.text=_seachText;
    [self.view addSubview:_textField];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(ScreenWidth-50, 20, 50, 44);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(seachButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)backButtonClick{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)seachButtonClick{
    UITextField *tf=(UITextField *)[self.view viewWithTag:1000];
    _seachText=tf.text;
    
}

@end
