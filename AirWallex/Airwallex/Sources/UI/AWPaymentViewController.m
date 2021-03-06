//
//  PaymentViewController.m
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/16.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import "AWPaymentViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AWConstants.h"
#import "AWPaymentConfiguration.h"
#import "AWPaymentItemCell.h"
#import "AWUtils.h"
#import "AWWidgets.h"
#import "AWPaymentMethod.h"
#import "AWAPIClient.h"
#import "AWPaymentIntentRequest.h"
#import "AWPaymentMethodOptions.h"
#import "AWPaymentIntentResponse.h"
#import "AWTheme.h"

@interface AWPaymentViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet AWButton *payButton;

@property (strong, nonatomic) NSString *cvc;

@end

@implementation AWPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.payButton setImage:[UIImage imageNamed:@"lock-white" inBundle:[NSBundle resourceBundle]] forState:UIControlStateNormal];
    [self.payButton setImage:[UIImage imageNamed:@"lock-grey" inBundle:[NSBundle resourceBundle]] forState:UIControlStateDisabled];
    [self.payButton setImageAndTitleHorizontalAlignmentCenter:8];
    self.totalLabel.text = [AWPaymentConfiguration sharedConfiguration].totalAmount.string;
    [self.tableView registerNib:[UINib nibWithNibName:@"AWPaymentItemCell" bundle:[NSBundle sdkBundle]] forCellReuseIdentifier:@"AWPaymentItemCell"];
    [self reloadData];
}

- (void)checkPaymentEnabled
{
    if ([self.paymentMethod.type isEqualToString:AWWechatpay]) {
        self.payButton.enabled = YES;
        return;
    }

    NSString *cvc = self.paymentMethod.card.cvc ?: self.cvc;
    self.payButton.enabled = cvc.length > 0;
}

- (void)reloadData
{
    [self checkPaymentEnabled];
    [self.tableView reloadData];
}

- (IBAction)payPressed:(id)sender
{
    AWPaymentMethod *paymentMethod = self.paymentMethod;
    if (!self.paymentMethod.card.cvc) {
        paymentMethod.card.cvc = self.cvc;
    }

    AWAPIClient *client = [AWAPIClient new];
    AWConfirmPaymentIntentRequest *request = [AWConfirmPaymentIntentRequest new];
    request.intentId = client.configuration.intentId;
    request.requestId = NSUUID.UUID.UUIDString;
    AWPaymentMethodOptions *options = [AWPaymentMethodOptions new];
    options.autoCapture = YES;
    options.threeDsOption = NO;
    request.options = nil;
    request.paymentMethod = paymentMethod;

    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [client send:request handler:^(id<AWResponseProtocol>  _Nullable response, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        [SVProgressHUD dismiss];
        [strongSelf dismissViewControllerAnimated:YES completion:^{
            id <AWPaymentResultDelegate> delegate = [AWPaymentConfiguration sharedConfiguration].delegate;
            if (error) {
                [delegate paymentDidFinishWithStatus:AWPaymentStatusError error:error];
                return;
            }

            AWConfirmPaymentIntentResponse *result = (AWConfirmPaymentIntentResponse *)response;
            if ([result.status isEqualToString:@"SUCCEEDED"]) {
                [delegate paymentDidFinishWithStatus:AWPaymentStatusSuccess error:error];
                return;
            }

            if (!result.nextAction) {
                [delegate paymentDidFinishWithStatus:AWPaymentStatusSuccess error:error];
                return;
            }

            if ([result.nextAction.type isEqualToString:@"call_sdk"]) {
                [delegate paymentWithWechatPaySDK:result.nextAction.wechatResponse];
            }
        }];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWPaymentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AWPaymentItemCell" forIndexPath:indexPath];
    cell.cvcField.delegate = self;
    cell.cvcField.text = self.cvc;
    cell.titleLabel.text = @"Payment";
    NSString *type = self.paymentMethod.type;
    if ([type isEqualToString:AWWechatpay]) {
        cell.selectionLabel.text = @"WeChat pay";
        cell.cvcHidden = YES;
    } else {
        cell.selectionLabel.text = [NSString stringWithFormat:@"%@ •••• %@", self.paymentMethod.card.brand.capitalizedString, self.paymentMethod.card.last4];
        cell.cvcHidden = NO;
        cell.cvcField.text = self.paymentMethod.card.cvc;
    }
    cell.selectionLabel.textColor = [AWTheme defaultTheme].textColor;
    cell.isLastCell = YES;
    cell.arrowView.hidden = YES;
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length <= 4) {
        self.cvc = text;
        [self checkPaymentEnabled];
        return YES;
    }
    return NO;
}

@end
