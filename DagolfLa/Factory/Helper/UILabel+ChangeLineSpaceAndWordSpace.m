//
//  UILabel+ChangeLineSpaceAndWordSpace.m
//  DagolfLa
//
//  Created by SHL on 2017/3/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation UILabel (ChangeLineSpaceAndWordSpace)

-(void)changeLineWithSpace:(float)space{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
//    [self sizeToFit];
    
}

-(void)changeWordWithSpace:(float)space{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
//    [self sizeToFit];
    
}

-(void)changeSpacewithLineSpace:(float)lineSpace WordSpace:(float)wordSpace{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
//    [self sizeToFit];
    
}



@end
