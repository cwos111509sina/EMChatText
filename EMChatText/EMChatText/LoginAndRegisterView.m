//
//  LoginAndRegisterView.m
//  EMChatText
//
//  Created by zzjd on 2017/3/14.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "LoginAndRegisterView.h"

@interface LoginAndRegisterView ()


@property (nonatomic,strong)UITextField * accountField;

@property (nonatomic,strong)UITextField * passwordField;


@end

@implementation LoginAndRegisterView


-(instancetype)init{
    
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    titleView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:titleView];
    
    UILabel * titleLab= [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    
    titleLab.backgroundColor = [UIColor blackColor];
    
    titleLab.text = @"注册登录";
    
    titleLab.textColor = [UIColor whiteColor];
    
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:titleLab];
    
    
    _accountField = [[UITextField alloc]initWithFrame:CGRectMake(30, 140, WIDTH-60, 40)];
    
    _accountField.placeholder = @"请输入账号";
    _accountField.layer.borderWidth = 1;
    _accountField.layer.borderColor = [UIColor blackColor].CGColor;
    _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self addSubview:_accountField];
    
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(30, 200, WIDTH-60, 40)];
    
    _passwordField.placeholder = @"请输入密码";
    
    _passwordField.layer.borderWidth = 1;
    _passwordField.layer.borderColor = [UIColor blackColor].CGColor;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self addSubview:_passwordField];
    
    
    
    NSArray * arr = @[@"注册",@"登录"];
    for (int i = 0; i<arr.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(WIDTH/2*i+20, 280, WIDTH/2-40, 40);
        
        [button setTitle:arr[i] forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor blackColor];
        
        [button addTarget:self action:@selector(registerOrLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    
}


#pragma mark ----------------------------------注册或登录方法------------------

-(void)registerOrLoginBtnClick:(UIButton *)btn{
    
    [_accountField endEditing:YES];
    [_passwordField endEditing:YES];
    
    if ([btn.titleLabel.text isEqualToString:@"登录"]) {
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:_accountField.text password:_passwordField.text];
        if (!error) {
            NSLog(@"登录成功");
            
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            
            UILabel * lab = (UILabel *)[self.superview viewWithTag:100];
            lab.text = [[EMClient sharedClient] currentUsername];
            self.hidden = YES;

            
        }else{
            NSLog(@"登录失败 ： error = %@",error.errorDescription);
        }
        
    }else{
        
        EMError *error = [[EMClient sharedClient] registerWithUsername:_accountField.text password:_passwordField.text];
        if (error == nil) {
            
            NSLog(@"注册成功");
        }else{
            
            
            NSLog(@"注册失败 ： error = %@",error.errorDescription);
        }
        
        
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
