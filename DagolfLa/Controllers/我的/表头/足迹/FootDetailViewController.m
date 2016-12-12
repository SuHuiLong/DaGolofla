//
//  FootDetailViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/11/3.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "FootDetailViewController.h"
#import "UIView+ChangeFrame.h"
#import "PicArrShowViewControllerViewController.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@interface FootDetailViewController ()
{
    
    NSMutableArray *_picsArr;
    
    UIButton *_btn;
    UIImageView *_iconImgv;
    UILabel *_labelTitle;
    UILabel *_labelContent;
    UIImageView *_isUseImgv;
    UILabel *_labelImgvCount;
    
    UILabel *_locationImg;
    UILabel *_labelDistance;
    UILabel *_labelCities;
}
@property (assign, nonatomic) NSInteger viewHeight;
@end

@implementation FootDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _picsArr = [NSMutableArray arrayWithArray:self.myFoot.pics];
    
    self.title = @"足迹详情";
    [self createMainView];
}


- (void)createMainView
{
    //头像
    

    _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 36*ScreenWidth/375, 36*ScreenWidth/375)];
    [_iconImgv sd_setImageWithURL:[Helper imageIconUrl:_myFoot.uPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    [self.view addSubview:_iconImgv];
    _iconImgv.layer.masksToBounds = YES;
    _iconImgv.userInteractionEnabled = YES;
    _iconImgv.layer.cornerRadius = 2*ScreenWidth/375;
    
    
    //    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    _btn.frame = CGRectMake(0, 0, _iconImgv.width, _iconImgv.height);
    //    _btn.backgroundColor = [UIColor clearColor];
    //    [_iconImgv addSubview:_btn];
    
    //用户id
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgv.frameX + _iconImgv.width + 10*ScreenWidth/375, _iconImgv.frameY  + 5*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelTitle.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
    _labelTitle.text = _myFoot.userName;
    _labelTitle.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [self.view addSubview:_labelTitle];
    
    //发布信息
    
    _labelContent = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgv.frameX + 5 * ScreenWidth /375, _iconImgv.frameY + _iconImgv.height + 10*ScreenWidth/375, ScreenWidth-_iconImgv.frameX - 15 *ScreenWidth / 375, 20*ScreenWidth/375)];
    
    NSInteger labelContentHeight = [Helper textHeightFromTextString:_myFoot.moodContent width:ScreenWidth - 30 *ScreenWidth/375 fontSize:15*ScreenWidth/375];
    _labelContent.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labelContent.textColor = [UIColor colorWithRed:0.38f green:0.38f blue:0.39f alpha:1.00f];
    self.viewHeight = _labelContent.frameY + _labelContent.height;
    _labelContent.text = _myFoot.moodContent;
    [_labelContent changeHeight:labelContentHeight];
    [self.view addSubview:_labelContent];
    
    
    
    
    if (![_picsArr isEqual:[NSNull null]]) {
        if ([_picsArr count] == 0) {
            [self isShowPic:NO];
        } else {
            [self isShowPic:YES];
        }
        
    } else {
        [self isShowPic:NO];
    }
    
    
    
    
}

#pragma mark -- 判断是否存在图片
- (void)isShowPic:(BOOL)isPic
{
    //发布图片
    
    if (isPic) {
        NSInteger picNumber = 3;
        
        if (_picsArr.count <= 3) {
            picNumber = _picsArr.count;
        } else {
            picNumber = 3;
        }
        
        for (int i = 0; i < picNumber; i++) {
            _isUseImgv = [[UIImageView alloc]initWithFrame:CGRectMake(_iconImgv.frameX +i*90*ScreenWidth/375, _labelContent.height + _labelContent.frameY + 5 *ScreenWidth/375, 75*ScreenWidth/375, 75*ScreenWidth/375)];
            //_isUseImgv.backgroundColor = [UIColor blackColor];
            _isUseImgv.userInteractionEnabled = YES;
            // 添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [tap addTarget:self action:@selector(showPicController:)];
            [_isUseImgv addGestureRecognizer:tap];
            _isUseImgv.tag = 10000 + i;
            [_isUseImgv sd_setImageWithURL:[Helper imageIconUrl:_picsArr[i]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
            [self.view addSubview:_isUseImgv];
            
            if (i == picNumber - 1) {
                //                _labelImgvCount = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 75*ScreenWidth/375, _isUseImgv.frameY + _isUseImgv.height - 25*ScreenWidth/375, 50*ScreenWidth/375, 25*ScreenWidth/375)];
                _labelImgvCount = [[UILabel alloc]initWithFrame:CGRectMake(_isUseImgv.width - 50*ScreenWidth/375,_isUseImgv.height - 25*ScreenWidth/375, 50*ScreenWidth/375, 25*ScreenWidth/375)];
                _labelImgvCount.backgroundColor = [UIColor blackColor];
                _labelImgvCount.alpha = 0.8;
                
                if (_picsArr.count <= 3) {
                    _labelImgvCount.text = [NSString stringWithFormat:@"共%ld张", (long)picNumber];
                } else {
                    _labelImgvCount.text = [NSString stringWithFormat:@"共%ld张", (long)_picsArr.count];
                }
                
                
                
                _labelImgvCount.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
                _labelImgvCount.textAlignment = NSTextAlignmentCenter;
                _labelImgvCount.textColor = [UIColor whiteColor];
                [_isUseImgv addSubview:_labelImgvCount];
            }
        }
        
        self.viewHeight = _isUseImgv.frameY + _isUseImgv.height;
    }
    
    
    //定位图片
    _locationImg = [[UILabel alloc]initWithFrame:CGRectMake(_labelContent.frameX, self.viewHeight + 10*ScreenWidth/375, 200*ScreenWidth/375, 18*ScreenWidth/375)];
    _locationImg.text = _myFoot.golfName;
    _locationImg.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    _locationImg.textColor = [UIColor colorWithRed:0.58f green:0.58f blue:0.58f alpha:1.00f];
    [self.view addSubview:_locationImg];
    
    //定位label
    _labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(_locationImg.frameX + _locationImg.width + 5*ScreenWidth/375, _locationImg.frameY, 80*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelDistance.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _labelDistance.text = [NSString stringWithFormat:@"%@",_myFoot.playTime];
    //    _labelDistance.textAlignment = NSTextAlignmentCenter;
    _labelDistance.textColor = [UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f];
    [self.view addSubview:_labelDistance];
    
    
    _labelCities = [[UILabel alloc]initWithFrame:CGRectMake(_labelDistance.frameX + _labelDistance.width + 10*ScreenWidth/375, _locationImg.frameY, ScreenWidth-135*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelCities.textColor = [UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f];
    _labelCities.text = [NSString stringWithFormat:@"%@杆", _myFoot.poleNum];
    _labelCities.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:_labelCities];
    
    
    
    
}

// 跳到显示图片的页面
- (void)showPicController:(UIGestureRecognizer *)tap
{
    PicArrShowViewControllerViewController *vi = [[PicArrShowViewControllerViewController alloc] initWithIndex:tap.view.tag- 10000 ];
    vi.selectImages = _picsArr;
    [self.navigationController pushViewController:vi animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
