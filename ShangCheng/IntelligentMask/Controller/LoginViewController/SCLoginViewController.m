//
//  SCLoginViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCBreathChangeView.h"
#import "SCLoginManager.h"
#import "ZXAppStartManager.h"
#import "ShareManage.h"

@interface SCLoginViewController ()<UITextFieldDelegate>
@property(nonatomic, strong) IBOutlet SCBreathChangeView *breathChangeView;
@property(nonatomic, strong) IBOutlet UITextField *txtPhone;
@property(nonatomic, strong) IBOutlet UITextField *txtPassword;
@end

@implementation SCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSAttributedString *phonePlaceHold = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPhone setAttributedPlaceholder:phonePlaceHold];
    
    NSAttributedString *passwordPlaceHold = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255 green:199.0f/255 blue:236.0f/255 alpha:1.0f]}];
    [_txtPassword setAttributedPlaceholder:passwordPlaceHold];
    
    CGFloat fontSize = [UIDevice adaptTextFontSizeWithIphone5FontSize:15.0f];
    [_breathChangeView inilizeViewWithFont:[UIFont systemFontOfSize:fontSize]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_txtPhone isFirstResponder]) {
        [_txtPhone resignFirstResponder];
    }
    
    if ([_txtPassword isFirstResponder]) {
        [_txtPassword resignFirstResponder];
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
    
    if ([AppUtils isNullStr:_txtPassword.text]) {
        [AppUtils showInfo:@"密码不能为空"];
        return NO;
    }
    
    if (_txtPassword.text.length < 6 || _txtPassword.text.length > 32) {
        [AppUtils showInfo:@"密码长度需为6-32位"];
        return NO;
    }
    
    return YES;
}


-(IBAction)clickLoginBtn:(id)sender
{
    if ([self isValidateInput]) {
        [AppUtils showProgressBarForView:self.view];
        [[SCLoginManager defaultManager] loginWithMobile:_txtPhone.text WithPassword:_txtPassword.text Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    Member *host = [[Member alloc] init];
                    host.token = [dataDic objectForKey:@"token"];
                    host.time = [dataDic objectForKey:@"time"];
                    host.mobilePhone = _txtPhone.text;
                    [[ZXAppStartManager defaultManager] setHostMember:host];
                    if ([self.delegate respondsToSelector:@selector(loginSuccess)]) {
                        [self.delegate loginSuccess];
                    }
                }
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils hideProgressBarForView:self.view];
        }];
    }
    
}

-(IBAction)clickRegisterBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goRegisterView)]) {
        [self.delegate goRegisterView];
    }
}

-(IBAction)clickForgetPasswordBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goFindPasswordView)]) {
        [self.delegate goFindPasswordView];
    }
}

-(IBAction)clickQQLoginBtn:(id)sender
{
    [[ShareManage GetInstance] loginWithQQAccount];
}

-(IBAction)clickWeChatLoginBtn:(id)sender
{
    [[ShareManage GetInstance] loginWithWXAccount];
}

-(IBAction)clickWeiBoLoginBtn:(id)sender
{
    [[ShareManage GetInstance] loginWithWeiboAccount];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
