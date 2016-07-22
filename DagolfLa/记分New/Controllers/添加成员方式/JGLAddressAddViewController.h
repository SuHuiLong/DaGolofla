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

@property (copy, nonatomic) void (^blockAddressPeople)(NSMutableDictionary* dict);

@property (copy, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@end
