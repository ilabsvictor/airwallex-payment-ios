//
//  AWPaymentIntentRequest.h
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/16.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWRequestProtocol.h"

@class AWPaymentMethod;
@class AWPaymentMethodOptions;

NS_ASSUME_NONNULL_BEGIN

@interface AWConfirmPaymentIntentRequest : NSObject <AWRequestProtocol>

@property (nonatomic, copy) NSString *intentId;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, strong) AWPaymentMethod *paymentMethod;
@property (nonatomic, strong, nullable) AWPaymentMethodOptions *options;

@end

@interface AWGetPaymentIntentRequest : NSObject <AWRequestProtocol>

@property (nonatomic, copy) NSString *intentId;

@end

NS_ASSUME_NONNULL_END
