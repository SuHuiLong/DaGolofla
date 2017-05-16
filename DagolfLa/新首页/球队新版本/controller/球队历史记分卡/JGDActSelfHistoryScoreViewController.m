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
#import "JGHRetrieveScoreViewController.h"

@interface JGDActSelfHistoryScoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UITextField *chadianTF;
@property (nonatomic, strong) JGDHistoryScoreShowModel *model;
@property (nonatomic, strong) JGDHistoryScoreShowModel *dataModel;

@property (nonatomic, strong) UILabel *poleLB;
@property (nonatomic, strong) UILabel *chaDianLB;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *viewTitle;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, strong) UILabel *keyLB;

@end

@implementation JGDActSelfHistoryScoreViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if ([self.model.almost integerValue] == 0 && _fromManeger != 6) {
        [self.chadianTF becomeFirstResponder];
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareStatisticsDataClick)];
        rightBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBar;
    }

    if (_fromManeger == 6) {
        self.poleLB.frame = CGRectMake(280 * ProportionAdapter, 45 * ProportionAdapter, 80 * ProportionAdapter, 25 * ProportionAdapter);
        [self.chadianTF removeFromSuperview];
        [self.chaDianLB removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.viewTitle addSubview:self.poleLB];
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(realShareStatisticsDataClick)];
        rightBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBar;
        
    }else{
        [self.viewTitle addSubview: self.chadianTF];
        [self.viewTitle addSubview: self.chaDianLB];
        [self.viewTitle addSubview: self.lineView];
        [self.viewTitle addSubview:self.poleLB];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人成绩简单记分表";
    
    [self setData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)setData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_fromManeger == 6) {
        [dic setObject:self.scoreKey forKey:@"scoreKey"];
        [dic setObject:self.userKey forKey:@"userKey"];
        [dic setObject:self.srcKey forKey:@"srcKey"];
        [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", self.userKey, self.srcKey]] forKey:@"md5"];
    }else{
        [dic setObject:self.scoreModel.scoreKey forKey:@"scoreKey"];
        [dic setObject:self.scoreModel.userKey forKey:@"userKey"];
        [dic setObject:self.timeKey forKey:@"srcKey"];
        [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", self.scoreModel.userKey, self.timeKey]] forKey:@"md5"];
    }
    [dic setObject:@0 forKey:@"teamKey"];
    [dic setObject:@1 forKey:@"srcType"];

    
    [[JsonHttp jsonHttp] httpRequest:@"score/getTeamScore" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            self.dataModel = [[JGDHistoryScoreShowModel alloc] init];
            [self.dataModel setValuesForKeysWithDictionary:data];
            NSLog(@"-------******%@", [data objectForKey:@"almost"]);

            if ([data objectForKey:@"bean"]) {
                self.model = [[JGDHistoryScoreShowModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[data objectForKey:@"bean"]];
            }
            
            if ([[data objectForKey:@"bean"] objectForKey:@"invitationCode"]) {
                self.invitationCode = [[data objectForKey:@"bean"] objectForKey:@"invitationCode"];
                self.keyLB.text = [NSString stringWithFormat:@"%@      取回记分 >>",[[data objectForKey:@"bean"] objectForKey:@"invitationCode"]];
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
    
    if (_fromManeger == 6) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 75 * ProportionAdapter)];
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(37.5 * ProportionAdapter, 30 * ProportionAdapter, 300 * ProportionAdapter, 45 * ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        lightV.backgroundColor = [UIColor whiteColor];
        lightV.layer.cornerRadius = 5 * ProportionAdapter;
        lightV.layer.masksToBounds = YES;
        
        UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter,0 * ProportionAdapter, 120 * ProportionAdapter, 45 * ProportionAdapter)];
        allLB.text = @"记分卡密钥：";
        allLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [lightV addSubview:allLB];
        
       self.keyLB = [[UILabel alloc] initWithFrame:CGRectMake(130 * ProportionAdapter, 0 * ProportionAdapter, 200 * ProportionAdapter, 45 * ProportionAdapter)];
        self.keyLB.text = [NSString stringWithFormat:@"%@      取回记分 >>", self.invitationCode];
        self.keyLB.textAlignment = NSTextAlignmentLeft;
        self.keyLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        self.keyLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [lightV addSubview:self.keyLB];
       
        UITapGestureRecognizer *tapAct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
        [self.keyLB addGestureRecognizer:tapAct];
        self.keyLB.userInteractionEnabled = YES;
        UIView *lightLine = [[UIView alloc] initWithFrame:CGRectMake(60 * ProportionAdapter, 0, 1 * ProportionAdapter, 45 * ProportionAdapter)];
        lightLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.keyLB addSubview:lightLine];
        
        [view addSubview:lightV];
        
        self.tableView.tableFooterView = view;
    }
    
    
    [self.view addSubview:self.tableView];
}

- (void)tapAct{
//     self.invitationCode
    JGHRetrieveScoreViewController *retriveVC = [[JGHRetrieveScoreViewController alloc] init];
    if (self.invitationCode) {
        retriveVC.invitationCode = self.invitationCode;
    }
    [self.navigationController pushViewController:retriveVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        self.viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * ProportionAdapter)];
        self.viewTitle.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
        titleLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        titleLB.text = self.dataModel.title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [self.viewTitle addSubview:titleLB];
        
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 45 * ProportionAdapter, 180 * ProportionAdapter, 25 * ProportionAdapter)];
        nameLB.text = self.dataModel.userName;
        nameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.viewTitle addSubview:nameLB];
        
        
        UILabel *ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 70 * ProportionAdapter, 260 * ProportionAdapter, 25 * ProportionAdapter)];
        ballNameLB.text = self.dataModel.ballName;
        ballNameLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        ballNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.viewTitle addSubview:ballNameLB];
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 70 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = self.dataModel.date;
        if ([timeStr length] >= 10) {
            timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];
        }        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        timeLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        timeLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [self.viewTitle addSubview:timeLB];
        
        self.poleLB = [[UILabel alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 45 * ProportionAdapter, 80 * ProportionAdapter, 25 * ProportionAdapter)];
        self.poleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            NSString *pole = [NSString stringWithFormat:@"总杆：%@", (self.model.poles)?self.model.poles:@""];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pole];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fe6424"] range:NSMakeRange(3, str.length - 3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 * ProportionAdapter] range:NSMakeRange(0, 3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 * ProportionAdapter] range:NSMakeRange(3, str.length - 3)];
            self.poleLB.attributedText = str;
        
        
        if (1) {
            
            self.chaDianLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 45 * ProportionAdapter, 50 * ProportionAdapter, 25 * ProportionAdapter)];
            self.chaDianLB.text = @"差点："; // saveAlmost
            self.chaDianLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
//            [self.viewTitle addSubview:self.chaDianLB];
            
            self.chadianTF = [[UITextField alloc] initWithFrame:CGRectMake(320 * ProportionAdapter, 45 * ProportionAdapter, 50 * ProportionAdapter, 25 * ProportionAdapter)];
            self.chadianTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            self.chadianTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.chadianTF.text = [NSString stringWithFormat:@"%.2f", [self.model.almost floatValue]];
            if ([self.model.almost integerValue] != 0) {
                self.chadianTF.userInteractionEnabled = NO;
            }
//            [self.viewTitle addSubview:self.chadianTF];
            
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(315 * ProportionAdapter, 70 * ProportionAdapter, 50 * ProportionAdapter, 1 * ProportionAdapter)];
            self.lineView.backgroundColor = [UIColor blackColor];
//            [self.viewTitle addSubview:self.lineView];
        }
        
        UILabel *partLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 98 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
        if ([self.dataArray count] > 0) {
            JGDHistoryScoreShowModel *model = self.dataArray[0];
            partLB.text = model.region1;
        }
        partLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [self.viewTitle addSubview:partLB];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 123 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [self.viewTitle addSubview:greenView];
        
        return self.viewTitle;
    }else{
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 12 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        UILabel *partLB = [[UILabel alloc] initWithFrame:CGRectMake(0 * ProportionAdapter, 10 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
        if ([self.dataArray count] > 0) {
            JGDHistoryScoreShowModel *model = self.dataArray[0];
            partLB.text = [NSString stringWithFormat:@"   %@", model.region2];
        }
        partLB.backgroundColor = [UIColor whiteColor];
        partLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [lightV addSubview:partLB];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [lightV addSubview:greenView];
        
        return lightV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 125 * ProportionAdapter;
    }else{
        return 37 * ProportionAdapter;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDTeamShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row > 0) {

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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row > 1) {
//        JGDNotActivityHisDetailViewController *detailV = [[JGDNotActivityHisDetailViewController alloc] init];
//        JGDHistoryScoreShowModel *model = self.dataArray[indexPath.row - 2];
//        detailV.model = model;
//        detailV.dataDic = self.dataDic;
//        [self.navigationController pushViewController:detailV animated:YES];
//    }
//}
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
    [dic setValue:self.teamKey forKey:@"teamKey"];
    [dic setValue:self.scoreModel.scoreKey  forKey:@"scoreKey"];
    [dic setValue:self.chadianTF.text forKey:@"almost"];
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/saveAlmost" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showToastWithText:@"差点保存成功" FromView:self.view];
            if (_isblock == 1) {
                _refrehData();
            }
            
            [self performSelector:@selector(pop) withObject:self afterDelay:TIMESlEEP];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)realShareStatisticsDataClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}


-(void)shareInfo:(NSInteger)index
{
    
    // http://imgcache.dagolfla.com/share/score/scoreDetail.html?teamKey=222&userKey=1&srcKey=1&srcType=1&key=11&share=1
    /*
     [dic setObject:self.scoreKey forKey:@"scoreKey"];
     [dic setObject:self.userKey forKey:@"userKey"];
     [dic setObject:self.srcKey forKey:@"srcKey"];
     [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", self.userKey, self.srcKey]] forKey:@"md5"];
     */
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreDetail.html?teamKey=0&userKey=%@&srcKey=%@&srcType=1&key=%@&share=1&md5=%@", self.userKey, self.srcKey, self.scoreKey, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", self.userKey, self.srcKey]]];

    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"个人成绩简单记分表"];
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
