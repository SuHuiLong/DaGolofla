//
//  JKSlideViewController.h
//  sliderSegment
//
//  Created by shixiangyu on 15/10/11.
//

#import <UIKit/UIKit.h>
#import "JKSlideSwitchView.h"

#import "WXViewController.h"

@interface JKSlideViewController : UIViewController <JKSlideSwitchViewDelegate>

@property (nonatomic, strong) IBOutlet JKSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) WXViewController *vc;


@property(strong,nonatomic)UIButton *leftBtn;
@property(strong,nonatomic)UIButton *rightBtn;


@end
