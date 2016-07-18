//
//  JGHScoresMainViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresMainViewController.h"
#import "JGHScoresPageCell.h"

static NSString *const JGHScoresPageCellIdentifier = @"JGHScoresPageCell";

@interface JGHScoresMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *scoresTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHScoresMainViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scoresTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.scoresTableView.delegate = self;
    self.scoresTableView.dataSource = self;
    self.scoresTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoresTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    UINib *scoresPageCellNib = [UINib nibWithNibName:@"JGHScoresPageCell" bundle: [NSBundle mainBundle]];
    [self.scoresTableView registerNib:scoresPageCellNib forCellReuseIdentifier:JGHScoresPageCellIdentifier];
    
    [self.view addSubview:self.scoresTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (screenHeight-64-50)/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHScoresPageCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHScoresPageCellIdentifier];
    scoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return scoresPageCell;
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
