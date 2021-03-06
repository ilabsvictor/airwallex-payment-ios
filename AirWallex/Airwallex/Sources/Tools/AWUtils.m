//
//  AWUtils.m
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/16.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import "AWUtils.h"
#import "AWConstants.h"
#import "AWLogger.h"
#import "AWPaymentConfiguration.h"

@implementation NSDictionary (Utils)

- (NSString *)queryURLEncoding
{
    NSMutableArray<NSString *> *parametersArray = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *queryString = [[NSString stringWithFormat:@"%@", obj] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, queryString]];
    }];
    return [parametersArray componentsJoinedByString:@"&"];
}

- (NSError *)convertToNSErrorWithCode:(NSNumber *)code
{
    return [NSError errorWithDomain:AWSDKErrorDomain
                               code:[code integerValue]
                           userInfo:self.appendErrorDescription];
}

- (NSError *)convertToNSError
{
    return [self convertToNSErrorWithCode:@(-1)];
}

- (NSDictionary *)appendErrorDescription
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:self];
    if (self[@"message"]) {
        [userInfo addEntriesFromDictionary: @{NSLocalizedDescriptionKey: self[@"message"]}];
    }
    return userInfo;
}

@end

@implementation NSBundle (Utils)

+ (NSBundle *)sdkBundle
{
    return [NSBundle bundleForClass:[AWPaymentConfiguration class]];
}

+ (NSBundle *)resourceBundle
{
    return [NSBundle bundleWithPath:[self.sdkBundle pathForResource:@"AirwallexSDK" ofType:@"bundle"]];
}

@end

@implementation NSString (Utils)

- (NSDictionary *)convertToDictionary
{
    if (self == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:&error];
    if (error) {
        return nil;
    }
    return dict;
}

- (NSString *)stringByRemovingIllegalCharacters
{
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
    NSArray *components = [self componentsSeparatedByCharactersInSet:set];
    return [components componentsJoinedByString:@""];
}

@end

@implementation NSDecimalNumber (Utils)

- (NSDecimalNumber *)toIntegerCents
{
    if (self == [NSDecimalNumber notANumber]) {
        [[AWLogger sharedLogger] logException:@"NaN can't be convert to cents"];
    }

    NSDecimalNumberHandler *round = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                           scale:0
                                                                                raiseOnExactness:YES
                                                                                 raiseOnOverflow:YES
                                                                                raiseOnUnderflow:YES
                                                                             raiseOnDivideByZero:YES];
    return [self decimalNumberByMultiplyingByPowerOf10:2 withBehavior:round];
}

- (NSString *)string
{
    if (self == [NSDecimalNumber zero]) {
        return @"Free";
    }

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.usesGroupingSeparator = YES;
    return [formatter stringFromNumber:self];
}

@end

@implementation AWValidationUtils

+ (void)checkNotNil:(id)value
               name:(NSString *)name
{
    if (value == nil) {
        [[AWLogger sharedLogger] logException:[NSString stringWithFormat:@"%@ must not be nil", name]];
    }
}

+ (void)checkNotNegative:(NSDecimalNumber *)value
                    name:(NSString *)name
{
    if ([value compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
        [[AWLogger sharedLogger] logException:[NSString stringWithFormat:@"%@ must not be negative", name]];
    }
}

@end

@implementation UIImage (Utils)

+ (nullable UIImage *)imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle
{
    return [UIImage imageNamed:name ofType:@"png" inBundle:bundle];
}

+ (nullable UIImage *)imageNamed:(NSString *)name ofType:(NSString *)type inBundle:(nullable NSBundle *)bundle
{
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:type]];
}

@end

@implementation UIButton (Utils)

- (void)setImageAndTitleVerticalAlignmentCenter:(float)spacing imageSize:(CGSize)imageSize
{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0f, 0.0f, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, - imageSize.width, - (imageSize.height + spacing), 0.0f);
}

- (void)setImageAndTitleHorizontalAlignmentCenter:(float)spacing
{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

@end
