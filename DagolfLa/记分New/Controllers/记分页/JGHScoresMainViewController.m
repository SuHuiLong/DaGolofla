//
//  JGHScoresMainViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresMainViewController.h"
#import "JGHScoresPageCell.h"
#import "JGHScoreListModel.h"
#import "JGHNewScoresPageCell.h"

static NSString *const JGHScoresPageCellIdentifier = @"JGHScoresPageCell";
static NSString *const JGHNewScoresPageCellIdentifier = @"JGHNewScoresPageCell";

@interface JGHScoresMainViewController ()<UITableViewDelegate, UITableViewDataSource, JGHScoresPageCellDelegate, JGHNewScoresPageCellDelegate>
{

    UIButton *_totalPoleBtn;
    
    UILabel *_areaLable;
}

@property (nonatomic, strong)UITableView *scoresTableView;

@end

@implementation JGHScoresMainViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    _switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
    
    if (_switchMode == 0) {
        [_totalPoleBtn setTitle:@"总杆模式" forState:UIControlStateNormal];
    }else{
        [_totalPoleBtn setTitle:@"差杆模式" forState:UIControlStateNormal];
    }
    
    [self.scoresTableView reloadData];
}

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (_index > 0) {
        [userdef setObject:@(_index-1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@(_index) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticePushScoresCtrl:) name:@"noticePushScores" object:nil];
    
    self.scoresTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    self.scoresTableView.delegate = self;
    self.scoresTableView.dataSource = self;
    self.scoresTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoresTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.scoresTableView.scrollEnabled = NO;
    
    UINib *scoresPageCellNib = [UINib nibWithNibName:@"JGHScoresPageCell" bundle: [NSBundle mainBundle]];
    [self.scoresTableView registerNib:scoresPageCellNib forCellReuseIdentifier:JGHScoresPageCellIdentifier];
    
    UINib *newScoresPageCellNib = [UINib nibWithNibName:@"JGHNewScoresPageCell" bundle: [NSBundle mainBundle]];
    [self.scoresTableView registerNib:newScoresPageCellNib forCellReuseIdentifier:JGHNewScoresPageCellIdentifier];
    
    [self.view addSubview:self.scoresTableView];
    
    [self creteSlidingView];//总杆／差杆
    
    [self createHeaderBallAreaView];
}
#pragma mark -- 球场区域
- (void)createHeaderBallAreaView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20*ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _areaLable = [[UILabel alloc]initWithFrame:CGRectMake(100*ProportionAdapter, 0, screenWidth -200 *ProportionAdapter, 18 *ProportionAdapter)];
    _areaLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    _areaLable.textColor = [UIColor blackColor];
    _areaLable.textAlignment = NSTextAlignmentCenter;
    if (_index < 9) {
        _areaLable.text = _currentAreaArray[0];
    }else{
        _areaLable.text = _currentAreaArray[1];
    }
    
    [headerView addSubview:_areaLable];
    
    UILabel *lineLbale = [[UILabel alloc]initWithFrame:CGRectMake(100*ProportionAdapter, 20 *ProportionAdapter -1, screenWidth -200 *ProportionAdapter, 1)];
    lineLbale.backgroundColor = [UIColor colorWithHexString:@"#32B14D"];
    [headerView addSubview:lineLbale];
    
    self.scoresTableView.tableHeaderView =headerView;
}
#pragma mark -- 总杆／差杆
- (void)creteSlidingView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 64 - 30*ProportionAdapter, screenWidth, 30*ProportionAdapter)];
    UIImageView *imageLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 8*ProportionAdapter, 14*ProportionAdapter, 14*ProportionAdapter)];
    imageLeftView.image = [UIImage imageNamed:@"sildLeft"];
    [view addSubview:imageLeftView];
    
    UIImageView *imageRightView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -20*ProportionAdapter -14 *ProportionAdapter, 8*ProportionAdapter, 14*ProportionAdapter, 14*ProportionAdapter)];
    imageRightView.image = [UIImage imageNamed:@"sildRight"];
    [view addSubview:imageRightView];

    _totalPoleBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-140*ProportionAdapter)/2, 0, 140*ProportionAdapter, 30*ProportionAdapter)];
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    
    if ([[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue] == 0) {
        [_totalPoleBtn setTitle:@"总杆模式" forState:UIControlStateNormal];
    }else{
        [_totalPoleBtn setTitle:@"差杆模式" forState:UIControlStateNormal];
    }
    
    NSLog(@"%td", [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue]);
    [_totalPoleBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    _totalPoleBtn.titleLabel.font = [UIFont systemFontOfSize:17.0*ProportionAdapter];
    [_totalPoleBtn addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_totalPoleBtn];
    
    [self.scoresTableView addSubview:view];
}
#pragma mark -- 记分模式切换
- (void)switchMode:(UIButton *)btn{
    NSLog(@"记分模式");
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    if ([[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue] == 0) {
        _switchMode = 1;
        [_totalPoleBtn setTitle:@"差杆模式" forState:UIControlStateNormal];
    }else{
        _switchMode = 0;
        [_totalPoleBtn setTitle:@"总杆模式" forState:UIControlStateNormal];
        
    }
    
    [self.scoresTableView reloadData];
    
    [userdf setObject:@(_switchMode) forKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]];
    [userdf synchronize];
}
#pragma mark -- 跳转指定记分几页通知
- (void)noticePushScoresCtrl:(NSNotification *)not{
    //weChatNotice
    NSLog(@"%@", not.userInfo);
    _index = [[not.userInfo objectForKey:@"index"] integerValue];
    if (_index < 9) {
        _areaLable.text = _currentAreaArray[0];
    }else{
        _areaLable.text = _currentAreaArray[1];
    }
    
    [self.scoresTableView reloadData];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count < 3) {
        return 260 *ProportionAdapter;
    }else{
        return (screenHeight-64-50*ProportionAdapter)/4 -5*ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    if (_dataArray.count < 3) {
        JGHNewScoresPageCell *newScoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewScoresPageCellIdentifier];
        newScoresPageCell.delegate = self;
        newScoresPageCell.tag = indexPath.section + 100;
        newScoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSLog(@"ussssss === %@", [userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]]);
        if ([[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue] == 0) {
            [newScoresPageCell configTotalPoleViewTitle];
            [newScoresPageCell configJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
        }else{
            [newScoresPageCell configPoleViewTitle];
            [newScoresPageCell configPoorJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
        }
        
        return newScoresPageCell;
    }else{
        JGHScoresPageCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHScoresPageCellIdentifier];
        scoresPageCell.delegate = self;
        scoresPageCell.tag = indexPath.section + 100;
        scoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"useeeees === %@", [userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]]);
        if ([[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue] == 0) {
            [scoresPageCell configTotalPoleViewTitle];
            [scoresPageCell configJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
        }else{
            [scoresPageCell configPoorJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
            [scoresPageCell configPoleViewTitle];
        }
        
        return scoresPageCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 0;
    }
    return 5*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}

#pragma mark -- 上球道
- (void)selectUpperTrackBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    btn.enabled = NO;
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = self.dataArray[cellTag-100];
    NSMutableArray *onthefairwayArray = [NSMutableArray array];
    for (int i=0; i<model.onthefairway.count; i++) {
        if (i == _index) {
            [onthefairwayArray addObject:@1];
        }else{
            [onthefairwayArray addObject:model.onthefairway[i]];
        }
    }
    
    model.onthefairway = onthefairwayArray;
    [self.dataArray replaceObjectAtIndex:cellTag-100 withObject:model];
    if (self.dataArray.count > 0) {
        self.returnScoresDataArray(_dataArray);
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:cellTag-100];
    [self.scoresTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    btn.enabled = YES;
    
    [self isAllScoresArray:_dataArray];
}
#pragma mark -- 未上球道
- (void)selectUpperTrackNoBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    btn.enabled = NO;
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = self.dataArray[cellTag-100];
    NSMutableArray *onthefairwayArray = [NSMutableArray array];
    for (int i=0; i<model.onthefairway.count; i++) {
        if (i == _index) {
            [onthefairwayArray addObject:@0];
        }else{
            [onthefairwayArray addObject:model.onthefairway[i]];
        }
    }
    
    model.onthefairway = onthefairwayArray;
    [self.dataArray replaceObjectAtIndex:cellTag -100 withObject:model];
    btn.enabled = YES;
    if (self.dataArray.count > 0) {
        self.returnScoresDataArray(_dataArray);
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:cellTag-100];
    [self.scoresTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self isAllScoresArray:_dataArray];
}

#pragma mark -- 减
- (void)selectReduntionScoresBtnClicK:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    btn.enabled = NO;
    if (btn.tag == 50) {
        NSLog(@"- 杆数");
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = self.dataArray[cellTag-100];
        NSMutableArray *poleNumberArray = [NSMutableArray array];
        for (int i=0; i<model.poleNumber.count; i++) {
            if (_switchMode == 0) {
                if (i == _index) {
                    if ([model.poleNumber[i] integerValue] == -1) {
                        [poleNumberArray addObject:@([model.standardlever[i] integerValue])];
                    }else{
                        if ([model.poleNumber[i] integerValue]-1 > 0) {
                            [poleNumberArray addObject:@([model.poleNumber[i] integerValue]-1)];
                        }else{
                            [poleNumberArray addObject:@1];
                        }
                    }
                }else{
                    [poleNumberArray addObject:model.poleNumber[i]];
                }
            }else{
                //差杆模式
                if (i == _index) {
                    if ([model.poleNumber[i] integerValue] == -1) {
                        [poleNumberArray addObject:model.standardlever[i]];
                    }else{
                        if ([model.poleNumber[i] integerValue]-1 > 0) {
                            [poleNumberArray addObject:@([model.poleNumber[i] integerValue]-1)];
                        }else{
                            [poleNumberArray addObject:@1];
                        }
                    }
                }else{
                    [poleNumberArray addObject:model.poleNumber[i]];
                }
            }
        }
        
        model.poleNumber = poleNumberArray;
        [self.dataArray replaceObjectAtIndex:cellTag-100 withObject:model];
    }else{
        NSLog(@"- 推杆");
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = self.dataArray[cellTag-100];
        NSMutableArray *pushrodArray = [NSMutableArray array];
        for (int i=0; i<model.pushrod.count; i++) {
            if (i == _index) {
                if ([model.pushrod[i] integerValue] == -1) {
                    [pushrodArray addObject:@2];
                }else{
                    if ([model.pushrod[i] integerValue]-1 > 0) {
                        [pushrodArray addObject:@([model.pushrod[i] integerValue]-1)];
                    }else{
                        [pushrodArray addObject:@0];
                    }
                }
            }else{
                [pushrodArray addObject:model.pushrod[i]];
            }
        }
        
        model.pushrod = pushrodArray;
        [self.dataArray replaceObjectAtIndex:cellTag-100 withObject:model];
    }
    
    if (self.dataArray.count > 0) {
        self.returnScoresDataArray(_dataArray);
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:cellTag-100];
    [self.scoresTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    btn.enabled = YES;
    [self isAllScoresArray:_dataArray];
}
#pragma mark -- 加
- (void)selectAddScoresBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    btn.enabled = NO;
    if (btn.tag == 60) {
        NSLog(@"+ 杆数");
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = self.dataArray[cellTag-100];
        NSMutableArray *poleNumberArray = [NSMutableArray array];
        for (int i=0; i<model.poleNumber.count; i++) {
            if (i == _index) {
                if ([model.poleNumber[i] integerValue] == -1) {
                    [poleNumberArray addObject:@([model.standardlever[i] integerValue])];
                }else{
                    if ([model.poleNumber[i] integerValue]-1 >= 0) {
                        [poleNumberArray addObject:@([model.poleNumber[i] integerValue]+1)];
                    }else{
                        [poleNumberArray addObject:@1];
                    }
                }
            }else{
                [poleNumberArray addObject:model.poleNumber[i]];
            }
        }
        
        model.poleNumber = poleNumberArray;
        [self.dataArray replaceObjectAtIndex:cellTag-100 withObject:model];
        
    }else{
        NSLog(@"+ 推杆");//pushrod
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = self.dataArray[cellTag-100];
        NSMutableArray *pushrodArray = [NSMutableArray array];
        for (int i=0; i<model.pushrod.count; i++) {
            if (i == _index) {
                if ([model.pushrod[i] integerValue] == -1) {
                    [pushrodArray addObject:@2];
                }else{
                    [pushrodArray addObject:@([model.pushrod[i] integerValue]+1)];
                }
            }else{
                [pushrodArray addObject:model.pushrod[i]];
            }
        }
        
        model.pushrod = pushrodArray;
        [self.dataArray replaceObjectAtIndex:cellTag-100 withObject:model];
    }
    
    if (self.dataArray.count > 0) {
        self.returnScoresDataArray(_dataArray);
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:cellTag-100];
    [self.scoresTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    btn.enabled = YES;
    
    [self isAllScoresArray:_dataArray];
}
#pragma mark -- 判断是否完成所有的记分
- (void)isAllScoresArray:(NSMutableArray *)dataArray{
    for (int x=0; x<dataArray.count; x++) {
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = dataArray[x];
        for (int i=0; i<18; i++) {
            if ([[model.poleNumber objectAtIndex:i] integerValue] == -1) {
                break;
            }
            
            if (x == dataArray.count -1 && i == 17) {
                NSLog(@"model.poleNumber == %@", model.poleNumber);
                NSLog(@"model.pushrod == %@", model.pushrod);
                NSLog(@"model.onthefairway == %@", model.onthefairway);
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"noticeAllScores" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }
    }
}
// --------   2人以下记分   ----------
#pragma mark -- 上球道
- (void)didTotalFairway:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectUpperTrackBtnClick:btn andCellTage:cellTag];
}
#pragma mark --未上球道
- (void)didTotalNOFairway:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectUpperTrackNoBtnClick:btn andCellTage:cellTag];
}
#pragma mark -- + 杆数 -- + 差杆
- (void)didTotalAddPoleNumber:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectAddScoresBtnClick:btn andCellTage:cellTag];
}
#pragma mark -- - 杆数 -- - 差杆
- (void)didTotalRedPoleNumber:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectReduntionScoresBtnClicK:btn andCellTage:cellTag];
}
#pragma mark -- + 推杆
- (void)didTotalAddPushRod:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectAddScoresBtnClick:btn andCellTage:cellTag];
}
#pragma mark -- - 推杆
- (void)didTotalRedPushRod:(UIButton *)btn andCellTage:(NSInteger)cellTag{
    [self selectReduntionScoresBtnClicK:btn andCellTage:cellTag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
