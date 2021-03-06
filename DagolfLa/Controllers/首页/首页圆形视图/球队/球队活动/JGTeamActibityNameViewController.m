//
//  JGTeamActibityNameViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActibityNameViewController.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGCostsDescriptionCell.h"
#import "JGActivityNameBaseCell.h"

static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGCostsDescriptionCellIdentifier = @"JGCostsDescriptionCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";

@interface JGTeamActibityNameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *teamActibityNameTableView;

@end

@implementation JGTeamActibityNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动名称";
    
    [self createTeamActibityNameTableView];
}

- (void)createTeamActibityNameTableView{
    self.teamActibityNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.dataSource = self;
    //活动场地cell
    UINib *addressNib = [UINib nibWithNibName:@"JGTeamActivityWithAddressCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:addressNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    //活动详情／规则说明
    UINib *detailNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:detailNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    //费用说明cell
    UINib *CostsDescriptionNib = [UINib nibWithNibName:@"JGCostsDescriptionCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:CostsDescriptionNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    //基础cell
    UINib *activityNameBaseCellNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:activityNameBaseCellNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    [self.view addSubview:self.teamActibityNameTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        return 70;
    }else if (indexPath.section == 2){
        return 110;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGTeamActivityWithAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityWithAddressCellIdentifier forIndexPath:indexPath];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addressCell;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier forIndexPath:indexPath];
        detailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailsCell;
    }else if (indexPath.section == 2){
        JGCostsDescriptionCell *costDescriptionCell = [tableView dequeueReusableCellWithIdentifier:JGCostsDescriptionCellIdentifier forIndexPath:indexPath];
        costDescriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return costDescriptionCell;
    }else{
        JGActivityNameBaseCell *activityNameBaseCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        activityNameBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return activityNameBaseCell;
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
