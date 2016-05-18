//
//  SCFindPasswordStepTwoViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFindPasswordStepTwoViewController.h"
#import "SCBreathChangeView.h"
#import "SCFindPasswordManager.h"
@interface SCFindPasswordStepTwoViewController ()<UITextFieldDelegate>
{
    NSString *thePhone;
    NSString *verificationCode;
    NSNumber *verificaitonTime;
}
@property(nonatomic, strong) IBOutlet SCBreathChangeView *breathChangeView;
@property(nonatomic, strong) IBOutlet UITextField *txtPassword;
@property(nonatomic, strong) IBOutlet UITextField *txtValidatePassword;
@end

@implementation SCFindPasswordStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    NSAttributedString *phonePlaceHold = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPassword setAttributedPlaceholder:phonePlaceHold];
    
    NSAttributedString *validateCodePlaceHold = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtValidatePassword setAttributedPlaceholder:validateCodePlaceHold];
    
    CGFloat fontSize = [UIDevice adaptTextFontSizeWithIphone5FontSize:12.0f];
    [_breathChangeView inilizeViewWithFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAnimate
{
    if (_breathChangeView) {
        [_breathChangeView startAnimate];
    }
}

-(void)setPhone:(NSString *)phone WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time
{
    thePhone = phone;
    verificationCode = code;
    verificaitonTime = time;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_breathChangeView) {
        [_breathChangeView stopAnimate];
    }
}

-(BOOL)isValidateInput
{
    if ([AppUtils isNullStr:_txtPassword.text]) {
        [AppUtils showInfo:@"密码不能为空"];
        return NO;
    }
    
    if ([AppUtils isNullStr:_txtValidatePassword.text]) {
        [AppUtils showInfo:@"确认密码不能为空"];
        return NO;
    }
    
    if (_txtPassword.text.length < 6 || _txtPassword.text.length > 32) {
        [AppUtils showInfo:@"密码长度需为6-32位"];
        return NO;
    }
    
    if (![_txtPassword.text isEqualToString:_txtValidatePassword.text]) {
        [AppUtils showInfo:@"密码与确认密码两者不一致"];
        return NO;
    }
    return YES;
}


-(IBAction)clickSubmitBtn:(id)sender
{
    if ([self isValidateInput]) {
        [[SCFindPasswordManager defaultManager] submitPassword:thePhone WithPassword:_txtPassword.text WithVerificationCode:verificationCode WithVerificationTime:verificaitonTime Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(submitSuccess)]) {
                [self.delegate submitSuccess];
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

@end
