//
//  JGLabel.h
//  DagolfLa
//
//  Created by 東 on 16/6/30.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLabel : UILabel
//1.header file
@property(nonatomic) UIEdgeInsets insets;

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end
