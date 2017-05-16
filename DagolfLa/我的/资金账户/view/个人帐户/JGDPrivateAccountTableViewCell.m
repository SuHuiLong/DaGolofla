
//
//  JGDPrivateAccountTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPrivateAccountTableViewCell.h"

@interface JGDPrivateAccountTableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *nexLB;
@property (nonatomic, strong) UIButton *deleBtn;

@end

@implementation JGDPrivateAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        
        
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
