//
//  JGMeMoreViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMeMoreViewController.h"
#import "MeDetailTableViewCell.h"
#import "JGHCabbieCertViewController.h"
#import "JGHCabbieCertSuccessViewController.h"
#import "MySetAboutController.h"
#import "JGLFeedbackViewController.h"
#import "MyRecomViewController.h"

@interface JGMeMoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation JGMeMoreViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    UIView *backView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"] frame:self.view.bounds];
    [self.view addSubview:backView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 218*4/5 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.tableView.rowHeight = 44 * ProportionAdapter;
    [self.tableView registerClass:[MeDetailTableViewCell class] forCellReuseIdentifier:@"MeDetailTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeDetailTableViewCell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.iconImgv.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            //hasCaddieRecord
            NSMutableDictionary *cabbieDict = [NSMutableDictionary dictionary];
            [cabbieDict setObject:DEFAULF_USERID forKey:@"userKey"];
            [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/hasCaddieRecord" JsonKey:nil withData:cabbieDict failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                NSLog(@"%@", data);
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    if ([[data objectForKey:@"has"] integerValue] == 0) {
                        JGHCabbieCertViewController *caddieCtrl = [[JGHCabbieCertViewController alloc]init];
                        caddieCtrl.blockCabbie = ^(){
                            //        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                            //        if ([userdef objectForKey:@"isCaddie"]) {
                            //            //认证球童
                            //            [self createCaddieView];
                            //        }
                        };

                        [self.navigationController pushViewController:caddieCtrl animated:YES];
                    }else{
                        JGHCabbieCertSuccessViewController *certSuflCtrl = [[JGHCabbieCertSuccessViewController alloc]init];
                        
                        [self.navigationController pushViewController:certSuflCtrl animated:YES];
                    }
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            }];
        }
            
            break;
               
        case 1:
        {
            
            MySetAboutController *abVC = [[MySetAboutController alloc] init];
            abVC.title = @"关于我们";
            abVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:abVC animated:YES];
        }
            break;
            
        case 2:
        {
            [Helper alertViewWithTitle:@"是否立即前往appStore进行评价" withBlockCancle:^{
                
            } withBlockSure:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-gao-er-fu-la-guo-nei-ling/id1056048082?l=en&mt=8"]];
            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
            break;
        case 3:
        {
            JGLFeedbackViewController* feedVc = [[JGLFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedVc animated:YES];
        }
            break;
          

            
            
        default:
            break;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"我是球童",@"关于我们",@"产品评价",@"建议与反馈",nil];//
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"smallIcn_qiutong", @"icn_about", @"icn_pingjia",@"icn_advice", nil];
    }
    return _imageArray;
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
