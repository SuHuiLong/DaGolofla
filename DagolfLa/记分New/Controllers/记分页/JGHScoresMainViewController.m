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
#import "JGHNewFourScoresPageCell.h"

static NSString *const JGHNewFourScoresPageCellIdentifier = @"JGHNewFourScoresPageCell";
static NSString *const JGHScoresPageCellIdentifier = @"JGHScoresPageCell";
static NSString *const JGHNewScoresPageCellIdentifier = @"JGHNewScoresPageCell";

@interface JGHScoresMainViewController ()<UITableViewDelegate, UITableViewDataSource, JGHScoresPageCellDelegate, JGHNewScoresPageCellDelegate,JGHNewFourScoresPageCellDelegate>
{

    UILabel *_holeLable;
    
    UILabel *_areaLable;
    
    UIButton *_holeDirebtn;
}

@property (nonatomic, strong)UITableView *scoresTableView;

@end

@implementation JGHScoresMainViewController

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
    
    [self.scoresTableView registerClass:[JGHNewFourScoresPageCell class] forCellReuseIdentifier:JGHNewFourScoresPageCellIdentifier];
    
    [self.view addSubview:self.scoresTableView];
    
    [self creteSlidingView];//总杆／差杆
    
}
#pragma mark -- 总杆／差杆
- (void)creteSlidingView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 64 - 52*ProportionAdapter, screenWidth, 52*ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(10 *ProportionAdapter, 5*ProportionAdapter, 60 *ProportionAdapter, 42*ProportionAdapter);
    [leftBtn setTitle:@"上一洞" forState:UIControlStateNormal];
    [leftBtn setTintColor:[UIColor colorWithHexString:Bar_Color]];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    leftBtn.tag = 20;
    [leftBtn addTarget:self action:@selector(leftScoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(screenWidth -70*ProportionAdapter, 5*ProportionAdapter, 60 *ProportionAdapter, 42*ProportionAdapter);
    [rightBtn setTintColor:[UIColor colorWithHexString:Bar_Color]];
    [rightBtn setTitle:@"下一洞" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    rightBtn.tag = 21;
    [rightBtn addTarget:self action:@selector(leftScoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    _areaLable = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth-140*ProportionAdapter)/2, 26*ProportionAdapter, 140*ProportionAdapter, 20*ProportionAdapter)];
    _areaLable.textAlignment = NSTextAlignmentCenter;
    
    if (_index < 9) {
        _areaLable.text = _currentAreaArray[0];
    }else{
        _areaLable.text = _currentAreaArray[1];
    }
    
    _areaLable.textColor = [UIColor colorWithHexString:B31_Color];
    _areaLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];

    [view addSubview:_areaLable];
    
    //洞号
    _holeLable = [[UILabel alloc]initWithFrame:CGRectMake(110*ProportionAdapter, 6*ProportionAdapter, 120*ProportionAdapter, 20*ProportionAdapter)];
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = _dataArray[0];
    if ([model.standardlever objectAtIndex:_index]) {
        _holeLable.text = [NSString stringWithFormat:@"%td Hole PAR %@", _index +1, [model.standardlever objectAtIndex:_index]];
    }else{
        _holeLable.text = [NSString stringWithFormat:@"%td Hole PAR ", _index +1];
    }
    
    _holeLable.textAlignment = NSTextAlignmentCenter;
    _holeLable.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    _holeLable.textColor = [UIColor colorWithHexString:Bar_Color];
    [view addSubview:_holeLable];
    
    _holeDirebtn = [[UIButton alloc]initWithFrame:CGRectMake(_holeLable.frame.origin.x +_holeLable.frame.size.width, _holeLable.frame.origin.y, 20 *ProportionAdapter, 20*ProportionAdapter)];
    [_holeDirebtn setImage:[UIImage imageNamed:@"zk"] forState:UIControlStateNormal];
    _holeDirebtn.tag = 15000;
    [view addSubview:_holeDirebtn];
    
    UIButton *holeBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth-140*ProportionAdapter)/2, 6*ProportionAdapter, 140*ProportionAdapter, 40*ProportionAdapter)];
    [holeBtn addTarget:self action:@selector(holeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:holeBtn];
    
    //线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:Bar_Color];
    [view addSubview:line];
    
    [self.scoresTableView addSubview:view];
    
}
#pragma mark -- 阅历成绩
- (void)holeBtnClick:(UIButton *)btn{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.2f];
}
- (void)btnClickedOperations{
    _selectHoleBtnClick();
}
#pragma mark -- LeftBtn 左切换 右切换
- (void)leftScoreBtn:(UIButton *)btn{
    NSLog(@"切换");
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];

    NSInteger indx = 0;
    if (btn.tag == 20) {
        //左
        if (_index -1 < 0) {
            indx = 17;
        }else{
            indx = _index -1;
        }
    }else{
        //右
        if (_index +1 > 17) {
            indx = 0;
        }else{
            indx = _index +1;
        }
    }
    
    [userDict setObject:@(indx) forKey:@"index"];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"noticePushScores" object:nil userInfo:userDict];
    
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

#pragma mark -- 记分模式切换
- (void)switchScoreModeNote{
    NSLog(@"记分模式");
    [self.scoresTableView reloadData];
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
        return (screenHeight-64-82*ProportionAdapter)/2;
    }else{
        return (screenHeight-64-102*ProportionAdapter)/4;
        //return 125*ProportionAdapter;
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
        JGHNewFourScoresPageCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewFourScoresPageCellIdentifier];
        
        scoresPageCell.delegate = self;
        scoresPageCell.tag = indexPath.section + 100;
        scoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"useeeees === %@", [userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]]);
        if ([[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue] == 0) {
            [scoresPageCell configJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
        }else{
            [scoresPageCell configPoorJGHScoreListModel:_dataArray[indexPath.section] andIndex:_index];
        }
        
        return scoresPageCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 0;
    }
    return 10*ProportionAdapter;
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
