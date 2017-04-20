
//
//  VipCardOrderDetailFormatData.m
//  DagolfLa
//
//  Created by SHL on 2017/4/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderDetailFormatData.h"
#import "VipCardOrderDetailModel.h"
@implementation VipCardOrderDetailFormatData

-(NSMutableArray *)formatData:(id)data{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSDictionary *cardTypeDict = [data objectForKey:@"cardType"];
    NSDictionary *luserDict = [data objectForKey:@"luser"];
    NSDictionary *orderDict = [data objectForKey:@"order"];
    //订单号
    NSString *orderNumberStr = [orderDict objectForKey:@"ordersn"];
    //下单时间
    NSString *orderTimeStr = [orderDict objectForKey:@"ts"];
    orderTimeStr = [orderTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    orderTimeStr = [orderTimeStr substringToIndex:orderTimeStr.length-3];
    //销售人员手机号
    NSString *sellMobile = [orderDict objectForKey:@"sellMobile"];
    if (sellMobile.length==0) {
        sellMobile = @"无";
    }
    //费用
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",[orderDict objectForKey:@"totalMoney"]];
    //订单状态
    NSString *stateStr = [orderDict objectForKey:@"stateShowString"];
    //订单实际状态
    _stateButtonString = [orderDict objectForKey:@"stateButtonString"];
    //会籍编号
    NSString *cardNum = [NSString string];
    if ([data objectForKey:@"userCardIds"]) {
        cardNum = [NSString stringWithFormat:@"%@",[data objectForKey:@"userCardIds"]];
    }
    //会籍名称
    NSString *name = [cardTypeDict objectForKey:@"name"];
    //权益
    NSString *enjoyService = [cardTypeDict objectForKey:@"enjoyService"];
    //权益细则
    NSString *enjoyDetail = @"权益细则请查阅《君高高尔夫会籍入会协议书》";
    //用户名
    NSString *userName = [luserDict objectForKey:@"userName"];
    //性别 0：女 1：男
    NSInteger sex = [[luserDict objectForKey:@"sex"] integerValue];
    NSString *sexStr = @"男";
    if (sex == 0) {
        sexStr = @"女";
    }
    //证件号
    NSString *certNumber = [luserDict objectForKey:@"certNumber"];
    //预留号码
    NSString *mobileStr = [luserDict objectForKey:@"mobile"];
    
    NSArray *titleArray = @[@[@"订单号",@"下单时间",@"销售人员",@"支付费用",@"订单状态"],@[@"会籍名称",@"会籍权益",@""],@[@"用户名",@"性别",@"证件号",@"预留号码"]];
    NSArray *contentArray = @[@[orderNumberStr,orderTimeStr,sellMobile,priceStr,stateStr],@[name,enjoyService,enjoyDetail],@[userName,sexStr,certNumber,mobileStr]];

    if (cardNum.length>0) {
        titleArray = @[@[@"订单号",@"下单时间",@"销售人员",@"支付费用",@"订单状态"],@[@"会籍编号",@"会籍名称",@"会籍权益",@""],@[@"用户名",@"性别",@"证件号",@"预留号码"]];
        contentArray = @[@[orderNumberStr,orderTimeStr,sellMobile,priceStr,stateStr],@[cardNum,name,enjoyService,enjoyDetail],@[userName,sexStr,certNumber,mobileStr]];

    }
    
    for (int i = 0; i<titleArray.count; i++) {
        NSMutableArray *mArray = [NSMutableArray array];
        NSArray *titleIndexArray = titleArray[i];
        NSArray *contentIndexArray = contentArray[i];
        for (int j = 0; j < titleIndexArray.count; j++) {
            VipCardOrderDetailModel *model = [[VipCardOrderDetailModel alloc] init];
            model.title = titleIndexArray[j];
            model.content = contentIndexArray[j];
            model.status = 0;
            if (i==1) {
                if (titleIndexArray.count==4) {
                    if (j==0||j==1) {
                        model.status = 1;
                    }else if (j==3){
                        model.status = 2;
                    }
                
                }else{
                    if (j==0) {
                        model.status = 1;
                    }else if (j==2){
                        model.status = 2;
                    }
                }
            }
            [mArray addObject:model];
        }
        [dataArray addObject:mArray];
    }

    return dataArray;
}

@end
