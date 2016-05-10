//
//  PicArrShowViewControllerViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/23.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamPhotoEditViewController.h"


#import "Helper.h"
#import "UIImageView+WebCache.h"

#import "Helper.h"
#import "PostDataRequest.h"
@interface TeamPhotoEditViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>


@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *selectImages;

@property (assign, nonatomic) CGPoint offset;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation TeamPhotoEditViewController

- (instancetype)initWithIndex:(NSInteger)index selectImages:(NSMutableArray *)selectImages {
    
    self = [super init];
    
    if (self) {
        
        self.index = index;
        self.selectImages = selectImages;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"第%ld/%lu张", self.index + 1, (unsigned long)self.selectImages.count];
    
    if ([_forrevent integerValue] != 3 && [_forrevent integerValue] != 5) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edittingClick)];
        item.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    
    
    [self initializeUserInterface];
}




-(void)edittingClick
{
    
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除照片",@"设为封面", nil];
    [selestSheet showInView:self.view];
 
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self userDeletePhoto];
    }else if (buttonIndex == 1) {
        [self userFirstPhoto];
    }
}

-(void)userDeletePhoto
{
//    //NSLog(@"%d",_index);
//    //NSLog(@"%@",_arrayId[_index]);
    [[PostDataRequest sharedInstance] postDataRequest:@"photos/deletePhoto.do" parameter:@{@"photosId":_arrayId[_index]} success:^(id respondsData) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            int flag = 0;
            if (_index + 1 == self.selectImages.count) {
                flag = 1;
                _index --;
            } else {
                for (NSInteger i = self.index + 1; i < self.scrollView.subviews.count; i ++) {
                    UIView *subView = self.scrollView.subviews[i];
                    [subView setFrame:CGRectMake(subView.frame.origin.x - CGRectGetWidth(subView.bounds), 0, CGRectGetWidth(subView.bounds), CGRectGetHeight(subView.bounds))];
                }
            }
            
            if (self.index == -1) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.selectImages removeAllObjects];
                return;
            }
            [self.selectImages removeObjectAtIndex:_index + flag];
            [_arrayId removeObjectAtIndex:_index + flag];
            [self.scrollView.subviews[_index + flag] removeFromSuperview];
            
            
            self.title = [NSString stringWithFormat:@"第%d/%d张", _index + 1, self.selectImages.count];
            self.scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
            
        }
        else
        {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    } failed:^(NSError *error) {
        
    }];
}
-(void)userFirstPhoto
{
    ////NSLog(@"%@",_selectImages[_index]);
    ////NSLog(@"%@",_photoId);
    [[PostDataRequest sharedInstance] postDataRequest:@"photos/updateGroup.do" parameter:@{@"photoGroupsId":_photoId,@"photoGroupsHomePic":_selectImages[_index]} success:^(id respondsData) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
//            [_selectImages removeObjectAtIndex:_index];
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        else
        {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    } failed:^(NSError *error) {
        
    }];

}
- (void)initializeUserInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //    blackView.backgroundColor = [UIColor blackColor];
    //    [self.view addSubview:blackView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(_index * _scrollView.bounds.size.width, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    self.offset = _scrollView.contentOffset;
    [self.view addSubview:_scrollView];
    
    [self resetScrollViewSubViews];
}

- (void)resetScrollViewSubViews {
    
    for (int i = 0; i < self.selectImages.count; i++) {
        
        UIView *imgeBroundView = [[UIView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_scrollView.bounds) + 1, 0, ScreenWidth - 2, ScreenHeight-64)];
        imgeBroundView.userInteractionEnabled = YES;
        imgeBroundView.contentMode = UIViewContentModeScaleAspectFit;
        imgeBroundView.clipsToBounds = YES;
        imgeBroundView.backgroundColor = [UIColor blackColor];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:imgeBroundView.bounds];
        image.userInteractionEnabled = YES;
        [image sd_setImageWithURL:[Helper imageUrl:[self.selectImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"xiangcemoren.jpg"]];
        image.contentMode =  UIViewContentModeScaleAspectFit;
        image.tag = 1000 + i;
        [imgeBroundView addSubview:image];
        [self.scrollView addSubview:imgeBroundView];
        
        
        UILongPressGestureRecognizer * longTapSave = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageGest:)];
        longTapSave.minimumPressDuration = 0.5f;
        [image addGestureRecognizer:longTapSave];

    }
}

-(void)saveImageGest:(UILongPressGestureRecognizer *)tap{
    
    if ([tap state] == UIGestureRecognizerStateBegan) {        
        [Helper alertViewWithTitle:@"是否保存此照片" withBlockCancle:^{
            
        } withBlockSure:^{
            UIImageView *svView = (UIImageView *)[self.view viewWithTag:tap.view.tag];
            UIImageWriteToSavedPhotosAlbum(svView.image ,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
        
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.title = [NSString stringWithFormat:@"第%.0f/%lu张", scrollView.contentOffset.x /scrollView.frame.size.width+ 1, (unsigned long)self.selectImages.count];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.offset.x > scrollView.contentOffset.x) {
        self.index --;
    } else if (self.offset.x < scrollView.contentOffset.x){
        self.index ++;
    }
    self.offset = scrollView.contentOffset;
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
