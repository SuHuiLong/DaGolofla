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

@interface JGCostSetViewController ()<JGHAddCostButtonCellDelegate, UITextFieldDelegate>
{
    NSInteger _sectionCount;//
    
    NSInteger _costListArrayCount;//统计现有的资费类型数量
    
    NSArray *_keyArray;
}

@end

@implementation JGCostSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"费用设置";
    
    _keyArray = @[@"costName", @"money"];
    
    if (!self.costListArray) {
        self.costListArray = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"" forKey:@"money"];
            if (i == 0) {
                [dict setObject:@"球队队员资费" forKey:@"costName"];
            }else if (i == 1){
                [dict setObject:@"嘉宾资费" forKey:@"costName"];
            }else if (i == 2){
                [dict setObject:@"球场记名会员资费" forKey:@"costName"];
            }else if (i == 3){
                [dict setObject:@"球场不记名会员资费" forKey:@"costName"];
            }else {
                [dict setObject:@"" forKey:@"costName"];
            }
            
            [self.costListArray addObject:dict];
        }
    }else{
        self.costListArray = [NSMutableArray arrayWithArray:self.costListArray];
    }
    
//    if (_isManager == 1) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:@"" forKey:@"money"];
//        [dict setObject:@"" forKey:@"costName"];
//        self.costListArray = [NSMutableArray arrayWithArray:self.costListArray];
//        [self.costListArray addObject:dict];
//    }
    
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
    NSInteger costCount = 0;
    NSInteger moneyIsNumber = 0;
    for (NSDictionary *dict in _costListArray) {
        NSString *costName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"costName"]];
        NSString *money = [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]];
        if (![costName isEqualToString:@""] && ![money isEqualToString:@""]) {
            costCount += 1;
        }
        
        if (![Helper isPureNumandCharacters:money]) {
            moneyIsNumber = 1;
        }
    }
    
    if (costCount == 0) {
        [[ShowHUD showHUD]showToastWithText:@"至少设置一个资费类型！" FromView:self.view];
        return;
    }
    
    if (moneyIsNumber == 1) {
        [[ShowHUD showHUD]showToastWithText:@"资费价格必须为数字！" FromView:self.view];
        return;
    }
    
    if (self.delegate) {
        [self.delegate costList:_costListArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popCtrl{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (section == 4) {
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
    }else if (indexPath.section < 4){
        JGHCostListCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [costListCell configCostListCell:_costListArray[indexPath.section]];
        costListCell.valueTextField.tag = 10 +indexPath.section;
        costListCell.valueTextField.delegate = self;
        NSLog(@"valueTextField == %td", costListCell.valueTextField.tag);
        return costListCell;
    }else{
        JGHNewCostListCell *newCostListCell = [tableView dequeueReusableCellWithIdentifier:JGHNewCostListCellIdentifier];
        newCostListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [newCostListCell configTextFeilSpeaclerText:_costListArray[indexPath.section]];
        newCostListCell.oneTextField.tag = indexPath.section - _costListArrayCount +100 +1;
        newCostListCell.twoTextField.tag = indexPath.section - _costListArrayCount +1000 +1;
        newCostListCell.oneTextField.delegate = self;
        newCostListCell.twoTextField.delegate = self;
        NSLog(@"oneTextField == %td", newCostListCell.oneTextField.tag);
        NSLog(@"twoTextField == %td", newCostListCell.twoTextField.tag);
        return newCostListCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == _costListArrayCount -1) {
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
/*
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 3 && indexPath.section != _costListArray.count) {
        NSLog(@"indexPath.section == %td", indexPath.section);
        NSLog(@"indexPath.row == %td", indexPath.row);
        NSString *type = nil;
        type = @"删除";
        
        UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:type handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self deleteChargesType:indexPath.section];
            NSLog(@"00000");
        }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
        return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}
#pragma mark -- 删除cell
- (void)deleteChargesType:(NSInteger)cellID{
    NSLog(@"删除");
    if (self.costListArray.count >= cellID) {
        [self.costListArray removeObjectAtIndex:cellID];
        [self.costTableView reloadData];
    }
}
 */
#pragma mark -- 添加自定义资费
- (void)addCostList:(UIButton *)btn{
    if (_sectionCount >= 5) {
        NSDictionary *costdict = [_costListArray lastObject];
        NSString *costName = [costdict objectForKey:@"costName"];
//        NSString *money = [costdict objectForKey:@"money"];
        if ([costName isEqualToString:@""]) {
            return;
        }
    }
    
    _sectionCount += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"" forKey:@"costName"];
    [dict setObject:@"" forKey:@"money"];
    [_costListArray addObject:dict];
    
    [self.costTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.tag == %td", textField.tag);
    if (textField.tag < 10 + _costListArrayCount) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        newDict = [NSMutableDictionary dictionaryWithDictionary:[self.costListArray objectAtIndex:textField.tag -10]];
        [newDict setObject:textField.text forKey:@"money"];
        
        [self.costListArray replaceObjectAtIndex:textField.tag -10 withObject:newDict];
    }else{
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        if (textField.tag < 900) {
            newDict = [NSMutableDictionary dictionaryWithDictionary:[self.costListArray objectAtIndex:((textField.tag -100) + _costListArrayCount -1)]];
            [newDict setObject:textField.text forKey:@"costName"];
            
            [self.costListArray replaceObjectAtIndex:((textField.tag -100) + _costListArrayCount -1) withObject:newDict];
        }else{
            newDict = [NSMutableDictionary dictionaryWithDictionary:[self.costListArray objectAtIndex:((textField.tag -1000) + _costListArrayCount -1)]];
            [newDict setObject:textField.text forKey:@"money"];
            
            [self.costListArray replaceObjectAtIndex:((textField.tag -1000) + _costListArrayCount -1) withObject:newDict];
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
