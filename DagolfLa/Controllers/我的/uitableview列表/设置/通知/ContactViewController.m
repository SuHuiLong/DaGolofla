//
//  ContactViewController.m
//  DagolfLa
//
//  Created by 東 on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *keyArray;
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球友列表";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.view = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50 * ScreenWidth/375;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keyArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        if (indexPath.section == 0) {
            cell.textLabel.text = @"粉丝";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"阿信";
        }
        cell.imageView.image = [UIImage imageNamed:@"xq_xx@3x"];
    }
    return cell;
}

// 右侧索引
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//  改变索引颜色
//  self.tableView.sectionIndexColor = [UIColor redColor];
//    return self.keyArray;
//}


- (NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [NSMutableArray arrayWithObjects:@"", @"A", @"C", @"D", @"E", nil];
    }
    return _keyArray;
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
