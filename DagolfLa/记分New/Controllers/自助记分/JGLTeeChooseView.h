//
//  JGLTeeChooseView.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLTeeChooseView : UIView


//tee台的视图
@property (strong, nonatomic) NSMutableArray* dataArray;

@property (copy, nonatomic) void (^blockTeeName)(NSString* );

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)array;


//-(id)initWithNumber:(NSMutableArray *)array;



//-(void)show;

@end
