//
//  JGHScoresHoleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresHoleView.h"
#import "JGHScoresHoleCell.h"
#import "JGHScoreListModel.h"
#import "JGHScoreAreaCell.h"
#import "JGHTwoScoreAreaCell.h"

#define BGScoreColor @"#B3E4BF"

static NSString *const JGHScoresHoleCellIdentifier = @"JGHScoresHoleCell";
static NSString *const JGHScoreAreaCellIdentifier = @"JGHScoreAreaCell";
static NSString *const JGHTwoScoreAreaCellIdentifier = @"JGHTwoScoreAreaCell";

@interface JGHScoresHoleView ()<UITableViewDelegate, UITableViewDataSource, JGHScoresHoleCellDelegate, JGHTwoScoreAreaCellDelegate, JGHScoreAreaCellDelegate>
{
    NSArray *_titleArray;
    NSArray *_colorArray;
    NSInteger _areaId;// 0-无区域，1- ； 2-；
    
    UIView *_oneAreaView;
    UIView *_twoAreaView;
}

@property (nonatomic, strong)UITableView *scoreTableView;

@end

@implementation JGHScoresHoleView


- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        _titleArray = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18"]];
        _colorArray = @[@"#FFFFFF", @"#EEEEEE", @"#FFFFFF", @"#F9F9F9", @"#FFFFFF", @"#F9F9F9"];
        self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (194+60)*ProportionAdapter) style:UITableViewStylePlain];
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
    }
    return self;
}

- (void)reloadScoreList{
    self.scoreTableView.frame = CGRectMake(0, 0, screenWidth, (194 + self.dataArray.count * 60)*ProportionAdapter);
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count +2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30*ProportionAdapter;
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
            [scoresPageCell configArray:_titleArray[indexPath.row ]];
        }else if (indexPath.row == 1){
            model = _dataArray[0];
            [scoresPageCell configOneToNine:model.standardlever andUserName:@"PAR"];
        }else{
            NSLog(@"indexPath.row -1 == %td", indexPath.row -1);
            NSLog(@"indexPath.section -1 == %td", indexPath.section -1);
            model = _dataArray[indexPath.row -2];
            [scoresPageCell configOneToNine:model.poleNumber andUserName:model.userName];
        }
    }else{
        if (indexPath.row == 0) {
            [scoresPageCell configArray:_titleArray[indexPath.section]];
        }else if (indexPath.row == 1){
            model = _dataArray[0];
            [scoresPageCell configNineToEighteenth:model.standardlever andUserName:@"PAR"];
        }else{
            model = _dataArray[indexPath.row -2];
            [scoresPageCell configNineToEighteenth:model.poleNumber andUserName:model.userName];
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
        scoreAreaCell.delegate = self;
        return scoreAreaCell;
    }else{
        JGHTwoScoreAreaCell *twoScoreAreaCell = [tableView dequeueReusableCellWithIdentifier:JGHTwoScoreAreaCellIdentifier];
        twoScoreAreaCell.delegate = self;
        return twoScoreAreaCell;
    }
}

#pragma mark -- 点击杆数跳转到指定的积分页面
- (void)selectHoleCoresBtnTag:(NSInteger)btnTag andCellTag:(NSInteger)cellTag{
    NSLog(@"%td", btnTag);//2
    NSLog(@"%td", cellTag);//101
    NSLog(@"cell10 = %td", cellTag%100/10);
    NSLog(@"cell100  = %td", cellTag/100);
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
#pragma mark -- 第一个区域
- (void)oneAreaNameBtn:(UIButton *)btn{
    NSLog(@"第一个区域");
    _areaId = 1;
    _oneAreaView = [[UIView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, btn.frame.origin.y + btn.frame.size.height, 84 *ProportionAdapter,_oneAreaArray.count *44 *ProportionAdapter)];
    for (int i=0; i < _oneAreaArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 *ProportionAdapter, 2 *ProportionAdapter, 80 *ProportionAdapter, 40 *ProportionAdapter)];
        [btn setTitle:[NSString stringWithFormat:@"%@", _oneAreaArray[i]] forState:UIControlStateNormal];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(oneAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_oneAreaView addSubview:btn];
    }
    [self addSubview:_oneAreaView];
}
#pragma mark -- 第一区域点击事件
- (void)oneAreaBtnClick:(UIButton *)btn{
    [_oneAreaView removeFromSuperview];
}
#pragma mark -- 第二个区域
- (void)twoAreaNameBtn:(UIButton *)btn{
    NSLog(@"第二个区域");
    _areaId = 2;
    
    _twoAreaView = [[UIView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, btn.frame.origin.y + btn.frame.size.height, 84 *ProportionAdapter,_twoAreaArray.count *44 *ProportionAdapter)];
    for (int i=0; i < _twoAreaArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 *ProportionAdapter, 2 *ProportionAdapter, 80 *ProportionAdapter, 40 *ProportionAdapter)];
        [btn setTitle:[NSString stringWithFormat:@"%@", _twoAreaArray[i]] forState:UIControlStateNormal];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(oneAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_twoAreaView addSubview:btn];
    }
    [self addSubview:_twoAreaView];
}
#pragma mark -- 第二区域点击事件
- (void)twoAreaBtnClick:(UIButton *)btn{
    [_twoAreaView removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
