//
//  TeamInviteViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamInviteViewController.h"
#import "LazyPageScrollView.h"

#import "TeamInviteTableViewCell.h"
#import "TeamMessageController.h"
#import "AddressBookViewCell.h"
#import "TKAddressModel.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "PostDataRequest.h"

#import "FriendModel.h"

@interface TeamInviteViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    //    UITableView* tableView;
    UITableView* _tableView;
    UITableView* _tableViewNear;
    
    NSMutableArray *addressBookTemp;
    NSMutableArray *_selectedAddressBookTempArr;
    
    //第一个表中获取的数据，好友
    NSMutableArray* _dataFriendArray;
    
    //第二个表中获取的数据，附近
    NSMutableArray* _dataNearByArray;
    
    //存第一个列表的indexPath
    NSMutableArray *_array1;
    NSMutableDictionary *_dict1;
    //存第二个列表的indexPath
    NSMutableArray *_array2;
    NSMutableDictionary *_dict2;
    //存第三个列表的indexPath
    NSMutableArray *_array3;
    NSMutableDictionary *_dict3;
    
    NSMutableDictionary *_dict4;
    
    NSInteger _page;
    NSInteger _pageNear;
}
@end

@implementation TeamInviteViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    
    _page = 1;
    _pageNear = 1;
    _dataFriendArray = [[NSMutableArray alloc]init];
    _dataNearByArray = [[NSMutableArray alloc]init];
    
    _array1 = [[NSMutableArray alloc] init];
    _array2 = [[NSMutableArray alloc] init];
    _array3 = [[NSMutableArray alloc] init];
    _dict1  = [[NSMutableDictionary alloc] init];
    _dict2  = [[NSMutableDictionary alloc] init];
    _dict3  = [[NSMutableDictionary alloc] init];
    _dict4  = [[NSMutableDictionary alloc]init];
    addressBookTemp = [NSMutableArray array];
    _selectedAddressBookTempArr = [NSMutableArray array];
    
    
    if (_arrayIndex.count != 0) {
        NSArray* array1 = _arrayIndex[0];
        for (int i = 0; i < array1.count; i++) {
            [_dict1 setObject:[_arrayData[0] objectAtIndex:i] forKey:array1[i]];
        }
        
        NSArray* array2 = _arrayIndex[1];
        for (int i = 0; i < array2.count; i++) {
            [_dict2 setObject:[_arrayData[1] objectAtIndex:i] forKey:array2[i]];
        }
        
        NSArray* array3 = _arrayIndex[2];
        for (int i = 0; i < array3.count; i++) {
            [_dict3 setObject:[_arrayData[2] objectAtIndex:i] forKey:array3[i]];
        }
        
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createAddress];
    
    [self createPageView];
}
-(void)barButtonPressed
{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    //    if (_dict1.count != 0 || _dict2.count != 0) {
    [arr1 addObject:[_dict1 allKeys]];
    [arr1 addObject:[_dict2 allKeys]];
    [arr1 addObject:[_dict3 allKeys]];
    
    [arr2 addObject:[_dict1 allValues]];
    [arr2 addObject:[_dict2 allValues]];
    [arr2 addObject:[_dict3 allValues]];
    [arr3 addObject:[_dict4 allValues]];

    _block(arr1,arr2,arr3);
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createAddress
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressModel *addressBook = [[TKAddressModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.isSelectNumber = 0;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookTemp addObject:addressBook];
        
        
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if (addressBookTemp.count != 0) {
        TKAddressModel *addressBook = addressBookTemp[0];
        addressBook.isSelectNumber=1;
    }
    
    
    
    
    
}

-(void)createPageView
{
    _titleArray = @[@"我的球友",@"附近好友",@"通讯录"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:50 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    _tableView=[[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[0] View:_tableView];
    _tableView.tag = 100;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   [_tableView registerNib:[UINib nibWithNibName:@"TeamInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeamInviteTableViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLeftRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLeftRereshing)];
    [_tableView.header beginRefreshing];
    
    
    
  
    _tableViewNear=[[UITableView alloc] init];
    _tableViewNear.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[1] View:_tableViewNear];
    _tableViewNear.tag = 101;
    _tableViewNear.delegate = self;
    _tableViewNear.dataSource = self;
    
    [_tableViewNear registerNib:[UINib nibWithNibName:@"TeamInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeamInviteTableViewCell"];
    
    UITableView* tableView3 = [[UITableView alloc] init];
    tableView3.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[2] View:tableView3];
    tableView3.tag = 102;
    tableView3.delegate = self;
    tableView3.dataSource = self;
    
    [tableView3 registerNib:[UINib nibWithNibName:@"AddressBookViewCell" bundle:nil] forCellReuseIdentifier:@"AddressBookViewCell"];
    
    
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:20*ScreenWidth/375];
    //选中后的样式
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15] Color:[UIColor blackColor] SelColor:[UIColor greenColor]];
    //分割线的样式
    [_pageView enableBreakLine:YES Width:1 TopMargin:5 BottomMargin:5 Color:[UIColor lightGrayColor]];
    //滑动视图到最左边和最右边的距离
    _pageView.leftTopView=0;
    _pageView.rightTopView=0;
    //    UIView* leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    //    leftView.backgroundColor=[UIColor blackColor];
    
    //    UIView* rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    //    rightView.backgroundColor=[UIColor purpleColor];
    //_pageView.rightTopView=rightView;
    
    // 生成LazyPageScrollView，需要设置完相关属性后调用该函数生成
    [_pageView generate];
    UIView *topView=[_pageView getTopContentView];
    UILabel *lb=[[UILabel alloc] init];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    lb.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:lb];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //_pageView.selectedIndex=4;
    });
    
}

#pragma mark 开始进入刷新状态
- (void)headerLeftRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerLeftRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querybyList.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataFriendArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                FriendModel *model = [[FriendModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataFriendArray addObject:model];
            }
            _page ++;
            [_tableView reloadData];
        }else {
            if (page == 1)[_dataFriendArray removeAllObjects];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}


-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    if (index == 0) {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLeftRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLeftRereshing)];
        [_tableView.header beginRefreshing];

    }
    else if (index == 1)
    {
        [_tableViewNear.header endRefreshing];
        _tableViewNear.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerNearRereshing)];
        [_tableViewNear.header beginRefreshing];
        
    }
    else
    {
        ////NSLog(@"3");
    }
}

#pragma mark 开始进入刷新状态
- (void)headerNearRereshing
{
    _pageNear = 1;
    [self downLoadNearData:_pageNear isReshing:YES];
}

- (void)footerNearRereshing
{
    [self downLoadNearData:_pageNear isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadNearData:(int)page isReshing:(BOOL)isReshing{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *lat = [user objectForKey:@"lat"];
    NSNumber *lng = [user objectForKey:@"lng"];
//    //NSLog(@"%@   %@",lat,lng);
    if (lat != nil && lng != nil) {
        [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/queryNearbyUser.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"xIndex":lat,@"yIndex":lng,@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //        ////NSLog(@"%@",dict);
            if ([[dict objectForKey:@"success"] boolValue]) {
                if (page == 1)[_dataNearByArray removeAllObjects];
                for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                    ////NSLog(@"%@",dataDict);
                    FriendModel *model = [[FriendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [_dataNearByArray addObject:model];
                }
                _pageNear++;
                [_tableViewNear reloadData];
            }else {
                if (page == 1)[_dataNearByArray removeAllObjects];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            if (isReshing) {
                [_tableViewNear.header endRefreshing];
            }else {
                [_tableViewNear.footer endRefreshing];
            }
        } failed:^(NSError *error) {
            if (isReshing) {
                [_tableViewNear.header endRefreshing];
            }else {
                [_tableViewNear.footer endRefreshing];
            }
        }];

        
    }else{
        [Helper alertViewNoHaveCancleWithTitle:@"请打开手机定位功能!" withBlock:^(UIAlertController *alertView) {
            
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
        
        if (isReshing) {
            [_tableViewNear.header endRefreshing];
        }else {
            [_tableViewNear.footer endRefreshing];
        }

    }
    
    
  
    
 }



-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
//    if(bLeft)
//    {
//        ////NSLog(@"left");
//    }
//    else
//    {
//        ////NSLog(@"right");
//    }
}

#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag != 102 ? 65*ScreenWidth/320 : 50*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 102) {
        return [addressBookTemp count];
    } else if (tableView.tag == 101) {
        return _dataNearByArray.count;
    }else {
        return _dataFriendArray.count;
    }
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 102) {
        AddressBookViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookViewCell" forIndexPath:indexPath];
        TKAddressModel *book = [addressBookTemp objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = book.name;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.phoneLabel.text = book.tel;
        NSString *str0=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSString *str=[_dict3 objectForKey:str0];
        
        if ([Helper isBlankString:str]==NO) {
            cell.chooseImage.image=[UIImage imageNamed:@"gou_x"];
        }else{
            cell.chooseImage.image=[UIImage imageNamed:@"gou_w"];
        }
        return cell;
    } else if (tableView.tag == 101) {
        TeamInviteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamInviteTableViewCell" forIndexPath:indexPath];
        [cell showFriendData:_dataNearByArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str0=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        FriendModel *str=[_dict2 objectForKey:str0];
        if ([str isKindOfClass:[FriendModel class]]) {
            cell.chooseImage.image=[UIImage imageNamed:@"gou_x"];
        }else{
            cell.chooseImage.image=[UIImage imageNamed:@"gou_w"];
        }

        return cell;
    } else {
        TeamInviteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamInviteTableViewCell" forIndexPath:indexPath];
        [cell showFriendData:_dataFriendArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str0=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        FriendModel *str=[_dict1 objectForKey:str0];
        if ([str isKindOfClass:[FriendModel class]]) {
            cell.chooseImage.image=[UIImage imageNamed:@"gou_x"];
        }else{
            cell.chooseImage.image=[UIImage imageNamed:@"gou_w"];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 100:{
            FriendModel *str=[_dict1 objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if (![str isKindOfClass:[FriendModel class]]) {
//                [_dict1 setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [_dict1 setObject:_dataFriendArray[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }else{
                [_dict1 removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            [tableView reloadData];
        }
            break;
        case 101:{
            FriendModel *str=[_dict2 objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if (![str isKindOfClass:[FriendModel class]]) {
                //                [_dict1 setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [_dict2 setObject:_dataNearByArray[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }else{
                [_dict2 removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            [tableView reloadData];
        }
            break;
        case 102:{
            NSString *str=[_dict3 objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if ([Helper isBlankString:str]==YES) {
                [_dict3 setObject:[addressBookTemp[indexPath.row] name] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [_dict4 setObject:[addressBookTemp[indexPath.row] tel] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                
            }else{
                [_dict3 removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [_dict4 removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            [tableView reloadData];
        }
        default:{
            
        }
            break;
    }
    
    
}

@end
