//
//  JGDHistoryScoreShowViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDActSelfHistoryScoreViewController.h"
#import "JGDTeamShowTableViewCell.h"

#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDNotActivityHisDetailViewController.h"

@interface JGDActSelfHistoryScoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UITextField *chadianTF;
@property (nonatomic, strong) JGDHistoryScoreShowModel *model;
@property (nonatomic, strong) JGDHistoryScoreShowModel *dataModel;

@end

@implementation JGDActSelfHistoryScoreViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.chadianTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人成绩简单记分表";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareStatisticsDataClick)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self setData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)setData{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.scoreModel.scoreKey forKey:@"scoreKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:@0 forKey:@"teamKey"];
    [dic setObject:@1 forKey:@"srcType"];
    [dic setObject:self.timeKey forKey:@"srcKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", DEFAULF_USERID, self.timeKey]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getTeamScore" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            self.dataModel = [[JGDHistoryScoreShowModel alloc] init];
            [self.dataModel setValuesForKeysWithDictionary:data];
            if ([data objectForKey:@"bean"]) {
                self.model = [[JGDHistoryScoreShowModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[data objectForKey:@"bean"]];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.tableView reloadData];
        
    }];
}


- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDTeamShowTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * ProportionAdapter)];
        viewTitle.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
        titleLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        titleLB.text = self.dataModel.title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [viewTitle addSubview:titleLB];
        
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 45 * ProportionAdapter, 180 * ProportionAdapter, 25 * ProportionAdapter)];
        nameLB.text = self.dataModel.userName;
        nameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [viewTitle addSubview:nameLB];
        
        
        UILabel *ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 70 * ProportionAdapter, 260 * ProportionAdapter, 25 * ProportionAdapter)];
        ballNameLB.text = self.dataModel.ballName;
        ballNameLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        ballNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [viewTitle addSubview:ballNameLB];
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 70 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = self.dataModel.date;
        if ([timeStr length] >= 10) {
            timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];
        }        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        timeLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        timeLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [viewTitle addSubview:timeLB];
        
        UILabel *poleLB = [[UILabel alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 45 * ProportionAdapter, 80 * ProportionAdapter, 25 * ProportionAdapter)];
        poleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            NSString *pole = [NSString stringWithFormat:@"总杆：%@", self.model.poles];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pole];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fe6424"] range:NSMakeRange(3, str.length - 3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 * ProportionAdapter] range:NSMakeRange(0, 3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 * ProportionAdapter] range:NSMakeRange(3, str.length - 3)];
            poleLB.attributedText = str;
            [viewTitle addSubview:poleLB];
        
        
        if (1) {
            
            UILabel *chaDianLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 45 * ProportionAdapter, 50 * ProportionAdapter, 25 * ProportionAdapter)];
            chaDianLB.text = @"差点："; // saveAlmost
            chaDianLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            [viewTitle addSubview:chaDianLB];
            
            self.chadianTF = [[UITextField alloc] initWithFrame:CGRectMake(330 * ProportionAdapter, 45 * ProportionAdapter, 50 * ProportionAdapter, 25 * ProportionAdapter)];
            self.chadianTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            self.chadianTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.chadianTF.text = [self.model.almost stringValue];
            [viewTitle addSubview:self.chadianTF];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(315 * ProportionAdapter, 70 * ProportionAdapter, 50 * ProportionAdapter, 1 * ProportionAdapter)];
            view.backgroundColor = [UIColor blackColor];
            [viewTitle addSubview:view];
        }
        
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 98 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
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
        return 100 * ProportionAdapter;
    }else{
        return 12 * ProportionAdapter;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDTeamShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row > 0) {
        NSLog(@"%td", indexPath.row);
        if (indexPath.row == 1) {
            [cell takeInfoWithModel:self.model index:indexPath];
        }else{
            [cell takeInfoWithModel:self.model index:indexPath];
        }
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
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
            
        }else if (indexPath.row == 5) {
            
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
            
        }
        
    }else if (indexPath.section == 1) {
        NSLog(@"%td", indexPath.row);
        if (indexPath.row == 0) {
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
            
        }else if (indexPath.row == 5) {
            
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
    if (indexPath.row > 1) {
        JGDNotActivityHisDetailViewController *detailV = [[JGDNotActivityHisDetailViewController alloc] init];
        JGDHistoryScoreShowModel *model = self.dataArray[indexPath.row - 2];
        detailV.model = model;
        detailV.dataDic = self.dataDic;
        [self.navigationController pushViewController:detailV animated:YES];
    }
}



//保存差点
-(void)shareStatisticsDataClick
{
    [self.chadianTF endEditing:YES];
    
    if (self.chadianTF.text.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入差点" FromView:self.view];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEFAULF_USERID forKey:@"userKey"];
    [dic setValue:@"" forKey:@"teamKey"];
    [dic setValue:@"" forKey:@"scoreKey"];
    [dic setValue:self.chadianTF.text forKey:@"almost"];
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"/saveAlmost" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"差点保存成功" FromView:self.view];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    
}
-(void)shareInfo:(NSInteger)index
{
    
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreTable.html?teamKey=0&userKey=%@&srcKey=%@&srcType=%@&scoreKey=%@&md5=%@&share=1", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"], self.timeKey, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=%@dagolfla.com", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"]]]];
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"历史记分卡"];
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"大家来看我打得怎么样" image:[UIImage imageNamed:IconLogo] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"大家来看我打得怎么样" image:[UIImage imageNamed:IconLogo] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:IconLogo];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"大家来看我打得怎么样",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        
        //  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"打高尔夫啦" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        //
        //        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
        //              ////NSLog(@"分享成功！");
        //        }
        //   }];
        //
        
    }
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
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
