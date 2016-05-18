//
//  SCRegisterViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCRegisterViewController.h"
#import "SCBreathChangeView.h"
#import "SCRegisterManager.h"

@interface SCRegisterViewController ()<UITextFieldDelegate>
{
    BOOL isAgree;
    NSTimer *timer;
    NSInteger seconds;
    
    NSString *phone;
    NSString *verificationCode;
    NSNumber *verificaitonTime;
}
@property(nonatomic, strong) IBOutlet SCBreathChangeView *breathChangeView;
@property(nonatomic, strong) IBOutlet UITextField *txtPhone;
@property(nonatomic, strong) IBOutlet UITextField *txtValidateCode;
@property(nonatomic, strong) IBOutlet UITextField *txtPassword;

@property(nonatomic, strong) IBOutlet UIButton *btnIsAgree;
@property(nonatomic, strong) IBOutlet UIButton *btnAgreement;
@property(nonatomic, strong) IBOutlet UIButton *btnValidateCode;
@end

@implementation SCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSAttributedString *phonePlaceHold = [[NSAttributedString alloc] initWithString:@"请输入11位手机号" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPhone setAttributedPlaceholder:phonePlaceHold];
    
    NSAttributedString *validateCodePlaceHold = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtValidateCode setAttributedPlaceholder:validateCodePlaceHold];
    
    NSAttributedString *passwordPlaceHold = [[NSAttributedString alloc] initWithString:@"6-32位数字字母组合密码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPassword setAttributedPlaceholder:passwordPlaceHold];
    
    NSAttributedString *verificationCodeTitle = [[NSAttributedString alloc] initWithString:@"获取验证码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.031 green:0.169 blue:0.290 alpha:1.000]}];
    [_btnValidateCode setAttributedTitle:verificationCodeTitle forState:UIControlStateNormal];
    [_btnValidateCode.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_btnValidateCode.layer setCornerRadius:7.0f];
    [_btnValidateCode.layer setMasksToBounds:YES];
    
    NSMutableAttributedString *agreementTitle= [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《用户注册协议》" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1.000]}];
    [agreementTitle appendAttributedString:str];
    [_btnAgreement setAttributedTitle:agreementTitle forState:UIControlStateNormal];
    
    CGFloat fontSize = [UIDevice adaptTextFontSizeWithIphone5FontSize:12.0f];
    [_breathChangeView inilizeViewWithFont:[UIFont systemFontOfSize:fontSize]];
    
    [self changeAgreeState:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeAgreeState:(BOOL)state
{
    isAgree = state;
    if (state) {
        [_btnIsAgree setImage:[UIImage imageNamed:@"AgreementSelectImage"] forState:UIControlStateNormal];
    }else{
        [_btnIsAgree setImage:[UIImage imageNamed:@"AgreementNotSelectImage"] forState:UIControlStateNormal];
    }
}

-(void)startAnimate
{
    if (_breathChangeView) {
        [_breathChangeView startAnimate];
    }
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
    if ([AppUtils isNullStr:_txtPhone.text]) {
        [AppUtils showInfo:@"手机号不能为空"];
        return NO;
    }
    
    if (![AppUtils isMobileNumber:_txtPhone.text]) {
        [AppUtils showInfo:@"手机号不合法"];
        return NO;
    }
    
    if ([AppUtils isNullStr:_txtValidateCode.text]) {
        [AppUtils showInfo:@"验证码不能为空"];
        return NO;
    }
    
    if ([AppUtils isNullStr:_txtPassword.text]) {
        [AppUtils showInfo:@"密码不能为空"];
        return NO;
    }
    
    if (_txtPassword.text.length < 6 || _txtPassword.text.length > 32) {
        [AppUtils showInfo:@"密码长度需为6-32位"];
        return NO;
    }
    
    if(!isAgree){
        [AppUtils showInfo:@"请阅读注册协议并同意"];
        return NO;
    }
    
    return YES;
}

-(void)sendPhoneCodeWithTel:(NSString *)tel
{
    [_btnValidateCode setEnabled:NO];
    [[SCRegisterManager defaultManager] requestVerificationCodeWithPhone:tel Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        seconds = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(validateBtnSetting) userInfo:nil repeats:YES];
        [timer fire];
        
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            if (dataDic) {
                phone = [dataDic objectForKey:@"phone"];
                verificationCode = [dataDic objectForKey:@"verificationCode"];
                verificaitonTime = [dataDic objectForKey:@"verificationCodeTime"];
            }
        }
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_btnValidateCode setEnabled:YES];
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_btnValidateCode setEnabled:YES];
    }];
}

-(void)validateBtnSetting
{
    --seconds;
    if (seconds>0) {
        NSAttributedString *verificationCodeTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"发送验证码\n(%ld)",(long)seconds] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1.000]}];
        [_btnValidateCode setAttributedTitle:verificationCodeTitle forState:UIControlStateNormal];
//        [_btnValidateCode.titleLabel sizeToFit];
        [_btnValidateCode.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btnValidateCode setBackgroundColor:[UIColor clearColor]];
        [_btnValidateCode setEnabled:NO];
    }else{
        [timer invalidate];
        timer = nil;
        NSAttributedString *verificationCodeTitle = [[NSAttributedString alloc] initWithString:@"获取验证码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.031 green:0.169 blue:0.290 alpha:1.000]}];
        [_btnValidateCode setAttributedTitle:verificationCodeTitle forState:UIControlStateNormal];
//        [_btnValidateCode.titleLabel sizeToFit];
        [_btnValidateCode.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_btnValidateCode setBackgroundColor:[UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1.000]];
        [_btnValidateCode setEnabled:YES];
    }
}


-(IBAction)clickLoginBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goLoginView)]) {
        [self.delegate goLoginView];
    }
}

-(IBAction)clickRegisterBtn:(id)sender
{
    if ([self isValidateInput]) {
        if (![_txtValidateCode.text isEqualToString:verificationCode]) {
            [AppUtils showInfo:@"验证码不匹配"];
            return;
        }
        
        if (![_txtPhone.text isEqualToString:phone]) {
            [AppUtils showInfo:@"手机号不一致"];
            return;
        }
        
        [AppUtils showProgressBarForView:self.view];
        [[SCRegisterManager defaultManager] registerWithMobile:_txtPhone.text WithPassword:_txtPassword.text WithVerificationCode:_txtValidateCode.text WithVerificationCodeTime:verificaitonTime Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            if ([self.delegate respondsToSelector:@selector(registerSuccess)]) {
                [self.delegate registerSuccess];
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils hideProgressBarForView:self.view];
        }];
    }
}

-(IBAction)clickValidateBtn:(id)sender
{
    if ([AppUtils isNullStr:_txtPhone.text]) {
        [AppUtils showInfo:@"手机号不能为空"];
        return;
    }
    
    if (![AppUtils isMobileNumber:_txtPhone.text]) {
        [AppUtils showInfo:@"手机号不合法"];
        return;
    }
    
    [self sendPhoneCodeWithTel:_txtPhone.text];
}

-(IBAction)clickIsAgreeBtn:(id)sender
{
    if (isAgree) {
        [self changeAgreeState:NO];
    }else{
        [self changeAgreeState:YES];
    }
}

-(IBAction)clickAgreementBtn:(id)sender
{
    
}
@end
