//
//  JGNewsViewController.m
//  DagolfLa
//
//  Created by 東 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGNewsViewController.h"
#import "JGNewsSubViewController.h"
#import "JGNewsTableViewCell.h"
#import "JGWkNewsViewController.h"

@interface JGNewsViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) UIView *titleBackView;
@property (nonatomic, strong) UIScrollView *scroller;

@property (nonatomic, strong) UITableView *currentTable;

@property (nonatomic, assign) NSInteger currentType;  // 1  2 3 4 @"赛事", @"球技", @"活动", @"视频"

@property (nonatomic, strong) NSMutableArray *matchDataArray;
@property (nonatomic, strong) NSMutableArray *ballSkillDataArray;
@property (nonatomic, strong) NSMutableArray *activityDataArray;
@property (nonatomic, strong) NSMutableArray *videoDataArray;

@property (nonatomic, assign) NSInteger matchOffset;
@property (nonatomic, assign) NSInteger ballSkillOffset;
@property (nonatomic, assign) NSInteger activityOffset;
@property (nonatomic, assign) NSInteger videoOffset;

@property (nonatomic, strong) NSMutableArray *allDataArray;

@property (nonatomic, assign) CGFloat contantOffSetY1;
@property (nonatomic, assign) CGFloat contantOffSetY2;

@end

@implementation JGNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"高球资讯";
    
    self.allDataArray = [NSMutableArray arrayWithObjects:self.matchDataArray, self.ballSkillDataArray, self.activityDataArray, self.videoDataArray, nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    NSArray *titleArray = [NSArray arrayWithObjects:@"赛事 ", @"球技 ", @"活动 ", @"视频 ", nil];
    
    self.titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 54 * ProportionAdapter)];
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *titleLB = [self lablerect:CGRectMake(i * screenWidth / titleArray.count, 10 * ProportionAdapter, screenWidth / 4, 44 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:17 text:titleArray[i] textAlignment:(NSTextAlignmentCenter)];
        titleLB.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
        titleLB.tag = 500 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitle:)];
        [titleLB addGestureRecognizer:tap];
        titleLB.userInteractionEnabled = YES;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * screenWidth / titleArray.count, 10 * ProportionAdapter, screenWidth / 4, 44 * ProportionAdapter)];
        imageV.tag = 400 + i;
        imageV.contentMode = UIViewContentModeScaleToFill;
        
        
        if (i == 0) {
            titleLB.textColor = [UIColor blackColor];
            //            titleLB.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line_news"]];
            imageV.image = [UIImage imageNamed:@"line_news"];
        }else{
            //            titleLB.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linedot_news"]];
            imageV.image = [UIImage imageNamed:@"linedot_news"];
        }
        
        [self.titleBackView addSubview:imageV];
        
        [self.titleBackView addSubview:titleLB];
    
        if (i > 0) {
            UILabel *lineLB = [self lablerect:CGRectMake(i * screenWidth / titleArray.count, 22 * ProportionAdapter, 1 * ProportionAdapter, 20 * ProportionAdapter)  labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
            lineLB.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [self.titleBackView addSubview:lineLB];
        }
    
    
    
    
    }
    [self.view addSubview:self.titleBackView];
    
    
    // UIScrollView
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 54 * ProportionAdapter, screenWidth, screenHeight)];
    self.scroller.delegate = self;
    self.scroller.contentSize = CGSizeMake(screenWidth * 4, screenHeight);
    self.scroller.pagingEnabled = YES;
    self.scroller.bounces = NO;
    self.scroller.tag = 700;
    //    self.scroller.scrollEnabled = NO;
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * screenWidth  , 0, screenWidth, screenHeight - 54 * ProportionAdapter - 64)];
        tableView.tag = 300 + i;
        [tableView registerClass:[JGNewsTableViewCell class] forCellReuseIdentifier:@"newsCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
        [tableView.mj_header beginRefreshing];
        
        
        [self.scroller addSubview:tableView];
    }
    self.currentTable = [self.scroller viewWithTag:300];
    
    [self.view addSubview:self.scroller];
    
    self.matchOffset = 0;
    self.ballSkillOffset = 0;
    self.activityOffset = 0;
    self.videoOffset = 0;
    
    self.currentType = 1;
    [self downLoadData];
    // Do any additional setup after loading the view. type  [def objectForKey:CITYNAME]
}

- (void)headRefresh{
    switch (self.currentType) {
            
        case 1:
            self.matchOffset = 0;
            break;
            
        case 2:
            self.ballSkillOffset = 0;
            break;
            
        case 3:
            self.activityOffset = 0;
            break;
            
        case 4:
            self.videoOffset = 0;
            break;
            
        default:
            break;
    }
    [self downLoadData];
}

- (void)footRefresh{
    switch (self.currentType) {
            
        case 1:
            self.matchOffset ++;
            break;
            
        case 2:
            self.ballSkillOffset ++;
            break;
            
        case 3:
            self.activityOffset ++;
            break;
            
        case 4:
            self.videoOffset ++;
            break;
            
        default:
            break;
    }
    [self downLoadData];
}

#pragma mark -- 加载数据

- (void)downLoadData{
    
    NSInteger offset = 0;
    switch (self.currentType) {
        case 1:
            offset = self.matchOffset;
            break;
            
        case 2:
            offset = self.ballSkillOffset;
            break;
            
        case 3:
            offset = self.activityOffset;
            break;
            
        case 4:
            offset = self.videoOffset;
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (DEFAULF_USERID) {
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
        [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&type=%tddagolfla.com", DEFAULF_USERID, self.currentType]] forKey:@"md5"];
    }else{
        [dic setObject:@0 forKey:@"userKey"];
        [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=0&type=%tddagolfla.com", self.currentType]] forKey:@"md5"];
    }
    [dic setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [dic setObject:[NSNumber numberWithInteger:self.currentType] forKey:@"type"];
    
    if (offset == 0) {
        //        [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    }
    [[JsonHttp jsonHttp] httpRequest:@"news/getNewList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [self.currentTable.mj_header endRefreshing];
        [self.currentTable.mj_footer endRefreshing];
        
        //        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [self.currentTable.mj_header endRefreshing];
        [self.currentTable.mj_footer endRefreshing];
        
        //        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (offset == 0) {
                
                switch (self.currentType) {
                        
                    case 1:
                        [self.matchDataArray removeAllObjects];
                        break;
                        
                    case 2:
                        [self.ballSkillDataArray removeAllObjects];
                        break;
                        
                    case 3:
                        [self.activityDataArray removeAllObjects];
                        break;
                        
                    case 4:
                        [self.videoDataArray removeAllObjects];
                        break;
                        
                    default:
                        break;
                }
            }
            
            if ([data objectForKey:@"newList"]) {
                
                switch (self.currentType) {
                        
                    case 1:
                        [self.matchDataArray addObjectsFromArray:[data objectForKey:@"newList"]];
                        break;
                        
                    case 2:
                        [self.ballSkillDataArray addObjectsFromArray:[data objectForKey:@"newList"]];
                        break;
                        
                    case 3:
                        [self.activityDataArray addObjectsFromArray:[data objectForKey:@"newList"]];
                        break;
                        
                    case 4:
                        [self.videoDataArray addObjectsFromArray:[data objectForKey:@"newList"]];
                        break;
                        
                    default:
                        break;
                }
            }
            [self.currentTable reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}



#pragma mark --- scroller delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.contantOffSetY1 = scrollView.contentOffset.y;
    self.contantOffSetY2 = self.contantOffSetY1 + scrollView.contentOffset.y;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView.tag != 700) {
        return;
    }
    
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x < screenWidth) {
        
        self.currentTable = [self.scroller viewWithTag:300];
        UILabel *lable = [self.titleBackView viewWithTag:500];
        lable.textColor = [UIColor blackColor];
        for (UILabel *subLable in self.titleBackView.subviews) {
            if (subLable.tag != 500 && [subLable isKindOfClass:[UILabel class]]) {
                subLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
        self.currentType = 1;
        if ([self.matchDataArray count] == 0) {
            [self downLoadData];
        }
        [self changeSeleCt:400];
    }else if (scrollView.contentOffset.x >= screenWidth && scrollView.contentOffset.x < screenWidth * 2){
        
        self.currentTable = [self.scroller viewWithTag:301];
        UILabel *lable = [self.titleBackView viewWithTag:501];
        lable.textColor = [UIColor blackColor];
        for (UILabel *subLable in self.titleBackView.subviews) {
            if (subLable.tag != 501 && [subLable isKindOfClass:[UILabel class]]) {
                subLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
        self.currentType = 2;
        if ([self.ballSkillDataArray count] == 0) {
            [self downLoadData];
        }
        [self changeSeleCt:401];
    }else if (scrollView.contentOffset.x >= screenWidth * 2 && scrollView.contentOffset.x < screenWidth * 3){
        
        self.currentTable = [self.scroller viewWithTag:302];
        UILabel *lable = [self.titleBackView viewWithTag:502];
        lable.textColor = [UIColor blackColor];
        for (UILabel *subLable in self.titleBackView.subviews) {
            if (subLable.tag != 502 && [subLable isKindOfClass:[UILabel class]]) {
                subLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
        self.currentType = 3;
        if ([self.activityDataArray count] == 0) {
            [self downLoadData];
        }
        [self changeSeleCt:402];
    }else if (scrollView.contentOffset.x >=  screenWidth * 3 && scrollView.contentOffset.x < screenWidth * 4){
        
        self.currentTable = [self.scroller viewWithTag:303];
        UILabel *lable = [self.titleBackView viewWithTag:503];
        lable.textColor = [UIColor blackColor];
        for (UILabel *subLable in self.titleBackView.subviews) {
            if (subLable.tag != 503 && [subLable isKindOfClass:[UILabel class]]) {
                subLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
        self.currentType = 4;
        if ([self.videoDataArray count] == 0) {
            [self downLoadData];
        }
        [self changeSeleCt:403];
    }
    
}


#pragma mark --- title的点击事件

- (void)tapTitle:(UITapGestureRecognizer *)tap{
    
    
    UILabel *label = (UILabel *)[tap view];
    label.textColor = [UIColor blackColor];
    
    for (UIView *subView in self.titleBackView.subviews) {
        if (label.tag != subView.tag && [subView isKindOfClass:[UILabel class]]) {
            
                UILabel *subLB = (UILabel *)subView;
                subLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
    
    
    UIImageView *imagev =  [self.titleBackView viewWithTag:label.tag - 100];
    imagev.image = [UIImage imageNamed:@"line_news"];
    
    for (UIView *subView in self.titleBackView.subviews) {
        if (label.tag - 100 != subView.tag && [subView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *subImage = (UIImageView *)subView;
            subImage.image = [UIImage imageNamed:@"linedot_news"];
        }
    }
    
    
    
    [self.scroller setContentOffset:CGPointMake((label.tag - 500) * screenWidth , 0) animated:YES];
    self.currentTable = [self.scroller viewWithTag:(label.tag - 200)];
    self.currentType = label.tag - 499;
    
    NSArray *array = [NSArray arrayWithObjects:self.matchDataArray, self.ballSkillDataArray, self.activityDataArray, self.videoDataArray, nil];
    if ([array[label.tag - 500] count] == 0) {
        [self downLoadData];
    }
    
}

- (void)changeSeleCt:(NSInteger)tag{
    
    UIImageView *imageV = [self.titleBackView viewWithTag:tag];
    imageV.image = [UIImage imageNamed:@"line_news"];
    
    for (UIView *subView in self.titleBackView.subviews) {
        if (tag != subView.tag && [subView isKindOfClass:[UIImageView class]]) {
            UIImageView *subImage = (UIImageView *)subView;
            subImage.image = [UIImage imageNamed:@"linedot_news"];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGWkNewsViewController *newVC = [[JGWkNewsViewController alloc] init];
    //newVC.detailDic = self.allDataArray[self.currentType - 1][indexPath.row];
    NSDictionary *detailDic = self.allDataArray[self.currentType - 1][indexPath.row];
    if ([detailDic objectForKey:@"id"]) {
        newVC.newsId = [detailDic objectForKey:@"id"];
    }
    
    [self.navigationController pushViewController:newVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    [cell.iconImageV sd_setImageWithURL:[self.allDataArray[self.currentType - 1][indexPath.row] objectForKey:@"picURL"] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    cell.titleNewsLB.text = [self.allDataArray[self.currentType - 1][indexPath.row] objectForKey:@"title"];
    cell.deltailLB.text = [self.allDataArray[self.currentType - 1][indexPath.row] objectForKey:@"summary"];
    
    BOOL isMedia = [[self.allDataArray[self.currentType - 1][indexPath.row] objectForKey:@"mediaTypes"] isEqualToString:@"video"];
    isMedia ? (cell.isVideoImageV.hidden = NO) : (cell.isVideoImageV.hidden = YES);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allDataArray[self.currentType - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 * ProportionAdapter;
}
//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    //    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (NSMutableArray *)matchDataArray{
    if (!_matchDataArray) {
        _matchDataArray = [[NSMutableArray alloc] init];
    }
    return _matchDataArray;
}

- (NSMutableArray *)ballSkillDataArray{
    if (!_ballSkillDataArray) {
        _ballSkillDataArray = [[NSMutableArray alloc] init];
    }
    return _ballSkillDataArray;
}

- (NSMutableArray *)activityDataArray{
    if (!_activityDataArray) {
        _activityDataArray = [[NSMutableArray alloc] init];
    }
    return _activityDataArray;
}

- (NSMutableArray *)videoDataArray{
    if (!_videoDataArray) {
        _videoDataArray = [[NSMutableArray alloc] init];
    }
    return _videoDataArray;
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
