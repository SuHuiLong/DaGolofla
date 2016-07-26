//
//  JGDHistoryScoreShowViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDHistoryScoreShowTableViewCell.h"

#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDTrueOrFalseTableViewCell.h"

@interface JGDHIstoryScoreDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *nameLB;

@end

@implementation JGDHIstoryScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记分卡";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareStatisticsDataClick)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDHistoryScoreShowTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[JGDTrueOrFalseTableViewCell class] forCellReuseIdentifier:@"TrueOrFalsecell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
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
    keyLB.text = [NSString stringWithFormat:@"%@", self.model.invitationCode];
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
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 135 * ProportionAdapter)];
        viewTitle.backgroundColor = [UIColor whiteColor];
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [viewTitle addSubview:lightV];
        
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
        [iconV sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[[self.dataDic objectForKey:@"srcKey"] integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        iconV.contentMode = UIViewContentModeScaleAspectFill;
        iconV.layer.cornerRadius = 8 * ProportionAdapter;
        iconV.layer.masksToBounds = YES;
        [viewTitle addSubview:iconV];
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(98 * ProportionAdapter, 26 * ProportionAdapter, 270 * ProportionAdapter, 30 * ProportionAdapter)];
        nameLB.text = [self.dataDic objectForKey:@"title"];

        nameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        nameLB.textColor = [UIColor colorWithHexString:@"313131"];
        [viewTitle addSubview:nameLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(88 * ProportionAdapter, 55 * ProportionAdapter, screenWidth - 100 * ProportionAdapter, 1 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        [viewTitle addSubview:lineView];
        
        UIImageView *locIcon = [[UIImageView alloc] initWithFrame:CGRectMake(98 * ProportionAdapter, 68 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
        locIcon.image = [UIImage imageNamed:@"juli"];
        [viewTitle addSubview:locIcon];
        
        UILabel *ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 60 * ProportionAdapter, 250 * ProportionAdapter, 30 * ProportionAdapter)];
        ballNameLB.text = [self.dataDic objectForKey:@"ballName"];
        ballNameLB.textColor = [UIColor colorWithHexString:@"666666"];
        ballNameLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [viewTitle addSubview:ballNameLB];
        
        UIView *lineLong = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 98 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 2.5 * ProportionAdapter)];
        lineLong.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
        [viewTitle addSubview:lineLong];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 108 * ProportionAdapter, 150 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameLB.text = [NSString stringWithFormat:@"%@(%@)", self.model.userName, self.model.tTaiwan];
        self.nameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [viewTitle addSubview:self.nameLB];
        
        
        UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 108 * ProportionAdapter, 90 * ProportionAdapter, 30)];
        allLB.text = @"总杆：          杆";
        allLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [viewTitle addSubview:allLB];
        
        UILabel *stemLB = [[UILabel alloc] initWithFrame:CGRectMake(310 * ProportionAdapter, 108 * ProportionAdapter, 39 * ProportionAdapter, 25 * ProportionAdapter)];
        stemLB.text = [self.model.poles stringValue];
        stemLB.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        stemLB.textAlignment = NSTextAlignmentCenter;
        stemLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        [viewTitle addSubview:stemLB];
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 140 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = [self.dataDic objectForKey:@"createtime"];
        timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [viewTitle addSubview:timeLB];
        
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(135 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV1.backgroundColor = [UIColor colorWithHexString:@"7fffff"];
        imageV1.layer.cornerRadius = 5 * ProportionAdapter;
        imageV1.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV1];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(152.5 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label1.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label1.text = @"Eagle";
        [viewTitle addSubview:Label1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(198.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV2.backgroundColor = [UIColor colorWithHexString:@"7fbfff"];
        imageV2.layer.cornerRadius = 5 * ProportionAdapter;
        imageV2.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV2];
        
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(216 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label2.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label2.text = @"Birdie";
        [viewTitle addSubview:Label2];
        
        UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(260.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV3.backgroundColor = [UIColor colorWithHexString:@"ffd2a6"];
        imageV3.layer.cornerRadius = 5 * ProportionAdapter;
        imageV3.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV3];
        
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(278 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label3.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label3.text = @"Par";
        [viewTitle addSubview:Label3];
        
        UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(310.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV4.backgroundColor = [UIColor colorWithHexString:@"ffaaa5"];
        imageV4.layer.cornerRadius = 5 * ProportionAdapter;
        imageV4.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV4];
        
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(328 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label4.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label4.text = @"Bogey";
        [viewTitle addSubview:Label4];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
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
        return 182 * ProportionAdapter;
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
            cell.colorImageV.backgroundColor = [UIColor clearColor];
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

    //    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreCard.html?teamKey=%@&userKey=%@&srcKey=1&srcType=1&scoreKey=0&md5=%@", _model.timeKey,DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%@&userKey=%@&srcKey=1&srcType=1dagolfla.com", _model.timeKey, DEFAULF_USERID]]];
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreCard.html?teamKey=0&userKey=%@&srcKey=%@&srcType=%@&scoreKey=%@&md5=%@&share=1", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"], _model.timeKey, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=%@dagolfla.com", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"]]]];
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"历史记分卡"];
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"大家看我打得怎么样" image:[UIImage imageNamed:IconLogo] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
