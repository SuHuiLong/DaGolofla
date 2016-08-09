//
//  JGHPlayAddCaddieViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPlayAddCaddieViewController.h"
#import "JGHSweepViewCell.h"

static NSString *const JGHSweepViewCellIdentifier = @"JGHSweepViewCell";

@interface JGHPlayAddCaddieViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *playAddCaddieTableView;

@end

@implementation JGHPlayAddCaddieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"球童记分";
    
    [self createPlayAddCaddieTableView];
    
    
}

- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
}

- (void)createPlayAddCaddieTableView{
    self.playAddCaddieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    UINib *operationScoreListCellNib = [UINib nibWithNibName:@"JGHSweepViewCell" bundle: [NSBundle mainBundle]];
    [self.playAddCaddieTableView registerNib:operationScoreListCellNib forCellReuseIdentifier:JGHSweepViewCellIdentifier];
    
    self.playAddCaddieTableView.delegate = self;
    self.playAddCaddieTableView.dataSource = self;
    
    self.playAddCaddieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.playAddCaddieTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.playAddCaddieTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JGHSweepViewCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHSweepViewCellIdentifier];
//        [tranCell configScoreJGLAddActiivePlayModel:_playModel];
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tranCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController popViewControllerAnimated:YES];
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
