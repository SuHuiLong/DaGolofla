

//
//  JGDTrueOrFalseTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDTrueOrFalseTableViewCell.h"

@implementation JGDTrueOrFalseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.colorImageV = [[UIImageView alloc] initWithFrame:CGRectMake(6 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        self.colorImageV.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.colorImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(25 * ProportionAdapter, 0, 55 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.nameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.nameLB];
        // screemw - 120
        CGFloat width = (screenWidth - 120 * ProportionAdapter) / 9;
        for (int i = 0; i < 9; i ++) {
            UIImageView *scoreLB = [[UIImageView alloc] initWithFrame:CGRectMake(88 * ProportionAdapter + i * width, 9 * ProportionAdapter, 13 * ProportionAdapter, 13 * ProportionAdapter)];
            scoreLB.tag = 777 + i;
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(80 * ProportionAdapter + i * width, 0 * ProportionAdapter, 2 * ProportionAdapter, 30 * ProportionAdapter)];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [self.contentView addSubview:lineV];
            [self.contentView addSubview:scoreLB];
            
            if (i == 8) {
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - 40 * ProportionAdapter, 0 * ProportionAdapter, 2 * ProportionAdapter, 30 * ProportionAdapter)];
                lineV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [self.contentView addSubview:lineV];
            }
        }
        
        self.sumLB = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 50 * ProportionAdapter, 0, 40 * ProportionAdapter, 30 * ProportionAdapter)];
        self.sumLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.sumLB.textAlignment = NSTextAlignmentRight;
        self.sumLB.textColor = [UIColor colorWithHexString:@"#5f6660"];
        [self.contentView addSubview:self.sumLB];
        
    }
    return self;
}


- (void)takeDetailInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath{
    
  
            if (indexPath.section == 0) {
                self.nameLB.text = @"上球道";
                [self.colorImageV removeFromSuperview];
                NSInteger sum = 0;
                for (UIImageView *imageV in self.contentView.subviews) {
                    if (imageV.tag) {
                        NSInteger core = [model.onthefairway[imageV.tag - 777] integerValue];
                        
                        if (core == 0) {
                            imageV.image = [UIImage imageNamed:@"jifen_wrong"];
                        }else if (core == 1) {
                            imageV.image = [UIImage imageNamed:@"jifen_right"];
                            sum ++;
                        }else {
                            [imageV removeFromSuperview];
                        }
                        
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }else if (indexPath.section == 1) {
                self.nameLB.text = @"上球道";
                [self.colorImageV removeFromSuperview];
                NSInteger sum = 0;
                for (UIImageView *imageV in self.contentView.subviews) {
                    if (imageV.tag) {
                        NSInteger core = [model.onthefairway[imageV.tag - 776 + 8] integerValue];
                        
                        if (core == 0) {
                            imageV.image = [UIImage imageNamed:@"jifen_wrong"];
                        }else if (core == 1) {
                            imageV.image = [UIImage imageNamed:@"jifen_right"];
                            sum ++;
                        }else {
                            [imageV removeFromSuperview];
                        }
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }
    
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