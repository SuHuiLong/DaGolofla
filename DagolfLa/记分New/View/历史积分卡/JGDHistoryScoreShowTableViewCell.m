//
//  JGDHistoryScoreShowTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHistoryScoreShowTableViewCell.h"

@interface JGDHistoryScoreShowTableViewCell ()

@property (nonatomic, strong) NSMutableDictionary *tTaiDic;

@end

@implementation JGDHistoryScoreShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.colorImageV = [[UIImageView alloc] initWithFrame:CGRectMake(6 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter, 10 * ProportionAdapter)];
        [self.contentView addSubview:self.colorImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(25 * ProportionAdapter, 0, 55 * ProportionAdapter, 30 * ProportionAdapter)];
        self.nameLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        self.nameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.nameLB];
        // screemw - 120
        CGFloat width = (screenWidth - 120 * ProportionAdapter) / 9;
        for (int i = 0; i < 9; i ++) {
            UILabel *scoreLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter + i * width, 4 * ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
            scoreLB.layer.cornerRadius = 11 * ProportionAdapter;
            scoreLB.layer.masksToBounds = YES;
            scoreLB.text = [NSString stringWithFormat:@"%d", i];
            scoreLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            scoreLB.textColor = [UIColor colorWithHexString:@"#5f6660"];
            scoreLB.textAlignment = NSTextAlignmentCenter;
            scoreLB.tag = 777 + i;
            [self.contentView addSubview:scoreLB];
        }
        
        self.sumLB = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 50 * ProportionAdapter, 0, 40 * ProportionAdapter, 30 * ProportionAdapter)];
        self.sumLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.sumLB.textAlignment = NSTextAlignmentRight;
        self.sumLB.textColor = [UIColor colorWithHexString:@"#5f6660"];
        [self.contentView addSubview:self.sumLB];
        
    }
    return self;
}

- (void)takeInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSLog(@"%td", indexPath.row);
        if (indexPath.row == 1) {
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ecf7ef"];
            self.nameLB.text = @"Par";
            self.colorImageV.backgroundColor = [UIColor clearColor];
//            [self.colorImageV removeFromSuperview];
            NSInteger sum = 0;
            for (UILabel *lb in self.contentView.subviews) {
                if (lb.tag) {
                    lb.text = [NSString stringWithFormat:@"%@", model.standardlever[lb.tag - 777]];
                   NSInteger core = [model.standardlever[lb.tag - 777] integerValue];
                    sum += core;
                }
            }
            self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
        }else{
            self.nameLB.text = model.userName;
            
            for (NSString *key in self.tTaiDic.allKeys) {
                if ([model.tTaiwan isEqualToString:key]) {
                    self.colorImageV.backgroundColor = [self.tTaiDic objectForKey:key];
                }
            }
            
            NSInteger sum = 0;
            for (UILabel *lb in self.contentView.subviews) {
                if (lb.tag) {
                    if ([model.poleNumber[lb.tag - 777] integerValue] != -1) {
                        lb.text = [NSString stringWithFormat:@"%@", model.poleNumber[lb.tag - 777]];
                        NSInteger core = [model.poleNumber[lb.tag - 777] integerValue];
                        NSInteger standardlever = [model.standardlever[lb.tag - 777] integerValue];
                        sum += core;
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                        if (standardlever - core >= 2) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#7fffff"];
                            
                        }else if (standardlever - core == 1) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#7fdfff"];
                            
                        }else if (standardlever == core) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#ffd2a6"];
                            
                        }else if (core > standardlever) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#ffaaa5"];
                            
                        }
                    }else{
                       lb.text = @"";
                    }
                }
            }
            self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
        }

        
    }else if (indexPath.section == 1) {
        
        
        if (indexPath.row == 1) {
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ecf7ef"];
            self.nameLB.text = @"Par";
            self.colorImageV.backgroundColor = [UIColor clearColor];
//            [self.colorImageV removeFromSuperview];
            NSInteger sum = 0;
            for (UILabel *lb in self.contentView.subviews) {
                if (lb.tag) {
                    lb.text = [NSString stringWithFormat:@"%@", model.standardlever[lb.tag - 776 + 8]];
                    NSInteger core = [model.standardlever[lb.tag - 776 + 8] integerValue];
                    sum += core;
                    NSLog(@"sum = %td -------- core = %td", sum, core);
                    
                }
            }
            self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
        }else{
            self.nameLB.text = model.userName;
            for (NSString *key in self.tTaiDic.allKeys) {
                if ([model.tTaiwan isEqualToString:key]) {
                    self.colorImageV.backgroundColor = [self.tTaiDic objectForKey:key];
                }
            }
            NSInteger sum = 0;
            for (UILabel *lb in self.contentView.subviews) {
                if (lb.tag) {
                    if ([model.poleNumber[lb.tag - 776 + 8] integerValue] != -1) {
                        lb.text = [NSString stringWithFormat:@"%@", model.poleNumber[lb.tag - 776 + 8]];
                        NSInteger core = [model.poleNumber[lb.tag - 776 + 8] integerValue];
                        NSInteger standardlever = [model.standardlever[lb.tag - 776 + 8] integerValue];
                        sum += core;
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                        if (standardlever - core >= 2) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#7fffff"];
                            
                        }else if (standardlever - core == 1) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#7fbfff"];
                            
                        }else if (standardlever == core) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#ffd2a6"];
                            
                        }else if (core > standardlever) {
                            lb.backgroundColor = [UIColor colorWithHexString:@"#ffaaa5"];
                        }
                    }else{
                        lb.text = @"";
                    }
                }
            }
            self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
        }
        
    }
    
}

- (void)takeDetailInfoWithModel:(JGDHistoryScoreShowModel *)model index:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 1:
            if (indexPath.section == 0) {
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ecf7ef"];
                self.nameLB.text = @"Par";
//                [self.colorImageV removeFromSuperview];
                self.colorImageV.backgroundColor = [UIColor clearColor];
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        lb.text = [NSString stringWithFormat:@"%@", model.standardlever[lb.tag - 777]];
                        NSInteger core = [model.standardlever[lb.tag - 777] integerValue];
                        sum += core;
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }else if (indexPath.section == 1) {
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ecf7ef"];
                self.nameLB.text = @"Par";
//                [self.colorImageV removeFromSuperview];
                self.colorImageV.backgroundColor = [UIColor clearColor];
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        lb.text = [NSString stringWithFormat:@"%@", model.standardlever[lb.tag - 776 + 8]];
                        NSInteger core = [model.standardlever[lb.tag - 776 + 8] integerValue];
                        sum += core;
                        NSLog(@"sum = %td -------- core = %td", sum, core);
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }
            break;
            
            case 2:
            if (indexPath.section == 0) {
                self.nameLB.text = @"杆数";
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        if ([model.poleNumber[lb.tag - 777] integerValue] != -1) {
                            lb.text = [NSString stringWithFormat:@"%@", model.poleNumber[lb.tag - 777]];
                            NSInteger core = [model.poleNumber[lb.tag - 777] integerValue];
                            NSInteger standardlever = [model.standardlever[lb.tag - 777] integerValue];
                            sum += core;
                            NSLog(@"sum = %td -------- core = %td", sum, core);
                            if (standardlever - core >= 2) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#7fffff"];
                                
                            }else if (standardlever - core == 1) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#7fbfff"];
                                
                            }else if (standardlever == core) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#ffd2a6"];
                                
                            }else if (core > standardlever) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#ffaaa5"];
                                
                            }
                        }else{
                            lb.text = @"";
                        }
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }else{
                self.nameLB.text = @"杆数";
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        if ([model.poleNumber[lb.tag - 776 + 8] integerValue] != -1) {
                            lb.text = [NSString stringWithFormat:@"%@", model.poleNumber[lb.tag - 776 + 8]];
                            NSInteger core = [model.poleNumber[lb.tag - 776 + 8] integerValue];
                            NSInteger standardlever = [model.standardlever[lb.tag - 776 + 8] integerValue];
                            sum += core;
                            NSLog(@"sum = %td -------- core = %td", sum, core);
                            if (standardlever - core >= 2) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#7fffff"];
                                
                            }else if (standardlever - core == 1) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#7fbfff"];
                                
                            }else if (standardlever == core) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#ffd2a6"];
                                
                            }else if (core > standardlever) {
                                lb.backgroundColor = [UIColor colorWithHexString:@"#ffaaa5"];
                                
                            }
                        }else{
                            lb.text = @"";
                        }
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }
            break;
            
        case 3:
            if (indexPath.section == 0) {
                self.nameLB.text = @"推杆";
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        if ([model.pushrod[lb.tag - 777] integerValue] != -1) {
                            lb.text = [NSString stringWithFormat:@"%@", model.pushrod[lb.tag - 777]];
                            NSInteger core = [model.pushrod[lb.tag - 777] integerValue];
                            sum += core;
                            NSLog(@"sum = %td -------- core = %td", sum, core);
                        }else{
                            lb.text = @"";
                        }
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }else{
                self.nameLB.text = @"推杆";
                NSInteger sum = 0;
                for (UILabel *lb in self.contentView.subviews) {
                    if (lb.tag) {
                        if ([model.pushrod[lb.tag - 776 + 8] integerValue] != -1) {
                            lb.text = [NSString stringWithFormat:@"%@", model.pushrod[lb.tag - 776 + 8]];
                            NSInteger core = [model.pushrod[lb.tag - 776 + 8] integerValue];
                            sum += core;
                            NSLog(@"sum = %td -------- core = %td", sum, core);
                        }else{
                            lb.text = @"";
                        }
                    }
                }
                self.sumLB.text = [NSString stringWithFormat:@"%td", sum];
            }
            break;

            
        default:
            break;
    }
    
    
}

- (NSMutableDictionary *)tTaiDic{
    if (!_tTaiDic) {
        _tTaiDic = [[NSMutableDictionary alloc] init];
        [_tTaiDic setObject:[UIColor colorWithHexString:@"#e21f23"] forKey:@"红T"];
        [_tTaiDic setObject:[UIColor colorWithHexString:@"#eeeeee"] forKey:@"白T"];
        [_tTaiDic setObject:[UIColor colorWithHexString:@"#000000"] forKey:@"黑T"];
        [_tTaiDic setObject:[UIColor colorWithHexString:@"#2474ac"] forKey:@"蓝T"];
        [_tTaiDic setObject:[UIColor colorWithHexString:@"#bedd00"] forKey:@"金T"];

    }
    return _tTaiDic;
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
