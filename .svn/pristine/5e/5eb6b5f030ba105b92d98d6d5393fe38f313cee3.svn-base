//
//  YueBallHallView.h
//  DagolfLa
//
//  Created by 张天宇 on 15/10/21.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface YueBallHallView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *firstPage;
@property (weak, nonatomic) IBOutlet UIButton *firstPageButton;
- (IBAction)firstPageButtonClik:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *myYueBall;
@property (weak, nonatomic) IBOutlet UIButton *myYueBallButton;
- (IBAction)myYueBallButtonClick:(id)sender;

- (void)showString:(NSMutableArray *)arrString;
- (void)showImage:(NSMutableArray *)arrImage;


@property (assign, nonatomic) NSInteger isXuanSang;
@property (copy, nonatomic)void(^blockFirstPage)(ViewController *);
@property (copy, nonatomic)void(^block)(ViewController *);

@end
