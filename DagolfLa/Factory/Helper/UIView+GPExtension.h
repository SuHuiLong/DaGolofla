

#import <UIKit/UIKit.h>

@interface UIView (GPExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat y_height;
@property (nonatomic, assign) CGFloat x_width;

//自适应自身
-(void)sizeToFitSelf;
/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;
@end
