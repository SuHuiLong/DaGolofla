//
//  JGMeMoreViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMeMoreViewController.h"
#import "MeDetailTableViewCell.h"
#import "MySetAboutController.h"
#import "JGHCaddieViewController.h"

@interface JGMeMoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation JGMeMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.rowHeight = 44 * ProportionAdapter;
    [self.tableView registerClass:[MeDetailTableViewCell class] forCellReuseIdentifier:@"MeDetailTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeDetailTableViewCell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
        case 0:
        {
            JGHCaddieViewController *caddieCtrl = [[JGHCaddieViewController alloc]initWithNibName:@"JGHCaddieViewController" bundle:nil];
            [self.navigationController pushViewController:caddieCtrl animated:YES];
        }
            
            break;
            
        case 1:
        {
            MySetAboutController *abVC = [[MySetAboutController alloc] init];
            [self.navigationController pushViewController:abVC animated:YES];
        }
            break;
            
        case 2:
        {
            [Helper alertViewWithTitle:@"是否立即前往appStore进行评价" withBlockCancle:^{
                
            } withBlockSure:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-gao-er-fu-la-guo-nei-ling/id1056048082?l=en&mt=8"]];
            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
            break;
            
        default:
            break;
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"球童记分", @"关于我们",@"产品评价",nil];
    }
    return _titleArray;
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
