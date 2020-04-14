//
//  AWPaymentMethod.h
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/16.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWCodable.h"
#import "AWPlaceDetails.h"
#import "AWCard.h"
#import "AWWeChatPay.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AWPaymentMethod` includes the information of a payment method.
 */
@interface AWPaymentMethod : NSObject <AWJSONEncodable, AWJSONDecodable>

/**
 Type of the payment method. One of card, wechatpay.
 */
@property (nonatomic, copy) NSString *type;

/**
 Unique identifier for the payment method.
 */
@property (nonatomic, copy, nullable) NSString *Id;

/**
 Billing object.
 */
@property (nonatomic, strong, nullable) AWPlaceDetails *billing;

/**
 Card object.
 */
@property (nonatomic, strong, nullable) AWCard *card;

/**
 Wechat pay object.
 */
@property (nonatomic, strong, nullable) AWWeChatPay *weChatPay;

/**
 The customer this payment method belongs to.
 */
@property (nonatomic, strong, nullable) NSString *customerId;

@end

NS_ASSUME_NONNULL_END
