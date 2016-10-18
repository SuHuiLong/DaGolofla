//
//  JGDSetConfrontViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSetConfrontViewController.h"
#import "JGDSetConfrontTableViewCell.h"

@interface JGDSetConfrontViewController ()<UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *pickerBackView;

@property (nonatomic, strong) NSString *currentName;

@property (nonatomic, strong) NSNumber *currentTeamKey;

@property (nonatomic, strong) NSMutableArray *matchArray; // 参赛球队列表

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *currentDic;

@property (nonatomic, strong) NSIndexPath *currentIndex;

@property (nonatomic, strong) UIButton *currentBtn;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *roundListArray; // 获取轮次列表

@property (nonatomic, strong) NSMutableArray *submitArray; // 设置的轮次列表

@property (nonatomic, assign) NSInteger maxRow;  // 可创建的最大行数
@end

@implementation JGDSetConfrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置对抗";
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(compAct)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JGDSetConfrontTableViewCell class] forCellReuseIdentifier:@"setConfront"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70 * ProportionAdapter)];
    headBackV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.tableHeaderView = headBackV;
    
    UILabel *setLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 300 * ProportionAdapter, 25 * ProportionAdapter)];
    setLB.text = @"请先设置球队的对抗关系！";
    setLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    setLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
    [headBackV addSubview:setLB];
    
    UIView *wihteBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
    wihteBackV.backgroundColor = [UIColor whiteColor];
    [headBackV addSubview:wihteBackV];
    
    UILabel *setConfLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 5 * ProportionAdapter, 300 * ProportionAdapter, 25 * ProportionAdapter)];
    setConfLB.text = @"设置对抗";
    setConfLB.textColor = [UIColor colorWithHexString:@"#313131"];
    setConfLB.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    [wihteBackV addSubview:setConfLB];
    
    // Data
    [self dataGet];
    
    // Do any additional setup after loading the view.
}


- (void)dataGet{
    
    // 获取参赛球队列表
    NSMutableDictionary *matchDic = [[NSMutableDictionary alloc] init];
    [matchDic setObject:@122 forKey:@"matchKey"];
    [matchDic setObject:@244 forKey:@"userKey"];
    [matchDic setObject:[Helper md5HexDigest:@"matchKey=122&userKey=244dagolfla.com"] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"match/getMatchTeamList" JsonKey:nil withData:matchDic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"teamList"]) {
                self.matchArray = [[data objectForKey:@"teamList"] mutableCopy];
                self.maxRow = [self.matchArray count] / 2;
                [self roundData];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)roundData{
    //  获取轮次
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@122 forKey:@"matchKey"];
    [dic setObject:@244 forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:@"matchKey=122&userKey=244dagolfla.com"] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"match/getMatchCombatList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                NSLog(@"---%@---", [data objectForKey:@"list"]);
                self.roundListArray = [data objectForKey:@"list"];
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    [self.submitArray addObject:[[dic objectForKey:@"combatList"] mutableCopy]];
                }
                
                // 判断是否已到最大分组
                for (int i = 0; i < [self.submitArray count]; i ++) {
                    if ([self.submitArray[i] count] < self.maxRow) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [self.submitArray[i] addObject:dic];
                    }
                }
                
                [self.tableView reloadData];
                // combatList
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)pickerViewSet{
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/3, ScreenWidth, ScreenHeight/3)];
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBackView];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    pickerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/3);
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.pickerBackView addSubview:pickerView];
    
    UIButton *_button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button1.frame = CGRectMake(10 * ProportionAdapter, 5 * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button1 addTarget:self action:@selector(buttonMissClickSec:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button1];
    
    
    UIButton *_button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button2.frame = CGRectMake(ScreenWidth-50 * ProportionAdapter, 5 * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button2 addTarget:self action:@selector(buttonShowClickSec:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:_button2];
    
    self.currentName = [self.matchArray[0] objectForKey:@"name"];
    self.currentTeamKey = [self.matchArray[0] objectForKey:@"timeKey"];
}


#pragma mark -- 完成

- (void)compAct{
    
    
    for (int i = 0; i < [self.submitArray count]; i ++) {
       NSMutableArray *array = self.submitArray[i];
        
        if ([[array lastObject] objectForKey:@"teamKey1"] == nil || [[array lastObject] objectForKey:@"teamKey2"] == nil) {
            [array removeLastObject];
        }
    }
    
    NSMutableArray *combatArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.submitArray count]; i ++) {
        [combatArray addObjectsFromArray:self.submitArray[i]];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@244 forKey:@"userKey"];
    [dic setObject:combatArray forKey:@"combatList"];
    
    
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"match/addCombat" JsonKey:nil withData:dic failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
  
            
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 确认

- (void)buttonShowClickSec:(UIButton *)btn{
    self.pickerBackView.hidden = YES;
    
    
    NSLog(@"%td---row = %td", self.currentIndex.section, self.currentIndex.row);
    NSLog(@"%td", [self.submitArray count] - 1);
    if (self.currentIndex.row < [self.submitArray[self.currentIndex.section] count] - 1) {
        
        NSDictionary *dic = self.submitArray[self.currentIndex.section][self.currentIndex.row];

        if (self.currentBtn.tag == 201) {
            
            if ([[dic objectForKey:@"teamKey2"] integerValue] == [self.currentTeamKey integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"不能选择同一支球队比赛" FromView:self.view];
                return;
            }
            [self.currentBtn setTitle:self.currentName forState:(UIControlStateNormal)];

//           NSDictionary *dic = self.submitArray[self.currentIndex.section][self.currentIndex.row];
            NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
            [subDic setObject:[dic objectForKey:@"matchKey"] forKey:@"matchKey"];
            [subDic setObject:[dic objectForKey:@"roundKey"] forKey:@"roundKey"];
            [subDic setObject:self.currentTeamKey forKey:@"teamKey1"];
            [subDic setObject:[dic objectForKey:@"teamKey2"] forKey:@"teamKey2"];
            [subDic setObject:[dic objectForKey:@"timeKey"] forKey:@"timeKey"];

            self.submitArray[self.currentIndex.section][self.currentIndex.row] = subDic;
            
        }else{

            if ([[dic objectForKey:@"teamKey1"] integerValue] == [self.currentTeamKey integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"不能选择同一支球队比赛" FromView:self.view];
                return;
            }
            [self.currentBtn setTitle:self.currentName forState:(UIControlStateNormal)];

//            NSDictionary *dic = self.submitArray[self.currentIndex.section][self.currentIndex.row];
            NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
            [subDic setObject:[dic objectForKey:@"matchKey"] forKey:@"matchKey"];
            [subDic setObject:[dic objectForKey:@"roundKey"] forKey:@"roundKey"];
            [subDic setObject:self.currentTeamKey forKey:@"teamKey2"];
            [subDic setObject:[dic objectForKey:@"teamKey1"] forKey:@"teamKey1"];
            [subDic setObject:[dic objectForKey:@"timeKey"] forKey:@"timeKey"];

            self.submitArray[self.currentIndex.section][self.currentIndex.row] = subDic;

        }
        
    }else{
        //      最后一行的情况
        
//        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dataDic = [self.submitArray[self.currentIndex.section][self.currentIndex.row] mutableCopy];
        [dataDic setValue:[self.roundListArray[self.currentIndex.section] objectForKey:@"matchKey"] forKey:@"matchKey"];
        [dataDic setValue:[self.roundListArray[self.currentIndex.section] objectForKey:@"timeKey"] forKey:@"roundKey"];
        
        if ([[self.roundListArray[self.currentIndex.section] objectForKey:@"combatList"] count] > self.currentIndex.row) {
            [dataDic setObject:[[self.roundListArray[self.currentIndex.section] objectForKey:@"combatList"][self.currentIndex.row] objectForKey:@"timeKey"] forKey:@"timeKey"];
            
        }else{
            [dataDic setObject:@0 forKey:@"timeKey"];

        }
        
        
//        if ([self.roundListArray[self.currentIndex.section] objectForKey:@"combatList"]) {
//            [dataDic setObject:[[self.roundListArray[self.currentIndex.section] objectForKey:@"combatList"][self.currentIndex.row] objectForKey:@"timeKey"] forKey:@"timeKey"];
//
//            if ([[self.roundListArray[self.currentIndex.section] objectForKey:@"combatList"][self.currentIndex.row] objectForKey:@"timeKey"]) {
//                
//            }
//            
//        }else{
//            [dataDic setObject:@0 forKey:@"timeKey"];
//
//        }

        JGDSetConfrontTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndex];
        
        if (self.currentBtn.tag == 201) {
            
            if ([[dataDic objectForKey:@"teamKey2"] integerValue] == [self.currentTeamKey integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"不能选择同一支球队比赛" FromView:self.view];
                return;
            }
            [self.currentBtn setTitle:self.currentName forState:(UIControlStateNormal)];

            
            UIButton *anotherBtn = [cell viewWithTag:202];
            [dataDic setValue:self.currentTeamKey forKey:@"teamKey1"];
            
//            [self.submitArray[self.currentIndex.section] addObject:dataDic];
            self.submitArray[self.currentIndex.section][self.currentIndex.row] = dataDic;
            
            if (![anotherBtn.titleLabel.text isEqualToString:@"+ 添加球队"] && (self.currentIndex.row + 1 < self.maxRow)) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex.row + 1 inSection:self.currentIndex.section];
                NSLog(@"%td---%td",indexPath.row, indexPath.section);
//                self.sectionArray[self.currentIndex.section] = [NSNumber numberWithInteger:[self.sectionArray[self.currentIndex.section] integerValue] + 1];
                NSMutableDictionary *emptyDic = [[NSMutableDictionary alloc] init];
                [self.submitArray[self.currentIndex.section] addObject:emptyDic];
                
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }else{
            
            if ([[dataDic objectForKey:@"teamKey1"] integerValue] == [self.currentTeamKey integerValue]) {
                [[ShowHUD showHUD]showToastWithText:@"不能选择同一支球队比赛" FromView:self.view];
                return;
            }
            [self.currentBtn setTitle:self.currentName forState:(UIControlStateNormal)];
            

            UIButton *anotherBtn = [cell viewWithTag:201];
            [dataDic setValue:self.currentTeamKey forKey:@"teamKey2"];
            
//            [self.submitArray[self.currentIndex.section] addObject:dataDic];
            self.submitArray[self.currentIndex.section][self.currentIndex.row] = dataDic;

            if (![anotherBtn.titleLabel.text isEqualToString:@"+ 添加球队"] && (self.currentIndex.row + 1 < self.maxRow)) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex.row + 1 inSection:self.currentIndex.section];
                NSLog(@"%td---%td",indexPath.row, indexPath.section);
//                self.sectionArray[self.currentIndex.section] = [NSNumber numberWithInteger:[self.sectionArray[self.currentIndex.section] integerValue] + 1];
                NSMutableDictionary *emptyDic = [[NSMutableDictionary alloc] init];
                [self.submitArray[self.currentIndex.section] addObject:emptyDic];

                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }

        
        
        
    }
    
    
    
}

// 取消
- (void)buttonMissClickSec:(UIButton *)btn{
    self.pickerBackView.hidden = YES;
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.matchArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return [self.matchArray[row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentName = [self.matchArray[row] objectForKey:@"name"];
    self.currentTeamKey = [self.matchArray[row] objectForKey:@"timeKey"];
}


#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JGDSetConfrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%td%td", indexPath.section, indexPath.row]];
    if (!cell) {
        cell = [[JGDSetConfrontTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:[NSString stringWithFormat:@"%td%td", indexPath.section, indexPath.row]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row < [self.submitArray[indexPath.section] count]) {
        
        if ([self.submitArray[indexPath.section][indexPath.row] objectForKey:@"teamName1"]) {
            NSString *name1 = [self.submitArray[indexPath.section][indexPath.row] objectForKey:@"teamName1"];
            [cell.leftButton setTitle:name1 forState:(UIControlStateNormal)];
        }else{
            [cell.leftButton setTitle:@"+ 添加球队" forState:(UIControlStateNormal)];
        }
        
        if ([self.submitArray[indexPath.section][indexPath.row] objectForKey:@"teamName2"]) {
            NSString *name2 = [self.submitArray[indexPath.section][indexPath.row] objectForKey:@"teamName2"];
            [cell.rightButton setTitle:name2 forState:(UIControlStateNormal)];
        }else{
            [cell.rightButton setTitle:@"+ 添加球队" forState:(UIControlStateNormal)];
        }



    }
    
    
    [cell.leftButton addTarget:self action:@selector(leftAct:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell.rightButton addTarget:self action:@selector(rightAct:) forControlEvents:(UIControlEventTouchUpInside)];


    return cell;
}


- (void)leftAct:(UIButton *)btn{
    if (self.pickerBackView) {
        self.pickerBackView.hidden = NO;
    }else{
        [self pickerViewSet];
    }
    
    JGDSetConfrontTableViewCell *cell = (JGDSetConfrontTableViewCell *)[[[btn superview] superview]superview];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    NSLog(@"row = %td, section = %td", index.row, index.section);
    
    self.currentBtn = btn;
    self.currentIndex = index;
    
    
}

- (void)rightAct:(UIButton *)btn{
    if (self.pickerBackView) {
        self.pickerBackView.hidden = NO;
    }else{
        [self pickerViewSet];
    }
    JGDSetConfrontTableViewCell *cell = (JGDSetConfrontTableViewCell *)[[[btn superview] superview]superview];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    NSLog(@"row = %td, section = %td", index.row, index.section);
    
    self.currentBtn = btn;
    self.currentIndex = index;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.submitArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * ProportionAdapter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.submitArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *styleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 8 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 30 * ProportionAdapter)];

    NSString *ruleType = [self.roundListArray[section] objectForKey:@"ruleType"];
    NSString *ruleName = [self.roundListArray[section] objectForKey:@"roundName"];
    NSString *headString = [NSString stringWithFormat:@"第%@轮 %@",ruleName ,ruleType];
    
    styleLB.text = ruleType;
    
    styleLB.textAlignment = NSTextAlignmentCenter;
    styleLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    styleLB.textColor = [UIColor colorWithHexString:@"#313131"];
    [view addSubview:styleLB];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5 * ProportionAdapter)];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:lineV];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50 * ProportionAdapter;
}


- (NSMutableArray *)matchArray{
    if (!_matchArray) {
        _matchArray = [[NSMutableArray alloc] init];
    }
    return _matchArray;
}

- (NSMutableArray *)sectionArray{
    
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] initWithObjects:@1,@1,@1,@1,@1,@1,@1,@1,@1,@1, nil];
    }
    return _sectionArray;
}

- (NSMutableArray *)submitArray{
    if (!_submitArray) {
        _submitArray = [[NSMutableArray alloc] init];
    }
    return _submitArray;
}

- (NSMutableArray *)roundListArray{
    if (!_roundListArray) {
        _roundListArray = [[NSMutableArray alloc] init];
    }
    return _roundListArray;
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
