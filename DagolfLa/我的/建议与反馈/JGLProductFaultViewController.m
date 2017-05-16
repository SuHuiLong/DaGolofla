//
//  JGLBallParkDataViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLProductFaultViewController.h"
#import "UITool.h"
#import "JGLWriteReplyViewController.h"
#import "SXPickPhoto.h"
#define TextViewDetail @"请描述一下您发现的问题"
@interface JGLProductFaultViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView* _scrollView;
    UITextView* _textView;
    UITextField* _textField;
    NSString* _str;
    
    UIButton* _btnImage;
    NSMutableArray* _arrayData;//存照片的数组
}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@end

@implementation JGLProductFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品缺陷反馈";
    self.view.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    _pickPhoto = [[SXPickPhoto alloc]init];
    _arrayData  = [[NSMutableArray alloc]init];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _scrollView.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    [self.view addSubview:_scrollView];
    
    
    [self createQuestion];
    
    [self createPhoto];
    
    [self createPhoneNum];
    
    [self createBtn];
    
}

-(void)createQuestion
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 107.5*ProportionAdapter)];
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
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 123.5*ProportionAdapter, screenWidth-40*ProportionAdapter, 102*ProportionAdapter)];
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
    label.text = @"拍照上传图片，便于我们正确解读您发现的问题。（选填）";
    [view addSubview:label];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [_scrollView addSubview:viewLine];
}

-(void)createPhoneNum
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ProportionAdapter, screenWidth, 45*ProportionAdapter)];
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
    btn.frame = CGRectMake(screenWidth/2 - 50*ProportionAdapter, 365*ProportionAdapter, 100*ProportionAdapter, 44*ProportionAdapter);
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
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]) {
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"userMobile"];
    }
    [dict setObject:@1 forKey:@"type"];//反馈
    if ([Helper isBlankString:_textView.text] || [_textView.text isEqualToString:TextViewDetail] == YES) {
        [[ShowHUD showHUD]showToastWithText:@"陛下：请明示臣妾哪里错了嘛！" FromView:self.view];
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
