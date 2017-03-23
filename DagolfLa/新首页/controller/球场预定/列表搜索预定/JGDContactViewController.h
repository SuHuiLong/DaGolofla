//
//  JGDContactViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "TKAddressModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface JGDContactViewController : ViewController<ABPeoplePickerNavigationControllerDelegate>


@property (copy, nonatomic) void (^blockAddressUserName)(NSString* userName);

@property (strong, nonatomic) NSMutableArray* addressArray;

@property (assign, nonatomic) NSInteger lastIndex;

@end
