//
//  JGDPersonalViewController.m
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPersonalViewController.h"
#import "JGDPersonalTableViewCell.h"
#import "JGDInputView.h"
#import "JGDPickerView.h"
#import "JGDDatePicker.h"
#import "JGDTextTipView.h"
#import "JGDPersonalCard.h"

@interface JGDPersonalViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation JGDPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.titleArray = [NSArray arrayWithObjects:@"昵称", @"性别", @"出生年月", @"行业", @"差点", @"球龄", @"城市", @"个人签名",  nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[JGDPersonalTableViewCell class] forCellReuseIdentifier:@"JGDPersonalTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 88 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 73 * ProportionAdapter, 73 * ProportionAdapter)];
    iconBtn.center = headerView.center;
    [iconBtn setImage:[UIImage imageNamed:@"bg_photo"] forState:(UIControlStateNormal)];;
    iconBtn.layer.cornerRadius = 73 * ProportionAdapter / 2;
    iconBtn.clipsToBounds = YES;
    iconBtn.layer.borderWidth = 1.5 * ProportionAdapter;
    iconBtn.layer.borderColor = [[UIColor colorWithHexString:@"#e4e4e4"] CGColor];
    iconBtn.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:iconBtn];
    
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDPersonalTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDPersonalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        JGDInputView *inputV = [[JGDInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (indexPath.row == 0) {
            inputV.height = 52.0;
            inputV.placeHolderString = @"请输入您的个性昵称";
        }else{
            inputV.height = 150.0;
            inputV.placeHolderString = @"请输入您的个人签名";
        }
        
        inputV.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        
        [self.view addSubview:inputV];
    
    }else if (indexPath.row == 1) {
        
        JGDPickerView *pickView = [[JGDPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        pickView.dataArray = @[@"江苏", @"湖南",@"河南",@"山东",@"河北",@"6",@"7"];
        pickView.selectRow = 3;
        pickView.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        [self.view addSubview:pickView];
        
    }else if (indexPath.row == 2) {
        
        JGDDatePicker *datePic = [[JGDDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        datePic.blockStr = ^(NSString *string){
            cell.nameLB.text = string;
        };
        [self.view addSubview:datePic];
    }else if (indexPath.row == 4) {
     
        JGDTextTipView *textTipV = [[JGDTextTipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:textTipV];
    }else if (indexPath.row == 6) {
        
        JGDPersonalCard *personalCard = [[JGDPersonalCard alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:personalCard];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
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
