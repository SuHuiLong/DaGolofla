//
//  JGDCourtNameSearchViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCourtNameSearchViewController.h"
#import "JGDCourtDetailViewController.h"
#import "JGDBookCourtTableViewCell.h"
#import "JGDCourtModel.h"

@interface JGDCourtNameSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *resultDataArray;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) UITextField *searchTF;


@end

@implementation JGDCourtNameSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self downData];
    [self searchVCSet];
    // Do any additional setup after loading the view.
}

- (void)downData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[JsonHttp jsonHttp] httpRequest:@"ball/getHotBallList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                self.dataArray = [data objectForKey:@"list"];
            }
            [self.searchTable reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];

}

- (void)searchVCSet{

    
    self.searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * ProportionAdapter, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    self.searchTable.tag = 50;
    self.searchTable.rowHeight = 28 * ProportionAdapter;
    self.searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTable.backgroundColor = [UIColor whiteColor];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64 * ProportionAdapter)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#32b14b"];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10* ProportionAdapter, 25* ProportionAdapter, 300* ProportionAdapter, 30* ProportionAdapter)];
    self.searchTF.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTF.placeholder = @"请输入关键字";
    self.searchTF.delegate = self;
    self.searchTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [headView addSubview:self.searchTF];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(310* ProportionAdapter, 25* ProportionAdapter, 60* ProportionAdapter, 30* ProportionAdapter)];
    [button setTitle:@"取消" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(searchAct) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:button];
    
    
   UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 5, 23 * ProportionAdapter, 15 * ProportionAdapter)];
    imageV.image = [UIImage imageNamed:@"Search-1"];
    self.searchTF.leftView = imageV;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.view addSubview:headView];

    [self.view addSubview:self.searchTable];
}

- (void)searchAct{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 60) {
        return nil;
    }
    UILabel *hotLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20 * ProportionAdapter)];
    hotLB.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    
    NSMutableAttributedString *text;
    if (section == 0) {
        text = [[NSMutableAttributedString alloc] initWithString:@"热门搜索"];
    }else{
        text = [[NSMutableAttributedString alloc] initWithString:@"历史搜索"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5 * ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [hotLB addSubview:view];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(340 * ProportionAdapter, 16 * ProportionAdapter, 17 * ProportionAdapter, 17 * ProportionAdapter)];
        [deleteBtn setImage:[UIImage imageNamed:@"trash"] forState:(UIControlStateNormal)];
        [deleteBtn addTarget:self action:@selector(deleteAllHis) forControlEvents:(UIControlEventTouchUpInside)];
        [hotLB addSubview:deleteBtn];
        hotLB.userInteractionEnabled = YES;
    }

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 18 * ProportionAdapter;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    hotLB.attributedText = text;
    return hotLB;
}

#pragma mark --- 清除历史

- (void)deleteAllHis{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"history"];;
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.searchTable reloadData];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 50) {
        return 50 * ProportionAdapter;
    }else{
        return 0.00001;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 50) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (indexPath.section == 1) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"][indexPath.row];
        }else{
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#313131"];
            cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"ballName"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        JGDBookCourtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCourtCell"];
        cell.model = self.resultDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 50) {
        if (section == 0) {
            return [self.dataArray count];
        }else{
            return [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] count];
        }
    }else{
        return [self.resultDataArray count];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 50) {
        return 2;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 50) {
        
        if (indexPath.section == 0) {
            JGDCourtDetailViewController *courtDetailVC = [[JGDCourtDetailViewController alloc] init];
            courtDetailVC.timeKey = [self.dataArray[indexPath.row] objectForKey:@"timeKey"];
            [self.navigationController pushViewController:courtDetailVC animated:YES];

        }else{
            [self nameSearch:[[NSUserDefaults standardUserDefaults] objectForKey:@"history"][indexPath.row]];
        }
    }else{
        JGDCourtDetailViewController *courtDetailVC = [[JGDCourtDetailViewController alloc] init];
        courtDetailVC.timeKey = [self.resultDataArray[indexPath.row] timeKey];
        [self.navigationController pushViewController:courtDetailVC animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self nameSearch:textField.text];
    
    return YES;
}


- (void)nameSearch:(NSString *)nameStr{
    
    self.searchTF.text = nameStr;

    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [dic setObject:@0 forKey:@"sortType"];
    [dic setObject:nameStr forKey:@"ballName"];
    [dic setObject:[def objectForKey:BDMAPLAT] forKey:@"latitude"];
    [dic setObject:[def objectForKey:BDMAPLNG] forKey:@"longitude"];
    
    [[JsonHttp jsonHttp] httpRequest:@"ball/getBallBookingList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [self.resultTableView.footer endRefreshing];
        
    } completionBlock:^(id data) {
        
        [self.view addSubview: self.resultTableView];
        [self.resultTableView.footer endRefreshing];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                if (self.offset == 0) {
                    [self.resultDataArray removeAllObjects];
                }
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDCourtModel *model = [[JGDCourtModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.resultDataArray addObject:model];
                }
            }
            [self.resultTableView reloadData];

            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    if ([def objectForKey:@"history"]) {
        NSArray *array = [def objectForKey:@"history"];
        NSMutableArray *hisArray = [NSMutableArray arrayWithArray:array];
        [hisArray insertObject:nameStr atIndex:0];
        //        [hisArray addObject:textField.text];
        if ([hisArray count] == 11) {
            [hisArray removeLastObject];
        }
        [def setObject:hisArray forKey:@"history"];
    }else{
        NSMutableArray *history = [[NSMutableArray alloc] init];
        [history addObject:nameStr];
        [def setObject:history forKey:@"history"];
    }
    
    [def synchronize];
}


#pragma mark -- 下拉刷新

- (void)footRefresh{
    
}


- (UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * ProportionAdapter, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.tag = 60;
        _resultTableView.rowHeight = 90 * ProportionAdapter;
        _resultTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
        [_resultTableView registerClass:[JGDBookCourtTableViewCell class] forCellReuseIdentifier:@"bookCourtCell"];


    }
    return _resultTableView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""] && [textField.text length] == 1) {
        // 全删
        [self.resultTableView removeFromSuperview];
        [self.searchTable reloadData];
    }
    return YES;
}

-(NSMutableArray *)resultDataArray{
    if (!_resultDataArray) {
        _resultDataArray = [[NSMutableArray alloc] init];
    }
    return _resultDataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
