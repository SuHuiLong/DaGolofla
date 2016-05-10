//
//  CityHighChooseView.h
//  DagolfLa
//
//  Created by bhxx on 15/10/28.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface CityHighChooseView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property(nonatomic,copy)void(^blockArea)(NSString *, NSString*,NSNumber*, NSNumber*);
//@property(nonatomic,copy)void(^blockMoney)(NSString*, NSString*);
@end
