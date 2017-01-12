//
//  YMShowImageView.m
//  WFCoretext
//
//  Created by 阿虎 on 14/11/3.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height


#import "YMShowImageView.h"

#import "Helper.h"
#import "UIImageView+WebCache.h"



@implementation YMShowImageView{

    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
    NSMutableArray *_ltlleArra;
}



- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray withLittleArray:(NSMutableArray *)littleArray{

    self = [super initWithFrame:frame];
    if (self) {
        
        self_Frame = frame;
        _littleArray = littleArray;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
  
           }
    return self;
}

-(void)saveImage:(UILongPressGestureRecognizer *)tap{
    
       if ([tap state] == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存此张照片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = tap.view.tag;
            }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImageView *svView = [self viewWithTag:alertView.tag];
        UIImageWriteToSavedPhotosAlbum(svView.image ,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    }else{

    }
}


-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if(!error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片保存成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片保存失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
}





- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray{

    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
    
    
    for (int i = 0; i < appendArray.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 1, 1)];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;

        imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longTapGser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        longTapGser.minimumPressDuration = 0.5f;
//        longTapGser.
        [self addGestureRecognizer:longTapGser];
        [imageView addGestureRecognizer:longTapGser];
        
        [UIView animateWithDuration:0.5f animations:^(){
            UIImageView *image = _littleArray[i];
            [imageView sd_setImageWithURL: [Helper imageUrl:[appendArray objectAtIndex:i]] placeholderImage:image.image];
            imageView.frame = self.bounds;
        } completion:^(BOOL finished) {
        }];
        


        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        
        
    }
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - 9999), 0) animated:YES];
    page = clickTag - 9999;

}

- (void)disappear{
    //发出通知隐藏标签栏
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];

    _removeImg();
   
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes{

    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
      
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;

}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
   
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
   // //NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;

}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
     [bgView addSubview:self];
    //发出通知隐藏标签栏
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
     _removeImg = tempBlock;
     [UIView animateWithDuration:0.5f animations:^(){
         
         self.alpha = 1.0f;
    
      } completion:^(BOOL finished) {
        
     }];

}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
   
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
    
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
   // //NSLog(@"page == %d",page);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
  

}

@end
