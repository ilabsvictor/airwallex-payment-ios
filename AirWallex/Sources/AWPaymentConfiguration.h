//
//  AWPaymentConfiguration.h
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/14.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWPaymentConfiguration : NSObject

@property (nonatomic, copy, readwrite) NSString *baseURL;
@property (nonatomic, copy, readwrite) NSString *intentId;
@property (nonatomic, copy, readwrite) NSString *clientSecret;
@property (nonatomic, copy, readwrite) NSString *customerId;
@property (nonatomic, copy, readwrite) NSString *region;
@property (nonatomic, copy, readwrite) NSString *currency;

+ (instancetype)sharedConfiguration;

@end

NS_ASSUME_NONNULL_END