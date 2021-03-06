//
//  SelfDataViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/3.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelfDataViewController.h"
#import "LazyPageScrollView.h"
#import "ChatDetailViewController.h"
#import "ChatDetailViewController.h"
#import "AddFootViewController.h"
#import "OtherDataModel.h"
#import "OtherDataTableViewCell.h"

#import <BaiduMapAPI/BMapKit.h>
#import "UIView+ChangeFrame.h"

#import "ShowMapViewViewController.h"
#import "MyfootModel.h"
#import "PicArrShowViewControllerViewController.h"

#import "SelfViewController.h"
#import "AddNoteViewController.h"

#define kUpDateData_URL @"user/updateUserInfo.do"

#define kqueryIDs_URL @"user/queryByIds.do"
@interface SelfDataViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate, UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableView;
    NSArray* _detailArray;
    OtherDataModel *_model;
    
    BOOL _isFollow;
    
    NSMutableArray* _array;
    
    
    BMKMapView* _mapView;
    
    // 相片的数据源
    NSMutableArray *_picArr;
    
    // 传过去的相片数据
    NSMutableArray *_postPicArr;
    
    MBProgressHUD* _prpgressHView;
    UIImageView * _picImgv;
    UIButton *_changePic;
    
    UILabel *_labelName;
    
    //头像
    UIImageView* _imgvIcon;
    
    UIImageView * _imgvSex;
    UILabel* _labelChadian;
    UILabel* _labelAge;
}


@end

@implementation SelfDataViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//    NoteModel *model = [NoteHandlle selectNoteWithUID:self.strMoodId];
//    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        _labelName.text = _model.userName;
        self.title = _model.userName;
//    }else{
//        _labelName.text = model.userremarks;
//        self.title = model.userremarks;
//    }

    
    self.navigationController.navigationBarHidden = NO;

    
    //发出通知隐藏标签栏
    [_mapView viewWillAppear];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _postPicArr = [NSMutableArray array];

    [[PostDataRequest sharedInstance] postDataRequest:kqueryIDs_URL parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":_strMoodId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",[dict objectForKey:@"rows"]);
        if ([[dict objectForKey:@"success"] boolValue]) {
            _model = [[OtherDataModel alloc] init];
            [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
            
            _array = [[NSMutableArray alloc]init];
            
            
//            NoteModel *modell = [NoteHandlle selectNoteWithUID:self.strMoodId];
//            if ([modell.userremarks isEqualToString:@"(null)"] || [modell.userremarks isEqualToString:@""] || modell.userremarks == nil) {
//                self.title = _model.userName;
//            }else{
//                self.title = modell.userremarks;
//            }
//            
//            self.title = _model.userName;
            [self createPageView];
            
            // 相片的数据请求
            [self inquirePicSource];
            [self createHeaderView];
            //资料信息
            [self createXinxi];
            //分割线
            [self createLineBetween];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
      
        
        [_tableView reloadData];
        
    } failed:^(NSError *error) {
    }];
    
   

    
    
   }

-(void)proGresHView
{
    _prpgressHView = [[MBProgressHUD alloc] initWithView:self.view];
    _prpgressHView.mode = MBProgressHUDModeIndeterminate;
    _prpgressHView.labelText = @"正在加载...";
    [self.view addSubview:_prpgressHView];
    [_prpgressHView show:YES];
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
                        [_postPicArr addObject:picStr];
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


-(void)createHeaderView
{
    _picImgv = [[UIImageView alloc]init];
    _picImgv.frame = CGRectMake(0, 0, ScreenWidth, 238*ScreenWidth/375);
    _picImgv.backgroundColor = [UIColor orangeColor];
    _picImgv.userInteractionEnabled = YES;
    _picImgv.contentMode = UIViewContentModeScaleAspectFill;
    _picImgv.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapAction:)];
    [_picImgv addGestureRecognizer:tap];
    
    [_picImgv sd_setImageWithURL:[Helper imageUrl:_model.backPic] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
    [self.view addSubview:_picImgv];
    
    
    if ([self.strMoodId isEqualToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
        //点击更换图片
        
        _changePic = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changePic setFrame:CGRectMake(_picImgv.frame.size.width-110*ScreenWidth/375, _picImgv.frame.size.height - 40*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375)];
        _changePic.tag = 10000;
        _changePic.layer.cornerRadius = 8*ScreenWidth/375;
        _changePic.layer.masksToBounds = YES;
        _changePic.backgroundColor = [UIColor blackColor];
        _changePic.alpha = 0.5;
        [self.view addSubview:_changePic];
        [_changePic setTitle:@"点击更换图片" forState:UIControlStateNormal];
        [_changePic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changePic.titleLabel.font = [UIFont systemFontOfSize:12];
        [_changePic addTarget:self action:@selector(usePhonePhotoAndCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view sendSubviewToBack:_picImgv];

}

#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [selestSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self usePhonCamera];
    }else if (buttonIndex == 1) {
        [self usePhonePhoto];
    }
}
#pragma mark - 调用相机
- (void)usePhonCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 调用相册
- (void)usePhonePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *photoData = UIImageJPEGRepresentation(image, 0.5);

    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *photoArr = [NSMutableArray array];
    
    [photoArr addObject:photoData];

    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    [[PostDataRequest sharedInstance] postDataAndImageRequestBackPic:@"user/updateUserInfo.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} imageDataArr:photoArr success:^(id respondsData) {
        [_picImgv setImage:image];
    } failed:^(NSError *error) {

    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }

#pragma mark - scrollView的协议方法

- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    if (_postPicArr.count != 0) {
//        PicArrShowViewControllerViewController *vc = [[PicArrShowViewControllerViewController alloc] initWithIndex:0];
//        vc.selectImages = _postPicArr;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)imageIconACt{
    
    if ([self.strMoodId isEqualToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {

    }else{
    AddNoteViewController *AVC = [[AddNoteViewController alloc] init];
    AVC.otherUid = self.strMoodId;
    AVC.userRemark = _labelName.text;
        if ([_model.followState intValue] == 1) {
            AVC.isFollow = YES;
        }else{
            AVC.isFollow = NO;
        }
    [self.navigationController pushViewController:AVC animated:YES];
    }
}

-(void)createXinxi
{
    //头像
    _imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(7*ScreenWidth/375, 225*ScreenWidth/375, 73*ScreenWidth/375, 73*ScreenWidth/375)];
    _imgvIcon.userInteractionEnabled = YES;
    [_imgvIcon sd_setImageWithURL:[Helper imageIconUrl:_model.pic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageIconACt)];
    [_imgvIcon addGestureRecognizer:tap];
    [self.view addSubview:_imgvIcon];
    //将图片切割为圆形
    _imgvIcon.layer.masksToBounds =YES;
    _imgvIcon.layer.cornerRadius =73*ScreenWidth/375/2;
    //描边
    CALayer *imgvLayer = [_imgvIcon layer];
    [imgvLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imgvLayer setBorderWidth:4*ScreenWidth/375];
    
    //昵称
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 243*ScreenWidth/375, 100*ScreenWidth/375, 26*ScreenWidth/375)];
    _labelName.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
//    NoteModel *model = [NoteHandlle selectNoteWithUID:self.strMoodId];
//    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        _labelName.text = _model.userName;
//    }else{
//        _labelName.text = model.userremarks;
//    }

    [self.view addSubview:_labelName];
    
    //性别图标
    _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 270*ScreenWidth/375, 15*ScreenWidth/375,18*ScreenWidth/375)];
    if ([_model.sex integerValue] == 0) {
        _imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    [self.view addSubview:_imgvSex];
    
    //年龄
    _labelAge = [[UILabel alloc]initWithFrame:CGRectMake(120*ScreenWidth/375, 273*ScreenWidth/375, 30*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelAge.textAlignment = NSTextAlignmentLeft;

    _labelAge.text = [NSString stringWithFormat:@"%@",_model.age];
    [self.view addSubview:_labelAge];
    _labelAge.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    
    UILabel *chaDian = [[UILabel alloc] initWithFrame:CGRectMake(_labelAge.frameX + _labelAge.width + 5, _labelAge.frameY, 30*ScreenWidth/375, _labelAge.height)];
    chaDian.text = @"差点";
    chaDian.textAlignment = NSTextAlignmentCenter;
    //    chaDian.backgroundColor = [UIColor redColor];
    chaDian.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [self.view addSubview:chaDian];
    
    _labelChadian = [[UILabel alloc]initWithFrame:CGRectMake(chaDian.frameX + chaDian.width + 5, 273*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
    //    labelChadian.backgroundColor = [UIColor redColor];
    _labelChadian.text = [NSString stringWithFormat:@"%@",_model.almost];
    _labelChadian.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [self.view addSubview:_labelChadian];
    
    //个性签名
    UILabel* labelText = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 300*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 20)];
    labelText.text = _model.userSign;
    labelText.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:labelText];

    
    if ([self.strMoodId isEqualToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
        //当前用户个人主页
       
        UIButton* btnSet = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置button边框
        CALayer *buttonLayer = [btnSet layer];
        [buttonLayer setBorderColor:[UIColor orangeColor].CGColor];
        [buttonLayer setBorderWidth:1];
        btnSet.frame = CGRectMake(180*ScreenWidth/375 + 70*ScreenWidth/375, 250*ScreenWidth/375, 100*ScreenWidth/375, 35*ScreenWidth/375);
        [btnSet setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btnSet.layer.cornerRadius = 10;
        btnSet.layer.masksToBounds = YES;
        [btnSet setTitle: @"编辑个人资料" forState:UIControlStateNormal];
        [btnSet setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [btnSet setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btnSet.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        btnSet.contentHorizontalAlignment = NSTextAlignmentCenter;
        [btnSet addTarget:self action:@selector(gerenClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:btnSet];
        
    }else{
        //不是当前用户个人主页
        for (int i = 0; i < 2; i++) {
            UIButton* btnSet = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置button边框
            CALayer *buttonLayer = [btnSet layer];
            [buttonLayer setBorderColor:[UIColor orangeColor].CGColor];
            [buttonLayer setBorderWidth:1];
            btnSet.tag = 100 + i;
            btnSet.frame = CGRectMake(225*ScreenWidth/375 + 70*ScreenWidth/375*i, 250*ScreenWidth/375, 60*ScreenWidth/375, 34*ScreenWidth/375);
            [btnSet setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            btnSet.layer.cornerRadius = 10;
            btnSet.layer.masksToBounds = YES;
            [self.view addSubview:btnSet];
            
            switch (i) {
                case 0:
                {
                    
                    [btnSet setImage:[UIImage imageNamed:@"xq_xx"] forState:UIControlStateNormal];
                    [btnSet setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    [btnSet setTitle: @"私信" forState:UIControlStateNormal];
                    [btnSet setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    [btnSet setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    btnSet.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    btnSet.contentHorizontalAlignment = NSTextAlignmentCenter;
                    [btnSet addTarget:self action:@selector(sixingClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                case 1:
                {
                    if ([_model.followState integerValue]== 0) {
                        [btnSet setTitle:@"关注" forState:UIControlStateNormal];
                        _isFollow = YES;
                    }
                    else
                    {
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
     
        //不是当前用户  禁止发布足迹
        UIButton *addFoot = [self.view viewWithTag:1988];
        [addFoot removeFromSuperview];
    }
}


-(void)gerenClick:(UIButton *)btn{

    SelfViewController* scVc = [[SelfViewController alloc]init];
    scVc.userModel = _model;
    
    scVc.blockRereshingMe = ^(NSArray* arrayData){
        //NSLog(@"返回刷新了!!!!!!!>>>%@",_model.sex);
        
        _labelName.text = _model.userName;
        
        _labelChadian.text = [NSString stringWithFormat:@"%@",_model.almost];

        _imgvSex.image = [UIImage imageNamed:@""];
        if ([_model.sex integerValue] == 0) {
            
            _imgvSex.image = [UIImage imageNamed:@"xb_n"];
        }else{
            _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
        }
        
        if (_model.age != nil) {
            _labelAge.text = [NSString stringWithFormat:@"%@",_model.age];
        }
        
        if (arrayData.count != 0) {
            _imgvIcon.image = [UIImage imageWithData:arrayData[0]];
        }
        [_tableView reloadData];
    };
    
    [self.navigationController pushViewController:scVc animated:YES];
}

-(void)createLineBetween
{
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 320*ScreenWidth/375, ScreenWidth, 5*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewLine];
}


-(void)createPageView
{
    _titleArray = @[@"个人资料",@"足迹"];
    _detailArray = @[@"昵称",@"球龄",@"主场",@"个性签名"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 330*ScreenWidth/375, ScreenWidth, ScreenHeight-320*ScreenWidth/375-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:40*ScreenWidth/375 TabHeight:40*ScreenWidth/375 VerticalDistance:10*ScreenWidth/375 BkColor:[UIColor whiteColor]];
    
    for (int i = 0; i < 2; i++) {
        
        if (i == 0) {
            _tableView=[[UITableView alloc] init];
            _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
            [_pageView addTab:_titleArray[i] View:_tableView];
            _tableView.tag = 100+i;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            
            
            //            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
            
            [_tableView registerNib:[UINib nibWithNibName:@"OtherDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherDataTableViewCell"];
        }
        else
        {
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
    lb.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:lb];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //_pageView.selectedIndex=4;
    });
    
}



//试图加载一个视图控制器的视图，它是释放是不允许的，可能会导致未定义的行为

-(void)createAddFoot
{
    
    UIView* viewBase = [[UIView alloc]init];
    viewBase.backgroundColor = [UIColor blackColor];
    [_pageView addTab:_titleArray[1] View:viewBase];
    
    _mapView = [[BMKMapView alloc] init];
    _mapView.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight-435*ScreenWidth/375);
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
    imgvJian.image = [UIImage imageNamed:@")"];
    [viewBtn addSubview:imgvJian];
    
    
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
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
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
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    OtherDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherDataTableViewCell" forIndexPath:indexPath];
//    cell.titleLabel.text = _detailArray[indexPath.row];
//    cell.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    cell.detailLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
//    
//    switch (indexPath.row) {
//        case 0:
//        {
//            if ([Helper isBlankString:_model.userName]) {
//                cell.detailLabel.text = @"暂无用户名";
//            }
//            else
//            {
//                cell.detailLabel.text = _model.userName;
//            }
//            
//        }
//            
//            break;
//        case 1:
//            
//            if (_model.ballage == nil) {
//                cell.detailLabel.text = @"暂无球龄";
//            }
//            else
//            {
//                cell.detailLabel.text = [NSString stringWithFormat:@"%@",_model.ballage];
//            }            break;
//        case 2:
//            if (_model.address == nil) {
//                cell.detailLabel.text = @"暂无主场";
//            }
//            else
//            {
//                cell.detailLabel.text = _model.address;
//            }            break;
//
//        case 3:
//            if (_model.userSign == nil) {
//                cell.detailLabel.text = @"暂无数据";
//            }
//            else
//            {
//                cell.detailLabel.text = _model.userSign;
//            }            break;
//            
//        default:
//            break;
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                //////NSLog(@"%@",[userData objectForKey:@"message"]);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];
        
    }
    else
    {
        _isFollow = YES;
        [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        [dic setValue:_strMoodId forKey:@"fid"];
        //NSLog(@"1111 ==    %@",dic);
        [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/deleteFollow.do" parameter:dic success:^(id respondsData) {
            ////NSLog(@"dicr == %@",dic);
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //////NSLog(@"%@",userData);
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            if ([[userData objectForKey:@"success"] boolValue]) {
                //////NSLog(@"%@",[userData objectForKey:@"message"]);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failed:^(NSError *error) {
            ////NSLog(@"%@",error);
        }];
        
    }
}

@end
