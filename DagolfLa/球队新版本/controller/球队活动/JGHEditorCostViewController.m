//
//  JGHEditorCostViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/30.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEditorCostViewController.h"
#import "JGHCostListCell.h"
#import "JGHNewCostListCell.h"
#import "JGHAddCostButtonCell.h"

static NSString *const JGHCostListCellIdentifier = @"JGHCostListCell";
static NSString *const JGHNewCostListCellIdentifier = @"JGHNewCostListCell";
static NSString *const JGHAddCostButtonCellIdentifier = @"JGHAddCostButtonCell";

@interface JGHEditorCostViewController ()<JGHAddCostButtonCellDelegate, UITextFieldDelegate>
{
    NSInteger _sectionCount;//
    
    NSInteger _costListArrayCount;//统计现有的资费类型数量
    
    NSArray *_keyArray;
}

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@end

@implementation JGHEditorCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"费用设置";
    
    self.costListArray = [NSMutableArray array];
    
    [self createAdminBtn];
    
    UINib *costListCellNib = [UINib nibWithNibName:@"JGHCostListCell" bundle: [NSBundle mainBundle]];
    [self.editorCostTableView registerNib:costListCellNib forCellReuseIdentifier:JGHCostListCellIdentifier];
    
    UINib *newCostListCellNib = [UINib nibWithNibName:@"JGHNewCostListCell" bundle: [NSBundle mainBundle]];
    [self.editorCostTableView registerNib:newCostListCellNib forCellReuseIdentifier:JGHNewCostListCellIdentifier];
    
    UINib *addCostButtonCellNib = [UINib nibWithNibName:@"JGHAddCostButtonCell" bundle: [NSBundle mainBundle]];
    [self.editorCostTableView registerNib:addCostButtonCellNib forCellReuseIdentifier:JGHAddCostButtonCellIdentifier];
    
    self.editorCostTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.editorCostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}
#pragma mark -- 下载数据
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[JGReturnMD5Str getTeamActivityCostListUserKey:[DEFAULF_USERID integerValue] andActivityKey:_activityKey] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivityCostList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.costListArray removeAllObjects];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            self.costListArray = [[data objectForKey:@"list"] mutableCopy];
            
        }else{
            [[ShowHUD showHUD]showToastWithText:@"获取资费列表失败！" FromView:self.view];
        }
        
        _sectionCount = _costListArray.count;
        _costListArrayCount = _costListArray.count;
        
        [self.editorCostTableView reloadData];
    }];
    
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
    
    //过滤资费类型
    NSMutableArray *costArray = [NSMutableArray array];
    
    for (int i=0; i < _costListArray.count; i++) {
        NSDictionary *dict = _costListArray[i];
        NSString *costName = [dict objectForKey:@"costName"];
        //        NSString *money = [dict objectForKey:@"money"];
        if (![costName isEqualToString:@""]) {
            [costArray addObject:_costListArray[i]];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:costArray forKey:@"costList"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/updateTeamActivityCost" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"保存成功！" FromView:self.view];
            [self performSelector:@selector(popCtrl) withObject:self afterDelay:TIMESlEEP];
        }else{
            [[ShowHUD showHUD]showToastWithText:@"保存失败！" FromView:self.view];
        }
    }];
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
    }else if (indexPath.section < _costListArrayCount){
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
        [newCostListCell configTextFeilSpeacler];
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
    if (_sectionCount >= _costListArrayCount) {
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
    
    [self.editorCostTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.tag == %td", textField.tag);
    if (textField.tag < 10 + _costListArrayCount) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        newDict = [[self.costListArray objectAtIndex:textField.tag -10] mutableCopy];
        [newDict setObject:textField.text forKey:@"money"];
        
        [self.costListArray replaceObjectAtIndex:textField.tag -10 withObject:newDict];
    }else{
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        if (textField.tag < 1000) {
            newDict = [[self.costListArray objectAtIndex:((textField.tag -100) + _costListArrayCount -1)] mutableCopy];
            [newDict setObject:textField.text forKey:@"costName"];
            
            [self.costListArray replaceObjectAtIndex:((textField.tag -100) + _costListArrayCount -1) withObject:newDict];
        }else{
            newDict = [[self.costListArray objectAtIndex:((textField.tag -1000) + _costListArrayCount -1)] mutableCopy];
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
