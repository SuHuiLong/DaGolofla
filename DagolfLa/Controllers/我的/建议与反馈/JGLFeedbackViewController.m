//
//  JGLFeedbackViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLFeedbackViewController.h"
#import "JGLBallParkDataViewController.h"
#import "JGLProductFaultViewController.h"
#import "JGLNewFuncTionViewController.h"
@interface JGLFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation JGLFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"建议与反馈";
    
    [self createUIConfig];
    
}

-(void)createUIConfig
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.rowHeight = 44 * ProportionAdapter;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            JGLBallParkDataViewController* parkVc = [[JGLBallParkDataViewController alloc]init];
            [self.navigationController pushViewController:parkVc animated:YES];
        }
            
            break;
            
        case 1:
        {
            JGLProductFaultViewController* proVc = [[JGLProductFaultViewController alloc]init];
            [self.navigationController pushViewController:proVc animated:YES];
        }
            break;
            
        case 2:
        {
            JGLNewFuncTionViewController* newVc = [[JGLNewFuncTionViewController alloc]init];
            
            [self.navigationController pushViewController:newVc animated:YES];
        }
            break;

        default:
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"球场数据纠错",@"产品缺陷反馈",@"产品新功能建议",nil];//
    }
    return _titleArray;
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
