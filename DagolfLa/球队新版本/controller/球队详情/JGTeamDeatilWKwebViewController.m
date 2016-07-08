//
//  JGTeamDeatilWKwebViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "JGTeamDeatilWKwebViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGTeamMemberController.h"
#import "JGLDrawalRecordViewController.h"

@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (_isShareBtn == 1) {
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordBtn)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
        
//    }
    
    self.title = self.teamName;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]]];
    
}

#pragma mark -- 账户体现
- (void)recordBtn{
    JGLDrawalRecordViewController* dwVc = [[JGLDrawalRecordViewController alloc]init];
    [self.navigationController pushViewController:dwVc animated:YES];
}

- (void)clearCookies{
    
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records)
                         {
                             //                             if ( [record.displayName containsString:@"baidu"]) //取消备注，可以针对某域名清除，否则是全清
                             //                             {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                    }];
                             //                             }
                         }
                     }];
    
}


// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    NSLog(@"%@", urlString);
    
    NSArray  * array= [urlString componentsSeparatedByString:@":"];
    
    if ([array[0] isEqualToString:@"dagolfla"]) {
        //球队提现
        if ([urlString containsString:@"teamWithDraw"]) {
            if ([urlString containsString:@"?"]) {
                JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
                vc.teamKey = [NSNumber numberWithInteger:[[self returnTimeKeyWithUrlString:urlString] integerValue]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        // 成员管理
        if ([urlString containsString:@"teamMemberMgr"]) {
            if ([urlString containsString:@"?"]) {
                JGTeamMemberController *tmVc = [[JGTeamMemberController alloc] init];
                
                tmVc.teamKey = [NSNumber numberWithInteger:[[self returnTimeKeyWithUrlString:urlString] integerValue]];
                
                tmVc.teamManagement = 1;
                [self.navigationController pushViewController:tmVc animated:YES];
            }
        }
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (NSString *)returnTimeKeyWithUrlString:(NSString *)string{
    NSArray *parameterArray = [NSArray array];
    NSString *timeKey;
    NSArray *timeKeyArray = [string componentsSeparatedByString:@"?"];
    if ([timeKeyArray count] == 2) {
        NSString *parameterStr = [timeKeyArray objectAtIndex:1];
        if ([parameterStr containsString:@"&"]) {
            parameterArray = [parameterStr componentsSeparatedByString:@"&"];
            if ([[parameterArray objectAtIndex:0]containsString:@"teamKey"]) {
                timeKey = [[[parameterArray objectAtIndex:0]componentsSeparatedByString:@"="] objectAtIndex:1];
            }
        }
    }
    
    return timeKey;
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
