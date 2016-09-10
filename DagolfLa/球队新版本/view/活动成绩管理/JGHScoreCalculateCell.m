//
//  JGHScoreCalculateCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoreCalculateCell.h"
#import "JGHOperationScoreCell.h"

static NSString *const JGHOperationScoreCellIdentifier = @"JGHOperationScoreCell";

@interface JGHScoreCalculateCell ()<UITableViewDelegate, UITableViewDataSource, JGHOperationScoreCellDelegate>

@property (nonatomic, strong)UITableView *scoreCalculateTable;

@end

@implementation JGHScoreCalculateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.poleNumberArray = [NSMutableArray array];
        self.parArray = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self createScoreCalculateTable];
    }
    return self;
}

- (void)createScoreCalculateTable{
    self.scoreCalculateTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth) style:UITableViewStylePlain];
    
    UINib *operationScoreCellNib = [UINib nibWithNibName:@"JGHOperationScoreCell" bundle: [NSBundle mainBundle]];
    [self.scoreCalculateTable registerNib:operationScoreCellNib forCellReuseIdentifier:JGHOperationScoreCellIdentifier];
    
    self.scoreCalculateTable.delegate = self;
    self.scoreCalculateTable.dataSource = self;
    
    self.scoreCalculateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreCalculateTable.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.scoreCalculateTable.transform = CGAffineTransformMakeRotation(-M_PI/2);
    self.scoreCalculateTable.pagingEnabled = YES;
    self.scoreCalculateTable.showsHorizontalScrollIndicator = NO;
    self.scoreCalculateTable.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.scoreCalculateTable];
}

- (void)layoutSubviews{
    if (_holeId > 1) {
        [self.scoreCalculateTable setContentOffset:CGPointMake(0, screenWidth*(_holeId-1)) animated:YES];
    }else{
        [self.scoreCalculateTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return screenWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHOperationScoreCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHOperationScoreCellIdentifier];
    tranCell.addScoreBtn.tag = 100 + indexPath.section;
    tranCell.redScoreBtn.tag = 200 + indexPath.section;
    tranCell.scoreListBtn.tag = indexPath.section + 300;
    tranCell.delegate = self;
    tranCell.transform = CGAffineTransformMakeRotation(M_PI/2);
    if (_parArray.count > 0) {
        [tranCell configStandPar:[_parArray[indexPath.section] integerValue] andHole:indexPath.section andPole:[_poleNumberArray[indexPath.section] integerValue]];
    }else{
        [tranCell configStandPar:-1 andHole:indexPath.section andPole:[_poleNumberArray[indexPath.section] integerValue]];
    }
    
    tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tranCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"contentOffset.y == %f", scrollView.contentOffset.y);
    NSLog(@"contentOffset.x == %f", scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.y < -screenWidth/4 && scrollView.contentOffset.y < 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:17];
        [self.scoreCalculateTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        self.scoreCalculateTable.pagingEnabled = YES;
    }
    
    if (scrollView.contentOffset.y > screenWidth/4 + 17*screenWidth && scrollView.contentOffset.y > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.scoreCalculateTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        self.scoreCalculateTable.pagingEnabled = YES;
    }
    
    self.scoreCalculateTable.pagingEnabled = YES;
}

#pragma mark -- +
- (void)addOperationBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    for (int i=0; i<18; i++) {
        if (i == btn.tag - 100) {
            NSInteger poles = [[self.poleNumberArray objectAtIndex:i] integerValue];
            if (poles == -1) {
                poles = [_parArray[btn.tag - 100] integerValue];
            }else{
                poles += 1;
            }
            
            [self.poleNumberArray replaceObjectAtIndex:i withObject:@(poles)];
        }
    }
    
    [self.scoreCalculateTable reloadData];
    self.returnScoresCalculateDataArray(_poleNumberArray);
}
#pragma mark -- -
- (void)redOperationBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    for (int i=0; i<18; i++) {
        if (i == btn.tag - 200) {
            NSInteger poles = [[self.poleNumberArray objectAtIndex:i] integerValue];
            if (poles == -1) {
                poles = [_parArray[btn.tag - 200] integerValue];
            }else{
                if (poles <= 1) {
                    poles = 1;
                }else{
                    poles -= 1;
                }
            }
            
            [self.poleNumberArray replaceObjectAtIndex:i withObject:@(poles)];
        }
    }
    
    [self.scoreCalculateTable reloadData];
    self.returnScoresCalculateDataArray(_poleNumberArray);
}
#pragma mark -- list
- (void)scoreListBtn:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate selectScoreListBtn:btn];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
