//
//  ChatVC.m
//  EMChatText
//
//  Created by zzjd on 2017/3/14.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "ChatVC.h"

#import "ConversationVC.h"


@interface ChatVC ()<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,EMCallManagerDelegate>

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)UIView * editView;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)EMConversation * conversation;

@property (nonatomic,strong)UIView * addView;

@property (nonatomic,strong)ConversationVC * converVC;


@property (nonatomic,strong)NSMutableDictionary * chatDict;


@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chatDict = [[NSMutableDictionary alloc]init];;
    
    _conversation = [[EMClient sharedClient].chatManager getConversation:([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111" type:EMConversationTypeChat createIfNotExist:YES];
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self createUI];
    
    [self loadData];
    
    
    //键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view.
}
#pragma mark ----------------------------------获取本地聊天内容---------------
-(void)loadData{
    
    [_conversation loadMessagesStartFromId:([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111" count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            
            for (EMMessage *message in aMessages) {
                if (message.body.type == EMMessageBodyTypeText) {
                    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
                    NSLog(@"本地消息内容：textBody : %@",textBody.text);
                    [_dataArray addObject:message];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            
        }else{
            
            NSLog(@"获取本地消息内容失败：error = %@",aError.errorDescription);
        }
        
    }];
    
}

-(void)createUI{
    
    [self createTitleView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];
    
    [self createEditView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)createTitleView{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    titleView.backgroundColor = [UIColor blackColor];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(44, 20, WIDTH-88, 44)];
    titLab.text = ([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111";
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor whiteColor];
    
    [titleView addSubview:backBtn];
    [titleView addSubview:titLab];
    
    [self.view addSubview:titleView];
}

-(void)createEditView{
    
    _editView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    _editView.backgroundColor = [UIColor blackColor];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(5, 5, 40, 40);
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(50, 5, WIDTH-100, 40)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.keyboardType = UIKeyboardTypeDefault;
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(WIDTH-45, 5, 40, 40);
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [sendBtn setTitle:@"send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_editView addSubview:addBtn];
    [_editView addSubview:_textView];
    [_editView addSubview:sendBtn];
    [self.view addSubview:_editView];
}


#pragma mark --------------------------------------tableView代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count<1) {
        return 0;
    }
    return _dataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMMessage * message = _dataArray[indexPath.row];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
    
    NSLog(@"消息内容 textBody.text = %@ ，indexPath = %ld",textBody.text,(long)indexPath.row);
    
    
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, WIDTH-40, 30)];
    
    lab.text = textBody.text;
    
    lab.textColor = [UIColor blackColor];

    if (message.direction == EMMessageDirectionReceive) {
        lab.textAlignment = NSTextAlignmentLeft;
    }else{
        lab.textAlignment = NSTextAlignmentRight;
    }
    
    [cell addSubview:lab];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ---------------------------------------接收消息回调------------------
//这里只写了接收文字的处理。别的消息处理方式类似。可自行到环信文档查询
-(void)messagesDidReceive:(NSArray *)aMessages{

    for (EMMessage *message in aMessages) {
        if (message.body.type == EMMessageBodyTypeText) {
            NSLog(@"接收到文字消息");

            [_dataArray addObject:message];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                
            });
        }
        
    }
    
}
#pragma mark ---------------------------------------发送功能按钮------------------

-(void)sendBtnClick{
    
    [self sendMessage:_textView.text];
}
-(void)sendMessage:(NSString *)msg{
    
    //发送内容
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:msg];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:([from isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111" from:from to:([from isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111" body:body ext:nil];
    
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        
        if (!error) {
            NSLog(@"消息发送成功");
            [_dataArray addObject:message];
            
            _textView.text = @"";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([msg isEqualToString:@"吾里草莓君·语音"]) {
                    self.converVC.isSender = YES;

                    [self presentViewController:self.converVC animated:YES completion:nil];
                    
                }else if([msg isEqualToString:@"吾里草莓君·视频"]){//视频
                    
                    self.converVC.type = 1;
                    self.converVC.isSender = YES;

                    [self presentViewController:self.converVC animated:YES completion:nil];
                    
                }
                
                [_tableView reloadData];
                
            });
            
        }else{
            NSLog(@"消息发送失败 ： error = %@",error.errorDescription);
        }
        
    }];

}

#pragma mark ---------------------------------------更多功能按钮（语音、视频）------------------

-(void)addBtnClick{
    [_textView endEditing:YES];

    _editView.frame = CGRectMake(0, HEIGHT-110, WIDTH, 50);
    
    if (!_addView) {
        _addView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 60)];
        
        _addView.backgroundColor = [UIColor whiteColor];
        
        NSArray * arr = @[@"语音",@"视频"];
        
        for (int i = 0; i<arr.count; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(WIDTH/2*i, 0, WIDTH/2, 60);
            
            button.backgroundColor = [UIColor blueColor];
            
            [button setTitle:arr[i] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [_addView addSubview:button];
            
        }
        
        [self.view addSubview:_addView];
        
    }else{
        _addView.hidden = !_addView.isHidden;

        if (_addView.isHidden){
            _editView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
        }
        
    }
    
    
}

-(void)buttonClick:(UIButton *)btn{
    _addView.hidden = !_addView.isHidden;
    if (_addView.isHidden){
        _editView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    }
    if ([btn.titleLabel.text isEqualToString:@"语音"]) {//语音
        [self sendMessage:@"吾里草莓君·语音"];
    }else{//视频
//        [self sendMessage:@"吾里草莓君·视频"];
    }
}


#pragma mark ---------------------------------------返回------------------
-(void)backBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark ---------------------------------------全局点击手势结束输入------------------
-(void)tapClick{
    
    [_textView endEditing:YES];
    _addView.hidden = YES;
    if (_addView.isHidden){
        _editView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    }
}
#pragma mark 键盘出现监听事件

-(void)keyboardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    _editView.frame = CGRectMake(0, HEIGHT-50-keyboardRect.size.height, WIDTH, 50);

    _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-114-keyboardRect.size.height);
    
}

-(void)keyboardWillHidden:(NSNotification *)notification{
    
    _editView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    
    _tableView.frame = CGRectMake(0,64, WIDTH, HEIGHT-114);
}


-(ConversationVC *)converVC{
    
    if (!_converVC) {
        _converVC = [[ConversationVC alloc]init];
    }
    return _converVC;
}


/*!
 *  \~chinese
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 */
- (void)callDidReceive:(EMCallSession *)aSession{
    NSLog(@"callDidReceive 用户A拨打用户B，用户B会收到这个回调");
    
    self.converVC.callSession = aSession;

    if (!aSession.type) {
        self.converVC.isSender = NO;
        [self presentViewController:self.converVC animated:YES completion:nil];
        
    }else{//视频
        self.converVC.type = 1;
        self.converVC.isSender = NO;
        [self presentViewController:self.converVC animated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
