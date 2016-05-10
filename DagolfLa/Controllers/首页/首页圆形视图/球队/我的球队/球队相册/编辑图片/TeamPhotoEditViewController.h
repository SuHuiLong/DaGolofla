//
//  TeamPhotoEditViewController.h
//  DagolfLa
//
//  Created by bhxx on 16/1/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface TeamPhotoEditViewController : ViewController

@property (strong, nonatomic) NSNumber * photoId;

@property (strong, nonatomic) NSMutableArray* arrayId;

@property (copy, nonatomic) void(^deleteBlock)(NSInteger index);

@property (strong, nonatomic) NSNumber* forrevent;

- (instancetype)initWithIndex:(NSInteger)index selectImages:(NSMutableArray *)selectImages;


@end
