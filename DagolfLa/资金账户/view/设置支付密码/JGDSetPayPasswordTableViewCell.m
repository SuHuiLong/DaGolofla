//
//  JGDSetPayPasswordTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSetPayPasswordTableViewCell.h"

@interface JGDSetPayPasswordTableViewCell ()

@property (nonatomic, strong) UILabel *LB;
@property (nonatomic, strong) UITextField *txFD;
@property (nonatomic, strong) UIButton *takeBtn;

@end

@implementation JGDSetPayPasswordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.LB = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 375, 0, 60 * screenWidth / 375, 44 * screenWidth / 375)];
//        self.txFD = [UITextField alloc] initWithFrame:CGRectMake(80, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
