//
//  JGHCabbieCertViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieCertViewController.h"

@interface JGHCabbieCertViewController ()

@property (nonatomic, strong)UITableView *cabbieCertTableView;

@end

@implementation JGHCabbieCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"球童认证";
    
    
    
}

- (void)createPlayAddCaddieTableView{
    self.cabbieCertTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
//    UINib *operationScoreListCellNib = [UINib nibWithNibName:@"JGHSweepViewCell" bundle: [NSBundle mainBundle]];
//    [self.cabbieCertTableView registerNib:operationScoreListCellNib forCellReuseIdentifier:JGHSweepViewCellIdentifier];
    
    self.cabbieCertTableView.delegate = self;
    self.cabbieCertTableView.dataSource = self;
    
    self.cabbieCertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cabbieCertTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.cabbieCertTableView];
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
//    JGHSweepViewCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHSweepViewCellIdentifier];
//    //        [tranCell configScoreJGLAddActiivePlayModel:_playModel];
//    tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return tranCell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
    lineLable.backgroundColor = [UIColor colorWithHexString:BG_color];
    [view addSubview:lineLable];
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
