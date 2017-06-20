//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height


#import "UIView+Extension.h"

#import "YMTableViewCell.h"
#import "WFReplyBody.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"

#import "UIImageView+WebCache.h"

#import "JKSlideSwitchView.h"
#import "PersonHomeController.h"

#define kImageTag 9999


@implementation YMTableViewCell
{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
    
    WFTextView *_textView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        
        //头像
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/375, 5*screenWidth/375, TableHeader, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:10.0];
        //        [layer setBorderWidth:1];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:_userHeaderImage];
        
        _totalCellHeight = _userHeaderImage.y+_userHeaderImage.height;
        
        _userHeaderImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *HeadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(entSelf:)];
        [_userHeaderImage addGestureRecognizer:HeadTap];
        
        
        
        //用户名
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(_userHeaderImage.x+_userHeaderImage.width+10*screenWidth/375, 5*screenWidth/375, screenWidth - 100*screenWidth/375, TableHeader/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:17*screenWidth/375];
        //        _userNameLbl.textColor = [UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        _userNameLbl.textColor = [JKSlideSwitchView colorFromHexRGB:@"32b14d"];
        
        [self.contentView addSubview:_userNameLbl];
        
        _userNameLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *HeadTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(entSelf:)];
        [_userNameLbl addGestureRecognizer:HeadTap2];
        
        //个人信息
        _userIntroLbl = [[UILabel alloc] initWithFrame:CGRectMake(_userHeaderImage.x+_userHeaderImage.width+10*screenWidth/375, 5*screenWidth/375 + TableHeader/2 , screenWidth - 100*screenWidth/375, TableHeader/2)];
        _userIntroLbl.numberOfLines = 1;
        _userIntroLbl.font = [UIFont systemFontOfSize:14.0*screenWidth/375];
        _userIntroLbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:_userIntroLbl];
        
        //关注
        _attentionBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _attentionBtn.frame = CGRectMake(310 * screenWidth / 375, 5 * screenWidth / 375, 60 * screenWidth / 375, TableHeader/2);
        [self.contentView addSubview:_attentionBtn];
        
        //展开Btn
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        
        //回复背景
        replyImageView = [[UIImageView alloc] init];
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];
        
        //赞手指图标
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan"];
        
        //分享图标
        _shareImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shareImage.image = [UIImage imageNamed:@"fenxiang"];
        
        //距离Label
        _distance = [[UIView alloc]init];
        [self.contentView addSubview:_distance];
        //足迹View
        _footView = [[UIView alloc]init];
        [self.contentView addSubview:_footView];
        //赞、评论、分享View
        _zpfView = [[UIView alloc]init];
        [self.contentView addSubview:_zpfView];
        
        //定位图片
        _locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(3,5,15,20)];
        _locationImg.image = [UIImage imageNamed:@"juli"];
        [_distance addSubview:_locationImg];
        //定位label
        _labelDistance = [[UILabel alloc] init];
        [_distance addSubview:_labelDistance];
        
        //定位的城市
        _labelCities = [[UILabel alloc] init];
        [_distance addSubview:_labelCities];
        
        //来自足迹
        _labelFoot = [[UILabel alloc] init];
        [_footView addSubview:_labelFoot];
        
        //足迹时间
        _footTime = [[UILabel alloc] init];
        [_footView addSubview:_footTime];
        
        //杆数
        _footNum = [[UILabel alloc] init];
        [_footView addSubview:_footNum];
        
        //点赞
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zpfView addSubview:_zanBtn];
        
        //评论
        _disCussBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zpfView addSubview:_disCussBtn];
        
        //分享
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zpfView addSubview:_shareBtn];
        
        // 更多点赞显示
        _moreLikeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _moreLikeBtn.tag = 666 + 1;
        //        [_moreLikeBtn addTarget:self action:@selector(moreLikeAct:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_moreLikeBtn];
        
        // 更多分享转发显示
        _moreShareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _moreShareBtn.tag = 666 + 2;
        //        [_moreShareBtn addTarget:self action:@selector(moreShareAct:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_moreShareBtn];
        
    }
    return self;
}


/////////////////////////////////

//if ([model.moodType integerValue] == 1) {
//    cellH = cellH;
//}else{
//    cellH -=cell.FootView.frame.size.height + 1;
//}

/////////////////////////////////

- (void)setYMViewWith:(YMTextData *)ymData{
    tempDate = ymData;
#pragma mark -  //头像 昵称 简介

    NSString *bgUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h_2o",@"user",[tempDate.uId integerValue]];

    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:bgUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    
//    
//    [_userHeaderImage sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[tempDate.uId integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"moren"]];
    _userHeaderImage.tag = [ymData.uId intValue];
    
    
//    NoteModel *model = [NoteHandlle selectNoteWithUID:ymData.uId];
//    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        _userNameLbl.text = [NSString stringWithFormat:@"%@",tempDate.messageBody.posterName];
//    }else{
//        _userNameLbl.text = model.userremarks;
//    }
    
    //    _userNameLbl.text = [NSString stringWithFormat:@"%@",tempDate.messageBody.posterName];
    _userNameLbl.tag = [ymData.uId intValue];
    
    _userIntroLbl.text = tempDate.messageBody.posterIntro;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] == [ymData.uId intValue]) {
            [_attentionBtn setTitle:@"撤销" forState:(UIControlStateNormal)];
        }else{
            
            if ([ymData.followState intValue]) {
                [_attentionBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
            }else{
                [_attentionBtn setTitle:@"+关注" forState:(UIControlStateNormal)];
            }
        }
    }else{
        [_attentionBtn setTitle:@"+关注" forState:(UIControlStateNormal)];
    }
    
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_ymShuoshuoArray removeAllObjects];
    
#pragma mark - // /////////添加说说view
    
    
    
    
    _textView = [[WFTextView alloc]init];
    //    _textView.backgroundColor = [UIColor orangeColor];
    _textView.delegate = self;
    _textView.attributedData = ymData.attributedDataShuoshuo;
    _textView.isFold = ymData.foldOrNot;
    _textView.isDraw = YES;
    [_textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:_textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float shuoshuoHeight = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    _textView.frame = CGRectMake(offSet_X, 10*screenWidth/375+ TableHeader, screenWidth - offSet_X - 10*screenWidth/375, shuoshuoHeight);
    
    _totalCellHeight += 15*screenWidth/375+shuoshuoHeight;
    
    [_ymShuoshuoArray addObject:_textView];
    
    //按钮
    foldBtn.frame = CGRectMake(offSet_X - 10*screenWidth/375,TableHeader + shuoshuoHeight + 15*screenWidth/375, 50*screenWidth/375, 20*screenWidth/375 );
    
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        [foldBtn setTitle:@"收起" forState:0];
    }
    
#pragma mark - /////// //图片部分
    
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_imageArray removeAllObjects];
    
    if ([ymData.messageBody.videoPath hasSuffix:@".mp4"]) {
        UIImageView *imageNew = [[UIImageView alloc]init];
        imageNew.contentMode = UIViewContentModeScaleAspectFill;
        imageNew.clipsToBounds = YES;
        [imageNew sd_setImageWithURL:[NSURL URLWithString:ymData.messageBody.thumbnailImageURL] placeholderImage:[UIImage imageNamed:@"moren"]];
        imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4*screenWidth/375)*(0%3), TableHeader + 4 * ((0/3) + 1*screenWidth/375) + (0/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30), (screenWidth - 2* offSet_X ), (screenWidth - 2* offSet_X )/3*2);
        //添加播放控件
        UIImageView *vedioPlayView = [[UIImageView alloc]initWithFrame:CGRectMake((imageNew.frame.size.width-2*20*screenWidth/375)/2, (imageNew.frame.size.height-2*20*screenWidth/375)/2, 2*20*screenWidth/375, 2*20*screenWidth/375)];
        vedioPlayView.image = [UIImage imageNamed:@"vedioPlayBtn"];
        [imageNew addSubview:vedioPlayView];
        imageNew.userInteractionEnabled = YES;
        imageNew.clipsToBounds = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapVedioImageView:)];
        [imageNew addGestureRecognizer:tap];
        //        tap.appendArray = ymData.showImageArray;
        //        imageNew.backgroundColor = [UIColor clearColor];
        //        imageNew.tag = kImageTag + 0;
        
        
        [self.contentView addSubview:imageNew];
        [_imageArray addObject:imageNew];
    }else{
        for (int  i = 0; i < [ymData.showImageArray count]; i++) {
            UIImageView *imageNew = [[UIImageView alloc] init];
            if ([ymData.showImageArray count] == 1) {
                if (ymData.JavaRubbish == 1) {
                    imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4*screenWidth/375)*(0%3),             TableHeader + 4 * ((0/3) + 1*screenWidth/375) + (0/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30), (screenWidth - 2* offSet_X )/3 * 1.5 ,(screenWidth - 2* offSet_X )/3 * 2);
                    
                }else if (ymData.JavaRubbish == 2){
                    imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4)*(0%3),             TableHeader + 4 * ((0/3) + 1) + (0/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30), (screenWidth - 2* offSet_X )/3 * 2 ,(screenWidth - 2* offSet_X )/3 );
                }else{
                    imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4)*(0%3),             TableHeader + 4 * ((0/3) + 1) + (0/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30*screenWidth/375), (screenWidth - 2* offSet_X )/3 * 2,(screenWidth - 2* offSet_X )/3 * 2);
                }
                
                //            NSLog(@"%f",imageNew.frame.origin.x);
                imageNew.contentMode = UIViewContentModeScaleAspectFill;
                imageNew.clipsToBounds = YES;
                [imageNew sd_setImageWithURL: [Helper imageUrl:[ymData.showImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"moren"]];
                
            }else{
                if ([ymData.showImageArray count] == 4 && (i == 2 || i == 3)) {
                    
                    imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4*screenWidth/375)*((i + 1)%3),             TableHeader + 4 * (((i + 1)/3) + 1*screenWidth/375) + ((i + 1)/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30),                            (screenWidth - 2* offSet_X )/3,                                   (screenWidth - 2* offSet_X )/3);
                }else{
                    imageNew.frame = CGRectMake(offSet_X + ((screenWidth - 2 * offSet_X )/3 + 4*screenWidth/375)*(i%3),             TableHeader + 4 * ((i/3) + 1*screenWidth/375) + (i/3) *((screenWidth - 2* offSet_X )/3) + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30),                            (screenWidth - 2* offSet_X )/3,                                   (screenWidth - 2* offSet_X )/3);
                }
                imageNew.contentMode = UIViewContentModeScaleAspectFill;
                [imageNew sd_setImageWithURL: [Helper imageIconUrl:[ymData.showImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"moren"]];
            }
            
            imageNew.userInteractionEnabled = YES;
            imageNew.clipsToBounds = YES;
            
            YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageNew addGestureRecognizer:tap];
            tap.appendArray = ymData.showImageArray;
            imageNew.backgroundColor = [UIColor clearColor];
            imageNew.tag = kImageTag + i;
            
            
            [self.contentView addSubview:imageNew];
            [_imageArray addObject:imageNew];
            //        [self.littleArray addObject:imageNew.image];
        }
    }
    
#pragma mark - /////点赞部分
    float origin_Y = 10;
    NSUInteger scale_Y = 0;
    if (ymData.showImageArray.count == 1) {
        if (ymData.JavaRubbish == 2) {
            scale_Y = 0;
        }else{
            scale_Y = 3;
        }
    }else{
        scale_Y = ymData.showImageArray.count - 1;
    }
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        //视频相关判断
        if ([ymData.messageBody.thumbnailImageURL containsString:@"userMoodVideoimage"]) {
            scale_Y = 3;
        }else{
            scale_Y = 0;
            balanceHeight = - ShowImage_H - kDistance ;
        }
    }
    
    float backView_Y = 0;
    float backView_H = 0;
    
    
    //距离View
    _distance.frame = CGRectMake(offSet_X,TableHeader + ShowImage_H + (ShowImage_H + 4*screenWidth/375)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30*screenWidth/375)*screenWidth/375 + balanceHeight*screenWidth/375, (screenWidth - offSet_X -20*screenWidth/375), 30*screenWidth/375);
    //    _distance.backgroundColor = [UIColor blueColor];
    
    //定位label
    //    _labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(_locationImg.x+_locationImg.width+2,_distance.height/10*1,100*screenWidth/375,_distance.height/10*8)];
    _labelDistance.frame = CGRectMake(_locationImg.x+_locationImg.width+2,_distance.height/10*1,80*screenWidth/375,_distance.height/10*8);
    //    _labelDistance.backgroundColor = [UIColor blackColor];
    _labelDistance.font = [UIFont systemFontOfSize:13*screenWidth/375];
    //    _labelDistance.text =@"9909.99公里";
    _labelDistance.text = [NSString stringWithFormat:@"%@公里",ymData.distance];
    _labelDistance.textColor = [UIColor lightGrayColor];
    //    [_distance addSubview:_labelDistance];
    
    //    ([tempDate.distance intValue] == 0 || ymData.golfName == nil)
    if ([ymData.golfName isKindOfClass:[NSNull class]] || ([tempDate.distance intValue] == 0)) {
        _distance.hidden = YES;
        ymData.isHaveDistance = YES;
        tempDate.isHaveDistance = YES;
    }else{
        _distance.hidden = NO;
        ymData.isHaveDistance = NO;
        tempDate.isHaveDistance = NO;
    }
    
    //球场
    _labelCities.frame = CGRectMake(_labelDistance.x+_labelDistance.width+2*screenWidth/375,_distance.height/10*1, _distance.frame.size.width - _locationImg.frame.size.width - _labelDistance.frame.size.width - 10*screenWidth/375 ,_distance.height/10*8);
    //    _labelCities.backgroundColor = [UIColor redColor];
    _labelCities.textColor = [UIColor lightGrayColor];
    _labelCities.font = [UIFont systemFontOfSize:13*screenWidth/375];
    _labelCities.text = [NSString stringWithFormat:@"%@",ymData.golfName];
    
    _totalCellHeight += _distance.y+_distance.height;
    
    //足迹View
    _footView.frame = CGRectMake(offSet_X, _distance.y+_distance.height + 5, screenWidth - offSet_X -30*screenWidth/375, ([ymData.moodType intValue] == 0)?0:30*screenWidth/375);
    //    _footView.backgroundColor = [UIColor yellowColor];
    //来自足迹
    _labelFoot.frame = CGRectMake(3*screenWidth/375, _footView.height/10*1, 70*screenWidth/375,_footView.height/10*8);
    //    _labelFoot.backgroundColor = [UIColor whiteColor];
    _labelFoot.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _labelFoot.text = @"来自足迹";
    _labelFoot.textColor = [UIColor lightGrayColor];
    //    [_footView addSubview:_labelFoot];
    
    //足迹时间
    _footTime.frame = CGRectMake(_labelFoot.x+_labelFoot.width+2*screenWidth/375,_footView.height/10*1, 90*screenWidth/375,_footView.height/10*8);
    //    _footTime.backgroundColor = [UIColor whiteColor];
    _footTime.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _footTime.text = [NSString stringWithFormat:@"%@",ymData.playTime];
    _footTime.textColor = [UIColor lightGrayColor];
    //    [_footView addSubview:_footTime];
    
    //杆数
    _footNum.frame = CGRectMake(_footTime.x+_footTime.width+2*screenWidth/375,_footView.height/10*1, 50*screenWidth/375,_footView.height/10*8);
    //    _footNum.backgroundColor = [UIColor whiteColor];
    _footNum.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _footNum.text = [NSString stringWithFormat:@"%@杆",ymData.poleNum];
    _footNum.textColor = [UIColor lightGrayColor];
    
    
    _totalCellHeight += _footView.y+_footView.height;
    
    
    //赞、评论、分享View
    _zpfView.frame = CGRectMake(screenWidth/2-15*screenWidth/375, (([ymData.moodType intValue] == 0)?(_distance.y+_distance.height):(_footView.y+_footView.height))+ 5*screenWidth/375 - (ymData.isHaveDistance ? 30 : 0) *screenWidth/375, screenWidth - (screenWidth/2 - 15*screenWidth/375) - 15*screenWidth/375, 30*screenWidth/375);
    //    _zpfView.backgroundColor = [UIColor purpleColor];
    
    //点赞
    _zanBtn.frame = CGRectMake(5*screenWidth/375,_distance.height/10*1,(_zpfView.width - 10)/3,_distance.height/10*8);
    _zanBtn.layer.cornerRadius = 5.0f;
    _zanBtn.layer.borderWidth = 1.0f;
    [_zanBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    _zanBtn.imageEdgeInsets = UIEdgeInsetsMake(-2*screenWidth/375, 0, -2*screenWidth/375, 10*screenWidth/375);
    if ([ymData.assistState intValue] == 0) {
        [_zanBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    }else{
        [_zanBtn setImage:[UIImage imageNamed:@"dz"] forState:UIControlStateNormal];
    }
    
    _zanBtn.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    
    [_zanBtn setTitle:[NSString stringWithFormat:@"%@",ymData.assistCount] forState:UIControlStateNormal];
    
    //    [_zanBtn setTitle:@"3333" forState:UIControlStateNormal];
    [_zanBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_zanBtn addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    _zanBtn.tag = 1;
    //    [_zpfView addSubview:_zanBtn];
    
    
    
    //评论
    _disCussBtn.frame = CGRectMake(_zanBtn.x+_zanBtn.width+2*screenWidth/375,_distance.height/10*1, (_zpfView.width - 10)/3,_distance.height/10*8);
    _disCussBtn.layer.cornerRadius = 5.0f;
    _disCussBtn.layer.borderWidth = 1.0f;
    [_disCussBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    _disCussBtn.imageEdgeInsets = UIEdgeInsetsMake(-2*screenWidth/375, 0, -2*screenWidth/375, 10*screenWidth/375);
    [_disCussBtn setImage:[UIImage imageNamed:@"pinlun"] forState:UIControlStateNormal];
    [_disCussBtn setTitle:[NSString stringWithFormat:@"%@",ymData.commentCount] forState:UIControlStateNormal];
    _disCussBtn.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    [_disCussBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_disCussBtn addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    _disCussBtn.tag = 0;
    //    [_zpfView addSubview:_disCussBtn];
    
    //分享
    _shareBtn.frame = CGRectMake(_disCussBtn.x+_disCussBtn.width+2*screenWidth/375,_distance.height/10*1, (_zpfView.width - 10)/3,_distance.height/10*8);
    _shareBtn.layer.cornerRadius = 5.0f;
    _shareBtn.layer.borderWidth =1.0f;
    [_shareBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    [_shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [_shareBtn setTitle:[NSString stringWithFormat:@"%@",ymData.forwardNum] forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(-2*screenWidth/375, -5*screenWidth/375 , -2*screenWidth/375, 10*screenWidth/375);
    //    [_zpfView addSubview:_shareBtn];
    _shareBtn.tag = 2;
    [_shareBtn addTarget:self action:@selector(operationDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _totalCellHeight += _zpfView.y+_zpfView.height;
    
    //回复灰色背景
    replyImageView.frame = CGRectMake(offSet_X,_zpfView.y+_zpfView.height + 5*screenWidth/375 , screenWidth - offSet_X - 5*screenWidth/375, ((ymData.favourHeight == 0)?0:30*screenWidth/375) + (([ymData.forwardNum intValue] == 0)?0:30*screenWidth/375));//微调
    
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_ymFavourArray removeAllObjects];
    
    
    //点赞图片的位置
    _favourImage.frame = CGRectMake(replyImageView.x + 5,replyImageView.y + 5, (ymData.favourHeight == 0)?0:20*screenWidth/375,(ymData.favourHeight == 0)?0:20*screenWidth/375);
    [self.contentView addSubview:_favourImage];
    
    //点赞名称显示
    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(_favourImage.x+_favourImage.width + 5*screenWidth/375, replyImageView.y + 5*screenWidth/375 ,screenWidth - offSet_X -_favourImage.width - 60*screenWidth/375, (ymData.favourHeight == 0)?0:20*screenWidth/375)];
    favourView.delegate = self;
    //    favourView.backgroundColor = [UIColor brownColor];
    favourView.attributedData = ymData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.canClickAll = NO;
    favourView.textColor = [JKSlideSwitchView colorFromHexRGB:@"32b14d"];
    
    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
    [self.contentView addSubview:favourView];
    
    backView_H += ((ymData.favourHeight == 0)?0:20*screenWidth/375);
    [_ymFavourArray addObject:favourView];
    
    
    // 更多点赞显示
    _moreLikeBtn.frame = CGRectMake(screenWidth - 50 *screenWidth/375, replyImageView.y + 5*screenWidth/375 ,50*screenWidth/375, (ymData.favourHeight == 0)?0:20*screenWidth/375);
    
    [_moreLikeBtn setImage:[UIImage imageNamed:@"genduo"] forState:(UIControlStateNormal)];
    
    
    float shareHight = ([ymData.forwardNum intValue] == 0)?0:20*screenWidth/375;
    
    //分享图片的位置
    _shareImage.frame = CGRectMake(_favourImage.x,_favourImage.y+_favourImage.height+5*screenWidth/375, shareHight, shareHight);
    [self.contentView addSubview:_shareImage];
    
    //分享名称显示
    WFTextView *shareView = [[WFTextView alloc] initWithFrame:CGRectMake(_shareImage.x+_shareImage.width + 5*screenWidth/375,_shareImage.y,screenWidth - offSet_X -_shareImage.width - 60*screenWidth/375,shareHight)];
    [self.contentView addSubview:shareView];
    
    // 更多分享转发显示
    _moreShareBtn.frame = CGRectMake(screenWidth - 50 *screenWidth/375, _shareImage.y  ,50*screenWidth/375, shareHight);
    
    [_moreShareBtn setImage:[UIImage imageNamed:@"genduo"] forState:(UIControlStateNormal)];
    
    shareView.delegate = self;
    //    shareView.backgroundColor = [UIColor blueColor];
    shareView.attributedData = ymData.attributedDataShare;
    shareView.isDraw = YES;
    shareView.isFold = NO;
    shareView.canClickAll = NO;
    shareView.textColor = [UIColor greenColor];
    
    if (ymData.showShare != nil) {
        [shareView setOldString:ymData.showShare andNewString:ymData.completionShare];
    }
    //    shareView.frame = CGRectMake(_shareImage.x + _shareImage.width + 5,_shareImage.y, screenWidth - offSet_X -_shareImage.width - 20,ymData.favourHeight);
    backView_H += ((ymData.shareHeight == 0)?0:20*screenWidth/375);
    [_ymFavourArray addObject:shareView];
    
#pragma mark - ///// //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
        }
    }
    [_ymTextArray removeAllObjects];
    
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X+5*screenWidth/375,20, screenWidth - offSet_X - 15*screenWidth/375, 0)];
        //        _ilcoreText.backgroundColor = [UIColor redColor];
        
        if (i == 0) {
            backView_Y = TableHeader + 10*screenWidth/375 + ShowImage_H + (ShowImage_H + 10*screenWidth/375)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30*screenWidth/375);
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        //        NoteModel *model = [NoteHandlle selectNoteWithUID:ymData.uId];
        //        if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
        //        }else{
        //            body.replyUser = model.userremarks;
        //        }
        
        if ([body.repliedUser isEqualToString:@""]) {
            
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X+5*screenWidth/375,origin_Y + _shareImage.y + _shareImage.height-10, screenWidth - offSet_X - 15*screenWidth/375, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        
        origin_Y += [_ilcoreText getTextHeight] + 1*screenWidth/375;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count - 1)*1*screenWidth/375;
    
    if (ymData.replyDataSource.count != 0) {//没回复的时候
        replyImageView.height = backView_H +15*screenWidth/375;
    }
    _totalCellHeight += replyImageView.y+replyImageView.height;
}

// 关注按钮点击方法
- (void)attentionAct{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue] == tempDate.userId) {
    }else{
        [_attentionBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
    }
}

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    });
}

- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if (index == -1) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = clickString;
    }else{
        [_delegate longClickRichText:_stamp replyIndex:index];
    }
}

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if ([clickString isEqualToString:@""] && index != -1) {
        //reply
        //NSLog(@"reply");
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
        if ([clickString isEqualToString:@""]) {
            //
        }else{
            [WFHudView showMsg:clickString inView:nil];
        }
    }
}

- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)operationDidClicked:(UIButton *)sender {
    //    [self dismiss];
    if (self.didSelectedOperationCompletion) {
        self.didSelectedOperationCompletion(sender.tag);
    }
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag withLittleArray:_imageArray];
}
#pragma mark -- 视频播放事件
- (void)tapVedioImageView:(YMTapGestureRecongnizer *)tapGes{
    if (self.delegate) {
        [self.delegate playWithStopVideoURL:tempDate.messageBody.videoPath];
    }
}
-(void)entSelf:(UITapGestureRecognizer*)tap {
    self.blockSelf(tap.view.tag);
    
}

- (NSMutableArray *)littleArray{
    if (!_littleArray) {
        _littleArray = [[NSMutableArray alloc] init];
    }
    return _littleArray;
}

@end
