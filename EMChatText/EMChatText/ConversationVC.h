//
//  ConversationVC.h
//  EMChatText
//
//  Created by zzjd on 2017/3/17.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationVC : UIViewController


@property (nonatomic,assign)NSInteger type;

@property (nonatomic,strong)EMCallSession *callSession;

@property (nonatomic,assign)BOOL isSender;


@end
