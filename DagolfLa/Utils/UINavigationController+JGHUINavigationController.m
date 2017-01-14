//
//  UINavigationController+JGHUINavigationController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "UINavigationController+JGHUINavigationController.h"

@implementation UINavigationController (JGHUINavigationController)


- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
