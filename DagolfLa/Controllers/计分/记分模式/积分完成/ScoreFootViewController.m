//
//  ScoreFootViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/11.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreFootViewController.h"
#import "ZYQAssetPickerController.h"
#import "IWTextView.h"
#import "Helper.h"
#import "BrowseImagesViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "MyFootViewController.h"

#import "MBProgressHUD.h"

#define LINE_COUNT 4
@interface ScoreFootViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate>
{
    
    IWTextView* _textView;
    UIView* _viewBase;
    UIScrollView* _scrollView;
    CGFloat _contentSizeY;
    
    UIView* _viewLine;
    UIView* _viewArea;
    UIButton* _fabuBtn;
    
    int indexBtn;
    
    UILabel* _labelChoose;
    
    UIButton* _btnAdd;
    UIButton* _btnNotAdd;
    NSInteger _btnNum;
    NSMutableArray* _arrayCamera;
    //是否同步
    BOOL _isTongbu;
    
    //发布足迹、社区
    NSMutableDictionary* _dict;
    //同步按钮
    UIButton* _btnTongbu;
    
    MBProgressHUD* _progress;
}
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) NSMutableArray *selectButtons;
@end


@implementation ScoreFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    self.title = @"添加足迹";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
   
    _dict = [[NSMutableDictionary alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 568);
    _arrayCamera = [[NSMutableArray alloc]init];
    //球场
    [self createArea];
    
    //时间和杆数
    [self createTimeAndNum];
    
    //发布状态，心情，照片
    [self createState];
    
    //创建按钮和提示信息
    [self createLastBtn];
    
    //创建照片和心情视图
    [self createView];
    
    /**
     相册照片添加的执行方法
     
     :returns:
     */
    [self initializeDataSource];
    [self initializeUserInterface];
    
    //添加按钮
    [self createButton];
}

-(void)backButtonClcik
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createArea
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(2*ScreenWidth/375, 12*ScreenWidth/375, ScreenWidth - 4*ScreenWidth/375, 40*ScreenWidth/375)];
    viewBase.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewBase];
    viewBase.layer.masksToBounds = YES;
    viewBase.layer.cornerRadius = 8*ScreenWidth/375;
    
    
    UILabel* labelPark = [[UILabel alloc]initWithFrame:CGRectMake(12*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-24*ScreenWidth/375, 20)];
    labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    labelPark.text = _strBallName;
    [viewBase addSubview:labelPark];
    
}

-(void)createTimeAndNum
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(2*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth/2 - 4*ScreenWidth/375, 40*ScreenWidth/375)];
    [_scrollView addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    viewBase.layer.masksToBounds = YES;
    viewBase.layer.cornerRadius = 8*ScreenWidth/375;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewBase.frame.size.width, viewBase.frame.size.height)];
    label.text = _strTime;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [viewBase addSubview:label];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8*ScreenWidth/375;
    
    
    UIView* viewNum = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 2*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth/2 - 4*ScreenWidth/375, 40*ScreenWidth/375)];
    [_scrollView addSubview:viewNum];
    viewNum.backgroundColor = [UIColor whiteColor];
    viewNum.layer.masksToBounds = YES;
    viewNum.layer.cornerRadius = 8*ScreenWidth/375;
    
    
    UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewNum.frame.size.width, viewNum.frame.size.height)];
    labelNum.text = _strNums;
    labelNum.textAlignment = NSTextAlignmentCenter;
    labelNum.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [viewNum addSubview:labelNum];
    labelNum.layer.masksToBounds = YES;
    labelNum.layer.cornerRadius = 8*ScreenWidth/375;
}


//文字设置
-(void)createView
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 110*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [_scrollView addSubview:_viewBase];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 80*ScreenWidth/375)];
//    _textView.backgroundColor=[UIColor redColor]; //背景色
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.placeholder = @"说点什么吧";
    [_viewBase addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
}
/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    
    [textField resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}







#pragma mark -- 图片选择
//图片选择
- (void)initializeDataSource {
    
    _selectButtons = [[NSMutableArray alloc] init];
    _selectImages = [[NSMutableArray alloc] init];
}

- (void)initializeUserInterface {
    
    _imageWidth = (ScreenWidth - ((LINE_COUNT + 1) * 20*ScreenWidth/375)) / LINE_COUNT;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 200*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, _imageWidth + 2 *10 *ScreenWidth/375)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [_scrollView addSubview:_contentView];
    
    _contentSizeY = _contentSizeY + _imageWidth + 2 *10 *ScreenWidth/375;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth);
//    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
//    _addButton.layer.borderWidth = 1;
//    _addButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_addButton];
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选照片", nil];
    
    _labelChoose = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 220*ScreenWidth/375+_imageWidth, 200*ScreenWidth/375, 44*ScreenWidth/375)];
    _labelChoose.text = @"是否同步到社区";
    _labelChoose.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labelChoose.textColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_labelChoose];
    
    _btnTongbu = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTongbu.frame = CGRectMake(ScreenWidth-54*ScreenWidth/375, 220*ScreenWidth/375+_imageWidth, 44*ScreenWidth/375, 44*ScreenWidth/375);
    //    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_btnTongbu setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    
    
    [_btnTongbu addTarget:self action:@selector(tongbuClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btnTongbu];
    
}
-(void)tongbuClick:(UIButton *)btn
{
    if (_isTongbu == YES) {
        [btn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        _isTongbu = NO;
    }
    else{
        [btn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
        _isTongbu = YES;
    }
}
/**
 *  按钮添加
 *
 *  @return
 */
-(void)createButton
{
    _btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, 274*ScreenWidth/375+_imageWidth, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _btnAdd.layer.masksToBounds = YES;
    _btnAdd.layer.cornerRadius = 8*ScreenWidth/375;
    [_btnAdd setTitle:@"添加足迹" forState:UIControlStateNormal];
    [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAdd.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_btnAdd];
    [_btnAdd addTarget:self action:@selector(footClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnNotAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnNotAdd.frame = CGRectMake(10*ScreenWidth/375, 328*ScreenWidth/375+_imageWidth, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    _btnNotAdd.layer.masksToBounds = YES;
    _btnNotAdd.layer.cornerRadius = 8*ScreenWidth/375;
    [_btnNotAdd setTitle:@"记分完成暂不添加足迹" forState:UIControlStateNormal];
    [_btnNotAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnNotAdd.backgroundColor = [UIColor orangeColor];
    [_btnNotAdd addTarget:self action:@selector(notAddClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btnNotAdd];
    
}


#pragma mark --记分完成并且添加到足迹
-(void)footClick:(UIButton *)btn
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在添加记分卡...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"uId"];
    //心情状态
    [_dict setObject:_textView.text forKey:@"moodContent"];

    NSString* xIndex = [[NSString alloc]init];
    xIndex  = [NSString stringWithFormat:@"%@",self.lat];
    [_dict setValue:self.lat forKey:@"xIndex"];
    
    NSString* yIndex = [[NSString alloc]init];
    yIndex  = [NSString stringWithFormat:@"%@",self.lng];
    [_dict setValue:self.lng forKey:@"yIndex"];
    
    [_dict setObject:_ballId forKeyedSubscript:@"placeId"];
    
    [_dict setObject:@1 forKeyedSubscript:@"moodType"];
    //poleNum
    [_dict setObject:_strNums forKeyedSubscript:@"poleNum"];
    //playTimes
    
    //isSync
    if (_isTongbu == YES) {
        [_dict setObject:@1 forKeyedSubscript:@"isSync"];
    }
    else
    {
        [_dict setObject:@0 forKeyedSubscript:@"isSync"];
    }
    [_dict setObject:_strTime forKeyedSubscript:@"playTimes"];
    
    ////NSLog(@"%@",_dict);
    if (![Helper isBlankString:_strBallName] && xIndex != nil && yIndex != nil) {
        if (![Helper isBlankString:_strTime]) {
            if (![Helper isBlankString:_strNums]) {
                
                [[PostDataRequest sharedInstance]postDataAndImageRequest:@"userMood/save.do" parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    btn.userInteractionEnabled = YES;
                    btn.backgroundColor = [UIColor orangeColor];
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    ////NSLog(@"%@",data);
                    
                    [Helper alertViewWithTitle:@"保存成功!" withBlockCancle:^{
                    } withBlockSure:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                        MyFootViewController* footVc = [[MyFootViewController alloc]init];
//                        footVc.typeNum = 3;
                        [self.navigationController pushViewController:footVc animated:YES];
                    } withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];

                } failed:^(NSError *error) {
                    btn.userInteractionEnabled = YES;
                    btn.backgroundColor = [UIColor orangeColor];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    });
                }];

            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor orangeColor];
                [Helper alertViewWithTitle:@"您还没有选择打球杆数" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor orangeColor];
            [Helper alertViewWithTitle:@"您还没有选择打球时间" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor orangeColor];
        [Helper alertViewWithTitle:@"您还没有选择球场" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}


#pragma mark --积分完成但是不添加到足迹
-(void)notAddClick:(UIButton *)btn
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在添加记分卡...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    _btnAdd.userInteractionEnabled = NO;
    if (_isTongbu == YES) {
        [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKeyedSubscript:@"uId"];
        //心情状态
        [_dict setObject:_textView.text forKey:@"moodContent"];
        //    NSString* str = [NSString stringWithFormat:@"%d",_isChoose];
        //    [_dict setValue:str forKey:@"isSync"];
        
        
        NSString* xIndex = [[NSString alloc]init];
        xIndex  = [NSString stringWithFormat:@"%@",self.lat];
        [_dict setValue:self.lat forKey:@"xIndex"];
        
        NSString* yIndex = [[NSString alloc]init];
        yIndex  = [NSString stringWithFormat:@"%@",self.lng];
        [_dict setValue:self.lng forKey:@"yIndex"];
        
        [_dict setObject:_ballId forKeyedSubscript:@"placeId"];
        
        [_dict setObject:@0 forKeyedSubscript:@"moodType"];
        //poleNum
        [_dict setObject:_strNums forKeyedSubscript:@"poleNum"];
        //playTimes
        
        //isSync
        [_dict setObject:@1 forKeyedSubscript:@"isSync"];
        [_dict setObject:_strTime forKeyedSubscript:@"playTimes"];
        
        if (![Helper isBlankString:_strBallName] && xIndex != nil && yIndex != nil) {
            if (![Helper isBlankString:_strTime]) {
                
                if (![Helper isBlankString:_strNums]) {
                    
                    [[PostDataRequest sharedInstance]postDataAndImageRequest:@"userMood/save.do" parameter:_dict imageDataArr:_selectImages success:^(id respondsData) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        btn.userInteractionEnabled = YES;
                        btn.backgroundColor = [UIColor orangeColor];
//                        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        ////NSLog(@"%@",data);
                        
                        [Helper alertViewWithTitle:@"保存成功!" withBlockCancle:^{
                            
                        } withBlockSure:^{
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        } withBlock:^(UIAlertController *alertView) {
                            
                            [self presentViewController:alertView animated:YES completion:nil];
                            
                        }];
                    
                    } failed:^(NSError *error) {
                        btn.userInteractionEnabled = YES;
                        btn.backgroundColor = [UIColor orangeColor];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        _btnAdd.userInteractionEnabled = YES;
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alertView show];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertView dismissWithClickedButtonIndex:0 animated:YES];
                        });
                    }];
                    
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    btn.userInteractionEnabled = YES;
                    btn.backgroundColor = [UIColor orangeColor];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打球杆数没有选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor orangeColor];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打球时间没有选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor orangeColor];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"球场没有选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }

    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor orangeColor];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    
}

#pragma mark --选择图片方法
//点击事件
- (void)addButtonClick:(UIButton *)sender {
    
    if (_selectImages.count < 9) {
        indexBtn++;
        [_textView resignFirstResponder];
        [_actionSheet showInView:_scrollView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)imageButtonPressed:(UIButton *)sender {
    
    BrowseImagesViewController *vc = [[BrowseImagesViewController alloc] initWithIndex:[_selectButtons indexOfObject:sender] selectImages:_selectImages];
    __weak ScoreFootViewController *weakSelf = self;
    
    vc.deleteBlock = ^(NSInteger index) {
        
        UIButton *button = [weakSelf.selectButtons objectAtIndex:index];
        [button removeFromSuperview];
        [weakSelf.selectButtons removeObjectAtIndex:index];
        [weakSelf updateUserInterface];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self selectFromCamera];
            break;
        case 1:
            [self selectFromPhoto];
            break;
        default:
            break;
    }
}

- (void)selectPhoto:(UITapGestureRecognizer *)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)selectFromCamera
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_arrayCamera removeAllObjects];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData* photoData = UIImageJPEGRepresentation(image, 0.7);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_arrayCamera addObject:photoData];
    
    
    //    [_selectImages addObject:_arrayCamera[0]];
    //    ALAsset *asset = _arrayCamera[0];
    UIImage *imageCamera = [UIImage imageWithData:_arrayCamera[0]];
    /**
     *  将图片转成二进制数据
     *
     *  @param image 图片
     *  @param 0.5   保真值
     *
     *  @return return value description
     */
    [_selectImages addObject:UIImageJPEGRepresentation(imageCamera, 0.7)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth)];
    [button setImage:imageCamera forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    [_selectButtons addObject:button];
    [self updateUserInterface];
}

- (void)selectFromPhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] initWithNSinter:(9-_selectImages.count)];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (int i = 0; i < assets.count; i ++) {
        ALAsset *asset = assets[i];
        ////NSLog(@"%@",assets[i]);
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        /**
         *  将图片转成二进制数据
         *
         *  @param image 图片
         *  @param 0.5   保真值
         *
         *  @return return value description
         */
        [_selectImages addObject:UIImageJPEGRepresentation(image, 0.7)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5*ScreenWidth/375, 10*ScreenWidth/375, _imageWidth, _imageWidth)];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        
        [_selectButtons addObject:button];
    }
    [self updateUserInterface];
}
//重画添加按钮和背景view的大小
- (void)updateUserInterface {
    
    [self resetAllImagePosition];
    
    
    
    _addButton.frame = [self frameWithButtonIndex:_selectButtons.count];
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, ScreenWidth-20*ScreenWidth/375, _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375);
    //重新规划文字的位置
    _labelChoose.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, 200*ScreenWidth/375, 44*ScreenWidth/375);
    _btnTongbu.frame = CGRectMake(ScreenWidth-54*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, 44*ScreenWidth/375, 44*ScreenWidth/375);
    //重写添加足迹按扭得位置
    _btnAdd.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 74*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    //重写不添加按钮的位置
    _btnNotAdd.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.origin.y+_addButton.bounds.size.height + _addButton.frame.origin.y + 128*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    
    _contentSizeY = _contentSizeY + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375 - _imageWidth + 2 *10 *ScreenWidth/375;
    
    _viewLine.frame = CGRectMake(10*ScreenWidth/375, _contentView.frame.size.height - 2, ScreenWidth -20*ScreenWidth/375, 2);
    _viewArea.frame = CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375 + _addButton.bounds.size.height + _addButton.frame.origin.y + 20*ScreenWidth/375, ScreenWidth - 20*ScreenWidth/375, 44*ScreenWidth/375);
    
    _fabuBtn.frame = CGRectMake(10*ScreenWidth/375, 174*ScreenWidth/375+ _addButton.bounds.size.height + _addButton.frame.origin.y, ScreenWidth - 20*ScreenWidth/375, 44);
}
//重设图片的位置
- (void)resetAllImagePosition {
    
    
    
    NSInteger count = _selectButtons.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        UIButton *button = _selectButtons[i];
        button.frame = [self frameWithButtonIndex:i];
        //        if (count == 9) {
        //            _addButton.hidden = YES;
        //
        //        }
        
        
    }
}

//增加一张照片，设置照片的位置
- (CGRect)frameWithButtonIndex:(NSInteger)index {
    
    index ++;
    _btnNum = index;
    NSInteger row = ceil(index * 1.0 / LINE_COUNT); // 第几行
    NSInteger cloumn = index % LINE_COUNT; // 第几列
    
    if (cloumn == 0) {
        
        cloumn += LINE_COUNT;
    }
    _scrollView.contentSize = CGSizeMake(0, ScreenHeight + (_imageWidth)*((index-1)/3)- 64-49);
    //    ////NSLog(@"%ld",index);
    return CGRectMake(10*ScreenWidth/375 * cloumn + (_imageWidth+10*ScreenWidth/375) * (cloumn - 1), 10*ScreenWidth/375 * row + _imageWidth * (row - 1), _imageWidth, _imageWidth);
}


-(void)createState
{
    
}
-(void)createLastBtn
{
    
}

@end
