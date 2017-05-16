//
//  MakePhotoTextAddTextViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ AddText)(NSString *textStr);
@interface MakePhotoTextAddTextViewController : BaseViewController
//球队名
@property(nonatomic, copy)NSString *teamName;
//默认填充文字
@property(nonatomic, copy)NSString *DefaultText;
//block
@property(nonatomic, copy)AddText addText;

-(void)setAddTextBlock:(AddText)AddText;
@end
