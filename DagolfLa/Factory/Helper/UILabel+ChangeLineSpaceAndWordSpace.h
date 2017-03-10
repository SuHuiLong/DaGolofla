//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  DagolfLa
//
//  Created by SHL on 2017/3/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
- (void)changeLineWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpacewithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
