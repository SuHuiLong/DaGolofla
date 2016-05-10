//
//  BaseModel.h
//  CharmRiuJin
//
//  Created by bhxx on 24/6/18.
//  Copyright (c) 2024年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
//- (id)valueForUndefinedKey:(NSString *)key;
@end
