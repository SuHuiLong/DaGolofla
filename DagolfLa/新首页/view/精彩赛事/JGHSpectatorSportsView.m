//
//  JGHSpectatorSportsView.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHSpectatorSportsView.h"
#import "JGHSpectatorSubCell.h"

static NSString *const JGHSpectatorSubCellIdentifier = @"JGHSpectatorSubCell";

@interface JGHSpectatorSportsView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _imageW;
    NSInteger _imageH;
}

@property (nonatomic, retain)NSArray *dataArray;

@property (nonatomic, retain)UITableView *spectatorTableView;

@end

@implementation JGHSpectatorSportsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _dataArray = [NSArray array];
        _spectatorTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 262*ProportionAdapter, screenWidth)];
        [_spectatorTableView registerClass:[JGHSpectatorSubCell class] forCellReuseIdentifier:JGHSpectatorSubCellIdentifier];
        _spectatorTableView.dataSource = self;
        _spectatorTableView.delegate = self;
        _spectatorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _spectatorTableView.backgroundColor = [UIColor whiteColor];
        _spectatorTableView.showsVerticalScrollIndicator = NO;
        _spectatorTableView.showsHorizontalScrollIndicator = NO;
        _spectatorTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _spectatorTableView.frame = CGRectMake(0, 0, screenWidth, 262*ProportionAdapter);
        [self addSubview:_spectatorTableView];
    }
    return self;
}

- (void)configJGHSpectatorSportsViewData:(NSArray *)dataArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    _imageW = imageW;
    _imageH = imageH;
    _dataArray = dataArray;
    [_spectatorTableView reloadData];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _imageW*ProportionAdapter +6*ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHSpectatorSubCell *spectatorSubCell = [tableView dequeueReusableCellWithIdentifier:JGHSpectatorSubCellIdentifier];
    if (_dataArray.count >0) {
        NSLog(@"====%td", indexPath.row);
        [spectatorSubCell configJGHSpectatorSubCell:_dataArray[indexPath.section] andImageW:_imageW andImageH:_imageH];
    }
    
    spectatorSubCell.selectionStyle = UITableViewCellSelectionStyleNone;
    spectatorSubCell.transform = CGAffineTransformMakeRotation(M_PI/2);
    //spectatorSubCell.frame = CGRectMake(0, 0, screenWidth -40*ProportionAdapter, 262*ProportionAdapter);
    spectatorSubCell.frame = CGRectMake(0, 0, _imageW*ProportionAdapter +20*ProportionAdapter, _imageH*ProportionAdapter+ 99*ProportionAdapter);
    return spectatorSubCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectSpectatorSportsViewUrlString:)]) {
        [self.delegate selectSpectatorSportsViewUrlString:indexPath.section];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
