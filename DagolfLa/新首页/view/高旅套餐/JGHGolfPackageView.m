//
//  JGHGolfPackageView.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHGolfPackageView.h"
#import "JGHGolfPackageSubCell.h"

static NSString *const JGHGolfPackageSubCellIdentifier = @"JGHGolfPackageSubCell";

@interface JGHGolfPackageView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _imageW;
    NSInteger _imageH;
}
@property (nonatomic, retain)NSArray *dataArray;

@property (nonatomic, retain)UITableView *golfPackageView;

@end

@implementation JGHGolfPackageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _dataArray = [NSArray array];
        _golfPackageView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 262*ProportionAdapter, screenWidth)];
        [_golfPackageView registerClass:[JGHGolfPackageSubCell class] forCellReuseIdentifier:JGHGolfPackageSubCellIdentifier];
        _golfPackageView.dataSource = self;
        _golfPackageView.delegate = self;
        _golfPackageView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _golfPackageView.backgroundColor = [UIColor whiteColor];
        _golfPackageView.showsVerticalScrollIndicator = NO;
        _golfPackageView.showsHorizontalScrollIndicator = NO;
        _golfPackageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _golfPackageView.frame = CGRectMake(0, 0, screenWidth, 262*ProportionAdapter);
        [self addSubview:_golfPackageView];
    }
    return self;
}

- (void)configJGHGolfPackageViewData:(NSArray *)dataArray andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    _imageW = imageW;
    _imageH = imageH;
    _dataArray = dataArray;
    [_golfPackageView reloadData];
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
    JGHGolfPackageSubCell *golfPackageSubCell = [tableView dequeueReusableCellWithIdentifier:JGHGolfPackageSubCellIdentifier];
    if (_dataArray.count >0) {
        [golfPackageSubCell configJGHGolfPackageSubCell:_dataArray[indexPath.section] andImageW:_imageW andImageH:_imageH];
    }
    
    golfPackageSubCell.selectionStyle = UITableViewCellSelectionStyleNone;
    golfPackageSubCell.transform = CGAffineTransformMakeRotation(M_PI/2);
    golfPackageSubCell.frame = CGRectMake(0, 0, _imageW*ProportionAdapter +20*ProportionAdapter, _imageH*ProportionAdapter+ 99*ProportionAdapter);
    return golfPackageSubCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectGolgPackageViewUrlString:)]) {
        [self.delegate didSelectGolgPackageViewUrlString:indexPath.section];
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
