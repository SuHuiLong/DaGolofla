//
//  JGHPoorScoreHoleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPoorScoreHoleView.h"
#import "JGHScoreListModel.h"
#import "JGHAreaListView.h"
#import "JGHNewPoorBarHoleCell.h"
#import "JGHNewScoresHoleCell.h"

#define BGScoreColor @"#B3E4BF"

static NSString *const JGHNewScoresHoleCellIdentifier = @"JGHNewScoresHoleCell";
static NSString *const JGHNewPoorBarHoleCellIdentifier = @"JGHNewPoorBarHoleCell";

@interface JGHPoorScoreHoleView ()<UITableViewDelegate, UITableViewDataSource, JGHAreaListViewDelegate, JGHNewPoorBarHoleCellDelegate, JGHNewScoresHoleCellDelegate>
{
    NSArray *_colorArray;
    NSInteger _areaId;// 0-无区域，1- ； 2-；
    
    NSArray *_currentAreaArray;
    NSArray *_areaArray;//区域列表
    
    
    JGHAreaListView *_areaListView;
    
    NSInteger _areaSourceID;
}

@property (nonatomic, strong)UITableView *scoreTableView;

@property (nonatomic, retain)JGHAreaListView *areaListView;//区域列表

@property (nonatomic, retain)UIView *tranView;

@end

@implementation JGHPoorScoreHoleView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        _colorArray = @[@"#FFFFFF", @"#EEEEEE", @"#FFFFFF", @"#F9F9F9", @"#FFFFFF", @"#F9F9F9"];
        self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (200 +20 +20 +60)*ProportionAdapter) style:UITableViewStylePlain];
        self.scoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.scoreTableView.scrollEnabled = NO;
        self.scoreTableView.delegate = self;
        self.scoreTableView.dataSource = self;
        
        [self.scoreTableView registerClass:[JGHNewPoorBarHoleCell class] forCellReuseIdentifier:JGHNewPoorBarHoleCellIdentifier];
        
        [self.scoreTableView registerClass:[JGHNewScoresHoleCell class] forCellReuseIdentifier:JGHNewScoresHoleCellIdentifier];
        
        self.scoreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.scoreTableView];
        
        UIView *whiteHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * ProportionAdapter)];
        whiteHeaderView.backgroundColor = [UIColor whiteColor];
        
        //关闭按钮
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -34*ProportionAdapter, 10*ProportionAdapter, 22*ProportionAdapter, 22*ProportionAdapter)];
        [closeBtn setImage:[UIImage imageNamed:@"date_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteHeaderView addSubview:closeBtn];
        //Par -
        UILabel *eagleColor = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        eagleColor.backgroundColor = [UIColor colorWithHexString:@"#54A5FC"];
        eagleColor.layer.masksToBounds = YES;
        eagleColor.layer.cornerRadius = eagleColor.bounds.size.width/2;
        [whiteHeaderView addSubview:eagleColor];
        
        UILabel *eagleValue = [[UILabel alloc]initWithFrame:CGRectMake(25 *ProportionAdapter, 38*ProportionAdapter, 25*ProportionAdapter, 14*ProportionAdapter)];
        eagleValue.text = @"Par";
        eagleValue.textColor = [UIColor colorWithHexString:B31_Color];
        eagleValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:eagleValue];
        
        UILabel *oneline = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 38 *ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        oneline.text = @"-";
        oneline.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        oneline.textColor = [UIColor colorWithHexString:B31_Color];
        [whiteHeaderView addSubview:oneline];
        
        //Par
        UILabel *parColor = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        parColor.backgroundColor = [UIColor colorWithHexString:@"#5A5856"];
        parColor.layer.masksToBounds = YES;
        parColor.layer.cornerRadius = parColor.bounds.size.width/2;
        [whiteHeaderView addSubview:parColor];
        
        UILabel *parValue = [[UILabel alloc]initWithFrame:CGRectMake(85 *ProportionAdapter, 38*ProportionAdapter, 25*ProportionAdapter, 14*ProportionAdapter)];
        parValue.text = @"Par";
        parValue.textColor = [UIColor colorWithHexString:B31_Color];
        parValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:parValue];
        
        //Par +
        UILabel *birdieColor = [[UILabel alloc]initWithFrame:CGRectMake(120 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        birdieColor.backgroundColor = [UIColor colorWithHexString:@"#FC5D2B"];
        birdieColor.layer.masksToBounds = YES;
        birdieColor.layer.cornerRadius = birdieColor.bounds.size.width/2;
        [whiteHeaderView addSubview:birdieColor];
        
        UILabel *birdieValue = [[UILabel alloc]initWithFrame:CGRectMake(135 *ProportionAdapter, 38*ProportionAdapter, 25*ProportionAdapter, 14*ProportionAdapter)];
        birdieValue.text = @"Par";
        birdieValue.textColor = [UIColor colorWithHexString:B31_Color];
        birdieValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:birdieValue];
        
        UILabel *twoline = [[UILabel alloc]initWithFrame:CGRectMake(160 *ProportionAdapter, 38 *ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        twoline.text = @"+";
        twoline.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        twoline.textColor = [UIColor colorWithHexString:B31_Color];
        [whiteHeaderView addSubview:twoline];
        
        self.scoreTableView.tableHeaderView = whiteHeaderView;
    }
    return self;
}
#pragma mark -- 关闭事件
- (void)closeBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(scoresHoleViewDelegateCloseBtnClick:)]) {
        [self.delegate scoresHoleViewDelegateCloseBtnClick:btn];
    }
}
- (void)reloadScoreList:(NSArray *)currentAreaArray andAreaArray:(NSArray *)areaArray{
    _areaArray = areaArray;
    _currentAreaArray = currentAreaArray;
    
    self.scoreTableView.frame = CGRectMake(0, 0, screenWidth, (80 +90*2 + self.dataArray.count * 30*2)*ProportionAdapter);
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
    JGHNewScoresHoleCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewScoresHoleCellIdentifier];
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
            [scoresPageCell configOneToNine:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever andTaiwan:model.tTaiwan];
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
            [scoresPageCell configNineToEighteenth:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever andTaiwan:model.tTaiwan];
        }
    }
    
    return scoresPageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JGHNewPoorBarHoleCell *scoreAreaCell = [tableView dequeueReusableCellWithIdentifier:JGHNewPoorBarHoleCellIdentifier];
    scoreAreaCell.backgroundColor = [UIColor colorWithHexString:BG_color];
    scoreAreaCell.delegate = self;
    scoreAreaCell.poorBtn.tag = 3000 +section;
    scoreAreaCell.arebtn.tag = 30000 +section;
    [scoreAreaCell configJGHNewPoorBarHoleCell:_currentAreaArray[section]];
    return scoreAreaCell;
}
#pragma mark -- 切换区域
- (void)selectNewPoorAreaBtnClick:(UIButton *)btn andCurrtitle:(NSString *)currtitle{
    NSLog(@"btn.tag == %td", btn.tag);
    [self createTwarnview:currtitle];
    
    if (btn.tag == 30000) {
        _areaSourceID = 0;
    }else{
        _areaSourceID = 1;
    }
    
    UIButton *arebtn = [self viewWithTag:30000 +btn.tag -3000];
    [arebtn setImage:[UIImage imageNamed:@"arrowTop"] forState:UIControlStateNormal];
}
#pragma mark -- 创建T台视图
- (void)createTwarnview:(NSString *)string{
    self.areaListView = [[JGHAreaListView alloc]initWithFrame:CGRectMake(0, screenHeight -_areaArray.count*40*ProportionAdapter, screenWidth, _areaArray.count *40*ProportionAdapter +2*ProportionAdapter)];
    _areaListView.delegate = self;
    _areaListView.backgroundColor = [UIColor whiteColor];
    [_areaListView reloadAreaListView:_areaArray andCurrAreString:string];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_areaListView];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.areaListView.frame = CGRectMake(0, screenHeight -_areaArray.count*40*ProportionAdapter, screenWidth, _areaArray.count *40*ProportionAdapter +2*ProportionAdapter);
    }];
    
    _tranView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -(_areaArray.count *40*ProportionAdapter +2*ProportionAdapter))];
    _tranView.backgroundColor = [UIColor whiteColor];
    _tranView.alpha = 0.2;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]init];
    [tag addTarget:self action:@selector(removeTranView)];
    [_tranView addGestureRecognizer:tag];
    [[UIApplication sharedApplication].keyWindow addSubview:_tranView];
}
#pragma mark -- 移除遮罩
- (void)removeTranView{
    [UIView animateWithDuration:0.5f animations:^{
        self.areaListView.frame = CGRectMake(0, screenHeight, screenWidth, _areaArray.count *40*ProportionAdapter +2*ProportionAdapter);
        [self performSelector:@selector(removeAnimateView) withObject:nil afterDelay:0.5f];
    }];
    
    UIButton *arebtn = [self viewWithTag:40000];
    [arebtn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    
    UIButton *arebtn1 = [self viewWithTag:40001];
    [arebtn1 setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
}
- (void)removeAnimateView{
    [_tranView removeFromSuperview];
    _tranView = nil;
    
    [_areaListView removeFromSuperview];
    _areaListView = nil;
}
#pragma mark -- 点击杆数跳转到指定的积分页面
- (void)selectHoleCoresBtnTag:(NSInteger)btnTag andCellTag:(NSInteger)cellTag{
    NSLog(@"%td", btnTag);//2
    NSLog(@"%td", cellTag);//101
    NSLog(@"cell10 = %td", cellTag%100/10);
    NSLog(@"cell100  = %td", cellTag/100);
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    if ((cellTag%100/10) == 0) {
        [userDict setObject:@(btnTag -1) forKey:@"index"];
    }else{
        [userDict setObject:@(btnTag -1 + 9) forKey:@"index"];
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"noticePushScores" object:nil userInfo:userDict];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

#pragma mark -- 区域点击事件
- (void)areaString:(NSString *)areaString andID:(NSInteger)selectId{
    if (_areaSourceID == 0) {
        //第一区域
        if (self.delegate) {
            [self.delegate poorOneAreaString:areaString andID:selectId];
        }
    }else{
        //第二区域
        if (self.delegate) {
            [self.delegate poorOneAreaString:areaString andID:selectId +400];
        }
    }
        
    [self.scoreTableView reloadData];
    
    [_areaListView removeFromSuperview];
    _areaListView = nil;
    
    [self removeTranView];
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
