

#import "GPProvince.h"

@implementation GPProvince

+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    GPProvince *p = [[self alloc] init];
    
    [p setValuesForKeysWithDictionary:dict];
    
    return p;
}

@end
