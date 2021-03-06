//
//  JGActivityMemNonMangerViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.5429
//

#import "JGDActivityListViewController.h"
#import "JGDactivityListTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"

#import "JGDActivityList.h"
#import "JGHAwardModel.h"

@interface JGDActivityListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableString *_signupKeyInfo;//key,拼接
    NSMutableString *_signupNameInfo;//name,拼接
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sumCount;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation JGDActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"成员列表";
    
    _signupKeyInfo =[NSMutableString stringWithString:@""];
    _signupNameInfo =[NSMutableString stringWithString:@""];
    
    if ([[_checkdict allKeys]containsObject:@"userInfo"]) {
        _signupKeyInfo = [NSMutableString stringWithString:[_checkdict objectForKey:@"signupKeyInfo"]];
        _signupNameInfo = [NSMutableString stringWithString:[_checkdict objectForKey:@"userInfo"]];
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    [self.view addSubview:view];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-10) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[JGDactivityListTableViewCell class] forCellReuseIdentifier:@"listCell"];
    
    _page = 0;
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.mj_header beginRefreshing];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *barItm = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(check)];
    barItm.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barItm;
    
    // Do any additional setup after loading the view.
}

- (void)check{
    if (self.delegate) {
        if (_signupKeyInfo.length == 0) {
            [_checkdict setObject:@"" forKey:@"signupKeyInfo"];
        }else{
            [_checkdict setObject:_signupKeyInfo forKey:@"signupKeyInfo"];
        }
        
        if (_signupNameInfo.length == 0) {
            [_checkdict setObject:@"" forKey:@"userInfo"];
        }else{
            [_checkdict setObject:_signupNameInfo forKey:@"userInfo"];
        }
        
        [self.delegate saveBtnDict:_checkdict andAwardId:_awardId];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_page]forKey:@"offset"];
    [dict setObject:@0 forKey:@"teamKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:self.activityKey userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([data objectForKey:@"packSuccess"]) {
            if (_page == 0)
            {
                //清除数组数据  signUpInfoKey
                [self.dataArray removeAllObjects];
            }
            
            _page++;
            if ([data objectForKey:@"teamSignUpList"]) {
                for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                    JGDActivityList *model = [[JGDActivityList alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
       
            self.sumCount = [[data objectForKey:@"sumCount"] integerValue];
            [_tableView reloadData];
        }else {
            
        }
        
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDactivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (_signupKeyInfo.length > 0) {
        JGDActivityList *model = [[JGDActivityList alloc]init];
        model = self.dataArray[indexPath.row];
        if ([_signupKeyInfo containsString:[NSString stringWithFormat:@"%@", model.timeKey]]) {
            model.isSelect = YES;
        }
        
        cell.listModel = model;
    }else{
        cell.listModel = self.dataArray[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat: @"活动成员列表（%td人）", self.sumCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0 * screenWidth / 375;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * screenWidth / 375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JGDactivityListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JGDActivityList *model = self.dataArray[indexPath.row];

    if (model.isSelect) {
        cell.selectImage.image = [UIImage imageNamed:@"kuang"];
        model.isSelect = NO;
        if ([_signupKeyInfo containsString:[NSString stringWithFormat:@"%@", model.timeKey]]) {
            
            //            _signupKeyInfo = [NSMutableString stringWithString:[_signupKeyInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,", model.timeKey] withString:@""]];
            //
            //            _signupNameInfo = [NSMutableString stringWithString:[_signupNameInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ | ", model.name] withString:@""]];
            
            _signupKeyInfo = [self string:_signupKeyInfo ByRepalcingFirstOccurrencesOfString:[NSString stringWithFormat:@"%@,", model.timeKey] withString:@""];
            
            _signupNameInfo = [self string:_signupNameInfo ByRepalcingFirstOccurrencesOfString:[NSString stringWithFormat:@"%@ | ", model.name] withString:@""];
            
        }
        
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"kuang_xz"];
        model.isSelect = YES;
        _signupKeyInfo = [NSMutableString stringWithString:[_signupKeyInfo stringByAppendingString:[NSString stringWithFormat:@"%@,", model.timeKey]]];
        
        _signupNameInfo = [NSMutableString stringWithString:[_signupNameInfo stringByAppendingString:[NSString stringWithFormat:@"%@ | ", model.name]]];
    }
    
    
    
    if (cell.listModel.isSelect == NO) {
        [self.selectedArray addObject:model];
    }
    
}

- (NSMutableString *)string:(NSMutableString *)string ByRepalcingFirstOccurrencesOfString:(NSString *)replacedString withString:(NSString *)byString{
    
    NSString *string_chara = [NSString stringWithFormat:@"%@", string];
    NSRange range = [string_chara rangeOfString:replacedString];
    string_chara = [string_chara stringByReplacingCharactersInRange:range withString:byString];
    
    return [NSMutableString stringWithString:string_chara];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
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

