//
//  AreaViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AreaViewController.h"
#import "PostDataRequest.h"
#import "Helper.h"

#import "BallParkModel.h"

#define kBallPark_URL @"ballInfo/queryPage.do"


@interface AreaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _numArray;
    BOOL _isClick;
    UITextField *_textField;
    
    NSInteger _page;
}

@end

@implementation AreaViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //发出通知隐藏标签栏
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.title = @"地区选择";
    //搜索栏
    [self createSeachBar];
    //表
    [self createTableView];
    
    
}

-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 5, ScreenWidth-80*ScreenWidth/375, 27)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius=13;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 7, 16*ScreenWidth/375, 16);
    [imageView addSubview:imageView2];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 26)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    [_textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入类别或关键字";
    _textField.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [imageView addSubview:_textField];
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3, 60*ScreenWidth/375, 30);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
-(void)keyboardDown3:(UITextField *)tf{
    
}
-(void)seachBtnClick{
    [_textField resignFirstResponder];
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:88];
    UITextField *tf=(UITextField *)[imageView viewWithTag:888];
    if ([self isBlankString:tf.text]==NO) {
        
        _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing1)];
//        _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing1)];
        [_tableView.mj_header beginRefreshing];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"123" message:@"请填写搜索信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
-(BOOL)isBlankString:(NSString *)string{
    if (string==nil||string==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


-(void)createTableView
{
    _dataArray = [[NSMutableArray alloc]init];
    _numArray = [[NSMutableArray alloc]init];
    //    _dataArray = @[@"XXX球场",@"QQQQ球场",@"WWWW球场",@"上海汤臣高尔夫球场",@"qerq球场",@"XXX球场",@"QQQQ球场",@"WWWW球场",@"上海汤臣高尔夫球场",@"qerq球场"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, ScreenHeight-37-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing1)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing1)];
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:kBallPark_URL parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@15,@"ballName":_textField.text} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_numArray removeAllObjects];
            }
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
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
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
    return 44*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isClick == NO)
    {
        //点击事件选中后传值
        _callback(_dataArray[indexPath.row],[_numArray[indexPath.row] integerValue]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
