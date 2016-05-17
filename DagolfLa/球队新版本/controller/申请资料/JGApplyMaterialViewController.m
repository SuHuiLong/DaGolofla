//
//  JGApplyMaterialViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGApplyMaterialViewController.h"
#import "JGApplyMaterialTableViewCell.h"


@interface JGApplyMaterialViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *placeholderArray;

@end

@implementation JGApplyMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"入队申请资料";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(complete)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;

    [self creatTableView];
    // Do any additional setup after loading the view.
}

- (void)complete{
    BOOL isLength = YES;

    for (JGApplyMaterialTableViewCell *cell in self.tableView.visibleCells) {
        NSLog(@"%@", cell.textFD.text);
    }
    for (int i = 0; i < 4; i ++) {
        JGApplyMaterialTableViewCell *cell = self.tableView.visibleCells[i];
        if ([cell.textFD.text length] == 0) {
            isLength = NO;
        }else{

        }
    }
    if (isLength) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊");
    }
}

- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.titleArray = [NSArray arrayWithObjects:@[@"姓名", @"性别", @"差点", @"手机号码"], @"常住地址", @"衣服尺码", @"惯用手", nil];
    self.placeholderArray = [NSArray arrayWithObjects:@[@"请输入真实姓名", @"请输入性别", @"请输入您的差点", @"请输入手机号" ],@"方便活动邀请（选填）",@"统一制服定做（选填）",@"制定特殊需求（选填）", nil];
    [self.view addSubview: self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGApplyMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.labell.text = self.titleArray[indexPath.section][indexPath.row];
        cell.textFD.placeholder = self.placeholderArray[indexPath.section][indexPath.row];
    }else{
        cell.labell.text = self.titleArray[indexPath.section];
        cell.textFD.placeholder = self.placeholderArray[indexPath.section];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
