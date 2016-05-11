//
//  JGTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamApplyViewController.h"
#import "JGActivityNameBaseCell.h"
#import "JGTableViewCell.h"
#import "JGApplyPepoleCell.h"

static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";

@interface JGTeamApplyViewController ()

@end

@implementation JGTeamApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名缴费";
    //注册cell
    UINib *activityNameNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityNameNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 90;
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
        JGTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tableCell;
    }else if (indexPath.section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier forIndexPath:indexPath];
        applyPepoleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyPepoleCell;
    }else{
        JGActivityNameBaseCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            activityNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return activityNameCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
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
