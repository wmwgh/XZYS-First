//
//  Order.m
//  AliSDKDemo
//
//  Created by 方彬 on 07/25/16.
//
//

#import "Order.h"

@implementation BizContent


@end


@implementation Order

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    
    if (self._input_charset) {
        [discription appendFormat:@"_input_charset=\"%@\"", self._input_charset];//utf-8
    }
    if (self.body) {
        [discription appendFormat:@"&body=\"%@\"", self.body];
    }
    if (self.notify_url) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notify_url];
    }
    if (self.out_trade_no) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.out_trade_no];
    }
    if (self.partner) {
        [discription appendFormat:@"&partner=\"%@\"", self.partner];
    }
    if (self.payment_type) {
        [discription appendFormat:@"&payment_type=\"%@\"", self.payment_type];//1
    }
    if (self.seller_id) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller_id];
    }
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"", self.service];//mobile.securitypay.pay
    }
    if (self.subject) {
        [discription appendFormat:@"&subject=\"%@\"", self.subject];
    }
    if (self.total_fee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.total_fee];
    }
    
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}
@end
