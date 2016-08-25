//
//  JGCostSetViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCostSetViewController.h"
#import "JGHCostListCell.h"
#import "JGHNewCostListCell.h"
#import "JGHAddCostButtonCell.h"

static NSString *const JGHCostListCellIdentifier = @"JGHCostListCell";
static NSString *const JGHNewCostListCellIdentifier = @"JGHNewCostListCell";
static NSString *const JGHAddCostButtonCellIdentifier = @"JGHAddCostButtonCell";

@interface JGCostSetViewController ()<UITableViewDelegate, UITableViewDataSource, JGHAddCostButtonCellDelegate, UITextFieldDelegate>
{
    NSInteger _sectionCount;//
    
    NSInteger _costListArrayCount;//统计现有的资费类型数量
}

@end

@implementation JGCostSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"费用设置";
    
    if (!self.costListArray) {
        self.costListArray = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(i) forKey:@"type"];
            if (i == 0) {
                [dict setObject:@"普通嘉宾资费" forKey:@"name"];
            }else if (i == 1){
                [dict setObject:@"球队队员资费" forKey:@"name"];
            }else if (i == 2){
                [dict setObject:@"球场记名会员资费" forKey:@"name"];
            }else{
                [dict setObject:@"球场无记名会员资费" forKey:@"name"];
            }
            
            [self.costListArray addObject:dict];
        }
    }
    
    _sectionCount = _costListArray.count;
    _costListArrayCount = _costListArray.count;
    
    [self createAdminBtn];
    
    UINib *costListCellNib = [UINib nibWithNibName:@"JGHCostListCell" bundle: [NSBundle mainBundle]];
    [self.costTableView registerNib:costListCellNib forCellReuseIdentifier:JGHCostListCellIdentifier];
    
    UINib *newCostListCellNib = [UINib nibWithNibName:@"JGHNewCostListCell" bundle: [NSBundle mainBundle]];
    [self.costTableView registerNib:newCostListCellNib forCellReuseIdentifier:JGHNewCostListCellIdentifier];
    
    UINib *addCostButtonCellNib = [UINib nibWithNibName:@"JGHAddCostButtonCell" bundle: [NSBundle mainBundle]];
    [self.costTableView registerNib:addCostButtonCellNib forCellReuseIdentifier:JGHAddCostButtonCellIdentifier];
    
    self.costTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.costTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- 创建保存按钮
- (void)createAdminBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)saveBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSLog(@"%@", _costListArray);
//    if (self.membersCost.text.length == 0) {
//        [[ShowHUD showHUD]showToastWithText:@"请输入会员费用！" FromView:self.view];
//        return;
//    }
//    
//    if (self.guestCost.text.length == 0) {
//        [[ShowHUD showHUD]showToastWithText:@"请输入嘉宾费用！" FromView:self.view];
//        return;
//    }
//    
//    if (self.delegate) {
//        NSLog(@"%@", self.membersCost.text);
//        NSLog(@"%@", self.guestCost.text);
//        NSLog(@"%@", self.registeredPrice.text);
//        NSLog(@"%@", self.bearerPrice.text);
//        [self.delegate inputMembersCost:self.membersCost.text guestCost:self.guestCost.text andRegisteredPrice:self.registeredPrice.text andBearerPrice:self.bearerPrice.text];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionCount +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 *ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == _costListArrayCount) {
        return 10 *ProportionAdapter;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section == %ld", (long)indexPath.section);
    if (indexPath.section == _sectionCount) {
        JGHAddCostButtonCell *addCostButtonCell = [tableView dequeueReusableCellWithIdentifier:JGHAddCostButtonCellIdentifier];
        addCostButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addCostButtonCell.delegate = self;
        return addCostButtonCell;
    }else if (indexPath.section > _costListArrayCount -1){
        if (indexPath.section > _costListArrayCount -1) {
            JGHNewCostListCell *newCostListCell = [tableView dequeueReusableCellWithIdentifier:JGHNewCostListCellIdentifier];
            newCostListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [newCostListCell configTextFeilSpeaclerText];
            newCostListCell.oneTextField.tag = indexPath.section - _costListArrayCount +100;
            newCostListCell.twoTextField.tag = indexPath.section - _costListArrayCount +1000;
            newCostListCell.oneTextField.delegate = self;
            newCostListCell.twoTextField.delegate = self;
            NSLog(@"oneTextField == %td", newCostListCell.oneTextField.tag);
            NSLog(@"twoTextField == %td", newCostListCell.twoTextField.tag);
            return newCostListCell;
        }else{
            JGHCostListCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListCellIdentifier];
            costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [costListCell configCostListCell:_costListArray[indexPath.section]];
            costListCell.valueTextField.delegate = self;
            return costListCell;
        }
    }else{
        JGHCostListCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [costListCell configCostListCell:_costListArray[indexPath.section]];
        costListCell.valueTextField.tag = 10 +indexPath.section;
        costListCell.valueTextField.delegate = self;
        NSLog(@"valueTextField == %td", costListCell.valueTextField.tag);
        return costListCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == _costListArrayCount) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
        footView.backgroundColor = [UIColor colorWithHexString:BG_color];
        return footView;
    }else{
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        footView.backgroundColor = [UIColor whiteColor];
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 0, screenWidth - 20 *ProportionAdapter, 1)];
        lineLable.backgroundColor = [UIColor colorWithHexString:BG_color];
        [footView addSubview:lineLable];
        return footView;
    }
}

#pragma mark -- 添加自定义资费
- (void)addCostList:(UIButton *)btn{
    _sectionCount += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_sectionCount -1) forKey:@"type"];
    [dict setObject:@"" forKey:@"name"];
    [_costListArray addObject:dict];
    
    [self.costTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.tag == %td", textField.tag);
    if (textField.tag < 10 + _costListArrayCount) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        newDict = [self.costListArray objectAtIndex:textField.tag -10];
        [newDict setObject:textField.text forKey:@"money"];
        [self.costListArray replaceObjectAtIndex:textField.tag -10 withObject:newDict];
    }else{
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        if (textField.tag < 1000) {
            newDict = [self.costListArray objectAtIndex:((textField.tag -100) + _costListArrayCount)];
            [newDict setObject:textField.text forKey:@"name"];
            [self.costListArray replaceObjectAtIndex:((textField.tag -100) + _costListArrayCount) withObject:newDict];
        }else{
            newDict = [self.costListArray objectAtIndex:((textField.tag -1000) + _costListArrayCount)];
            [newDict setObject:textField.text forKey:@"money"];
            [self.costListArray replaceObjectAtIndex:((textField.tag -1000) + _costListArrayCount) withObject:newDict];
        }
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
