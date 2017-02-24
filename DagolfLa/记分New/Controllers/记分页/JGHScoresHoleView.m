//
//  JGHScoresHoleView.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresHoleView.h"
#import "JGHScoreListModel.h"
#import "JGHAreaListView.h"
#import "JGHNewPoorBarHoleCell.h"
#import "JGHNewScoresHoleCell.h"

#define BGScoreColor @"#B3E4BF"

static NSString *const JGHNewPoorBarHoleCellIdentifier = @"JGHNewPoorBarHoleCell";
static NSString *const JGHNewScoresHoleCellIdentifier = @"JGHNewScoresHoleCell";

@interface JGHScoresHoleView ()<UITableViewDelegate, UITableViewDataSource, JGHNewPoorBarHoleCellDelegate, JGHAreaListViewDelegate, JGHNewScoresHoleCellDelegate>
{
    NSArray *_colorArray;
    NSInteger _areaId;// 0-无区域，1- ； 2-；
    
    NSArray *_currentAreaArray;//当前区域
    NSArray *_areaArray;//区域列表
    
    NSInteger _areaSourceID;//0-一区；1-二区
}

@property (nonatomic, strong)UITableView *scoreTableView;

@property (nonatomic, retain)JGHAreaListView *areaListView;//区域列表

@property (nonatomic, retain)UIView *tranView;

@end

@implementation JGHScoresHoleView


- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        _colorArray = @[@"#FFFFFF", @"#f4f6f8", @"#FFFFFF", @"#f4f6f8", @"#FFFFFF", @"#f4f6f8"];
        
        self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, (200 +20 +20 + 70)*ProportionAdapter) style:UITableViewStylePlain];
        self.scoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.scoreTableView.scrollEnabled = NO;
        self.scoreTableView.delegate = self;
        self.scoreTableView.dataSource = self;
        
        [self.scoreTableView registerClass:[JGHNewScoresHoleCell class] forCellReuseIdentifier:JGHNewScoresHoleCellIdentifier];
        
        [self.scoreTableView registerClass:[JGHNewPoorBarHoleCell class] forCellReuseIdentifier:JGHNewPoorBarHoleCellIdentifier];
        
        self.scoreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.scoreTableView];
        
        UIView *whiteHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * ProportionAdapter)];
        whiteHeaderView.backgroundColor = [UIColor whiteColor];
        
        //关闭按钮
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -34*ProportionAdapter, 10*ProportionAdapter, 22*ProportionAdapter, 22*ProportionAdapter)];
        [closeBtn setImage:[UIImage imageNamed:@"date_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteHeaderView addSubview:closeBtn];
        
        UILabel *eagleColor = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        eagleColor.backgroundColor = [UIColor colorWithHexString:@"#FDBB53"];
        eagleColor.layer.masksToBounds = YES;
        eagleColor.layer.cornerRadius = eagleColor.bounds.size.width/2;
        [whiteHeaderView addSubview:eagleColor];
        
        UILabel *eagleValue = [[UILabel alloc]initWithFrame:CGRectMake(25 *ProportionAdapter, 38*ProportionAdapter, 40*ProportionAdapter, 14*ProportionAdapter)];
        eagleValue.text = @"Eagle";
        eagleValue.textColor = [UIColor colorWithHexString:B31_Color];
        eagleValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:eagleValue];
        
        UILabel *birdieColor = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        birdieColor.backgroundColor = [UIColor colorWithHexString:@"#FC5D2B"];
        birdieColor.layer.masksToBounds = YES;
        birdieColor.layer.cornerRadius = eagleColor.bounds.size.width/2;
        [whiteHeaderView addSubview:birdieColor];
        
        UILabel *birdieValue = [[UILabel alloc]initWithFrame:CGRectMake(85 *ProportionAdapter, 38*ProportionAdapter, 40*ProportionAdapter, 14*ProportionAdapter)];
        birdieValue.text = @"Birdie";
        birdieValue.textColor = [UIColor colorWithHexString:B31_Color];
        birdieValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:birdieValue];
        
        UILabel *parColor = [[UILabel alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        parColor.backgroundColor = [UIColor colorWithHexString:@"#5A5856"];
        parColor.layer.masksToBounds = YES;
        parColor.layer.cornerRadius = eagleColor.bounds.size.width/2;
        [whiteHeaderView addSubview:parColor];
        
        UILabel *parValue = [[UILabel alloc]initWithFrame:CGRectMake(145 *ProportionAdapter, 38*ProportionAdapter, 40*ProportionAdapter, 14*ProportionAdapter)];
        parValue.text = @"Par";
        parValue.textColor = [UIColor colorWithHexString:B31_Color];
        parValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:parValue];
        
        UILabel *bogeyColor = [[UILabel alloc]initWithFrame:CGRectMake(180 *ProportionAdapter, 42*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        bogeyColor.backgroundColor = [UIColor colorWithHexString:@"#54A5FC"];
        bogeyColor.layer.masksToBounds = YES;
        bogeyColor.layer.cornerRadius = eagleColor.bounds.size.width/2;
        [whiteHeaderView addSubview:bogeyColor];
        
        UILabel *bogeyValue = [[UILabel alloc]initWithFrame:CGRectMake(195 *ProportionAdapter, 38*ProportionAdapter, 40*ProportionAdapter, 14*ProportionAdapter)];
        bogeyValue.text = @"Bogey";
        bogeyValue.textColor = [UIColor colorWithHexString:B31_Color];
        bogeyValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        [whiteHeaderView addSubview:bogeyValue];
        
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
    NSLog(@"page == %td", self.tag);
    //背景
    if (_dataArray.count > 0) {
        NSLog(@"_curPage === %td", _curPage);
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
    
    NSLog(@"page1111 == %td", self.tag);
    //数据
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
            [scoresPageCell configPoorOneToNine:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever andTaiwan:model.tTaiwan];
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
            [scoresPageCell configPoorNineToEighteenth:model.poleNumber andUserName:model.userName andStandradArray:model.standardlever andTaiwan:model.tTaiwan];
        }
    }
    NSLog(@"page22222 == %td", self.tag);
    return scoresPageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JGHNewPoorBarHoleCell *scoreAreaCell = [tableView dequeueReusableCellWithIdentifier:JGHNewPoorBarHoleCellIdentifier];
    scoreAreaCell.backgroundColor = [UIColor colorWithHexString:@"#dddfe1"];
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
    [arebtn setImage:[UIImage imageNamed:@"icn_show_arrowdown"] forState:UIControlStateNormal];
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
#pragma mark -- 创建T台视图
- (void)createTwarnview:(NSString *)string{
    self.areaListView = [[JGHAreaListView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, _areaArray.count *40*ProportionAdapter +2*ProportionAdapter)];
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
    
    UIButton *arebtn = [self viewWithTag:30000];
    [arebtn setImage:[UIImage imageNamed:@"icn_show_arrowup"] forState:UIControlStateNormal];
    
    UIButton *arebtn1 = [self viewWithTag:30001];
    [arebtn1 setImage:[UIImage imageNamed:@"icn_show_arrowup"] forState:UIControlStateNormal];
}
- (void)removeAnimateView{
    [_tranView removeFromSuperview];
    _tranView = nil;
    
    [_areaListView removeFromSuperview];
    _areaListView = nil;
}
#pragma mark -- 区域点击事件
- (void)areaString:(NSString *)areaString andID:(NSInteger)selectId{
    if (_areaSourceID == 0) {
        //第一区域
        if (self.delegate) {
            [self.delegate oneAreaString:areaString andID:selectId];
        }
    }else{
        //第二区域
        if (self.delegate) {
            [self.delegate oneAreaString:areaString andID:selectId +400];
        }
    }
    
    [self.scoreTableView reloadData];
    
    [self removeTranView];
}

#pragma mark -- 刷新数据
- (void)reloadViewData:(NSMutableArray *)dataArray andCurrentAreaArrat:(NSArray *)currentAreaArray{
    
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
