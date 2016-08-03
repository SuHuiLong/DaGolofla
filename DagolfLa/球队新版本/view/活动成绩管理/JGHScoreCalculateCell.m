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
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.poleNumberArray = [NSMutableArray array];
        
        [self createScoreCalculateTable];
    }
    return self;
}

- (void)createScoreCalculateTable{
    self.scoreCalculateTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth) style:UITableViewStylePlain];
    
    UINib *operationScoreCellNib = [UINib nibWithNibName:@"JGHOperationScoreCell" bundle: [NSBundle mainBundle]];
    [self.scoreCalculateTable registerNib:operationScoreCellNib forCellReuseIdentifier:JGHOperationScoreCellIdentifier];
//
//    UINib *playersScoreNib = [UINib nibWithNibName:@"JGHPlayersScoreTableViewCell" bundle: [NSBundle mainBundle]];
//    [self.scoreCalculateTable registerNib:playersScoreNib forCellReuseIdentifier:JGHPlayersScoreTableViewCellIdentifier];
//    
//    UINib *centerBtnNib = [UINib nibWithNibName:@"JGHCenterBtnTableViewCell" bundle: [NSBundle mainBundle]];
//    [self.scoreCalculateTable registerNib:centerBtnNib forCellReuseIdentifier:JGHCenterBtnTableViewCellIdentifier];
    
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
    tranCell.delegate = self;
    tranCell.transform = CGAffineTransformMakeRotation(M_PI/2);
    return tranCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark -- +
- (void)addOperationBtn:(UIButton *)btn{
    for (int i=0; i<18; i++) {
        if (i == btn.tag - 100) {
            NSInteger poles = [[self.poleNumberArray objectAtIndex:i] integerValue];
            if (poles > 0) {
                poles += 1;
            }else{
                poles = 1;
            }
            
            [self.poleNumberArray replaceObjectAtIndex:i withObject:@(poles)];
        }
    }
    
    self.returnScoresCalculateDataArray(_poleNumberArray);
}
#pragma mark -- -
- (void)redOperationBtn:(UIButton *)btn{
    for (int i=0; i<18; i++) {
        if (i == btn.tag - 100) {
            NSInteger poles = [[self.poleNumberArray objectAtIndex:i] integerValue];
            if (poles > 1) {
                poles -= 1;
            }else{
                poles = 0;
            }
            
            [self.poleNumberArray replaceObjectAtIndex:i withObject:@(poles)];
        }
    }
    
    self.returnScoresCalculateDataArray(_poleNumberArray);
}
#pragma mark -- list
- (void)scoreListBtn{
    if (self.delegate) {
        [self.delegate selectScoreListBtn];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
