//
//  JGDHistoryScoreShowViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayerNotActScoreCardViewController.h"
#import "JGDAlmostScoreTableViewCell.h"

#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDNotActScoreDetailViewController.h"
#import "JGDHistoryScoreViewController.h"

#import "JGDNotActScoreViewController.h"
#import "JGDPlayPersonViewController.h"
#import "JGDPlayerNotActScoreDetailViewController.h"
#import "JGLCaddieScoreViewController.h"

@interface JGDPlayerNotActScoreCardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *isReversal;

@end

@implementation JGDPlayerNotActScoreCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;
    //    [self.tableView reloadData];
}

- (void)backBtn{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGDHistoryScoreViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGDPlayPersonViewController class]] || [vc isKindOfClass:[JGLCaddieScoreViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记分卡";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareStatisticsDataClick)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self setData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)setData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.timeKey forKey:@"scoreKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&scoreKey=%@dagolfla.com", DEFAULF_USERID, self.timeKey]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getScoreList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                NSArray *array = [data objectForKey:@"list"];
                
                for (NSDictionary *dic in array) {
                    JGDHistoryScoreShowModel *model = [[JGDHistoryScoreShowModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150 * ProportionAdapter)];
                UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
                lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
                
                UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 15 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
                allLB.text = @"差杆成绩（杆）";
                allLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                
                for (int i = 0; i < [self.dataArray count]; i ++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / [self.dataArray count] * i, 50 * ProportionAdapter, screenWidth / [self.dataArray count], 60 * ProportionAdapter)];
                    JGDHistoryScoreShowModel *model = self.dataArray[i];
                    NSInteger poleSum = 0;
                    NSInteger standSum = 0;
                    for (int i = 0; i < model.poleNumber.count; i ++) {
                        if ([model.poleNumber[i] integerValue] != -1) {
                            poleSum += [model.poleNumber[i] integerValue];
                            standSum += [model.standardlever[i] integerValue];
                        }
                    }
                    if (poleSum - standSum <= 0) {
                        label.text = [NSString stringWithFormat:@"%td", poleSum - standSum];
                    }else{
                        label.text = [NSString stringWithFormat:@"+%td", poleSum - standSum];
                    }
                    label.tag = 1000 + i;
                    label.textColor = [UIColor colorWithHexString:@"#fe6424"];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:30 * ProportionAdapter];
                    [view addSubview:label];
                }
                for (int i = 0; i < [self.dataArray count]; i ++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / [self.dataArray count] * i, 110 * ProportionAdapter, screenWidth / [self.dataArray count], 30 * ProportionAdapter)];
                    JGDHistoryScoreShowModel *model = self.dataArray[i];
                    label.text = model.userName;
                    label.tag = 2000 + i;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                    [view addSubview:label];
                }
                [view addSubview:allLB];
                [view addSubview:lightV];
                view.backgroundColor = [UIColor whiteColor];
                
                self.tableView.tableFooterView = view;
                if (self.ballkid == 10) {
                    self.name = [NSString stringWithFormat:@"球童 %@ 正在为您记分", [[data objectForKey:@"list"][0] objectForKey:@"scoreUserName"]];
                    
                    
                }else{
                    self.name = [NSString stringWithFormat:@"球童 %@ 记分", [[data objectForKey:@"list"][0] objectForKey:@"scoreUserName"]];
                }
            }
            
            
            
            
            if ([data objectForKey:@"score"]) {
                self.dataDic = [data objectForKey:@"score"];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.tableView reloadData];
        
    }];
}

- (void)changeAct{
    
    JGDNotActScoreViewController *almostVC = [[JGDNotActScoreViewController alloc] init];
    almostVC.timeKey = self.timeKey;
    almostVC.ballkid = self.ballkid;
    [self.navigationController pushViewController:almostVC animated:YES];
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDAlmostScoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150 * ProportionAdapter)];
    UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 15 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
    allLB.text = @"总杆成绩（杆）";
    allLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 4 * i, 50 * ProportionAdapter, screenWidth / 4, 60 * ProportionAdapter)];
        label.text = @"72";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30 * ProportionAdapter];
        [view addSubview:label];
    }
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 4 * i, 110 * ProportionAdapter, screenWidth / 4, 30 * ProportionAdapter)];
        label.text = @"张小章";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [view addSubview:label];
    }
    [view addSubview:allLB];
    [view addSubview:lightV];
    view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count] + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 152 * ProportionAdapter)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
        self.label.backgroundColor = [UIColor whiteColor];
        
        if (self.name) {
            if (self.ballkid == 10) {
                NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:self.name];
                [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(3, lbStr.length - 10)];
                self.label.attributedText = lbStr;
            }else{
                NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:self.name];
                [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(3, lbStr.length - 6)];
                self.label.attributedText = lbStr;
            }
            
        }
        
        self.label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:self.label];
        
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * ProportionAdapter, screenWidth, 82 * ProportionAdapter)];
        viewTitle.backgroundColor = [UIColor whiteColor];
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [viewTitle addSubview:lightV];
        
        
        UILabel *ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 260 * ProportionAdapter, 30 * ProportionAdapter)];
        ballNameLB.text = [self.dataDic objectForKey:@"ballName"];
        ballNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        ballNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [viewTitle addSubview:ballNameLB];
        
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = [self.dataDic objectForKey:@"createtime"];
        if ([timeStr length] >= 10) {
            timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];
        }        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [viewTitle addSubview:timeLB];
        
        UIButton *changeModelBtn = [[UIButton alloc] initWithFrame:CGRectMake(270 * ProportionAdapter, 5 * ProportionAdapter, 91 * ProportionAdapter, 38 * ProportionAdapter)];
        [changeModelBtn setImage:[UIImage imageNamed:@"btn_change"] forState:(UIControlStateNormal)];
        [changeModelBtn addTarget:self action:@selector(changeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [viewTitle addSubview:changeModelBtn];
        
//        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(135 * ProportionAdapter, 60 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
//        imageV1.backgroundColor = [UIColor colorWithHexString:@"7fffff"];
//        imageV1.layer.cornerRadius = 5 * ProportionAdapter;
//        imageV1.layer.masksToBounds = YES;
//        [viewTitle addSubview:imageV1];
//        
//        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(152.5 * ProportionAdapter, 50 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
//        Label1.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
//        Label1.text = @"Eagle";
//        [viewTitle addSubview:Label1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(198.5 * ProportionAdapter, 60 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV2.backgroundColor = [UIColor colorWithHexString:@"#3586d8"];
        imageV2.layer.cornerRadius = 5 * ProportionAdapter;
        imageV2.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV2];
        
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(216 * ProportionAdapter, 50 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label2.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label2.text = @"Par-";
        [viewTitle addSubview:Label2];
        
        UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(260.5 * ProportionAdapter, 60 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV3.backgroundColor = [UIColor colorWithHexString:@"#b4b3b3"];
        imageV3.layer.cornerRadius = 5 * ProportionAdapter;
        imageV3.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV3];
        
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(278 * ProportionAdapter, 50 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label3.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label3.text = @"Par";
        [viewTitle addSubview:Label3];
        
        UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(310.5 * ProportionAdapter, 60 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV4.backgroundColor = [UIColor colorWithHexString:@"#e8625a"];
        imageV4.layer.cornerRadius = 5 * ProportionAdapter;
        imageV4.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV4];
        
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(328 * ProportionAdapter, 50 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label4.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label4.text = @"Par+";
        [viewTitle addSubview:Label4];
        
        UILabel *partLB = [[UILabel alloc] initWithFrame:CGRectMake(0 * ProportionAdapter, 90 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
        if ([self.dataArray count] > 0) {
            JGDHistoryScoreShowModel *model = self.dataArray[0];
            partLB.text = [NSString stringWithFormat:@"   %@", model.region1];
        }
        partLB.backgroundColor = [UIColor whiteColor];
        partLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [viewTitle addSubview:partLB];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 115 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [viewTitle addSubview:greenView];
        [headerView addSubview:viewTitle];
        
        return headerView;
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
        return 177 * ProportionAdapter;
    }else{
        return 37 * ProportionAdapter;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDAlmostScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row > 0 && ([self.dataArray count] >= (indexPath.row - 1)) && ([self.dataArray count] > 0)) {
        NSLog(@"%td", indexPath.row);
        if (indexPath.row == 1) {
            [cell takeInfoWithModel:self.dataArray[0] index:indexPath];
        }else{
            [cell takeInfoWithModel:self.dataArray[indexPath.row - 2] index:indexPath];
        }
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.colorImageV.backgroundColor = [UIColor clearColor];
            cell.nameLB.text = @"Hole";
            cell.sumLB.text = @"Out";
            if ([self.dataArray count] > 0) {
                [cell setholeSWithModel:self.dataArray[0] index:indexPath];
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
            if ([self.dataArray count] > 0) {
                [cell setholeSWithModel:self.dataArray[0] index:indexPath];
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
        JGDPlayerNotActScoreDetailViewController *detailV = [[JGDPlayerNotActScoreDetailViewController alloc] init];
        JGDHistoryScoreShowModel *model = self.dataArray[indexPath.row - 2];
        detailV.model = model;
        detailV.ballkid = self.ballkid;
        detailV.dataDic = self.dataDic;
        detailV.isReversal = self.isReversal;
        [self.navigationController pushViewController:detailV animated:YES];
    }
}


// 分享
//统计记分点击事件
-(void)shareStatisticsDataClick
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
