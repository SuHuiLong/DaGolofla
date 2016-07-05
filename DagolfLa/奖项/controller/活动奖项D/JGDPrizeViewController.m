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
#import "JGLPresentAwardViewController.h"
#import "JGHSetAwardViewController.h"

@interface JGDPrizeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation JGDPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self createTableView];
    [self setdata];
    
    // Do any additional setup after loading the view.
}

- (void)setdata{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"activityKey"];
    [dic setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"teamKey"];

    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivityPrizeList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errtype == %@", errType);
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
        }
    }];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            JGDActvityPriziSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.presentationBtn addTarget:self action:@selector(present) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.prizeBtn addTarget:self action:@selector(prizeSet) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }else{
            
            JGDprizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prizeCell"];
            cell.nameLabel.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人";
            cell.prizeLbel.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人";
            cell.numberLabel.text = @"122";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
    }
    

}

//
- (void)prizeSet{
    JGHSetAwardViewController *setAwardVC = [[JGHSetAwardViewController alloc] init];
    [self.navigationController pushViewController:setAwardVC animated:YES];
}


//立即颁奖
- (void)present{

    JGLPresentAwardViewController *preVC = [[JGLPresentAwardViewController alloc] init];
    [self.navigationController pushViewController:preVC animated:YES];

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
