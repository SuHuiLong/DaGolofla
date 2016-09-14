//
//  JGHPoorScoreHoleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPoorScoreHoleView.h"
#import "JGHScoresHoleCell.h"
#import "JGHScoreListModel.h"
#import "JGHScoreAreaCell.h"
#import "JGHTwoScoreAreaCell.h"

#define BGScoreColor @"#B3E4BF"

static NSString *const JGHScoresHoleCellIdentifier = @"JGHScoresHoleCell";
static NSString *const JGHScoreAreaCellIdentifier = @"JGHScoreAreaCell";
static NSString *const JGHTwoScoreAreaCellIdentifier = @"JGHTwoScoreAreaCell";

@interface JGHPoorScoreHoleView ()<UITableViewDelegate, UITableViewDataSource, JGHScoreAreaCellDelegate, JGHScoresHoleCellDelegate, JGHTwoScoreAreaCellDelegate>
{
//    NSArray *_titleArray;
    NSArray *_colorArray;
    NSInteger _areaId;// 0-无区域，1- ； 2-；
    
    UIView *_oneAreaView;
    UIView *_twoAreaView;
    
    NSInteger _imageSelectOne;
    NSInteger _imageSelectTwo;
    
    NSArray *_currentAreaArray;
    NSArray *_areaArray;//区域列表
}

@property (nonatomic, strong)UITableView *scoreTableView;

@end

@implementation JGHPoorScoreHoleView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
//        _titleArray = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18"]];
        _colorArray = @[@"#FFFFFF", @"#EEEEEE", @"#FFFFFF", @"#F9F9F9", @"#FFFFFF", @"#F9F9F9"];
        self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (194 +20 +60)*ProportionAdapter) style:UITableViewStylePlain];
        self.scoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.scoreTableView.scrollEnabled = NO;
        self.scoreTableView.delegate = self;
        self.scoreTableView.dataSource = self;
        UINib *scoresPageCellNib = [UINib nibWithNibName:@"JGHScoresHoleCell" bundle: [NSBundle mainBundle]];
        [self.scoreTableView registerNib:scoresPageCellNib forCellReuseIdentifier:JGHScoresHoleCellIdentifier];
        
        UINib *scoreAreaCellNib = [UINib nibWithNibName:@"JGHScoreAreaCell" bundle: [NSBundle mainBundle]];
        [self.scoreTableView registerNib:scoreAreaCellNib forCellReuseIdentifier:JGHScoreAreaCellIdentifier];
        
        UINib *twoScoreAreaCellNib = [UINib nibWithNibName:@"JGHTwoScoreAreaCell" bundle: [NSBundle mainBundle]];
        [self.scoreTableView registerNib:twoScoreAreaCellNib forCellReuseIdentifier:JGHTwoScoreAreaCellIdentifier];
        
        self.scoreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.scoreTableView];
        
        UIView *whiteHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20 * ProportionAdapter)];
        whiteHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *headLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 16 * ProportionAdapter)];
        headLB.textAlignment = NSTextAlignmentCenter;
        headLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        headLB.text = @"【魔兽世界】CHASSEUR";
        [whiteHeaderView addSubview:headLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(100 * ProportionAdapter, 19 * ProportionAdapter, screenWidth - 200 * ProportionAdapter, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#32B14D"];
        [whiteHeaderView addSubview:lineView];
        self.scoreTableView.tableHeaderView = whiteHeaderView;
    }
    return self;
}

- (void)reloadScoreList:(NSArray *)currentAreaArray andAreaArray:(NSArray *)areaArray{
    _areaArray = areaArray;
    _currentAreaArray = currentAreaArray;
    _imageSelectOne = 0;
    _imageSelectTwo = 0;
    self.scoreTableView.frame = CGRectMake(0, 0, screenWidth, (194 + 20 + self.dataArray.count * 70)*ProportionAdapter);
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count +2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHScoresHoleCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHScoresHoleCellIdentifier];
    scoresPageCell.delegate = self;
    scoresPageCell.tag = indexPath.section*10 + indexPath.row*100;
    scoresPageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"%td", self.tag);
    if (_dataArray.count > 0) {
        NSLog(@"%td", _curPage);
        if (_curPage <= 9) {
            if (indexPath.section == 0) {
                [scoresPageCell configAllViewBgColor:_colorArray[indexPath.row] andCellTag:_curPage];
            }else{
                [scoresPageCell configAllViewBgColor:_colorArray[indexPath.row] andCellTag:10];
            }
        }else{
            if (indexPath.section == 1) {
                [scoresPageCell configAllViewBgColor:_colorArray[indexPath.row] andCellTag:_curPage-9];
            }else{
                [scoresPageCell configAllViewBgColor:_colorArray[indexPath.row] andCellTag:10];
            }
        }
    }
    
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            model = _dataArray[0];
            [scoresPageCell configArray:model.poleNameList];
        }else if (indexPath.row == 1){
            model = _dataArray[0];
            [scoresPageCell configOneToNine:model.standardlever andUserName:@"PAR"];
        }else{
            NSLog(@"indexPath.row -1 == %td", indexPath.row -1);
            NSLog(@"indexPath.section -1 == %td", indexPath.section -1);
            model = _dataArray[indexPath.row -2];
//            [scoresPageCell configOneToNine:model.poleNumber andUserName:model.userName];
            [scoresPageCell configOneToNine:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever];
        }
    }else{
        if (indexPath.row == 0) {
            model = _dataArray[0];
            [scoresPageCell configPoorArray:model.poleNameList];
        }else if (indexPath.row == 1){
            model = _dataArray[0];
            [scoresPageCell configNineToEighteenth:model.standardlever andUserName:@"PAR"];
        }else{
            model = _dataArray[indexPath.row -2];
//            [scoresPageCell configNineToEighteenth:model.poleNumber andUserName:model.userName];
            [scoresPageCell configNineToEighteenth:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever];
        }
    }
    
    return scoresPageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGHScoreAreaCell *scoreAreaCell = [tableView dequeueReusableCellWithIdentifier:JGHScoreAreaCellIdentifier];
        scoreAreaCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        scoreAreaCell.delegate = self;
        [scoreAreaCell configArea:_currentAreaArray[section] andImageDirection:_imageSelectOne];
        return scoreAreaCell;

    }else{
        JGHTwoScoreAreaCell *twoScoreAreaCell = [tableView dequeueReusableCellWithIdentifier:JGHTwoScoreAreaCellIdentifier];
        twoScoreAreaCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        twoScoreAreaCell.delegate = self;
        [twoScoreAreaCell configArea:_currentAreaArray[section] andImageDirection:_imageSelectTwo];
        return twoScoreAreaCell;
    }
}

#pragma mark -- 点击杆数跳转到指定的积分页面
- (void)selectHoleCoresBtnTag:(NSInteger)btnTag andCellTag:(NSInteger)cellTag{
    NSLog(@"%td", btnTag);//2
    NSLog(@"%td", cellTag);//101
    NSLog(@"cell10 = %td", cellTag%100/10);
    NSLog(@"cell100  = %td", cellTag/100);
    
    if (_oneAreaView != nil) {
        [_oneAreaView removeFromSuperview];
        _oneAreaView = nil;
        return;
    }
    
    if (_twoAreaView != nil) {
        [_twoAreaView removeFromSuperview];
        _twoAreaView = nil;
        return;
    }
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    if ((cellTag%100/10) == 0) {
        [userDict setObject:@(btnTag - 1) forKey:@"index"];
    }else{
        [userDict setObject:@(btnTag - 1 + 9) forKey:@"index"];
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"noticePushScores" object:nil userInfo:userDict];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
#pragma mark -- 选择第一区域
- (void)oneAreaNameBtn:(UIButton *)btn{
    NSLog(@"第一个区域");
    NSLog(@"%f", btn.frame.origin.y);
    
    if (_imageSelectOne == 0) {
        _imageSelectOne = 1;
    }else{
        _imageSelectOne = 0;
    }
    
    [self.scoreTableView reloadData];
    
    [_twoAreaView removeFromSuperview];
    _twoAreaView = nil;
    if (_oneAreaView != nil) {
        [_oneAreaView removeFromSuperview];
        _oneAreaView = nil;
        return;
    }
    
    _areaId = 1;
    _oneAreaView = [[UIView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, btn.frame.origin.y + btn.frame.size.height, 84 *ProportionAdapter, _areaArray.count *44 *ProportionAdapter  + 4*ProportionAdapter)];
    [_oneAreaView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"alertViewBG"]]];
    for (int i=0; i < _areaArray.count; i++) {
        NSInteger btnY;
        if (i == 0) {
            btnY = 2 *ProportionAdapter;
        }else{
            btnY = (i * 40 + 2) *ProportionAdapter;
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 *ProportionAdapter, btnY, 80 *ProportionAdapter, 40 *ProportionAdapter)];
        [btn setTitle:[NSString stringWithFormat:@"%@", _areaArray[i]] forState:UIControlStateNormal];
        btn.tag = 300 + i;
        if ([_areaArray[i] isEqualToString:_currentAreaArray[0]]) {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [btn addTarget:self action:@selector(oneAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        btn.tag = 200 + i;
        [_oneAreaView addSubview:btn];
    }
    [self addSubview:_oneAreaView];
}
- (void)oneAreaBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate oneAreaPoorBtnDelegate:btn];
    }
}
- (void)removePoorOneAreaView{
    [_oneAreaView removeFromSuperview];
    _oneAreaView = nil;
}
#pragma mark -- 第二个区域
- (void)twoAreaNameBtn:(UIButton *)btn{
    NSLog(@"第二个区域");
    if (_imageSelectTwo == 0) {
        _imageSelectTwo = 1;
    }else{
        _imageSelectTwo = 0;
    }
    
    [self.scoreTableView reloadData];
    
    [_oneAreaView removeFromSuperview];
    _oneAreaView = nil;
    if (_twoAreaView != nil) {
        [_twoAreaView removeFromSuperview];
        _twoAreaView = nil;
        return;
    }
    
    _areaId = 2;
    
    NSLog(@"%f", btn.frame.origin.y);
    
    _twoAreaView = [[UIView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, btn.frame.origin.y + btn.frame.size.height + (_dataArray.count +2) *35 *ProportionAdapter + 37 *ProportionAdapter, 84 *ProportionAdapter,_areaArray.count *44 *ProportionAdapter  + 4*ProportionAdapter)];
    [_twoAreaView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"alertViewBG"]]];
    for (int i=0; i < _areaArray.count; i++) {
        NSInteger btnY;
        if (i == 0) {
            btnY = 2 *ProportionAdapter;
        }else{
            btnY = (i * 40 + 2) *ProportionAdapter;
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 *ProportionAdapter, btnY, 80 *ProportionAdapter, 40 *ProportionAdapter)];
        [btn setTitle:[NSString stringWithFormat:@"%@", _areaArray[i]] forState:UIControlStateNormal];
        btn.tag = 400 + i;
        if ([_areaArray[i] isEqualToString:_currentAreaArray[1]]) {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [btn addTarget:self action:@selector(twoAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
                
        [_twoAreaView addSubview:btn];
    }
    [self addSubview:_twoAreaView];
}
#pragma mark -- 第二区域点击事件
- (void)twoAreaBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate twoAreaPoorBtnDelegate:btn];
    }
}
-(void)removePoorTwoAreaView{
    [_twoAreaView removeFromSuperview];
    _twoAreaView = nil;
}

#pragma mark -- 刷新数据
- (void)reloadPoorViewData:(NSMutableArray *)dataArray andCurrentAreaArrat:(NSArray *)currentAreaArray{
    self.dataArray = dataArray;
    _currentAreaArray = currentAreaArray;
    
    [self.scoreTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
