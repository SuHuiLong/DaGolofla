//
//  JGDContactUpdata.h
//  DagolfLa
//
//  Created by 東 on 17/3/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^blockContact)(NSMutableArray* contactArray);

@interface JGDContactUpdata : NSObject

+ (void)contanctUpload:(blockContact)contact;

@end
