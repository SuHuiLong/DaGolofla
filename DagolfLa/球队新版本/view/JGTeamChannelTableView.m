//
//  JGTeamChannelTableView.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"

@interface JGTeamChannelTableView ()

@end

@implementation JGTeamChannelTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
   self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"first"];
        [self registerClass:[JGTeamChannelTableViewCell class] forCellReuseIdentifier:@"second"];
    }
    return self;
}



//- (NSMutableArray *)firstSectionArray{
//    if (!_firstSectionArray) {
//        _firstSectionArray = [[NSMutableArray alloc] init];
//    }
//    return _firstSectionArray;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
