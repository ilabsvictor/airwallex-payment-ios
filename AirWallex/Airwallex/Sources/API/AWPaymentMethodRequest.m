//
//  AWPaymentMethodRequest.m
//  Airwallex
//
//  Created by Victor Zhu on 2020/2/4.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import "AWPaymentMethodRequest.h"
#import "AWPaymentMethodResponse.h"

@implementation AWGetPaymentMethodsRequest

- (NSString *)path
{
    return @"/api/v1/pa/payment_methods";
}

- (AWHTTPMethod)method
{
    return AWHTTPMethodGET;
}

- (nullable NSDictionary *)parameters
{
    if (self.customerId) {
        return @{@"customer_id": self.customerId};
    }
    return nil;
}

- (Class)responseClass
{
    return AWGetPaymentMethodsResponse.class;
}

@end

@implementation AWCreatePaymentMethodRequest

- (NSString *)path
{
    return @"/api/v1/pa/payment_methods/create";
}

- (AWHTTPMethod)method
{
    return AWHTTPMethodPOST;
}

- (nullable NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"request_id"] = self.requestId;
    if (self.customerId) {
        parameters[@"customer_id"] = self.customerId;
    }
    [parameters addEntriesFromDictionary:self.paymentMethod.toJSONDictionary];
    return parameters;
}

- (Class)responseClass
{
    return AWCreatePaymentMethodResponse.class;
}

@end
