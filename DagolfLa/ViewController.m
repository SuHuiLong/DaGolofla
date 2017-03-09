//
//  ViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/10/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*******/
/*******/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//
//
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
}

-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:BDMAPLAT] != nil) {
        self.lat = [user objectForKey:BDMAPLAT];
    }
    else
    {
        _lat = @31.156063;
    }
    if ([user objectForKey:BDMAPLNG] != nil) {
        self.lng = [user objectForKey:BDMAPLNG];
    }
    else
    {
        _lng = @121.605072;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
