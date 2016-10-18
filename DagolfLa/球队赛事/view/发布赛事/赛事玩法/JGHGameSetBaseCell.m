//
//  JGHGameSetBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetBaseCell.h"

@implementation JGHGameSetBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rulesName.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.rulesNameLeft.constant = 40 *ProportionAdapter;
    
    self.rulesContext.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.rulesContextLeft.constant = 10 *ProportionAdapter;
    self.rulesContextRight.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configJGHGameSetBaseCell:(NSDictionary *)dict{
    self.rulesName.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    float rulesNameWSize = [Helper textWidthFromTextString:self.rulesName.text height:self.rulesName.frame.size.height fontSize:14 *ProportionAdapter];
    self.rulesNameW.constant = rulesNameWSize +10;
    
    self.rulesContext.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"parentName"]];
}

@end
