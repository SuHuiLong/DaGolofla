//
//  JGDAboutUsViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAboutUsViewController.h"

@interface JGDAboutUsViewController ()

@end

@implementation JGDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(151 * ProportionAdapter, 30  * ProportionAdapter, 74 * ProportionAdapter, 74 * ProportionAdapter)];
    imageView.image = [UIImage imageNamed:@"iconlogo"];
    [self.view addSubview:imageView];
    
    UILabel *jgName = [Helper lableRect:CGRectMake(0, 114 * ProportionAdapter, screenWidth, 17 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#32b14d"] labelFont:18 * ProportionAdapter text:@"君高高尔夫" textAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:jgName];
    
    NSString* versionKey = (NSString*)kCFBundleVersionKey;
    NSString* version = [NSBundle mainBundle].infoDictionary[versionKey];
    UILabel *versionName = [Helper lableRect:CGRectMake(0, 141 * ProportionAdapter, screenWidth, 13 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:14 * ProportionAdapter text:[NSString stringWithFormat:@"版本：%@", version] textAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:versionName];
    
    UILabel *detailLB = [Helper lableRect:CGRectMake(21 * ProportionAdapter, 170 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 91 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:15 * ProportionAdapter text:@"“君高高尔夫”APP，打造专业的高尔夫社群平台，专注服务于高尔夫领域，提供专业的记分、球队、订场、教练等一系列功能，方便您更好的享受高尔夫运动的乐趣，结识趣味相投的球友。" textAlignment:(NSTextAlignmentLeft)];
    detailLB.numberOfLines = 0;
    [self.view addSubview:detailLB];
    
    // Do any additional setup after loading the view.
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
