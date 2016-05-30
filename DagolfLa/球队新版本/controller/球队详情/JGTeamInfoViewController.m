//
//  JGTeamInfoViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamInfoViewController.h"


@interface JGTeamInfoViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JGTeamInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.scrollView.contentSize = CGSizeMake(screenWidth, [self calculationLabelHeight:self.string]);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球队简介";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 20, [self calculationLabelHeight:self.string])];
    label.text = self.string;
    label.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    label.numberOfLines = 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [self calculationLabelHeight:self.string])];
    
    [self.scrollView addSubview:label];
    
    [self.view addSubview:self.scrollView];
    
    // Do any additional setup after loading the view.
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15 * screenWidth / 320] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 320 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
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
