//
//  SCFindPasswordStepOneViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFindPasswordStepOneViewController.h"
#import "SCBreathChangeView.h"
#import "SCFindPasswordManager.h"

@interface SCFindPasswordStepOneViewController ()<UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger seconds;
    
    NSString *phone;
    NSString *verificationCode;
    NSNumber *verificaitonTime;
}
@property(nonatomic, strong) IBOutlet SCBreathChangeView *breathChangeView;
@property(nonatomic, strong) IBOutlet UITextField *txtPhone;
@property(nonatomic, strong) IBOutlet UITextField *txtValidateCode;
@property(nonatomic, strong) IBOutlet UIButton *btnValidateCode;
@end

@implementation SCFindPasswordStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    NSAttributedString *phonePlaceHold = [[NSAttributedString alloc] initWithString:@"请输入11位手机号" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPhone setAttributedPlaceholder:phonePlaceHold];
    
    NSAttributedString *validateCodePlaceHold = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtValidateCode setAttributedPlaceholder:validateCodePlaceHold];
    
    NSAttributedString *verificationCodeTitle = [[NSAttributedString alloc] initWithString:@"获取验证码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.031 green:0.169 blue:0.290 alpha:1.000]}];
    [_btnValidateCode setAttributedTitle:verificationCodeTitle forState:UIControlStateNormal];
    [_btnValidateCode.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_btnValidateCode.layer setCornerRadius:7.0f];
    [_btnValidateCode.layer setMasksToBounds:YES];
    
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
    return YES;
}

-(void)sendPhoneCodeWithTel:(NSString *)tel
{
    [_btnValidateCode setEnabled:NO];
    [[SCFindPasswordManager defaultManager] requestFindPasswordVerificationCodeWithPhone:tel Success:^(AFHTTPRequestOperation *operation, id responseObject) {
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



-(IBAction)clickNextStepBtn:(id)sender
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
        
        if ([self.delegate respondsToSelector:@selector(goNextStep:WithVerificationCode:WithVerificationTime:)]) {
            [self.delegate goNextStep:phone WithVerificationCode:verificationCode WithVerificationTime:verificaitonTime];
        }
        
    }
}
@end
