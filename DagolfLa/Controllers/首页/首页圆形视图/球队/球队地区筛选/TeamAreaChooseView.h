//
//  TeamAreaChooseView.h
//  DagolfLa
//
//  Created by bhxx on 16/1/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface TeamAreaChooseView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property(nonatomic,copy)void(^blockArea)(NSString *, NSString*);
//@property(nonatomic,copy)void(^blockMoney)(NSString*, NSString*);
@end
