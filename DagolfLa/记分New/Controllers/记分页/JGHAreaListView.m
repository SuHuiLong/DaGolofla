//
//  JGHAreaListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAreaListView.h"
#import "JGHNewAreaListCell.h"

static NSString *const JGHNewAreaListCellIdentifier = @"JGHNewAreaListCell";

@interface JGHAreaListView ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *_areString;
}

@end

@implementation JGHAreaListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
//        _oneLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2*ProportionAdapter)];
//        _oneLine.backgroundColor = [UIColor blackColor];
//        _oneLine.alpha = 0.1;
//        [self addSubview:_oneLine];
        _areString = nil;
        
        _twoLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2*ProportionAdapter)];
        _twoLine.backgroundColor = [UIColor blackColor];
        _twoLine.alpha = 0.1;
        [self addSubview:_twoLine];
        
        self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 2*ProportionAdapter, self.frame.size.width, self.frame.size.height)];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.listTableView registerClass:[JGHNewAreaListCell class] forCellReuseIdentifier:JGHNewAreaListCellIdentifier];
        
        [self addSubview:self.listTableView];
        
        
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 *ProportionAdapter;
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView.tag == 1001) {
//        if ([self.listArray[section] count] == 0) {
//            return nil;
//        }else{
//            return self.keyArray[section];
//        }
//    }
//    else{
//        return nil;
//    }
//    
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGHNewAreaListCell *scoresPageCell = [tableView dequeueReusableCellWithIdentifier:JGHNewAreaListCellIdentifier];
    [scoresPageCell configJGHNewAreaListCell:_listArray[indexPath.row]];
    if (indexPath.row == _listArray.count -1) {
        scoresPageCell.line.hidden = YES;
    }else{
        scoresPageCell.line.hidden = NO;
    }
    
    if ([_areString isEqualToString:[NSString stringWithFormat:@"%@", _listArray[indexPath.row]]]) {
        scoresPageCell.tilte.textColor = [UIColor lightGrayColor];
    }else{
        scoresPageCell.tilte.textColor = [UIColor colorWithHexString:B31_Color];
    }
    
    return scoresPageCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row == %td", indexPath.row);
    if ([[_listArray objectAtIndex:indexPath.row] isEqualToString:_areString]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(areaString:andID:)]) {
        [self.delegate areaString:_listArray[indexPath.row] andID:indexPath.row];
    }
}

- (void)reloadAreaListView:(NSArray *)listArray andCurrAreString:(NSString *)areString{
    _areString = areString;
    _listArray = listArray;
    [self.listTableView reloadData];
}


@end
