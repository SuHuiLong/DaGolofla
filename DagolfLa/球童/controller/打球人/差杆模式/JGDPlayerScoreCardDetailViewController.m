//
//  JGDHistoryScoreShowViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayerScoreCardDetailViewController.h"
#import "JGDAlmostScoreTableViewCell.h"

#import "JGDHIstoryScoreDetailViewController.h"
#import "JGDTrueOrFalseTableViewCell.h"
#import "JGDPlayerHisScoreCardViewController.h"
#import "JGDPlayerScoreCardViewController.h"

#import "JGDPlayerHisScoreDetailViewController.h"
#import "JGHScoresViewController.h"


@interface JGDPlayerScoreCardDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *keyLB;

@end

@implementation JGDPlayerScoreCardDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;
    //    [self.tableView reloadData];
    
    
}

- (void)backBtn{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGDPlayerHisScoreCardViewController class]] || [vc isKindOfClass:[JGDPlayerScoreCardViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记分卡";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareStatisticsDataClick)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self createTableView];
    
    if (_fromLive == 5) {
        [self setData];
    }
    
    // Do any additional setup after loading the view.
}


- (void)setData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.scoreKey forKey:@"scoreKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:self.srcKey forKey:@"srcKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", DEFAULF_USERID, self.srcKey]] forKey:@"md5"];
    [dic setObject:@0 forKey:@"teamKey"];
    [dic setObject:@1 forKey:@"srcType"];
    
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getUserScore" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            self.dataDic = data;
            
            if ([data objectForKey:@"bean"]) {
                self.model = [[JGDHistoryScoreShowModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[data objectForKey:@"bean"]];
            }
            self.keyLB.text =  [NSString stringWithFormat:@"%@", self.model.invitationCode];
            
            [self.tableView reloadData];
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
    [self.tableView registerClass:[JGDAlmostScoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[JGDTrueOrFalseTableViewCell class] forCellReuseIdentifier:@"TrueOrFalsecell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 75 * ProportionAdapter)];
    UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(37.5 * ProportionAdapter, 12 * ProportionAdapter, 300 * ProportionAdapter, 45 * ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    lightV.backgroundColor = [UIColor whiteColor];
    lightV.layer.cornerRadius = 5 * ProportionAdapter;
    lightV.layer.masksToBounds = YES;
    
    UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(50 * ProportionAdapter,0 * ProportionAdapter, 120 * ProportionAdapter, 45 * ProportionAdapter)];
    allLB.text = @"记分卡密钥：";
    allLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [lightV addSubview:allLB];
    
    UILabel *tipLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 5 * ProportionAdapter, 300 * ProportionAdapter, 20 * ProportionAdapter)];
    tipLB.text = @"注：长按杆数区，进入编辑页，可修改成绩！";
    tipLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    [view addSubview:tipLB];
    
    self.keyLB = [[UILabel alloc] initWithFrame:CGRectMake(170 * ProportionAdapter, 0 * ProportionAdapter, 100 * ProportionAdapter, 45 * ProportionAdapter)];
    self.keyLB.text = [NSString stringWithFormat:@"%@", self.model.invitationCode];
    self.keyLB.textAlignment = NSTextAlignmentLeft;
    self.keyLB.textColor = [UIColor colorWithHexString:@"#fe7a7a"];
    self.keyLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [lightV addSubview:self.keyLB];
    
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
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 228 * ProportionAdapter)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
        label.backgroundColor = [UIColor whiteColor];
        
        if (self.ballkid == 10) {
            NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"球童 %@ 正在为您记分", self.model.scoreUserName]];
            [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(3, lbStr.length - 10)];
            label.attributedText = lbStr;
            
            
        }else{
            NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"球童 %@ 记分", self.model.scoreUserName]];
            [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(3, lbStr.length - 6)];
            label.attributedText = lbStr;
        }
        
        //        NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:@"球童 王二狗 正在为您记分"];
        //        [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(3, lbStr.length - 10)];
        //        label.attributedText = lbStr;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * ProportionAdapter, screenWidth, 165 * ProportionAdapter)];
        viewTitle.backgroundColor = [UIColor whiteColor];
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [viewTitle addSubview:lightV];
        
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
        if (_fromLive == 5) {
            [iconV sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[self.srcKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        }else{
            [iconV sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[[self.dataDic objectForKey:@"srcKey"] integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        }
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
        
        
        UILabel *allLB = [[UILabel alloc] initWithFrame:CGRectMake(270 * ProportionAdapter, 108 * ProportionAdapter, 110 * ProportionAdapter, 30)];
        allLB.text = @"总差杆：          杆";
        allLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [viewTitle addSubview:allLB];
        
        UILabel *stemLB = [[UILabel alloc] initWithFrame:CGRectMake(310 * ProportionAdapter, 108 * ProportionAdapter, 39 * ProportionAdapter, 25 * ProportionAdapter)];
        NSInteger poleSum = 0;
        NSInteger standSum = 0;
        for (int i = 0; i < self.model.poleNumber.count; i ++) {
            if ([self.model.poleNumber[i] integerValue] != -1) {
                poleSum += [self.model.poleNumber[i] integerValue];
                standSum += [self.model.standardlever[i] integerValue];
            }
        }
        if (poleSum - standSum <= 0) {
            stemLB.text = [NSString stringWithFormat:@"%td", poleSum - standSum];
        }else{
            stemLB.text = [NSString stringWithFormat:@"+%td", poleSum - standSum];
        }
        stemLB.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
        stemLB.textAlignment = NSTextAlignmentCenter;
        stemLB.textColor = [UIColor colorWithHexString:@"#fe6424"];
        [viewTitle addSubview:stemLB];
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 140 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        NSString *timeStr = [self.dataDic objectForKey:@"createtime"];
        timeLB.text =  [timeStr substringWithRange:NSMakeRange(0, 10)];        timeLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [viewTitle addSubview:timeLB];
        
        UIButton *changeModelBtn = [[UIButton alloc] initWithFrame:CGRectMake(270 * ProportionAdapter, 5 * ProportionAdapter, 91 * ProportionAdapter, 38 * ProportionAdapter)];
        [changeModelBtn setImage:[UIImage imageNamed:@"btn_change"] forState:(UIControlStateNormal)];
        [changeModelBtn addTarget:self action:@selector(changeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [viewTitle addSubview:changeModelBtn];
        
//        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(135 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
//        imageV1.backgroundColor = [UIColor colorWithHexString:@"7fffff"];
//        imageV1.layer.cornerRadius = 5 * ProportionAdapter;
//        imageV1.layer.masksToBounds = YES;
//        [viewTitle addSubview:imageV1];
//        
//        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(152.5 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
//        Label1.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
//        Label1.text = @"Eagle";
//        [viewTitle addSubview:Label1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(198.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV2.backgroundColor = [UIColor colorWithHexString:@"#3586d8"];
        imageV2.layer.cornerRadius = 5 * ProportionAdapter;
        imageV2.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV2];
        
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(216 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label2.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label2.text = @"par-";
        [viewTitle addSubview:Label2];
        
        UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(260.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV3.backgroundColor = [UIColor colorWithHexString:@"#b4b3b3"];
        imageV3.layer.cornerRadius = 5 * ProportionAdapter;
        imageV3.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV3];
        
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(278 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label3.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label3.text = @"Par";
        [viewTitle addSubview:Label3];
        
        UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(310.5 * ProportionAdapter, 150 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        imageV4.backgroundColor = [UIColor colorWithHexString:@"#e8625a"];
        imageV4.layer.cornerRadius = 5 * ProportionAdapter;
        imageV4.layer.masksToBounds = YES;
        [viewTitle addSubview:imageV4];
        
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(328 * ProportionAdapter, 140 * ProportionAdapter, 44 * ProportionAdapter, 30 * ProportionAdapter)];
        Label4.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        Label4.text = @"Par-";
        [viewTitle addSubview:Label4];
        
        UILabel *partLB = [[UILabel alloc] initWithFrame:CGRectMake(0 * ProportionAdapter, 173 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
        partLB.text = [NSString stringWithFormat:@"   %@", self.model.region1];
        partLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        partLB.backgroundColor = [UIColor whiteColor];
        [viewTitle addSubview:partLB];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 195 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [viewTitle addSubview:greenView];
        [headerView addSubview:viewTitle];
        
        return headerView;
    }else{
        
        UIView *lightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 12 * ProportionAdapter)];
        lightV.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        UILabel *partLB = [[UILabel alloc] initWithFrame:CGRectMake(0 * ProportionAdapter, 10 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
        partLB.text = [NSString stringWithFormat:@"   %@", self.model.region2];
        partLB.backgroundColor = [UIColor whiteColor];
        partLB.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [lightV addSubview:partLB];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
        greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [lightV addSubview:greenView];
        
        return lightV;
    }
}

//切换差杆模式
- (void)changeAct{
    JGDPlayerHisScoreDetailViewController *AlmostDetailVC = [[JGDPlayerHisScoreDetailViewController alloc] init];
    AlmostDetailVC.dataDic = self.dataDic;
    AlmostDetailVC.model = self.model;
    AlmostDetailVC.ballkid = self.ballkid;
    AlmostDetailVC.fromLive = self.fromLive;
    AlmostDetailVC.srcKey = self.srcKey;
    AlmostDetailVC.scoreKey = self.scoreKey;
    [self.navigationController pushViewController:AlmostDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 253 * ProportionAdapter; // 182
    }else{
        return 37 * ProportionAdapter;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    JGDAlmostScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
            [cell setholeSWithModel:self.model index:indexPath];

        }else if (indexPath.row == 3) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        }
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            for (UILabel *lb in cell.contentView.subviews) {
                if (lb.tag) {
                    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPGAct1:)];
                    [lb addGestureRecognizer:longPG];
                }
            }
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //            [cell.colorImageV removeFromSuperview];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.colorImageV.backgroundColor = [UIColor clearColor];
            cell.nameLB.text = @"Hole";
            cell.sumLB.text = @"In";
            [cell setholeSWithModel:self.model index:indexPath];

        }else if (indexPath.row == 3) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        }else if (indexPath.row == 2) {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            for (UILabel *lb in cell.contentView.subviews) {
                if (lb.tag) {
                    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPGAct2:)];
                    [lb addGestureRecognizer:longPG];
                }
            }
        }
    }
    
    return cell;
}

// 上半场 长按
- (void)longPGAct1:(UILongPressGestureRecognizer *)longPG {

    if (self.ballkid == 10) {
        [[ShowHUD showHUD]showToastWithText:@"记分未完成" FromView:self.view];
    }else{
        [Helper alertViewWithTitle:@"点击“确定”修改成绩" withBlockCancle:^{
            NSLog(@"－－－cancle");
        } withBlockSure:^{
            JGHScoresViewController *scoreVC = [[JGHScoresViewController alloc] init];
            scoreVC.backHistory = 1;
            if ([self.isReversal integerValue] == 1) {
                scoreVC.currentPage = [longPG view].tag - 777 + 9;
            }else{
                scoreVC.currentPage = [longPG view].tag - 777;
            }
            scoreVC.scorekey = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"timeKey"]];
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            [userdf setObject:@"1" forKey:[NSString stringWithFormat:@"switchMode%@", [self.dataDic objectForKey:@"timeKey"]]];
            [userdf synchronize];
            [self.navigationController pushViewController:scoreVC animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }

}

// 下半场 长按
- (void)longPGAct2:(UILongPressGestureRecognizer *)longPG {
    
    if (self.ballkid == 10) {
        [[ShowHUD showHUD]showToastWithText:@"记分未完成" FromView:self.view];
    }else{
        [Helper alertViewWithTitle:@"点击“确定”修改成绩" withBlockCancle:^{
            NSLog(@"cancle");
        } withBlockSure:^{
            JGHScoresViewController *scoreVC = [[JGHScoresViewController alloc] init];
            scoreVC.backHistory = 1;
            if ([self.isReversal integerValue] == 1) {
                scoreVC.currentPage = [longPG view].tag - 777;
            }else{
                scoreVC.currentPage = [longPG view].tag - 777 + 9;
            }
            scoreVC.scorekey = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"timeKey"]];
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            [userdf setObject:@"1" forKey:[NSString stringWithFormat:@"switchMode%@", [self.dataDic objectForKey:@"timeKey"]]];
            [userdf synchronize];
            [self.navigationController pushViewController:scoreVC animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
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
    
    /*
     [dic setObject:self.scoreKey forKey:@"scoreKey"];
     [dic setObject:DEFAULF_USERID forKey:@"userKey"];
     [dic setObject:self.srcKey forKey:@"srcKey"];
     [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", DEFAULF_USERID, self.srcKey]] forKey:@"md5"];
     [dic setObject:@0 forKey:@"teamKey"];
     [dic setObject:@1 forKey:@"srcType"];
     */
    
    
    NSString*  shareUrl;
    if (_fromLive == 5) {
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreCard.html?teamKey=0&userKey=%@&srcKey=%@&srcType=1&scoreKey=%@&md5=%@&share=1", DEFAULF_USERID, self.srcKey, self.scoreKey, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=1dagolfla.com", DEFAULF_USERID, self.srcKey]]];
        
    }else{
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreCard.html?teamKey=0&userKey=%@&srcKey=%@&srcType=%@&scoreKey=%@&md5=%@&share=1", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"], _model.timeKey, [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=0&userKey=%@&srcKey=%@&srcType=%@dagolfla.com", DEFAULF_USERID, [self.dataDic objectForKey:@"srcKey"], [self.dataDic objectForKey:@"srcType"]]]];
    }
    
    
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
