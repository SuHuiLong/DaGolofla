//
//  JGNewsSubViewController.m
//  ;
//
//  Created by 東 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGNewsSubViewController.h"
#import "JGNewsTableViewCell.h"

@interface JGNewsSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentType;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation JGNewsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tablewView];
    // Do any additional setup after loading the view.
}


- (void)tablewView{
    
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    [self.newsTableView registerClass:[JGNewsTableViewCell class] forCellReuseIdentifier:@"newsCell"];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    
    [self.view addSubview:self.newsTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
