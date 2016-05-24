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
@property (nonatomic, strong)UITableView *secondTableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *placeholderArray;
@property (nonatomic, strong)NSMutableDictionary *paraDic;

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

- (void)creatNewTableView{
    
    self.secondTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGApplyMaterialTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.titleArray = [NSArray arrayWithObjects:@[@"姓名", @"性别", @"手机号码"], "行业", @"公司", @"职业",   @"常住地址", @"衣服尺码", @"惯用手", nil];
    self.placeholderArray = [NSArray arrayWithObjects:@[@"请输入真实姓名", @"请输入性别", @"请输入您的差点", @"请输入手机号" ],@"方便活动邀请（选填）",@"统一制服定做（选填）",@"制定特殊需求（选填）", nil];
    [self.view addSubview: self.tableView];
    
}


- (void)complete{
    BOOL isLength = YES;
    NSArray *array = [NSArray arrayWithObjects:@"userName", @"sex", @"almost", @"mobile", nil];
    for (JGApplyMaterialTableViewCell *cell in self.tableView.visibleCells) {
        NSLog(@"%@", cell.textFD.text);
    }
    for (int i = 0; i < 4; i ++) {
        JGApplyMaterialTableViewCell *cell = self.tableView.visibleCells[i];
        if ([cell.textFD.text length] == 0) {
            isLength = NO;
        }else{
            
            if (i == 0 || i == 3) {
                [self.paraDic setObject:cell.textFD.text  forKey:array[i]];

            }else{
                [self.paraDic setObject:@([cell.textFD.text  integerValue]) forKey:array[i]];
            }
            
        }
    }
    
    if (isLength) {
       
//        [self.paraDic setObject:@"911" forKey:@"mobile"];
//        [self.paraDic setObject:@0 forKey:@"sex"];
//        [self.paraDic setObject:@0 forKey:@"almost"];
//        [self.paraDic setObject:@"nyanco" forKey:@"userName"];
// TEST
        [self.paraDic setObject:@83 forKey:@"userKey"];
        
//        [self.paraDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
        [self.paraDic setObject:@(self.teamKey) forKey:@"teamKey"];
        [self.paraDic setObject:@0 forKey:@"state"];
        [self.paraDic setObject:@"2016-12-11 10:00:00" forKey:@"createTime"];
        [self.paraDic setObject:@0 forKey:@"timeKey"];

        [[JsonHttp jsonHttp] httpRequest:@"team/reqJoinTeam" JsonKey:@"teamMemeber" withData:self.paraDic requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"error *** %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
        }];
        
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

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
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
