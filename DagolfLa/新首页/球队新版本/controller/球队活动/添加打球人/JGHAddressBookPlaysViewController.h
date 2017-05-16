//
//  JGHAddressBookPlaysViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "TKAddressModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface JGHAddressBookPlaysViewController : ViewController<ABPeoplePickerNavigationControllerDelegate>

@property (copy, nonatomic) void (^blockAddressPeople)(TKAddressModel* dict);

@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

//@property (nonatomic, strong)NSMutableArray *userKeyArray;

@end
