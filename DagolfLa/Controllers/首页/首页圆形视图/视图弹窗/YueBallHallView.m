//
//  YueBallHallView.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/21.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "YueBallHallView.h"

// 首页
#import "ShouyeViewController.h"
#import "NewsDetailController.h"

#import "MineRewardViewController.h"
#import "YueMyBallViewController.h"
#import "MineTeamController.h"
#import "ManageForMeController.h"
@implementation YueBallHallView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code


}


// 直到需要时才调用
- (void)showString:(NSMutableArray *)arrString
{
    [self.firstPageButton setTitle:[arrString objectAtIndex:0] forState:UIControlStateNormal];
//    [self.messageButton setTitle:[arrString objectAtIndex:1] forState:UIControlStateNormal];
    [self.myYueBallButton setTitle:[arrString objectAtIndex:1] forState:UIControlStateNormal];

    
//    if ([[arrString objectAtIndex:2] isEqualToString:@"我的悬赏"]) {
//        self.isXuanSang = YES;
//    } else {
//        self.isXuanSang = NO;
//    }
    
}

- (void)showImage:(NSMutableArray *)arrImage
{
    self.firstPage.image = [UIImage imageNamed:[arrImage objectAtIndex:0]];
//    self.message.image = [UIImage imageNamed:[arrImage objectAtIndex:1]];
    self.myYueBall.image = [UIImage imageNamed:[arrImage objectAtIndex:1]];

}

- (IBAction)firstPageButtonClik:(id)sender {
    
    ShouyeViewController* shouVc = [[ShouyeViewController alloc]init];
    _blockFirstPage(shouVc);
    
}

- (IBAction)myYueBallButtonClick:(id)sender {
    

    if(_isXuanSang == 1) {
        YueMyBallViewController* shouVc = [[YueMyBallViewController alloc]init];
        _block(shouVc);
    }
    else if (_isXuanSang == 2) {
        MineRewardViewController *vc = [[MineRewardViewController alloc] init];
        _block(vc);
    }
    else if (_isXuanSang == 3)
    {
        MineTeamController *teamVc = [[MineTeamController alloc] init];
        _block(teamVc);
        
    }
    else
    {
        ManageForMeController* manVc= [[ManageForMeController alloc]init];
        _block(manVc);
        
    }
}
@end
