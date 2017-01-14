//
//  UITabBarController+JGHUITabBarController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "UITabBarController+JGHUITabBarController.h"

@implementation UITabBarController (JGHUITabBarController)


- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
