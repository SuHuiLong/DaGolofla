//
//  JGLGuestAddressViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
/**
 *  嘉宾的通讯录
 */
#import "TKAddressModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface JGLGuestAddressViewController : ViewController<ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary* dictFinish;
@property (copy, nonatomic) void (^blockAddressPeople)(TKAddressModel* dict);
@property (assign, nonatomic) BOOL isGest;//判断是否是嘉宾，嘉宾不需要标记

@end
