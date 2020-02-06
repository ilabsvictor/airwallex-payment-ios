//
//  PaymentMethodCell.h
//  Examples
//
//  Created by Victor Zhu on 2020/1/19.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentMethodCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRightConstraint;
@property (nonatomic) BOOL isLastCell;

@end

@interface NoCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRightConstraint;
@property (nonatomic) BOOL isLastCell;

@end

NS_ASSUME_NONNULL_END
