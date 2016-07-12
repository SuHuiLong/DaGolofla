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
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"自定义奖项";
    
    _titleArray = @[@"奖项设置", @"", @"奖品名称", @"奖品数量"];
    _placerArray = @[@"请输入您要自定义添加的奖项名称", @"", @"请输入奖品名称", @"请输入奖品数量"];
    
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
    NSLog(@"保存");
    [self.view endEditing:YES];
    if (_awardName.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入奖项名称" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:@(_activityKey) forKey:@"teamActivityKey"];
    [dict setObject:_awardName forKey:@"name"];
    if (_prizeName.length > 0) {
        [dict setObject:_prizeName forKey:@"prizeName"];
    }
    
    if (_prizeNumber != 0) {
        [dict setObject:[NSString stringWithFormat:@"%td", _prizeNumber] forKey:@"prizeSize"];
    }
    
    if (_model.timeKey > 0) {
        [dict setObject:_model.timeKey forKey:@"timeKey"];
    }else{
        [dict setObject:@0 forKey:@"timeKey"];
    }
    
    NSMutableDictionary *pataDict = [NSMutableDictionary dictionary];
    [pataDict setObject:dict forKey:@"prize"];
    [pataDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doSavePrize" JsonKey:nil withData:pataDict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"保存成功！" FromView:self.view];
            [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
//            _awardName = @"";
//            _prizeName = @"";
//            _prizeNumber = 0;
//            
//            [self.customAwardTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)pushCtrl{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGHSetAwardViewController class]]) {
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"reloadAwardData" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
#pragma mark -- 创建TB
- (void)createCustomAwardTableView{
    self.customAwardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.customAwardTableView.delegate = self;
    self.customAwardTableView.dataSource = self;
    
    UINib *textFiledCellNib = [UINib nibWithNibName:@"JGHTextFiledCell" bundle: [NSBundle mainBundle]];
    [self.customAwardTableView registerNib:textFiledCellNib forCellReuseIdentifier:JGHTextFiledCellIdentifier];
    
    UINib *signUoPromptCellNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.customAwardTableView registerNib:signUoPromptCellNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    self.customAwardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customAwardTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.customAwardTableView];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 20*ProportionAdapter;
    }else{
        return 55 * ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        [signUoPromptCell configAllPromptString:@"提示：请设置您要发布的奖品名称与数量" andLeftCon:10 andRightCon:10];
        return signUoPromptCell;
    }else{
        JGHTextFiledCell *chooseAwardCell = [tableView dequeueReusableCellWithIdentifier:JGHTextFiledCellIdentifier];
        [chooseAwardCell conFigAllTitle:_titleArray[indexPath.section] andPlacerString:_placerArray[indexPath.section]];
        chooseAwardCell.titlefileds.tag = indexPath.section + 100;
        chooseAwardCell.titlefileds.delegate = self;
        if (_model.timeKey == nil) {
            chooseAwardCell.titlefileds.text = nil;
        }else{
            if (indexPath.section == 0) {
                chooseAwardCell.titlefileds.text = _model.name;
            }else if (indexPath.section == 2){
                if (_model.prizeName == nil) {
                    chooseAwardCell.titlefileds.text = @"";
                }else{
                    chooseAwardCell.titlefileds.text = [NSString stringWithFormat:@"%@", _model.prizeName];
                }
            }else if (indexPath.section == 3){
                if (_model.prizeSize <= 0) {
                    chooseAwardCell.titlefileds.text = @"";
                }else{
                    if ([_model.prizeSize integerValue] == 0) {
                        chooseAwardCell.titlefileds.text = @"";
                    }else{
                        chooseAwardCell.titlefileds.text = [NSString stringWithFormat:@"%@", _model.prizeSize];
                    }
                }
            }
        }
        
        return chooseAwardCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 20*ProportionAdapter, 1)];
        viewLabel.backgroundColor = [UIColor colorWithHexString:BG_color];
        [view addSubview:viewLabel];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:BG_color];
        return view;
    }
}

#pragma mark -- titlefile
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        NSLog(@"奖项名称");
        _awardName = textField.text;
        if (_model.timeKey != nil) {
            _model.name = _awardName;
        }
        
    }else if (textField.tag == 102){
        NSLog(@"奖品名称");
        _prizeName = textField.text;
        if (_model.timeKey != nil) {
            _model.prizeName = _prizeName;
        }
        
    }else if (textField.tag == 103){
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
    if (textField.tag == 103) {
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
