//
//  BallParkViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BallParkViewController.h"

#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "Helper.h"
#import "BallParkModel.h"

#define kBallPark_URL @"ballInfo/queryPage.do"


@interface BallParkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    BOOL _isClick;
    UITextField *_textField;
    
    NSInteger _page;
}

@end

@implementation BallParkViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区选择";
    
    _page = 1;
    //搜索栏
    [self createSeachBar];
    //表
    [self createTableView];
    
    
}

-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 4*ScreenWidth/375, ScreenWidth-80*ScreenWidth/375, 36*ScreenWidth/375)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius = 15*ScreenWidth/375;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375);
    [imageView addSubview:imageView2];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0*ScreenWidth/375, ScreenWidth-115*ScreenWidth/375, 36*ScreenWidth/375)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    [_textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入类别或关键字";
    [imageView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 0*ScreenWidth/375, 60*ScreenWidth/375, 44*ScreenWidth/375);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
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
        
//        [_dataArray removeAllObjects];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_tableView.header beginRefreshing];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请填写搜索信息" FromView:self.view];
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, ScreenHeight-44*ScreenWidth/375-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@15 forKey:@"rows"];
    [dict setObject:_textField.text forKey:@"ballName"];
    [dict setObject:self.lat forKey:@"xIndex"];
    [dict setObject:self.lng forKey:@"yIndex"];
    [[PostDataRequest sharedInstance] postDataRequest:kBallPark_URL parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                BallParkModel *model = [[BallParkModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
//                [_numArray addObject:model.ballId];
            }
            _page++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
//        [_tableView reloadData];
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
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
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
    cell.textLabel.text = [_dataArray[indexPath.row] ballName];//表示这个数组里买呢有多少区。区里面有多少行
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNeedAdd == YES) {
        if (![Helper isBlankString:[_dataArray[indexPath.row] ballAddress]]) {
            _callbackAddress([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue],[_dataArray[indexPath.row] ballAddress]);
        }
        else{
            _callbackAddress([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue],[_dataArray[indexPath.row] ballName]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (_type1==0) {
            if (_isClick == NO)
            {
                //点击事件选中后传值
                _callback([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue]);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if (_isClick == NO)
            {
                [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":@([[_dataArray[indexPath.row] ballId] integerValue])} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"] integerValue] == 1) {
                        //点击事件选中后传值
                        _callback1([dict objectForKey:@"rows"]);
                        _callback([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue]);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [Helper alertViewWithTitle:@"球场整修中" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                } failed:^(NSError *error) {
                    
                }];
                
            }
        }
    }
    
}


@end
