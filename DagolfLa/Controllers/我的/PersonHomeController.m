//
//  PersonHomeController.m
//  DagolfLa
//
//  Created by Soldoroos on 16/4/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "PersonHomeController.h"

#import "Helper.h"
#import "UIView+Extension.h"
#import "LazyPageScrollView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UIView+ChangeFrame.h"
#import "OtherDataTableViewCell.h"
#import "PostDataRequest.h"
#import "OtherDataModel.h"
#import "DeatilModel.h"

#import "SelfDataViewController.h"
#import "ChatDetailViewController.h"
#import "ChatDetailViewController.h"
#import "AddFootViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"

#import "OtherDataModel.h"
#import "MeselfModel.h"
#import "OtherDataTableViewCell.h"

#import <BaiduMapAPI/BMapKit.h>
#import "UIView+ChangeFrame.h"

#import "ShowMapViewViewController.h"
#import "MyfootModel.h"
#import "PicArrShowViewControllerViewController.h"

#import "MBProgressHUD.h"

#import "SelfViewController.h"
#import "DetailViewController.h"

#import "NoteHandlle.h"
#import "NoteModel.h"
#import "AddNoteViewController.h"
#import "SXPickPhoto.h"


static NSString *const orderDetailCellIdentifier = @"OtherDataTableViewCell";


#define kqueryIDs_URL @"user/queryByIds.do"

@interface PersonHomeController () <LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIScrollView * _mainScrollView;
    LazyPageScrollView* _pageView;
    UIImageView *_profileView;
    UITableView* _tableView;
    UIButton *_changePic;
    MeselfModel *_model;
    DeatilModel *_deatilModel;
    UIImageView *_backImg;
    UIImageView *_iconImg;
    UILabel *_nameLabel;
    UIImageView *_sexImg;
    UILabel * _infoLabel;
    
    NSMutableArray *_dataArray;
    
    CGFloat _tabY;
    
    BOOL _isFollow;
    BMKMapView* _mapView;
    // 相片的数据源
    NSMutableArray *_picArr;
    
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@end

@implementation PersonHomeController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    //发出通知隐藏标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    NoteModel *model = [NoteHandlle selectNoteWithUID:self.strMoodId];
    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        _nameLabel.text = _model.userName;
        self.title = _model.userName;
    }else{
        _nameLabel.text = model.userremarks;
        self.title = model.userremarks;
    }
    [_mapView viewWillAppear];

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"00" forKey:@"data"];
    _pickPhoto = [[SXPickPhoto alloc]init];
    _dataArray = [NSMutableArray array];
    [self detailPostData];
    
    [self creatScrollView];
    [self gerenPostData];
    

}

-(void)creatScrollView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mainScrollView.showsHorizontalScrollIndicator = YES;
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    //顶部背景图片
    _backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 238*ScreenWidth/375)];
    _backImg.backgroundColor = [UIColor whiteColor];
    _backImg.userInteractionEnabled = YES;
    [_mainScrollView addSubview:_backImg];
    
    
    if ([_strMoodId integerValue] == [DEFAULF_USERID integerValue]) {
        //点击更换图片
        _changePic = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changePic setFrame:CGRectMake(_backImg.frame.size.width-110*ScreenWidth/375, _backImg.y + 20*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375)];
        _changePic.tag = 10000;
        _changePic.layer.cornerRadius = 8*ScreenWidth/375;
        _changePic.layer.masksToBounds = YES;
        _changePic.backgroundColor = [UIColor blackColor];
        _changePic.alpha = 0.2;
        [_backImg addSubview:_changePic];
        [_changePic setTitle:@"点击更换图片" forState:UIControlStateNormal];
        [_changePic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changePic.titleLabel.font = [UIFont systemFontOfSize:12*ScreenWidth/375];
        [_changePic addTarget:self action:@selector(usePhonePhotoAndCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    //    [_mainScrollView sendSubviewToBack:_backImg];
    
    
    _profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _backImg.height-90*ScreenWidth/375, ScreenWidth, 90*ScreenWidth/375)];
    _profileView.backgroundColor = [UIColor clearColor];
    [_profileView setImage:[UIImage imageNamed:@"gerenback"]];
    _profileView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:_profileView];
    
    _mainScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + _profileView.y+_profileView.height-49*ScreenWidth/375);
    
    //头像
    _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
    _iconImg.backgroundColor = [UIColor purpleColor];
    _iconImg.layer.cornerRadius = _iconImg.frame.size.height/2;
    [_iconImg.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_iconImg.layer setBorderWidth:1.0];
    _iconImg.clipsToBounds = YES;
    
    _iconImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageIconACt)];
    [_iconImg addGestureRecognizer:tap];
    [_profileView addSubview:_iconImg];
    
    //用户名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImg.x +_iconImg.width +23*ScreenWidth/375, _iconImg.y +10*ScreenWidth/375, (ScreenWidth - _iconImg.x - _iconImg.width - 15*ScreenWidth/375), 30*ScreenWidth/375)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17*ScreenWidth/375];
    [_profileView addSubview:_nameLabel];
    
    //性别
    _sexImg = [[UIImageView alloc]initWithFrame:CGRectMake(_iconImg.x +_iconImg.width +3*ScreenWidth/375,_nameLabel.y+_nameLabel.height+5*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    _sexImg.backgroundColor = [UIColor clearColor];
    [_profileView addSubview:_sexImg];
    
    //年龄-差点
    _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sexImg.x+_sexImg.width+5*ScreenWidth/375,_nameLabel.y+_nameLabel.height+5*ScreenWidth/375,120*ScreenWidth/375, 20*ScreenWidth/375)];
    _infoLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.backgroundColor = [UIColor clearColor];
    [_profileView addSubview:_infoLabel];
    
    NSLog(@"%@",DEFAULF_USERID);
    
    if ([self.strMoodId integerValue] == [DEFAULF_USERID integerValue]) {
        //当前用户个人主页
        
        UIButton* btnSet = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置button边框
        CALayer *buttonLayer = [btnSet layer];
        [buttonLayer setBorderColor:[UIColor whiteColor].CGColor];
        [buttonLayer setBorderWidth:1];
        btnSet.frame = CGRectMake(ScreenWidth - 110*ScreenWidth/375, _infoLabel.y-5*ScreenWidth/375,100*ScreenWidth/375, 30*ScreenWidth/375);
        [btnSet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSet.layer.cornerRadius = 10;
        btnSet.layer.masksToBounds = YES;
        [btnSet setTitle: @"编辑个人资料" forState:UIControlStateNormal];
        [btnSet setTitleEdgeInsets:UIEdgeInsetsMake(0, 5*ScreenWidth/375, 0, 0)];
        [btnSet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSet.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        btnSet.contentHorizontalAlignment = NSTextAlignmentCenter;
        [btnSet addTarget:self action:@selector(gerenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_profileView addSubview:btnSet];
        
    }else{
        //不是当前用户个人主页
        for (int i = 0; i < 2; i++) {
            UIButton* btnSet = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置button边框
            CALayer *buttonLayer = [btnSet layer];
            [buttonLayer setBorderColor:[UIColor whiteColor].CGColor];
            [buttonLayer setBorderWidth:1];
            btnSet.tag = 100 + i;
            
            btnSet.frame = CGRectMake(_infoLabel.x + _infoLabel.width+3*ScreenWidth/375+ ((ScreenWidth -_infoLabel.x -_infoLabel.width - 15*ScreenWidth/375)/2 + 2)*i, _infoLabel.y-5,(ScreenWidth -_infoLabel.x -_infoLabel.width - 15*ScreenWidth/375)/2, 30*ScreenWidth/375);
            [btnSet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnSet.layer.cornerRadius = 10;
            btnSet.layer.masksToBounds = YES;
            [_profileView addSubview:btnSet];
            
            switch (i) {
                case 0:{
                    
                    [btnSet setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
                    [btnSet setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    [btnSet setTitle: @"私信" forState:UIControlStateNormal];
                    [btnSet setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    [btnSet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btnSet.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    btnSet.contentHorizontalAlignment = NSTextAlignmentCenter;
                    [btnSet addTarget:self action:@selector(sixingClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                case 1:{
                    if ([_model.followState integerValue]== 0) {
                        [btnSet setTitle:@"关注" forState:UIControlStateNormal];
                        _isFollow = YES;
                    }else{
                        [btnSet setTitle:@"已关注" forState:UIControlStateNormal];
                        _isFollow = NO;
                    }
                    
                    btnSet.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [btnSet addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}


-(void)createPageView
{
    NSArray* titleArray = @[@"动态",@"足迹"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0,_profileView.y+_profileView.height, ScreenWidth, ScreenHeight-65)];
    _pageView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_pageView];
    
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:40*ScreenWidth/375 TabHeight:40*ScreenWidth/375 VerticalDistance:10*ScreenWidth/375 BkColor:[UIColor whiteColor]];
    
    for (int i = 0; i < 2; i++) {
        
        if (i == 0) {
            _tableView=[[UITableView alloc] init];
            _tableView.backgroundColor = [UIColor whiteColor];
            [_pageView addTab:titleArray[i] View:_tableView];
            _tableView.tag = 100+i;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.scrollEnabled = NO;
            _tableView.separatorStyle = NO;
            
            [_tableView registerNib:[UINib nibWithNibName:@"OtherDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherDataTableViewCell"];
        }
        else
        {
            //            UIView *mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            //            mapView.backgroundColor = [UIColor brownColor];
            
            //            if (_mapView) {
            [self createAddFoot];
            //            }
            
        }
        
    }
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:80*ScreenWidth/375];
    //选中后的样式
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15*ScreenWidth/375] Color:[UIColor blackColor] SelColor:[UIColor greenColor]];
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
    lb.backgroundColor=[UIColor whiteColor];
    [topView addSubview:lb];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _pageView.selectedIndex = _selectedIndex;
    });

}




-(void)gerenPostData {
    //自己
    if ([DEFAULF_USERID integerValue] == [_strMoodId integerValue]) {
        NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
        [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
        NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
        [dictUser setObject:strMD forKey:@"md5"];
        
        [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] boolValue]) {
                _model = [[MeselfModel alloc] init];
                [_model setValuesForKeysWithDictionary:[data objectForKey:@"user"]];
                
                self.title = _model.userName;
                
                NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%td_background.jpg",[_strMoodId integerValue]];
                [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
                [_backImg sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
                
                NSString *iconUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[_strMoodId integerValue]];
                [[SDImageCache sharedImageCache] removeImageForKey:iconUrl fromDisk:YES];
                [_iconImg sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                
                //替换备注名称
                NoteModel *model = [NoteHandlle selectNoteWithUID:self.strMoodId];
                if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                    _nameLabel.text = _model.userName;
                }else{
                    _nameLabel.text = model.userremarks;
                }
                
                if ([_model.sex integerValue] == 0) {
                    _sexImg.image = [UIImage imageNamed:@"xb_n"];
                }else{
                    _sexImg.image = [UIImage imageNamed:@"xb_nn"];
                }
                if (_model.age != nil && _model.almost != nil) {
                    _infoLabel.text = [NSString stringWithFormat:@"%@岁  差点:%@",_model.age,_model.almost];
                }
                else if (_model.age == nil && _model.almost != nil)
                {
                    _infoLabel.text = [NSString stringWithFormat:@"暂无年龄  差点:%@",_model.almost];
                }
                else if (_model.almost == nil && _model.age != nil)
                {
                    _infoLabel.text = [NSString stringWithFormat:@"%@岁  暂无差点",_model.age];
                }
                else{
                    _infoLabel.text = [NSString stringWithFormat:@"暂无年龄  暂无差点"];

                }
                // 相片的数据请求
                [self inquirePicSource];
                //分割线
            }else {
                [LQProgressHud showMessage:[data objectForKey:@"message"]];
            }
        }];
    }
    else{
        [[PostDataRequest sharedInstance] postDataRequest:kqueryIDs_URL parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":_strMoodId} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",[dict objectForKey:@"rows"]);
            if ([[dict objectForKey:@"success"] boolValue]) {
                _model = [[MeselfModel alloc] init];
                [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                
                self.title = _model.userName;
                
                NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%td_background.jpg",[_strMoodId integerValue]];
                [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
                [_backImg sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
                
                NSString *iconUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[_strMoodId integerValue]];
                [[SDImageCache sharedImageCache] removeImageForKey:iconUrl fromDisk:YES];
                [_iconImg sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                
                
                
                //替换备注名称
                NoteModel *model = [NoteHandlle selectNoteWithUID:self.strMoodId];
                if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                    _nameLabel.text = _model.userName;
                }else{
                    _nameLabel.text = model.userremarks;
                }
                
                if ([_model.sex integerValue] == 0) {
                    _sexImg.image = [UIImage imageNamed:@"xb_n"];
                }else{
                    _sexImg.image = [UIImage imageNamed:@"xb_nn"];
                }
                _infoLabel.text = [NSString stringWithFormat:@"%@岁  差点:%@",_model.age,_model.almost];
                
                // 相片的数据请求
                [self inquirePicSource];
                //分割线
            }else {
                [LQProgressHud showMessage:[dict objectForKey:@"message"]];
            }
        } failed:^(NSError *error) {
        }];
    }
    
}

-(void)detailPostData {
    [[PostDataRequest sharedInstance] postDataRequest:@"userMood/getUserMood.do" parameter:@{@"userId":_strMoodId, @"page":@1,@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@">>>>>>>>>>%@",[dict objectForKey:@"rows"]);
        if ([[dict objectForKey:@"success"] boolValue]) {
            //NSLog(@"chenggong");
            
            [_dataArray removeAllObjects];
            
            for (NSDictionary *deatilDic in [dict objectForKey:@"rows"]) {
                _deatilModel = [[DeatilModel alloc]init];
                
                //提取照片
                NSArray * deatArr = [deatilDic objectForKey:@"images"];
                if (deatArr.count) {
                    _deatilModel.picUrl = [[deatilDic objectForKey:@"images"][0] objectForKey:@"path"];
                    //NSLog(@"%@",_deatilModel.picUrl);
                }else{
                    _deatilModel.picUrl = nil;
                }
 
                [_deatilModel setValuesForKeysWithDictionary:deatilDic];
                [_dataArray addObject:_deatilModel];
            }
        }else {
            
        }
        
        [self createPageView];

    } failed:^(NSError *error) {
    }];
}



- (void)inquirePicSource
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@1 forKey:@"page"];
    [dict setObject:@5 forKey:@"rows"];
    
    [dict setObject:_strMoodId forKey:@"userId"];
    if (self.lng) {
        [dict setObject:self.lng forKey:@"yIndex"];
    }else{
        [dict setObject:@31.2 forKey:@"yIndex"];
    }
    if (self.lat) {
        [dict setObject:self.lat forKey:@"xIndex"];
    }else{
        [dict setObject:@121.4 forKey:@"xIndex"];
    }
    [dict setObject:@-1 forKey:@"searchState"];
    [dict setObject:@1 forKey:@"moodType"];

    [[PostDataRequest sharedInstance] postDataRequest:@"userMood/queryPage.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        _picArr = [NSMutableArray array];
        if ([[dict objectForKey:@"success"]boolValue]) {
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                MyfootModel *model = [[MyfootModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_picArr addObject:model];
            }
            for (MyfootModel *pic in _picArr) {
                for (NSString *picStr in pic.pics) {
                    if (![Helper isBlankString:picStr]) {
                        //                        [_postPicArr addObject:picStr];
                    }
                }
            }
            _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
            //添加标注 一定要和代理写在一起
            [self addPointAnnotation:_picArr.count];
            //            [self createHeaderView];
        }else {
            _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
            //添加标注 一定要和代理写在一起
            [self addPointAnnotation:_picArr.count];
            [_picArr addObject:@""];
            //            [self createHeaderView];
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
    }];
    
}



-(void)gerenClick:(UIButton *)btn{
    
    SelfViewController* scVc = [[SelfViewController alloc]init];
    scVc.userModel = _model;
    
    scVc.blockRereshingMe = ^(NSArray* arrayData){

        _nameLabel.text = _model.userName;
        
        if (_model.age != nil) {
            _infoLabel.text = [NSString stringWithFormat:@"%@岁  差点:%@",_model.age,_model.almost];
        }
        _sexImg.image = [UIImage imageNamed:@""];
        if ([_model.sex integerValue] == 0) {
            
            _sexImg.image = [UIImage imageNamed:@"xb_n"];
        }else{
            _sexImg.image = [UIImage imageNamed:@"xb_nn"];
        }
        
        if (arrayData.count != 0) {
            _iconImg.image = [UIImage imageWithData:arrayData[0]];
        }
        [_tableView reloadData];
    };
    
    [self.navigationController pushViewController:scVc animated:YES];
}


-(void)createAddFoot
{
    
    UIView* viewBase = [[UIView alloc]init];
    viewBase.backgroundColor = [UIColor blackColor];
    //    [_pageView addTab:_titleArray[1] View:viewBase];
    [_pageView addTab:@"足迹" View:viewBase];
    
    
    _mapView = [[BMKMapView alloc] init];
    _mapView.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight-65);
    [viewBase addSubview:_mapView];
    
    //地图
    UIButton* btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMap.frame = CGRectMake(0, 30*ScreenWidth / 375,ScreenWidth, ScreenHeight-475*ScreenWidth/375);
    [viewBase addSubview:btnMap];
    [btnMap addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* viewFabu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    viewFabu.tag = 1988;
    viewFabu.backgroundColor = [UIColor lightGrayColor];
    [viewBase addSubview:viewFabu];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewFabu.frame.size.width, viewFabu.frame.size.height);
    [viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(addFootClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 3*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(addFootClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];
    [btnText setTitle:@"添加足迹" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(addFootClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 8*ScreenWidth/375, 10*ScreenWidth/375, 14*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
    if ([self.strMoodId integerValue] == [DEFAULF_USERID integerValue]) {
        
    }else{
        //不是当前用户  禁止发布足迹
        
        [viewFabu removeFromSuperview];
    }
}
-(void)mapClick
{
    if (_picArr.count != 0) {
        if (_picArr[0] != nil) {
            ShowMapViewViewController *vc = [[ShowMapViewViewController alloc] init];
            //NSLog(@"%@",_picArr);
            NSMutableArray* mapArr = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < _picArr.count; i++) {
                if (![[NSString stringWithFormat:@"%@",_picArr[i]] isEqualToString:@""]) {
                    [mapArr addObject:_picArr[i]];
                }
            }
            vc.mapCLLocationCoordinate2DArr = mapArr;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        //    if (![[_picArr firstObject] isEqualToString:@""]) {
        
        //    }
    }
}



//添加标注并设置地图
- (void)addPointAnnotation:(NSInteger)annotationNumber
{
    // 移除所有的标注
    [_mapView removeAnnotations:_mapView.annotations];
    // 双击和单击，移动，旋转
    _mapView.zoomEnabled = NO;
    _mapView.zoomEnabledWithTap = NO;
    _mapView.scrollEnabled = NO;
    _mapView.overlookEnabled = NO;
    _mapView.rotateEnabled = NO;
    
    if (_picArr.count == 0) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        
        if (self.lat) {
            coor.latitude = [self.lat doubleValue];
            
        }else{
            coor.latitude = 31.2;
            
        }
        
        if (self.lng) {
            coor.longitude = [self.lng doubleValue];
            
        }else{
            coor.longitude = 121.4;
            
        }
        
        
        
        annotation.coordinate = coor;
        annotation.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位"];
        [_mapView addAnnotation:annotation];
        
        // 设定屏幕的可见范围， 根据所有的标注来设定的
        
        
        CGFloat minlatitude = 0.0;
        CGFloat maxlatitude = 0.0;
        CGFloat minlongitude = 0.0;
        CGFloat maxlongitude = 0.0;
        
        if (minlatitude < coor.latitude ) {
            minlatitude = coor.latitude;
        }
        if (maxlatitude < coor.latitude ) {
            maxlatitude = coor.latitude;
        }
        if (minlongitude < coor.longitude ) {
            minlongitude = coor.longitude;
        }
        if (maxlongitude < coor.longitude ) {
            maxlongitude = coor.longitude;
        }
        
        CLLocationCoordinate2D coord;
        coord.latitude = (minlatitude + maxlatitude )/2 ;
        coord.longitude = (minlongitude + maxlongitude)/2;
        BMKCoordinateSpan co;
        co.latitudeDelta = maxlatitude - coord.latitude + 1.000;
        co.longitudeDelta = maxlongitude - coord.longitude + 1.0000;
        BMKCoordinateRegion region;
        region.center = coord;
        region.span = co;
        [_mapView setRegion:region animated:YES];
        
    } else {
        
        CGFloat minlatitude = 0.0;
        CGFloat maxlatitude = 0.0;
        CGFloat minlongitude = 0.0;
        CGFloat maxlongitude = 0.0;
        
        for (int i = 0; i < _picArr.count; i++) {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [[_picArr[i] xIndex] doubleValue];
            coor.longitude = [[_picArr[i] yIndex] doubleValue];
            annotation.coordinate = coor;
            annotation.title = [_picArr[i] golfName];
            [_mapView addAnnotation:annotation];
            
            
            if (minlatitude < coor.latitude ) {
                minlatitude = coor.latitude;
            }
            if (maxlatitude < coor.latitude ) {
                maxlatitude = coor.latitude;
            }
            if (minlongitude < coor.longitude ) {
                minlongitude = coor.longitude;
            }
            if (maxlongitude < coor.longitude ) {
                maxlongitude = coor.longitude;
            }
        }
        
        
        
        
        // 设定屏幕的可见范围， 根据所有的标注来设定的
        CLLocationCoordinate2D coord;
        coord.latitude = (minlatitude + maxlatitude )/2 ;
        coord.longitude = (minlongitude + maxlongitude)/2;
        BMKCoordinateSpan co;
        co.latitudeDelta = maxlatitude - coord.latitude + 1.000;
        co.longitudeDelta = maxlongitude - coord.longitude + 1.0000;
        BMKCoordinateRegion region;
        region.center = coord;
        region.span = co;
        [_mapView setRegion:region animated:YES];
    }
    
    
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    
    
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        // 设置颜色
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        // 设置可拖拽
        newAnnotationView.draggable = YES;
        return newAnnotationView;
    }
    return nil;
}

//气泡弹窗点击
//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
//{
//    ////NSLog(@"%@", view.annotation.title);
//
//
//}


- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
}


-(void)addFootClick
{
    AddFootViewController* addVc = [[AddFootViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            NSMutableArray* arrayData = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:arrayData withImage:(UIImage *)Data];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            NSMutableArray* arrayData = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [self imageArray:arrayData withImage:(UIImage *)Data];
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}


#pragma mark --上传图片方法
-(void)imageArray:(NSMutableArray *)array withImage:(UIImage *)image
{
    NSString* strTimeKey = [NSString stringWithFormat:@"%@_background",DEFAULF_USERID];
    // 上传图片
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strTimeKey forKey:@"data"];
    [dict setObject:TYPE_USER_HEAD forKey:@"nType"];
    [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
    
    [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {
    } completionBlock:^(id data) {
//        NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/user/head/%td_background.jpg",[_strMoodId integerValue]];
//        [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
//        [_backImg sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
        [_backImg setImage:image];
    }];
}


-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    //////NSLog(@"%ld %ld",preIndex,index);
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        // ////NSLog(@"left");
    }
    else
    {
        //////NSLog(@"right");
    }
}
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        static OtherDataTableViewCell *cell;
        if (!cell) {
            cell = [_tableView dequeueReusableCellWithIdentifier:@"OtherDataTableViewCell"];
        }
        DeatilModel *deatModel = [_dataArray objectAtIndex:indexPath.row];
        
        cell.contentLabel.text = deatModel.moodContent;
        
        
        if (deatModel.picUrl) {
            
            return 160*ScreenWidth/375;
            
        }else{
            //        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
            
            CGFloat labelHeigh = [deatModel.moodContent boundingRectWithSize:CGSizeMake(ScreenWidth - 25*ScreenWidth/375, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15*ScreenWidth/375]} context:nil].size.height;
            //NSLog(@"%f",labelHeigh);
            return labelHeigh+80*ScreenWidth/375;
            
        }
        
        
    }else{
        return 160*ScreenWidth/375;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OtherDataTableViewCell * cell = (OtherDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OtherDataTableViewCell"];
    if (_dataArray.count) {
        [cell setDeatilModel:_dataArray[indexPath.row]];
    }else{
        cell.tuoYuan.hidden = YES;
        cell.picView.hidden = YES;
        cell.dateLabel.hidden = YES;
        cell.zanLabel.hidden = YES;
        cell.pingLabel.hidden = YES;
        cell.fenLabel.hidden = YES;
        cell.zanImage.hidden = YES;
        cell.pingImage.hidden = YES;
        cell.fenImage.hidden = YES;
        cell.lineLabel.hidden = YES;
        cell.contentLabel.text = @"该用户暂无动态!";
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray.count != 0) {
        //点击cell进入详情
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        
        DetailViewController * comDevc = [[DetailViewController alloc]init];
        
        comDevc.detailId = [_dataArray[indexPath.row] userMoodId];
        
        [self.navigationController pushViewController:comDevc animated:YES];
    }
    

    
    
}

#pragma mark --点击事件
-(void)sixingClick:(UIButton *)btn
{
    ////NSLog(@"%@",_model.otherUserId);
    if (_model.otherUserId != nil) {
        
        ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
        //设置聊天类型
        vc.conversationType = ConversationType_PRIVATE;
        //设置对方的id
        //        vc.targetId = model.targetId;
        vc.targetId = [NSString stringWithFormat:@"%@",_model.userId];
        //设置聊天标题
        //        vc.title = model.conversationTitle;
        vc.title = _model.userName;
        //设置不现实自己的名称  NO表示不现实
        vc.displayUserNameInCell = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}
-(void)guanzhuClick:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_isFollow == YES) {
        [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        [dic setValue:_strMoodId forKey:@"otherUserId"];
        
        _isFollow = NO;
        
        [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:dic success:^(id respondsData) {
            ////NSLog(@"dicr == %@",dic);
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //////NSLog(@"%@",userData);
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            if ([[userData objectForKey:@"success"] boolValue]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];
        
    }else{
        _isFollow = YES;
        [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        [dic setValue:_strMoodId forKey:@"fid"];
        [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/deleteFollow.do" parameter:dic success:^(id respondsData) {
            ////NSLog(@"dicr == %@",dic);
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //////NSLog(@"%@",userData);
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            if ([[userData objectForKey:@"success"] boolValue]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failed:^(NSError *error) {
        }];
    }
}

- (void)imageIconACt{
    
    if ([self.strMoodId integerValue] == [DEFAULF_USERID integerValue]) {
        
    }else{
        AddNoteViewController *AVC = [[AddNoteViewController alloc] init];
        AVC.otherUid = self.strMoodId;
        AVC.userRemark = _nameLabel.text;
        if ([_model.followState intValue] == 1) {
            AVC.isFollow = YES;
        }else{
            AVC.isFollow = NO;
        }
        [self.navigationController pushViewController:AVC animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"%f",_mainScrollView.contentOffset.y);
    //    //NSLog(@"tab.contentoffset.y>>>>>>>>>>>>>%f",_tableView.contentOffset.y);
    //    //NSLog(@"cgfloat>>>>>>>>>>>>>>>>>>>%f",_tabY);
    
    //上划显示时间轴
    if (_mainScrollView.contentOffset.y > _profileView.y+_profileView.height-5) {
        _tableView.scrollEnabled = YES;
    }else{
        _tableView.scrollEnabled = NO;
    }
    
    //下拉回到顶部
    if (_tableView.contentOffset.y < 0 && _tableView.contentOffset.y < _tabY) {
        _tableView.scrollEnabled = NO;
        [_mainScrollView setContentOffset:CGPointZero animated:YES];
    }
    
    _tabY = _tableView.contentOffset.y;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
