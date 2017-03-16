//
//  JGDCourtSecDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCourtSecDetailViewController.h"
#import "JGDCostumTableViewCell.h"

@interface JGDCourtSecDetailViewController () <UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) CGFloat profileHeight;
@property (nonatomic, assign) CGFloat addressHeight;

@end

@implementation JGDCourtSecDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球场详情";
    
    self.profileHeight = 0;
    
    [self detailTableView];
    // Do any additional setup after loading the view.
}


- (UITableView *)detailTableView{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_detailTableView];
    }
    return _detailTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
        
            UILabel *titleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 20, 50 * ProportionAdapter)  labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"基本信息" textAlignment:(NSTextAlignmentLeft)];
            [cell addSubview:titleLB];
            UILabel *lineLB = [self lablerect:CGRectMake(0, 50 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
            lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [cell addSubview:lineLB];
            
        }else{
            UILabel *discLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 78 * ProportionAdapter, 22 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:self.titleArray[indexPath.row - 1] textAlignment:(NSTextAlignmentRight)];
            [cell addSubview:discLB];
            if ([self.proArray count] == 8) {
                UILabel *detailLB = [self lablerect:CGRectMake(93 * ProportionAdapter, 0, 270 * ProportionAdapter, 22 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:self.proArray[indexPath.row - 1] textAlignment:(NSTextAlignmentLeft)];
                [cell addSubview:detailLB];
            }
            
        }
        
    }if (indexPath.section == 1) {
        UILabel *titleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 50 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"导航" textAlignment:(NSTextAlignmentLeft)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:titleLB];
        
        self.addressHeight = [Helper textHeightFromTextString:[self.detailDic objectForKey:@"address"] width:300 * ProportionAdapter fontSize:15 * ProportionAdapter];
        if (self.addressHeight <= 50 * ProportionAdapter) {
            UILabel *addressLB = [self lablerect:CGRectMake(60 * ProportionAdapter, 0 * ProportionAdapter, 300 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:[self.detailDic objectForKey:@"address"] textAlignment:(NSTextAlignmentLeft)];
            addressLB.numberOfLines = 0;
            [cell.contentView addSubview:addressLB];

        }else{
            UILabel *addressLB = [self lablerect:CGRectMake(60 * ProportionAdapter, 0 * ProportionAdapter, 300 * ProportionAdapter, self.profileHeight) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:[self.detailDic objectForKey:@"address"] textAlignment:(NSTextAlignmentLeft)];
            addressLB.numberOfLines = 0;
            [cell.contentView addSubview:addressLB];

        }
        
    }else if (indexPath.section == 2) {
        UILabel *titleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 80 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"球场电话" textAlignment:(NSTextAlignmentLeft)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:titleLB];
        
        UILabel *mobileLB = [self lablerect:CGRectMake(93 * ProportionAdapter, 0, 270 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#32b14b"] labelFont:(17 * ProportionAdapter) text:[self.detailDic objectForKey:@"mobile"] textAlignment:(NSTextAlignmentLeft)];
        [cell addSubview:mobileLB];
    }else if (indexPath.section == 3) {
        
        UILabel *titleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 80 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(17 * ProportionAdapter) text:@"球场简介" textAlignment:(NSTextAlignmentLeft)];
        [cell addSubview:titleLB];
        
//        self.profileHeight = [Helper textHeightFromTextString:[self.detailDic objectForKey:@"profile"] width:screenWidth - 20 * ProportionAdapter fontSize:15 * ProportionAdapter];

        
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, self.profileHeight)];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.scrollView.bounces = NO;
        [webView loadHTMLString:[self.detailDic objectForKey:@"details"] baseURL:nil];
        [cell addSubview:webView];

        UILabel *profileLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, self.profileHeight) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:[self.detailDic objectForKey:@"profile"] textAlignment:(NSTextAlignmentLeft)];
        profileLB.numberOfLines = 0;
//        [cell addSubview:profileLB];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    // 计算WKWebView高度
    if (self.profileHeight == 0) {
        __weak JGDCourtSecDetailViewController *weakSelf = self;
        [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGRect frame =webView.frame;
            frame.size.height = ([result doubleValue] / 2) * ProportionAdapter;
            weakSelf.profileHeight = ([result doubleValue] / 2) * ProportionAdapter;
            webView.frame = frame;
            [weakSelf.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:NO];
        }];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 9 : 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 64 * ProportionAdapter;
        }else{
            return 22 * ProportionAdapter;
        }
    }else if (indexPath.section == 1) {
        
        if (self.addressHeight <= 50 * ProportionAdapter) {
            return 50 * ProportionAdapter;

        }else{
            return self.addressHeight;
        }

    }else if (indexPath.section == 2) {
        return 50 * ProportionAdapter;

    }else{
        return self.profileHeight + 60 * ProportionAdapter;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", [self.detailDic objectForKey:@"mobile"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 25 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, section == 1 ? 15 * ProportionAdapter : 0, screenWidth, 10 * ProportionAdapter)];
    lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:lB];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 25 * ProportionAdapter : 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
}


- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"球场模式：", @"建立时间：",@"球场面积：",@"果岭草种：",@"球洞数：",@"设计师：",@"球道长度：",@"球道草种：",      nil];
    }
    return _titleArray;
}

- (NSMutableArray *)proArray{
    if (!_proArray) {
        _proArray = [[NSMutableArray alloc] init];
    }
    return _proArray;
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
