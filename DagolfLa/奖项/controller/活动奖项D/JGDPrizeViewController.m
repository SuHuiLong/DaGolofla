//
//  JGDPrizeViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrizeViewController.h"
#import "JGDtopTableViewCell.h"
#import "JGDprizeTableViewCell.h"
#import "JGDActvityPriziSetTableViewCell.h"

@interface JGDPrizeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGDPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDprizeTableViewCell class] forCellReuseIdentifier:@"prizeCell"];
    [self.tableView registerClass:[JGDtopTableViewCell class] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[JGDActvityPriziSetTableViewCell class] forCellReuseIdentifier:@"setCell"];

    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JGDtopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            JGDActvityPriziSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
            return cell;
        }else{
            
            JGDprizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prizeCell"];
            return cell;
        }
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80 * ProportionAdapter;
    }else{
        return 44 * ProportionAdapter;
    }
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
