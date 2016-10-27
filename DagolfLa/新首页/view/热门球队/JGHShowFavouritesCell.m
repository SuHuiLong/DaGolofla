//
//  JGHShowFavouritesCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowFavouritesCell.h"

@implementation JGHShowFavouritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.activityHeaderImageViewLeft.constant = 10 *ProportionAdapter;
    self.activityHeaderImageViewW.constant = 70 *ProportionAdapter;
    
    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.nameLeft.constant = 20 *ProportionAdapter;
    
    self.activityNumber.font = [UIFont systemFontOfSize:12 *ProportionAdapter];
    self.activityNumberLeft.constant = 10 *ProportionAdapter;
    
    self.addressImageLeft.constant = 20 *ProportionAdapter;

    self.address.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.addressLeft.constant = 10 *ProportionAdapter;
    
    self.details.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.detailsLeft.constant = 20 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHShowFavouritesCell:(NSDictionary *)dict{
    if ([dict objectForKey:@"timeKey"]) {
        [self.activityHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"imgURL"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
        
        self.name.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]];
        
        self.address.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]];
        
        self.details.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"desc"]];
    }
}

@end
