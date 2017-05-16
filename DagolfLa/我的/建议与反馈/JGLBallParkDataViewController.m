//
//  JGLBallParkDataViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLBallParkDataViewController.h"
#import "UITool.h"
#import "BallParkViewController.h"
#import "SXPickPhoto.h"
#import "JGLWriteReplyViewController.h"
#define TextViewDetail @"请描述一下您发现的问题"
@interface JGLBallParkDataViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView* _scrollView;
    UITextView* _textView;
    UITextField* _textField;
    NSString* _str;
    UILabel* _labelPark;
    UIButton* _btnImage;
    NSMutableArray* _arrayData;//存照片的数组
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@end

@implementation JGLBallParkDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球场纠错内容";
    self.view.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    self.pickPhoto = [[SXPickPhoto alloc]init];
    _arrayData     = [[NSMutableArray alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _scrollView.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    [self.view addSubview:_scrollView];
    
    
    [self createBallParkChoose];
    
    [self createQuestion];
    
    [self createPhoto];
    
    [self createPhoneNum];
    
    [self createBtn];
    
}

-(void)createBallParkChoose
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, screenWidth, 58*ProportionAdapter);
    [btn addTarget:self action:@selector(ballParkClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 13*ProportionAdapter, screenWidth - 70*ProportionAdapter, 30*ProportionAdapter)];
    _labelPark.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    _labelPark.backgroundColor = [UIColor whiteColor];
    _labelPark.text = @" 选择纠错球场";
    if ([_labelPark.text isEqualToString:@" 选择纠错球场"] == YES) {
        _labelPark.textColor = [UIColor lightGrayColor];
    }
    else{
        _labelPark.textColor = [UIColor blackColor];
    }
    
    [btn addSubview:_labelPark];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(screenWidth - 50*ProportionAdapter, 13*ProportionAdapter, 30*ProportionAdapter, 30*ProportionAdapter)];
    view.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    view.userInteractionEnabled = NO;
    [btn addSubview:view];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"y_jiantou"];
    [view addSubview:imgv];
    
    UIView* viewLine = [[ UIView alloc]initWithFrame:CGRectMake(0, 57*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [btn addSubview:viewLine];
    
}

-(void)ballParkClick:(UIButton* )btn
{
    //选择球场
    BallParkViewController* ballVc = [[BallParkViewController alloc]init];
    [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
        _labelPark.text = balltitle;
        if ([_labelPark.text isEqualToString:@" 选择纠错球场"] == YES) {
            _labelPark.textColor = [UIColor lightGrayColor];
        }
        else{
            _labelPark.textColor = [UIColor blackColor];
        }
    }];
    [self.navigationController pushViewController:ballVc animated:YES];
}

-(void)createQuestion
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 58*ProportionAdapter, screenWidth, 107.5*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 17.5*ProportionAdapter, screenWidth - 40*ProportionAdapter, 75*ProportionAdapter)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.text = TextViewDetail;
    if ([_textView.text isEqualToString:TextViewDetail] == YES) {
        _textView.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    }
    else{
        _textView.textColor = [UIColor blackColor];
    }
    _textView.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [view addSubview:_textView];
    
    UIView* viewLine = [[ UIView alloc]initWithFrame:CGRectMake(0, 107.5*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [view addSubview:viewLine];
}


#pragma mark --textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //判断为空
    if ([Helper isBlankString:_str]) {
        textView.text = nil;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([_textView.text isEqualToString:TextViewDetail] == YES || [Helper isBlankString:_textView.text]) {
        _textView.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    }
    else{
        _textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([Helper isBlankString:textView.text]) {
        textView.text = TextViewDetail;
        _str = nil;
    }else {
        _str = textView.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
    }
    return YES;
}

-(void)createPhoto
{
    //165.5+102
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 180*ProportionAdapter, screenWidth-40*ProportionAdapter, 102*ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    

    
    _btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnImage.frame = CGRectMake(10*ProportionAdapter, 20*ProportionAdapter, 63*ProportionAdapter, 63*ProportionAdapter);
    [_btnImage setBackgroundImage:[UIImage imageNamed:@"addPIC"] forState:UIControlStateNormal];
    [_btnImage addTarget:self action:@selector(upDataPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnImage];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(85*ProportionAdapter, 20*ProportionAdapter, screenWidth - 135*ProportionAdapter, 63*ProportionAdapter)];
    label.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    label.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    label.numberOfLines = 2;
    label.text = @"拍照上传球场记分卡，便于我们及时核对及更新相关数据。（选填）";
    [view addSubview:label];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 297*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [_scrollView addSubview:viewLine];
}
#pragma mark --获取相册或者拍照权限
-(void)upDataPhotoClick
{
    
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            _arrayData = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [_btnImage setImage:(UIImage *)Data forState:UIControlStateNormal];
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        _pickPhoto.picker.allowsEditing = NO;
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            _arrayData = [NSMutableArray arrayWithObject:UIImageJPEGRepresentation((UIImage *)Data, 0.7)];
            [_btnImage setImage:(UIImage *)Data forState:UIControlStateNormal];
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
    
    
}
#pragma mark --上传图片方法
-(void)imageArray:(NSMutableArray *)array withDict:(NSMutableDictionary *)dictData
{
    [[JsonHttp jsonHttp] httpRequest:@"globalCode/createTimeKey" JsonKey:nil withData:nil requestMethod:@"GET" failedBlock:^(id errType) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }completionBlock:^(id data) {
        NSNumber* TimeKey = [data objectForKey:@"timeKey"];
        
        /**
         上传图片
         */
        NSMutableDictionary* dictMedia = [[NSMutableDictionary alloc]init];
        [dictMedia setObject:[NSString stringWithFormat:@"%@" ,TimeKey] forKey:@"data"];
        [dictMedia setObject:TYPE_FEEDBACK_HEAD forKey:@"nType"];
        [dictMedia setObject:@"dagolfla" forKey:@"tag"];
        [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dictMedia andDataArray:array failedBlock:^(id errType) {
            NSLog(@"errType===%@", errType);
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        } completionBlock:^(id data) {
            /**
             上传图片的参数
             */
            [dictData setObject:TimeKey forKey:@"imgs"];
            if ([[data objectForKey:@"code"] integerValue] == 1) {
                [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"feedback/createFeedback" JsonKey:@"feedBack" withData:dictData failedBlock:^(id errType) {
                    
                } completionBlock:^(id data) {
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        JGLWriteReplyViewController* reVc = [[JGLWriteReplyViewController alloc]init];
                        [self.navigationController pushViewController:reVc animated:YES];
                    }
                    else{
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }];
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [Helper alertViewWithTitle:@"上传图片失败" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        }];
        
    }];
}



-(void)createPhoneNum
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 297*ProportionAdapter, screenWidth, 45*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 15*ProportionAdapter, screenWidth - 40*ProportionAdapter, 30*ProportionAdapter)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.placeholder = @"请留下联系方式";
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [view addSubview:_textField];
    
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth/2 - 50*ProportionAdapter, 422*ProportionAdapter, 100*ProportionAdapter, 44*ProportionAdapter);
    btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    [self.view addSubview:btn];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 22*ProportionAdapter;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)upDataClick:(UIButton *)btn
{

    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([Helper isBlankString:_labelPark.text] || [_labelPark.text isEqualToString:@" 选择纠错球场"] == YES) {
        [[ShowHUD showHUD]showToastWithText:@"陛下：请明示臣妾哪里错了嘛！" FromView:self.view];
        return;
    }
    else{
        [dict setObject:_labelPark.text forKey:@"ballName"];
    }
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]) {
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"userMobile"];
    }
    [dict setObject:@0 forKey:@"type"];//球场
    if ([Helper isBlankString:_textView.text] || [_textView.text isEqualToString:TextViewDetail] == YES) {
        [[ShowHUD showHUD]showToastWithText:@"陛下：请指出哪里出了问题，臣妾立马改正。" FromView:self.view];
        [self.view endEditing:YES];
        return;
    }
    else{
        [dict setObject:_textView.text forKey:@"describe"];
    }
    if (![Helper isBlankString:_textField.text]) {
        [dict setObject:_textField.text forKey:@"contactWay"];
    }
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    if (_arrayData.count == 0) {
        [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"feedback/createFeedback" JsonKey:@"feedBack" withData:dict failedBlock:^(id errType) {
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                JGLWriteReplyViewController* reVc = [[JGLWriteReplyViewController alloc]init];
                [self.navigationController pushViewController:reVc animated:YES];
            }
            else{
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        }];
    }
    else{
        [self imageArray:_arrayData withDict:dict];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    }
    
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
