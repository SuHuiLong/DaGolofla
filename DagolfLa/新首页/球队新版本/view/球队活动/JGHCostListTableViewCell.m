//
//  JGHCostListTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCostListTableViewCell.h"

@implementation JGHCostListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLeft.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCostData:(NSMutableDictionary *)dict{
    self.titles.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"costName"]];
    self.price.text = [NSString stringWithFormat:@"    %@", [dict objectForKey:@"money"]];
    self.titles.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.price.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    float titlesWSize;
    float priceWSize;
    float priceUnitWSize;
    
    titlesWSize = [Helper textWidthFromTextString:self.titles.text height:self.titles.frame.size.height fontSize:15 *ProportionAdapter];
    priceWSize = [Helper textWidthFromTextString:[NSString stringWithFormat:@"    %@", self.price.text] height:self.price.frame.size.height fontSize:15 *ProportionAdapter];
    priceUnitWSize = [Helper textWidthFromTextString:self.priceUnit.text height:self.priceUnit.frame.size.height fontSize:15 *ProportionAdapter];
    
    if (titlesWSize + priceWSize + priceUnitWSize > screenWidth - 40*ProportionAdapter) {
        self.titlesW.constant = screenWidth - 40*ProportionAdapter - priceWSize - priceUnitWSize;
    }else{
        self.titlesW.constant = titlesWSize +10*ProportionAdapter;
    }
}

- (void)configMatchCostData:(NSMutableDictionary *)dict{
    self.titles.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.price.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.titles.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"costName"]];
    self.price.text = [NSString stringWithFormat:@"    %@", [dict objectForKey:@"money"]];
    
    
    float titlesWSize;
    float priceWSize;
    float priceUnitWSize;
    
    titlesWSize = [Helper textWidthFromTextString:self.titles.text height:self.titles.frame.size.height fontSize:15 *ProportionAdapter];
    priceWSize = [Helper textWidthFromTextString:[NSString stringWithFormat:@"    %@", self.price.text] height:self.price.frame.size.height fontSize:15 *ProportionAdapter];
    priceUnitWSize = [Helper textWidthFromTextString:self.priceUnit.text height:self.priceUnit.frame.size.height fontSize:15 *ProportionAdapter];
    
    if (titlesWSize + priceWSize + priceUnitWSize > screenWidth - 40*ProportionAdapter) {
        self.titlesW.constant = screenWidth - 40*ProportionAdapter - priceWSize - priceUnitWSize;
    }else{
        self.titlesW.constant = titlesWSize +10*ProportionAdapter;
    }
}

@end
