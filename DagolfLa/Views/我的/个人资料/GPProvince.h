

#import <Foundation/Foundation.h>

@interface GPProvince : NSObject
//城市数组
@property (nonatomic, strong) NSArray *cities;
//省，直辖市名
@property (nonatomic, strong) NSString *name;

+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
