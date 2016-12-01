//
//  JGLAddressAddViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "TKAddressModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface JGLAddressAddViewController : ViewController<ABPeoplePickerNavigationControllerDelegate>
///通讯录添加好友
@property (copy, nonatomic) void (^blockAddressArray)(NSMutableArray* addressArray);

@property (strong, nonatomic) NSMutableArray* addressArray;

@property (assign, nonatomic) NSInteger lastIndex;

@end
