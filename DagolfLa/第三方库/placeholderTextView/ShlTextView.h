//
//  ShlTextView.h
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShlTextView : UITextView

@property(nonatomic,copy)UILabel  *placeLabel;

@property(nonatomic,copy)NSString *placeStr;

-(void)textViewDidChange:(NSString *)str;

//配置
- (instancetype)initWithFrame:(CGRect)frame placeLabel:(UILabel *)placeLabel;

@end
