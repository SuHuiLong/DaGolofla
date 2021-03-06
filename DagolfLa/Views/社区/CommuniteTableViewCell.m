//
//  CommuniteTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "CommuniteTableViewCell.h"
#import "AppDelegate.h"

#import "PersonHomeController.h"
#import "ZanNumViewController.h"

//#import "ComDetailViewController.h"

#import "UIView+ChangeFrame.h"
#import "UIButton+WebCache.h"

#import "CommunityViewController.h"

#import "PicArrShowViewControllerViewController.h"


#import "UITool.h"


@implementation CommuniteTableViewCell


- (void)awakeFromNib {
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.userInteractionEnabled = YES;
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews {
    
    //头像
    _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 36*ScreenWidth/375, 36*ScreenWidth/375)];
    [self.contentView addSubview:_iconImgv];
    _iconImgv.layer.masksToBounds = YES;
    _iconImgv.userInteractionEnabled = YES;
    _iconImgv.layer.cornerRadius = 8*ScreenWidth/375;
    
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn.frame = CGRectMake(0, 0, _iconImgv.width, _iconImgv.height);
    _btn.backgroundColor = [UIColor clearColor];
    [_iconImgv addSubview:_btn];
    
    //用户id
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgv.frameX + _iconImgv.width + 15*ScreenWidth/375, _iconImgv.frameY, 180*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelTitle.textColor = [UITool colorWithHexString:@"4C7256" alpha:1.00f];
    _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.contentView addSubview:_labelTitle];
    
    //时间
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgv.frameX + _iconImgv.width + 15*ScreenWidth/375, _labelTitle.frameY  + _labelTitle.frame.size.height, 180*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelTime.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    _labelTime.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_labelTime];
    _labelTime.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    
    
    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportBtn setFrame:CGRectMake(ScreenWidth - 60, _labelTitle.frameY, 40*ScreenWidth/375, _labelTitle.height)];
    [_reportBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [_reportBtn setTitleColor:[UIColor colorWithRed:0.38f green:0.38f blue:0.39f alpha:1.00f] forState:UIControlStateNormal];
    [_reportBtn.titleLabel setFont:[UIFont systemFontOfSize:15*ScreenWidth/375]];
    _reportBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:_reportBtn];
    
    
    
    //发布信息
    _labelContent = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgv.frameX + 5 * ScreenWidth /375, _iconImgv.frameY + _iconImgv.height + 5*ScreenWidth/375, ScreenWidth-_iconImgv.frameX - 15 *ScreenWidth / 375, 20*ScreenWidth/375)];
    _labelContent.numberOfLines = 0;
    _labelContent.textColor = [UIColor colorWithRed:0.38f green:0.38f blue:0.39f alpha:1.00f];
    _labelContent.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [self.contentView addSubview:_labelContent];
    self.viewHeight = _labelContent.frameY + _labelContent.height;
    
    [self addPicView];
    [self location];
    [self addFootView];
    [self zanPingFen];
    [self addZanView];
}

-(void)addPicView {
    _picImage1 =[[UIImageView alloc]init];
    _picImage1.frame = CGRectMake(10,_labelContent.height + _labelContent.frameY + 5 *ScreenWidth/375, (ScreenWidth-40)/3,(ScreenWidth-40)/3);
    _picImage1.contentMode = UIViewContentModeScaleAspectFill;
    _picImage1.clipsToBounds = YES;
    
    [self.contentView addSubview:_picImage1];
    
    _picImage2 =[[UIImageView alloc]init];
    _picImage2.frame = CGRectMake(20+(ScreenWidth-40*ScreenWidth/375)/3, _labelContent.height + _labelContent.frameY + 5 *ScreenWidth/375, (ScreenWidth-40*ScreenWidth/375)/3,(ScreenWidth-40*ScreenWidth/375)/3);
    [self.contentView addSubview:_picImage2];
    
    _picImage3 =[[UIImageView alloc]init];
    _picImage3.frame = CGRectMake(30+((ScreenWidth-40)/3)*2, _labelContent.height + _labelContent.frameY + 5 *ScreenWidth/375, (ScreenWidth-40)/3,(ScreenWidth-40)/3);
    _picImage3.userInteractionEnabled = YES;
    [self.contentView addSubview:_picImage3];
    
    _picImage1.tag = 110;
    _picImage2.tag = 111;
    _picImage3.tag = 112;
    
    _picCount = [[UILabel alloc]init];
    _picCount.backgroundColor = [UIColor blackColor];
    _picCount.alpha = 0.5;
    _picCount.text = @"2";
    _picCount.textColor = [UIColor whiteColor];
    _picCount.font = [UIFont systemFontOfSize:14];
    _picCount.textAlignment = NSTextAlignmentCenter;
    _picCount.frame =  CGRectMake(_picImage3.frame.size.width/2,_picImage3.frame.size.height - 20*ScreenWidth/375,_picImage3.frame.size.width/2,20*ScreenWidth/375);
    [_picImage3 addSubview:_picCount];
    
    self.viewHeight = _picImage1.frameY + _picImage1.height;
    
}

//公里数+俱乐部
-(void)location {
    
    _ClubView = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, self.viewHeight + 10*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 25*ScreenWidth/375)];
    [self.contentView addSubview:_ClubView];
    //定位图片
    _locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 3*ScreenWidth/375, 12*ScreenWidth/375, 18*ScreenWidth/375)];
    _locationImg.image = [UIImage imageNamed:@"juli"];
    [_ClubView addSubview:_locationImg];
    
    
    //定位label
    _labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(40*ScreenWidth/375,3*ScreenWidth/375, 80*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelDistance.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    _labelDistance.textColor = [UIColor lightGrayColor];
    [_ClubView addSubview:_labelDistance];
    
    
    //定位的城市
    _labelCities = [[UILabel alloc]initWithFrame:CGRectMake(125*ScreenWidth/375, 3*ScreenWidth/375, ScreenWidth-135*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelCities.textColor = [UIColor lightGrayColor];
    _labelCities.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_ClubView addSubview:_labelCities];
    
    
    self.viewHeight = _ClubView.frameY + _ClubView.height;
    
}

-(void)addFootView {
    
    _FootView = [[UIView alloc]initWithFrame:CGRectMake(30*ScreenWidth/375, self.viewHeight + 5*ScreenWidth/375 *ScreenWidth/375, ScreenWidth - 60, 25*ScreenWidth/375)];
    [self.contentView addSubview:_FootView];
    
    //来自足迹
    _labelFoot = [[UILabel alloc]initWithFrame:CGRectMake(35*ScreenWidth/375, 3*ScreenWidth/375, 80*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelFoot.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _labelFoot.text = @"来自足迹";
    _labelFoot.textColor = [UIColor lightGrayColor];
    [_FootView addSubview:_labelFoot];
    
    //定位label
    _footTime = [[UILabel alloc]initWithFrame:CGRectMake(120*ScreenWidth/375, 3*ScreenWidth/375, 80*ScreenWidth/375, 20*ScreenWidth/375)];
    _footTime.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _footTime.textColor = [UIColor lightGrayColor];
    [_FootView addSubview:_footTime];
    
    //定位label
    _footNum = [[UILabel alloc]initWithFrame:CGRectMake(210*ScreenWidth/375, 3*ScreenWidth/375, 80*ScreenWidth/375, 20*ScreenWidth/375)];
    _footNum.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _footNum.textColor = [UIColor lightGrayColor];
    [_FootView addSubview:_footNum];
    
    self.viewHeight = _FootView.frameY + _FootView.height;
}

-(void)zanPingFen {
    _ZPFView = [[UIView alloc]initWithFrame:CGRectMake(5,self.viewHeight+5*ScreenWidth/375, ScreenWidth-10*ScreenWidth/375, 35*ScreenWidth/375)];
    [self.contentView addSubview:_ZPFView];
    
    
    //分割线
    _viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, -3*ScreenWidth/375, ScreenWidth-20, 2)];
    _viewLine1.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
    [_ZPFView addSubview:_viewLine1];
    
    
    //点赞
    _zanBaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _zanBaseBtn.backgroundColor = [UIColor redColor];
    _zanBaseBtn.frame = CGRectMake(0, 3*ScreenWidth/375, (ScreenWidth - 40*ScreenWidth/375)/3, 30*ScreenWidth/375);
    [_ZPFView addSubview:_zanBaseBtn];
    _zanBaseBtn.imageEdgeInsets = UIEdgeInsetsMake(-2*ScreenWidth/375, 0, -2*ScreenWidth/375, 55*ScreenWidth/375);
    [_zanBaseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    _zanBaseBtn.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_zanBaseBtn setTitle:@"3333" forState:UIControlStateNormal];
    [_zanBaseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //评论
    _disCussBtnBase = [UIButton buttonWithType:UIButtonTypeCustom];
//    _disCussBtnBase.backgroundColor = [UIColor blueColor];
    _disCussBtnBase.frame = CGRectMake((ScreenWidth - 40*ScreenWidth/375)/3,3*ScreenWidth/375, (ScreenWidth - 40*ScreenWidth/375)/3, 30*ScreenWidth/375);
    [_ZPFView addSubview:_disCussBtnBase];
    
    _disCussBtnBase.imageEdgeInsets = UIEdgeInsetsMake(-2*ScreenWidth/375, 0, -2*ScreenWidth/375, 55*ScreenWidth/375);
    [_disCussBtnBase setImage:[UIImage imageNamed:@"pinlun"] forState:UIControlStateNormal];
    _disCussBtnBase.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_disCussBtnBase setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //喜欢
    _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btnLike.backgroundColor = [UIColor blackColor];
    _btnLike.frame = CGRectMake((ScreenWidth - 40*ScreenWidth/375)/3*2, 3*ScreenWidth/375, (ScreenWidth - 40*ScreenWidth/375)/3, 30*ScreenWidth/375);
    [_ZPFView addSubview:_btnLike];
    
    //分享
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shareBtn.backgroundColor = [UIColor orangeColor];
    _shareBtn.frame = CGRectMake(ScreenWidth-45*ScreenWidth/375, 3*ScreenWidth/375, 40*ScreenWidth/375, 30*ScreenWidth/375);
    [_shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [_ZPFView addSubview:_shareBtn];
    
    
    self.viewHeight = _ZPFView.frameY + _ZPFView.height;
}

-(void)addZanView {
    _ZanView = [[UIView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, self.viewHeight, ScreenWidth-10*ScreenWidth/375, (ScreenWidth-17)/10+5)];
    [self.contentView addSubview:_ZanView];
    
    //分割线
    _viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375,-3*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 2)];
    _viewLine2.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
    [_ZanView addSubview:_viewLine2];
    
    
    //赞图标，显示头像
    _discussImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, ((ScreenWidth-17)/10-10)/2, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    
    _discussImg.image = [UIImage imageNamed:@"zan"];
    [_ZanView addSubview:_discussImg];
    
    
    for (int i = 0 ; i < 9 ; i ++) {
        
        _zanPeopleIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanPeopleIcon.tag = i+120;
        _zanPeopleIcon.frame = CGRectMake(30*ScreenWidth/375+i*((ScreenWidth-17)/10+1.5), 3, (ScreenWidth-17)/10, (ScreenWidth-17)/10);
        _zanPeopleIcon.layer.cornerRadius = _zanPeopleIcon.bounds.size.width/2;
        _zanPeopleIcon.layer.masksToBounds = YES;
        [_ZanView addSubview:_zanPeopleIcon];
    }
}


#pragma mark -- cell控件 Model赋值

-(void)setCommunityModel:(CommunityModel *)model {
    
    
    
    _communityModel = model;
    /**
     头像 姓名 时间 内容 赋值
     */
    //头像 + 点击跳转个人主页block
    [_iconImgv sd_setImageWithURL:[Helper imageIconUrl:model.uPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _btn.tag = 1000 + _cellIndexPath;
    
    [_btn addTarget:self action:@selector(selfDataClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_reportBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];

    
    _labelTitle.text = model.userName;
    CGFloat moodContentH = [model.moodContent boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    //    _labelContent.backgroundColor = [UIColor purpleColor];
    _labelContent.frame = CGRectMake(10* ScreenWidth /375, _iconImgv.frame.origin.y + _iconImgv.frame.size.height+5*ScreenWidth/375, ScreenWidth- 20*ScreenWidth / 375, moodContentH);
    _labelContent.numberOfLines = 0;
    _labelContent.text = model.moodContent;
    _labelDistance.text = [NSString stringWithFormat:@"%.1f公里",[model.distance doubleValue]];
    _labelCities.text = model.golfName;
    
    // 取当前时间的秒数
    NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
    [dateFormattor setDateFormat:@"yyyy-MM-dd"];
    // 当前的时间转化为字符串
    NSString *currentTimeString = [dateFormattor stringFromDate:[NSDate date]];
    // 判断当前时间和网络请求得到的时间进行比较
    if ([currentTimeString isEqualToString:[[NSString stringWithFormat:@"%@", model.createTime] substringToIndex:10]]) {
        _labelTime.text = [[NSString stringWithFormat:@"%@", model.createTime] substringWithRange:NSMakeRange(0,16)];
    } else {
        _labelTime.text = [[NSString stringWithFormat:@"%@", model.createTime] substringToIndex:10];
    }
    
    _newHeight = _labelContent.frame.origin.y + _labelContent.frame.size.height;
    
    _picImage1.frame = CGRectMake(10,_newHeight+5, (ScreenWidth-40)/3,(ScreenWidth-40)/3);
    _picImage2.frame = CGRectMake(20+(ScreenWidth-40)/3,_newHeight+5, (ScreenWidth-40)/3,(ScreenWidth-40)/3);
    _picImage3.frame = CGRectMake(30+((ScreenWidth-40)/3)*2,_newHeight+5, (ScreenWidth-40)/3,(ScreenWidth-40)/3);
    
    //创建的三张图片赋值
    for (int i = 0; i < 3; i++) {
        //看能不能找到这个tag
        UIImageView * picView = [self.contentView viewWithTag:110+i];
        
        //图片点击事件
        picView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TuPianbuttonClick:)];
        [picView addGestureRecognizer:tap];
        //找到赋值
        if (i < model.pics.count) {
            picView.hidden = NO;
            [picView sd_setImageWithURL:[Helper imageIconUrl:model.pics[i]] placeholderImage:[UIImage imageNamed:@"moren"]];
            _newHeight =_picImage1.frame.origin.y + _picImage1.frame.size.height;
            [picView setContentMode:UIViewContentModeScaleAspectFill];
            picView.clipsToBounds = YES;
        }else{
            //否则清空
            picView.hidden = YES;
        }
    }
    _picCount.text = [NSString stringWithFormat:@"共%lu张", (unsigned long)model.pics.count];
    
    if (model.pics.count == 0 ) {
        _ClubView.frame =CGRectMake(10,_newHeight + 10*ScreenWidth/375, ScreenWidth - 20, 25*ScreenWidth/375);
    }else{
        _ClubView.frame = CGRectMake(10, _picImage1.frame.origin.y +  _picImage1.frame.size.height + 10*ScreenWidth/375, ScreenWidth - 20, 25*ScreenWidth/375);
    }
    _newHeight = _ClubView.frame.origin.y + _ClubView.frame.size.height;
    
    
    /**
     来自足迹 根据图片有无 更改Frame
     */
    if ([model.moodType integerValue] == 1) {
        _FootView.hidden = NO;
        _FootView.frame = CGRectMake(30*ScreenWidth/375,_ClubView.frame.origin.y +_ClubView.frame.size.height+4, ScreenWidth - 60, 25*ScreenWidth/375);
        _ZPFView.frame = CGRectMake(5,_FootView.frame.origin.y + _FootView.frame.size.height+4, ScreenWidth-10, 35*ScreenWidth/375);
        _ZanView.frame = CGRectMake(5,_ZPFView.frame.origin.y + _ZPFView.frame.size.height+4, ScreenWidth-10, 35*ScreenWidth/375);
        
        //    来自足迹 赋值
        NSString *footTimeString = [NSString stringWithFormat:@"%@", model.playTime];
        NSString *strDate1 = [NSString stringWithFormat:@"%@", [footTimeString substringFromIndex:5]];
        _footTime.text = strDate1;
        
        _footNum.text = [NSString stringWithFormat:@"%@杆",model.poleNum];
        [_disCussBtnBase setTitle:[NSString stringWithFormat:@"%@", model.commentCount] forState:UIControlStateNormal];
    }
    else
    {
        _FootView.frame = CGRectMake(30*ScreenWidth/375,_newHeight + 5 *ScreenWidth/375, ScreenWidth - 60, 25*ScreenWidth/375);
        _FootView.hidden = YES;
        _ZPFView.frame = CGRectMake(5,_newHeight+5, ScreenWidth-10, 35*ScreenWidth/375);
        _ZanView.frame = CGRectMake(5*ScreenWidth/375,_ZPFView.frame.origin.y + _ZPFView.frame.size.height+4, ScreenWidth-10, (ScreenWidth-17)/10+5);
    }
    
    
    
#pragma mark --点赞 评论 关注 分享 btn 赋值 + 点击方法
    
    //点赞
    _zanBaseBtn.tag = 100000 + _cellIndexPath;
    [_zanBaseBtn setTitle:[NSString stringWithFormat:@"%@",model.assistCount] forState:UIControlStateNormal];
    
    //评论
    _disCussBtnBase.tag = 100000 +_cellIndexPath;
    [_disCussBtnBase setTitle:[NSString stringWithFormat:@"%@",model.commentCount] forState:UIControlStateNormal];
    [_disCussBtnBase addTarget:self action:@selector(pinlunClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //关注
    _btnLike.tag = 1000000 + _cellIndexPath;
    if ([model.followState isEqualToNumber:@0]) {
        [_btnLike setImage:[UIImage imageNamed:@"shouchang2"] forState:UIControlStateNormal];
    } else {
        [_btnLike setImage:[UIImage imageNamed:@"shouchang"] forState:UIControlStateNormal];
    }
    [_btnLike addTarget:self action:@selector(btnLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //分享
    [_shareBtn addTarget:self action:@selector(shareComClick) forControlEvents:UIControlEventTouchUpInside];
    
    //点赞
    [_zanBaseBtn addTarget:self action:@selector(btnZanClickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setZanIcon:(NSArray *)iconArr {
    //点赞头像赋值
    for (int i = 0; i < 9; i++) {
        UIButton *zanPeopleIcon=(UIButton *)[self.contentView viewWithTag:120+i];
        //更多按钮
        if (i != 8) {
            if (i < iconArr.count) {
                _ZanView.hidden = NO;
                zanPeopleIcon.hidden = NO;
                [zanPeopleIcon sd_setImageWithURL:[Helper imageIconUrl:[iconArr[i] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                [zanPeopleIcon addTarget:self action:@selector(selfDataClickZanArray:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if (iconArr.count == 0) {
                    _ZanView.hidden = YES;
                }else{
                    _ZanView.hidden = NO;
                    zanPeopleIcon.hidden = YES;
                }
            }
            
        }else{
            if (iconArr.count >= 9) {
                if (i == 8) {
                    zanPeopleIcon.hidden = NO;

                    [zanPeopleIcon setImage:[UIImage imageNamed:@"genduo"] forState:UIControlStateNormal];
                    [zanPeopleIcon removeTarget:self action:@selector(selfDataClickZanArray:) forControlEvents:UIControlEventTouchUpInside];
                    [zanPeopleIcon addTarget:self action:@selector(pushZanNumViewController) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    
                }

            }else{
                zanPeopleIcon.hidden = YES;
            }
        }
    }
}

//自己头像点击事件
-(void)selfDataClick:(UIButton *)btn{
     NSNumber * idPush = [_cellDataArray[btn.tag-1000] uId];
    self.blockIconPush(idPush);
}

//点赞头像点击事件
-(void)selfDataClickZanArray:(UIButton *)btn{
    NSNumber * idPush = [[_cellDataArray[_cellIndexPath] tUserAssists][btn.tag-120] uId];
    self.blockIconPush(idPush);
}

//点赞事件
-(void)btnZanClickBtn:(UIButton*)btn {
    self.blockAddZanIcon(btn);
}

//更多赞的列表
-(void)pushZanNumViewController {
    self.blockMoreZan();
}
//举报点击时间
-(void)reportClick {
    self.blockReportBtn();
}


//图片点击事件
- (void)TuPianbuttonClick:(UITapGestureRecognizer *)tap{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    NSMutableArray *arr = [NSMutableArray array];
    arr = [NSMutableArray arrayWithArray:[_cellDataArray[_cellIndexPath] pics]];
    self.blockPicPush(tap.view.tag-110, arr);
}

//评论点击事件
-(void)pinlunClick:(UIButton *)btn{
    self.blockPinglunPush(btn.tag - 100000);
}

#pragma mark --关注点击事件
- (void)btnLikeClick:(UIButton *)btn
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        NSInteger dianJi = btn.tag - 1000000;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if ([[_cellDataArray[dianJi] followState] isEqualToNumber:@0]) {
            [btn setImage:[UIImage imageNamed:@"shouchang"] forState:UIControlStateNormal];
            
            [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
            
            [dic setValue:[_cellDataArray[dianJi] uId] forKey:@"otherUserId"];
            
            [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/saveFollow.do" parameter:dic success:^(id respondsData) {
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[userData objectForKey:@"success"] boolValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [_cellDataArray[dianJi] setValue:@1 forKey:@"followState"];
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [_cellDataArray[dianJi] setValue:@1 forKey:@"followState"];
                }
            } failed:^(NSError *error) {
            }];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"shouchang2"] forState:UIControlStateNormal];
            
            [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
            
            [dic setValue:[_cellDataArray[dianJi] uId] forKey:@"fid"];
            
            [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/deleteFollow.do" parameter:dic success:^(id respondsData) {
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[userData objectForKey:@"success"] boolValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [_cellDataArray[dianJi] setValue:@0 forKey:@"followState"];
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            } failed:^(NSError *error) {
            }];
        }
    }else {
        self.blockIsLogin();
    }
}

#pragma mark --分享点击事件
-(void)shareComClick{
    self.blockShare();
}
//-(void)shareInfo:(NSInteger)index
//{
//
//}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


@end
