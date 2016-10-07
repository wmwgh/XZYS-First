//
//  Order.h
//  AliSDKDemo
//
//  Created by 方彬 on 07/25/16.
//
//

#import <Foundation/Foundation.h>

@interface BizContent : NSObject



@end


@interface Order : NSObject

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * notify_url;
@property(nonatomic, copy) NSString * out_trade_no;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * payment_type;
@property(nonatomic, copy) NSString * seller_id;

@property(nonatomic, copy) NSString * total_fee;
@property(nonatomic, copy) NSString * _input_charset;

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end
