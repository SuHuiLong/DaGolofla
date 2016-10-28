//
//  JGHShowActivityPhotoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowActivityPhotoCell.h"
#import "JGHShowActivityView.h"
#import "JGDShowLiveView.h" // 直播
#import "JGDShowPhotoView.h" // 相册

#define LineColor @"#E1E1E1"


@interface JGHShowActivityPhotoCell ()
{
    JGHShowActivityView *_showActivityView;
    JGDShowLiveView *_liveView;
    JGDShowPhotoView *_photoView;
}

@end

@implementation JGHShowActivityPhotoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)configJGHShowActivityPhotoCell:(NSArray *)activtiyList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createLineCase:@"left"];
    for (int i=0; i<activtiyList.count; i++) {
        
        _showActivityView = [[JGHShowActivityView alloc]initWithFrame:CGRectMake(20 *ProportionAdapter, 60 *i *ProportionAdapter +(i+1)*17 *ProportionAdapter, screenWidth -40*ProportionAdapter, 60 *ProportionAdapter)];
        _showActivityView.backgroundColor = [UIColor whiteColor];
        [_showActivityView configJGHShowActivityView:activtiyList[i]];
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 60 *ProportionAdapter)];
        selectBtn.tag = 200 +i;
        [selectBtn addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showActivityView addSubview:selectBtn];
        _showActivityView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_showActivityView];
    }
}


- (void)configJGHShowLiveCell:(NSArray *)activtiyList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createLineCase:@"right"];
    for (int i=0; i<activtiyList.count; i++) {
        
        _liveView = [[JGDShowLiveView alloc]initWithFrame:CGRectMake(20 *ProportionAdapter, 60 *i *ProportionAdapter +(i+1)*17 *ProportionAdapter, screenWidth -40*ProportionAdapter, 60 *ProportionAdapter)];
        _liveView.backgroundColor = [UIColor whiteColor];
        [_liveView configJGHShowLiveView:activtiyList[i]];
        
//        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        selectBtn.tag = 200 +i;
//        [selectBtn addTarget:self action:@selector(liveClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_liveView addSubview:selectBtn];
        _liveView.tag = 300 + i;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveTapAct:)];
        [_liveView addGestureRecognizer:tapGes];
        [self addSubview:_liveView];
    }
}

- (void)configJGHShowPhotoCell:(NSArray *)activtiyList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createLineCase:@"middle"];
    for (int i = 0; i < [activtiyList count]; i ++) {
        if (i%2 == 0) {
            _photoView = [[JGDShowPhotoView alloc]initWithFrame:CGRectMake(22*ProportionAdapter, (i/2 +1)*10*ProportionAdapter + (i/2)*70*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 70 *ProportionAdapter)];
        }else{
            _photoView = [[JGDShowPhotoView alloc]initWithFrame:CGRectMake(13*ProportionAdapter +(screenWidth-16*ProportionAdapter)/2, (i/2 +1)*10*ProportionAdapter + (i/2)*70*ProportionAdapter, (screenWidth-24*ProportionAdapter)/2, 70 *ProportionAdapter)];
        }
        [_photoView configJGHShowPhotoView:activtiyList[i]];
        
        _photoView.tag = 500 + i;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAct:)];
        [_photoView addGestureRecognizer:tapGes];
        [self addSubview:_photoView];
    }
}

// 直播
- (void)liveTapAct:(UIGestureRecognizer *)geture{
    //    JGLScoreLiveViewController
    NSLog(@"%td",   [geture view].tag - 300);
    self.liveBlock([geture view].tag - 300);
}

// 照片
- (void)photoTapAct:(UIGestureRecognizer *)geture{
    //    JGPhotoAlbumViewController
      NSLog(@"%td",   [geture view].tag - 500);
    self.photoBlock([geture view].tag - 500);

}

- (void)activityClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(activityListSelectClick:)]) {
        [self.delegate activityListSelectClick:btn];
    }
    
    btn.enabled = YES;
}

- (void)createLineCase:(NSString *)imageName{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 160 *ProportionAdapter, screenWidth -20*ProportionAdapter, 30 *ProportionAdapter)];
    bgImageView.image = [UIImage imageNamed:@"datouying"];
    UILabel *bgLable = [[UILabel alloc]initWithFrame:CGRectMake(2 *ProportionAdapter, 0*ProportionAdapter, screenWidth - 24 *ProportionAdapter, 16 *ProportionAdapter)];
    bgLable.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:bgLable];
    
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 16*ProportionAdapter, screenWidth - 20 *ProportionAdapter, 0.5)];
    downLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    [bgImageView addSubview:downLine];
    [self addSubview:bgImageView];
    
    UIImageView *topImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 5 *ProportionAdapter, screenWidth -20*ProportionAdapter, 3)];
    topImageview.image = [UIImage imageNamed:imageName];
    [self addSubview:topImageview];
    
    UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 5 *ProportionAdapter, 0.5, 171 *ProportionAdapter)];
    leftLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    [self addSubview:leftLine];
    
    UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth -10*ProportionAdapter, 5 *ProportionAdapter, 0.5, 171 *ProportionAdapter)];
    rightLine.backgroundColor = [UIColor colorWithHexString:LineColor];
    [self addSubview:rightLine];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
