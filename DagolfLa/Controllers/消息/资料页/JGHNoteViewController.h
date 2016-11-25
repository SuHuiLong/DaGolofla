//
//  JGHNoteViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHNoteViewController : ViewController

typedef void(^BlockRereshNote)(NSString *);
@property(nonatomic,copy)BlockRereshNote blockRereshNote;

@property (nonatomic, retain)NSNumber *friendUserKey;

@end
