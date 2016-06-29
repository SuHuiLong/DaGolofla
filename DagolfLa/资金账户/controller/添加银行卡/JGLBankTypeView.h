//
//  JGLBankTypeView.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGLBankTypeView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView* _collectionView;
}


-(id) initBankAlert;

//-(void) show;

@property(strong,nonatomic)void(^callBackTitle)(NSInteger,NSString* );
@end
