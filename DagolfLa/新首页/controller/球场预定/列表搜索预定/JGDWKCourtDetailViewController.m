//
//  JGDWKCourtDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 17/1/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDWKCourtDetailViewController.h"
#import "MyfootModel.h"
#import "ShowMapViewViewController.h"

@interface JGDWKCourtDetailViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGDWKCourtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球场详情";
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/ball/ballDetails.html?ballKey=%@&md5=%@", self.ballKey, [Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%@dagolfla.com", self.ballKey]]]]]];

    
    // Do any additional setup after loading the view.
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    
    if ([urlString containsString:@"map"]) {
        // 球场地址
        NSArray *array = [urlString componentsSeparatedByString:@"="];
        NSString *latitude = [array[1] componentsSeparatedByString:@"&"][0];
        NSString *longitude = [array[2] componentsSeparatedByString:@"&"][0];
        NSString *adress = array[3];
        NSLog(@"%@ --- %@ --- %@", latitude, longitude, adress);
        MyfootModel *model = [[MyfootModel alloc] init];
        model.xIndex = [self stringNumberValue:latitude];
        model.yIndex = [self stringNumberValue:longitude];
        model.golfName = adress;
        ShowMapViewViewController *mapVC = [[ShowMapViewViewController alloc] init];
        mapVC.fromWitchVC = 1;
        mapVC.mapCLLocationCoordinate2DArr = [NSMutableArray arrayWithObjects:model, nil];
        [self.navigationController pushViewController:mapVC animated:YES];
    }else if ([urlString containsString:@"tel"]) {
        //  球场电话
        NSArray *array = [urlString componentsSeparatedByString:@"tel:"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", array[1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
    

    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (NSNumber *)stringNumberValue:(NSString *)str{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:str];
    return numTemp;
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
