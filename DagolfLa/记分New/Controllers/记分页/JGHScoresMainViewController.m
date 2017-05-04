//
//  JGHScoresMainViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresMainViewController.h"
#import "JGHScoreListModel.h"
#import "JGHNewScoresPageCell.h"
#import "JGHNewFourScoresPageCell.h"
#import "JGHScoreDatabase.h"

static NSString *const JGHNewFourScoresPageCellIdentifier = @"JGHNewFourScoresPageCell";
static NSString *const JGHScoresPageCellIdentifier = @"JGHScoresPageCell";
static NSString *const JGHNewScoresPageCellIdentifier = @"JGHNewScoresPageCell";

@interface JGHScoresMainViewController ()<UITableViewDelegate, UITableViewDataSource, JGHNewScoresPageCellDelegate,JGHNewFourScoresPageCellDelegate>{
    UILabel *_holeLable;
    UILabel *_areaLable;
}

@property (nonatomic, strong)UITableView *scoresTableView;

//箭头图标
@property (nonatomic, strong)UIButton *holeDirebtn;

@end

@implementation JGHScoresMainViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    //箭头变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoresArrowChange:) name:@"scoresArrowChange" object:nil];
     
    [self createView];
}


#pragma mark - CreateView
-(void)createView{
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
    
}
// 总杆／差杆
- (UIView *)creteHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(61))];
    view.backgroundColor = [UIColor whiteColor];
    
    //球场分区名
    _areaLable = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    if (_index < 9) {
        _areaLable.text = _currentAreaArray[0];
    }else{
        _areaLable.text = _currentAreaArray[1];
    }
    [_areaLable sizeToFitSelf];
    [view addSubview:_areaLable];
    
    //洞号
    _holeLable = [Factory createLabelWithFrame:_areaLable.frame textColor:RGB(49,49,49) fontSize:0 Title:nil];
    _holeLable.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = _dataArray[0];
    if ([model.standardlever objectAtIndex:_index]) {
        _holeLable.text = [NSString stringWithFormat:@"%tdHole  Par%@", _index +1, [model.standardlever objectAtIndex:_index]];
    }else{
        _holeLable.text = [NSString stringWithFormat:@"%tdHole  Par", _index +1];
    }
    [_holeLable sizeToFitSelf];
    [view addSubview:_holeLable];
    
    //向下&&向上箭头
    _holeDirebtn = [Factory createButtonWithFrame:CGRectMake(0, kHvertical(20), kWvertical(18), kHvertical(10)) NormalImage:@"zk" SelectedImage:@"zk1" target:self selector:nil];
    _holeDirebtn.selected = false;
    [view addSubview:_holeDirebtn];
    //设置坐标
    _areaLable.x = (screenWidth - _areaLable.width - _holeLable.width - _holeDirebtn.width - kWvertical(20))/2;
    _holeLable.x =  _areaLable.x_width + kWvertical(10);
    _holeDirebtn.x = _holeLable.x_width + kWvertical(10);
    
    //线
    UIView *line = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:Bar_Color] frame:CGRectMake(_areaLable.x-kWvertical(10), kHvertical(49), _holeDirebtn.x_width + kWvertical(20) - _areaLable.x, 1)];
    //可点击按钮
    UIButton *holeBtn = [Factory createButtonWithFrame:CGRectMake(line.x,0,line.width,kHvertical(50)) target:self selector:@selector(holeBtnClick:) Title:nil];
    [view addSubview:holeBtn];
    [view addSubview:line];
    
    //grayClocorView
    UIView *grayClocorView = [[UIView alloc]initWithFrame:CGRectMake(0, kHvertical(50), screenWidth, kHvertical(10))];
    grayClocorView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [view addSubview:grayClocorView];
    
    return view;
}
#pragma mark -- Action
//阅历成绩
- (void)holeBtnClick:(UIButton *)btn{
    _holeDirebtn.selected = false;
    _selectHoleBtnClick();
}
//记分模式切换
- (void)switchScoreModeNote{
    NSLog(@"记分模式");
    [self.scoresTableView reloadData];
}
#pragma mark -- notification
//跳转指定记分几页通知
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

/**
 处理箭头方向
 
 @param notic 返回参数 0：默认 1：选中
 */
-(void)scoresArrowChange:(NSNotification *)notic{
    
    if ([notic.object isEqual:@"1"]) {
        self.holeDirebtn.selected = false;
    }else{
        self.holeDirebtn.selected = true;
    }
    
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
        return (screenHeight-64-kHvertical(71))/2;
    }else{
        return (screenHeight-64-kHvertical(91))/4;
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
    if (section == 0) {
        return kHvertical(61);
    }
    return kHvertical(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self creteHeaderView];
    }
    //grayClocorView
    UIView *grayClocorView = [[UIView alloc]initWithFrame:CGRectMake(0, kHvertical(50), screenWidth, kHvertical(10))];
    grayClocorView.backgroundColor = ClearColor;
    
    return grayClocorView;
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
    
    [[JGHScoreDatabase shareScoreDatabase]updateOnthefairway:model andScoreKey:_scorekey];
    
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
    
    [[JGHScoreDatabase shareScoreDatabase]updateOnthefairway:model andScoreKey:_scorekey];
    
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
        
        [[JGHScoreDatabase shareScoreDatabase]updatePoleNumber:model andScoreKey:_scorekey];
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
        
        [[JGHScoreDatabase shareScoreDatabase]updatePushrod:model andScoreKey:_scorekey];
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
        
        [[JGHScoreDatabase shareScoreDatabase]updatePoleNumber:model andScoreKey:_scorekey];
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
        
        [[JGHScoreDatabase shareScoreDatabase]updatePushrod:model andScoreKey:_scorekey];
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
