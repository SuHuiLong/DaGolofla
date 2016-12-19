//
//  JGDServiceViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDServiceViewController.h"
#import "JGDServiceTableViewCell.h"

@interface JGDServiceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *phoneArray;
@end

@implementation JGDServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务定制";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 450 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.tableView registerClass:[JGDServiceTableViewCell class] forCellReuseIdentifier:@"serviceCell"];
    
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200 * ProportionAdapter)];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 190 * ProportionAdapter)];
    imageV.image = [UIImage imageNamed:@"banner"];
    [backView addSubview:imageV];
    
        UIImageView *grayImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 190 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
    grayImageV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [backView addSubview:grayImageV];
    
    self.tableView.tableHeaderView = backView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *iconArray = [NSArray arrayWithObjects:@"icn_serve_heart", @"icn_serve_pen", @"icn_serve_event", nil];
    NSArray *titleArray = [NSArray arrayWithObjects: @"球队订场、吃、住、行服务定制", @"球队托管及活动策划", @"赛事及商旅活动组织、策划、执行", nil];
    
    cell.iconV.image = [UIImage imageNamed:iconArray[indexPath.row]]; //icn_serve_event   icn_serve_pen
    cell.detailLB.text = titleArray[indexPath.row];
    cell.contactBtn.tag = 200 + indexPath.row;
    [cell.contactBtn addTarget:self action:@selector(contactAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.contactBtn setTitle:@" 服务定制" forState:(UIControlStateNormal)];
    if (indexPath.row == 2) {
        cell.lineView.hidden = YES;
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 * ProportionAdapter;
}

- (void)contactAct:(UIButton *)btn {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.phoneArray[btn.tag - 200]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (NSMutableArray *)phoneArray{
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray arrayWithObjects:@"4008605308", @"18721262298", @"18721262298", nil];
    }
    return _phoneArray;
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
