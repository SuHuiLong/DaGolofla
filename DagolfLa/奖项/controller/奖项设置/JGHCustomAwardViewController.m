//
//  JGHCustomAwardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCustomAwardViewController.h"
#import "JGSignUoPromptCell.h"
#import "JGHTextFiledCell.h"
#import "JGHAwardModel.h"
#import "JGHSetAwardViewController.h"
#import "JGDCustomAwardTableViewCell.h"
#import "JGDAwardSetViewController.h"

static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHTextFiledCellIdentifier = @"JGHTextFiledCell";

@interface JGHCustomAwardViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *_titleArray;
    NSArray *_placerArray;
    NSString *_awardName;//奖项名称
    NSString *_prizeName;//奖品名称
    NSInteger _prizeNumber;//奖品数量
}

@property (nonatomic, strong)UITableView *customAwardTableView;

@end

@implementation JGHCustomAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationItem.title = @"自定义奖项";
    
    _titleArray = @[@"奖项名称", @"奖品", @"数量"];
    _placerArray = @[@"请输入您要添加的奖项名称", @"请输入奖品名称", @"请输入奖品数量"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    if (_model.timeKey != nil) {
        _awardName = _model.name;
        _prizeName = _model.prizeName;//奖品名称
        _prizeNumber = [_model.prizeSize integerValue];//奖品数量
        _teamKey = [_model.teamKey integerValue];
        _activityKey = [_model.teamActivityKey integerValue];
    }
    
    [self createCustomAwardTableView];
}
#pragma mark -- 保存
- (void)saveBtnClick{

    [self.view endEditing:YES];
    
    if (_awardName.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入奖项名称" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *customDic = [NSMutableDictionary dictionary];
    [customDic setObject:_awardName forKey:@"name"];
    [customDic setObject:_prizeName.length > 0 ? _prizeName : @"" forKey:@"prizeName"];
    [customDic setObject:_prizeNumber != 0 ? [NSString stringWithFormat:@"%td", _prizeNumber] : @"0" forKey:@"prizeSize"];
    
    NSNotification *notice = [NSNotification notificationWithName:@"customPrize" object:customDic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGDAwardSetViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];

        }
    }
}

#pragma mark -- 创建TB
- (void)createCustomAwardTableView{
    self.customAwardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.customAwardTableView.delegate = self;
    self.customAwardTableView.dataSource = self;
    
    [self.customAwardTableView registerClass:[JGDCustomAwardTableViewCell class] forCellReuseIdentifier:@"JGDCustomAwardTableViewCell"];
    
    self.customAwardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customAwardTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.customAwardTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return kHvertical(50);
    }else{
        return kHvertical(45);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDCustomAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDCustomAwardTableViewCell"];
    if (indexPath.row == 0) {
        cell.lineLB.frame = CGRectMake(0, kHvertical(49), screenWidth, 1);
        cell.iconImageView.image = [UIImage imageNamed:@"add_awards"];
        cell.rowHeight = kHvertical(50);
    }else{
        
        CGFloat lineX;
        indexPath.row == 1 ? (lineX = kWvertical(65)) : (lineX = 0);
        cell.lineLB.frame = CGRectMake(lineX, kHvertical(44), screenWidth - lineX, 1);
        cell.iconImageView.image = [UIImage imageNamed:@""];
        cell.rowHeight = kHvertical(45);

    }
    cell.inputTF.delegate = self;
    cell.inputTF.tag = indexPath.row + 100;
    cell.titleLB.text = _titleArray[indexPath.row];
    cell.inputTF.placeholder = _placerArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(10);
}


#pragma mark -- titlefile
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        NSLog(@"奖项名称");
        _awardName = textField.text;
        if (_model.timeKey != nil) {
            _model.name = _awardName;
        }
        
    }else if (textField.tag == 101){
        NSLog(@"奖品名称");
        _prizeName = textField.text;
        if (_model.timeKey != nil) {
            _model.prizeName = _prizeName;
        }
        
    }else if (textField.tag == 102){
        NSLog(@"奖品数量");
        _prizeNumber = [textField.text integerValue];
        if (_model.timeKey != nil) {
            _model.prizeSize = [NSNumber numberWithChar:_prizeNumber];
        }
        
    }
}
//实现UITextField的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 102) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            //输入了非法字符
            [[ShowHUD showHUD]showToastWithText:@"必须输入纯数字！" FromView:self.view];
            return NO;
        }
        
        NSUInteger length = textField.text.length + string.length - range.length;
        if (length == 1) {
            NSLog(@"%@", string);
            NSLog(@"%td", [textField.text integerValue]);
            if ([string integerValue] == 0 && ![string isEqualToString:@""]) {
                return NO;
            }
        }
    
        //其他的类型不需要检测，直接写入
        return YES;
    }
    return YES;
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
