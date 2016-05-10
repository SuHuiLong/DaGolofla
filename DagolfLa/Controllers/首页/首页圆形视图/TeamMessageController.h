//
//  TeamMessageController.h
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface TeamMessageController : ViewController<ABPeoplePickerNavigationControllerDelegate>

@property (copy, nonatomic) NSMutableArray* dataArray, * telArray;

@end
