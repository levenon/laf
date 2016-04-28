//
//  LFUser.h
//  Suixingou
//
//  Created by Marike Jave on 14-6-16.
//  strongright (c) 2014年 JhihPong. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFUser : LFBaseModel

@property(nonatomic, copy  ) NSString    *sid;           //  用户登录唯一标识
@property(nonatomic, copy  ) NSString    *username;      //	用户名
@property(nonatomic, copy  ) NSString    *nickname;      //	昵称
@property(nonatomic, copy  ) NSString    *realname;      //	真名
@property(nonatomic, copy  ) NSString    *headImageUrl;    //	头像地址
@property(nonatomic, copy  ) NSString    *email;         //	Email
@property(nonatomic, copy  ) NSString    *telephone;     //	电话
@property(nonatomic, copy  ) NSString    *introduction;
@property(nonatomic, copy  ) NSString    *roleId;
@property(nonatomic, assign) NSInteger   foundsCount;    //	发现的数量
@property(nonatomic, assign) NSInteger   lostsCount;     //	丢失的数量

@property(nonatomic, assign, readonly)  BOOL isLocalUser;
@property(nonatomic, copy  , readonly)  NSString *salutation;

@end
