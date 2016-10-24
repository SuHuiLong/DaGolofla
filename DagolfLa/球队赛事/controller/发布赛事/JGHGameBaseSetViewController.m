//
//  JGHGameBaseSetViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameBaseSetViewController.h"
#import "JGHGameBaseHeaderCell.h"
#import "JGHGameBaseHeaderSubCell.h"
#import "JGHRulesForDetailsView.h"

static NSString *const JGHGameBaseHeaderCellIdentifier = @"JGHGameBaseHeaderCell";
static NSString *const JGHGameBaseHeaderSubCellIdentifier = @"JGHGameBaseHeaderSubCell";

@interface JGHGameBaseSetViewController ()<UITableViewDelegate, UITableViewDataSource, JGHGameBaseHeaderCellDelegate, UITextFieldDelegate>
{
    NSString *_toptextfeil;
}

@property (nonatomic, strong)UITableView *gameBaseSetTableView;

//@property (nonatomic, strong)NSMutableArray *titleArray;

@end

@implementation JGHGameBaseSetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    
    self.navigationItem.title = [dict objectForKey:@"name"];    
    
    [self createGameSetTableView];
}
#pragma mark -- 确定
- (void)saveBtnClick{
    if (self.delegate) {
        [self.delegate selectRulesArray:self.rulesArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createGameSetTableView{
    self.gameBaseSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    UINib *gameBaseHeaderCellNib = [UINib nibWithNibName:@"JGHGameBaseHeaderCell" bundle: [NSBundle mainBundle]];
    [self.gameBaseSetTableView registerNib:gameBaseHeaderCellNib forCellReuseIdentifier:JGHGameBaseHeaderCellIdentifier];
    
    UINib *gameSetBaseCellNib = [UINib nibWithNibName:@"JGHGameBaseHeaderSubCell" bundle: [NSBundle mainBundle]];
    [self.gameBaseSetTableView registerNib:gameSetBaseCellNib forCellReuseIdentifier:JGHGameBaseHeaderSubCellIdentifier];
    
    self.gameBaseSetTableView.dataSource = self;
    self.gameBaseSetTableView.delegate = self;
    self.gameBaseSetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameBaseSetTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    [self.view addSubview:self.gameBaseSetTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *timeKey = nil;
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    timeKey = [dict objectForKey:@"timeKey"];
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    return secondaryDirectoryArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *timeKey = nil;
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    timeKey = [dict objectForKey:@"timeKey"];
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    NSDictionary *rulesTitleDict = secondaryDirectoryArray[section];
    NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
    return rulesList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *timeKey = nil;
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    timeKey = [dict objectForKey:@"timeKey"];
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    NSDictionary *rulesTitleDict = secondaryDirectoryArray[indexPath.section];
    NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
    NSDictionary *baseDict = [rulesList objectAtIndex:indexPath.row];
    JGHGameBaseHeaderSubCell *gameSetBaseCellCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderSubCellIdentifier];
    NSInteger _select = 0;
    for (int i=0; i< _rulesArray.count; i++) {
        NSDictionary *rulesDict = _rulesArray[i];
        NSLog(@"timeKey %@== timeKey %@", [rulesDict objectForKey:@"timeKey"], [baseDict objectForKey:@"timeKey"]);
        NSInteger timeKey1 = [[rulesDict objectForKey:@"timeKey"] integerValue];
        NSInteger timeKey2 = [[baseDict objectForKey:@"timeKey"] integerValue];
        if (timeKey1 == timeKey2) {
            _select = 1;
        }
    }
    
    NSString *nameString = [NSString stringWithFormat:@"%@", [baseDict objectForKey:@"name"]];
    
    gameSetBaseCellCell.toptextfeil.delegate = self;
    
    [gameSetBaseCellCell configJGHGameBaseHeaderSubCell:nameString andSelect:_select andTopvalue:_toptextfeil];
    
    return gameSetBaseCellCell;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHGameBaseHeaderCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderCellIdentifier];
    gameSetCell.delegate = self;
    NSString *timeKey = nil;
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    timeKey = [dict objectForKey:@"timeKey"];
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    NSDictionary *rulesTitle = secondaryDirectoryArray[section];
    [gameSetCell configJGHGameBaseHeaderCell:[rulesTitle objectForKey:@"name"]];
    return gameSetCell;
}

//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 *ProportionAdapter;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 *ProportionAdapter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *timeKey = nil;
    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
    timeKey = [dict objectForKey:@"timeKey"];
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    NSDictionary *rulesTitleDict = secondaryDirectoryArray[indexPath.section];
    NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
    NSMutableDictionary *baseDict = [[rulesList objectAtIndex:indexPath.row] mutableCopy];
    
    if ([[baseDict objectForKey:@"name"] containsString:@"regular"]) {
        [baseDict setObject:_toptextfeil forKey:@"value"];
    }
    
    [self.rulesArray replaceObjectAtIndex:indexPath.section +1 withObject:baseDict];
    
    [self.gameBaseSetTableView reloadData];
}
#pragma mark -- 查看规则详情
- (void)didSelectHelpBtn:(UIButton *)btn{
    JGHRulesForDetailsView *rulesForDetailsView = [[JGHRulesForDetailsView alloc]init];
    rulesForDetailsView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    rulesForDetailsView.alpha = 0.5;
    [self.view addSubview:rulesForDetailsView];
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _toptextfeil= textField.text;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSCharacterSet *cs;
    if(textField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [[ShowHUD showHUD]showToastWithText:@"请输入数字" FromView:self.view];
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
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
