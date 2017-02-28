//
//  JGHRecomStadiumView.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHRecomStadiumView : UIView

@property (nonatomic, strong)UIImageView *activityImageView;
@property (nonatomic ,strong)UILabel *name;
@property (nonatomic ,strong)UILabel *price;

- (void)configJGHRecomStadiumView:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH;

@end
