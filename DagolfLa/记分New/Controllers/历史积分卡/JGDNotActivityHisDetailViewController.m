//
//  JGDHistoryScoreShowViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDNotActivityHisDetailViewController.h"
#import "JGDHistoryScoreShowTableViewCell.h"

#import "JGDNotActivityHisDetailViewController.h"
#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDTrueOrFalseTableViewCell.h"

@interface JGDNotActivityHisDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *nameLB;

@end

@implementation JGDNotActivityHisDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记分卡";
    
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDHistoryScoreShowTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[JGDTrueOrFalseTableViewCell class] forCellReuseIdentifier:@"TrueOrFalsecell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 75 * ProportionAdapter)];
    UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(37.5 * ProportionAdapter, 30 * ProportionAdapter, 300 * ProportionAdapter, 45 * ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    lightV.backgroundColor = [UIColor whiteColor];
    lightV.layer.cornerRadius = 5 * ProportionAdapter;
    lightV.layer.masksToBounds = YES;
    
    UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(50 * ProportionAdapter,0 * ProportionAdapter, 120 * ProportionAdapter, 45 * ProportionAdapter)];
    allLB.text = @"成绩领取密钥：";
    allLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [lightV addSubview:allLB];
    
    UILabel *keyLB = [[UILabel alloc] initWithFrame:CGRectMake(170 * ProportionAdapter, 0 * ProportionAdapter, 100 * ProportionAdapter, 45 * ProportionAdapter)];
    keyLB.text = @"123456";
    keyLB.textAlignment = NSTextAlignmentLeft;
    keyLB.textColor = [UIColor colorWithHexString:@"#fe7a7a"];
    keyLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [lightV addSubview:keyLB];
    
    [view addSubview:lightV];
        
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 92 * ProportionAdapter)];
        viewTitle.backgroundColor = [UIColor whiteColor];
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [viewTitle addSubview:lightV];

        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 15 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameLB.text = self.model.userName;
        self.nameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        self.nameLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [viewTitle addSubview:self.nameLB];
        
        
        UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 15 * ProportionAdapter, 90 * ProportionAdapter, 30)];
        allLB.text = @"总杆：          杆";
        allLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [viewTitle addSubview:allLB];
        
        UILabel *stemLB = [[UILabel alloc] initWithFrame:CGRectMake(310 * ProportionAdapter, 15 * ProportionAdapter, 39 * ProportionAdapter, 30 * ProportionAdapter)];
        stemLB.text = [self.model.poles stringValue];
        stemLB.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        stemLB.textAlignment = NSTextAlignmentCenter;
        stemLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        [viewTitle addSubview:stemLB];
        
        
        
        
        UILabel *ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter, 350 * ProportionAdapter, 30 * ProportionAdapter)];
        ballNameLB.text = [self.dataDic objectForKey:@"ballName"];
        ballNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        ballNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [viewTitle addSubview:ballNameLB];
        
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 80 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = [self.dataDic objectForKey:@"createtime"];
        if ([timeStr length] >= 10) {
            timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];
        }
        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [viewTitle addSubview:timeLB];
        
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(135 * ProportionAdapter, 90 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV1.backgroundColor = [UIColor colorWithHexString:@"7fffff"];
        imageV1.layer.cornerRadius = 5 * ProportionAdapter;
        imageV1.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV1];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(152.5 * ProportionAdapter, 80 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label1.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label1.text = @"Eagle";
        [viewTitle addSubview:Label1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(198.5 * ProportionAdapter, 90 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV2.backgroundColor = [UIColor colorWithHexString:@"7fbfff"];
        imageV2.layer.cornerRadius = 5 * ProportionAdapter;
        imageV2.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV2];
        
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(216 * ProportionAdapter, 80 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label2.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label2.text = @"Birdie";
        [viewTitle addSubview:Label2];
        
        UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(260.5 * ProportionAdapter, 90 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV3.backgroundColor = [UIColor colorWithHexString:@"ffd2a6"];
        imageV3.layer.cornerRadius = 5 * ProportionAdapter;
        imageV3.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV3];
        
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(278 * ProportionAdapter, 80 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label3.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label3.text = @"Par";
        [viewTitle addSubview:Label3];
        
        UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(310.5 * ProportionAdapter, 90 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV4.backgroundColor = [UIColor colorWithHexString:@"ffaaa5"];
        imageV4.layer.cornerRadius = 5 * ProportionAdapter;
        imageV4.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV4];
        
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(328 * ProportionAdapter, 80 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label4.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label4.text = @"Bogey";
        [viewTitle addSubview:Label4];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 120 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [viewTitle addSubview:greenView];
        
        return viewTitle;
    }else{
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 12 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [lightV addSubview:greenView];
        
        return lightV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 122 * ProportionAdapter;
    }else{
        return 12 * ProportionAdapter;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDHistoryScoreShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row > 0) {
        NSLog(@"%td", indexPath.row);
        if (indexPath.row == 4) {
            JGDTrueOrFalseTableViewCell *trueCell = [tableView dequeueReusableCellWithIdentifier:@"TrueOrFalsecell"];
            [trueCell takeDetailInfoWithModel:self.model index:indexPath];
            trueCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return trueCell;
        }else{
//            [cell.colorImageV removeFromSuperview];
            [cell takeDetailInfoWithModel:self.model index:indexPath];
        }
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
//            [cell.colorImageV removeFromSuperview];
            cell.colorImageV.backgroundColor = [UIColor clearColor];
            cell.nameLB.text = @"Hole";
            cell.sumLB.text = @"Out";
            for (UILabel *lb in cell.contentView.subviews) {
                if (lb.tag) {
                    lb.text = [NSString stringWithFormat:@"%td", lb.tag - 776];
                }
            }
        }else if (indexPath.row == 3) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        }

        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            [cell.colorImageV removeFromSuperview];
            cell.colorImageV.backgroundColor = [UIColor clearColor];
            cell.nameLB.text = @"Hole";
            cell.sumLB.text = @"In";
            for (UILabel *lb in cell.contentView.subviews) {
                if (lb.tag) {
                    lb.text = [NSString stringWithFormat:@"%td", lb.tag - 776 + 9];
                }
            }
        }else if (indexPath.row == 3) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        }

    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30 * ProportionAdapter;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 152 * ProportionAdapter; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
