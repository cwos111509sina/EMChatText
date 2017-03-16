//
//  ViewController.m
//  EMChatText
//
//  Created by zzjd on 2017/3/13.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "ViewController.h"

#import "LoginAndRegisterView.h"

#import "ChatVC.h"


@interface ViewController ()


@property (nonatomic,strong)LoginAndRegisterView * loginV;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [self createUI];
    
    NSLog(@"[EMClient sharedClient].isLoggedIn = %d",[EMClient sharedClient].isLoggedIn);
    
    if (![EMClient sharedClient].isLoggedIn) {
        
        if (!_loginV) {
            _loginV = [[LoginAndRegisterView alloc]init];
            
            [self.view addSubview:_loginV];
            
        }else{
            _loginV.hidden = NO;
        }
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark --------------------------------获取好友数据-------------------
-(void)loadData{
    
}

-(void)createUI{
    
    [self createTitleView];
    
    UIButton * friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    friendBtn.frame = CGRectMake(0, 64, WIDTH, 50);
    
    friendBtn.backgroundColor = [UIColor grayColor];
    
    [friendBtn setTitle:([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111(点击聊天)":@"aaaaa111(点击聊天)" forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendChatClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginOutBtn.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    loginOutBtn.backgroundColor = [UIColor redColor];
    [loginOutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:friendBtn];
    
    [self.view addSubview:loginOutBtn];
    
}

-(void)createTitleView{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    
    titleView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:titleView];
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    titleLab.backgroundColor = [UIColor blackColor];
    titleLab.text = [[EMClient sharedClient] currentUsername];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.tag = 100;
    
    [self.view addSubview:titleLab];
    
}

-(void)friendChatClick{
    
    ChatVC * VC = [[ChatVC alloc]init];
    
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark ----------------------------------------退出登录---------------
-(void)logOutBtnClick:(UIButton *)btn{
    
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        
        if (!aError.code) {
            if (!_loginV) {
                _loginV = [[LoginAndRegisterView alloc]init];
                [self.view addSubview:_loginV];
                
            }else{
                _loginV.hidden = NO;
            }
        }
        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
