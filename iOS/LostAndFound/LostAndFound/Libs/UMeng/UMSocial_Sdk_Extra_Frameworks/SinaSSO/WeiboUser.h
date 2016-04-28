//
//  WeiboUser.h
//  WeiboSDK
//
//  Created by DannionQiu on 14-9-23.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/*@
    You can get the latest WeiboUser field description on http://open.weibo.com/wiki/2/friendships/friends/en .
*/
@interface WeiboUser : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)paraDict;
+ (instancetype)userWithDictionary:(NSDictionary*)paraDict;

// Validate the dictionary to be converted.
+ (BOOL)isValidForDictionary:(NSDictionary *)dict;

- (BOOL)updateWithDictionary:(NSDictionary*)paraDict;


@property(readwrite, nonatomic, strong) NSString* userID;
@property(readwrite, nonatomic, strong) NSString* userClass;
@property(readwrite, nonatomic, strong) NSString* screenName;
@property(readwrite, nonatomic, strong) NSString* name;
@property(readwrite, nonatomic, strong) NSString* province;
@property(readwrite, nonatomic, strong) NSString* city;
@property(readwrite, nonatomic, strong) NSString* location;
@property(readwrite, nonatomic, strong) NSString* userDescription;
@property(readwrite, nonatomic, strong) NSString* url;
@property(readwrite, nonatomic, strong) NSString* profileImageUrl;
@property(readwrite, nonatomic, strong) NSString* coverImageUrl;
@property(readwrite, nonatomic, strong) NSString* coverImageForPhoneUrl;
@property(readwrite, nonatomic, strong) NSString* profileUrl;
@property(readwrite, nonatomic, strong) NSString* userDomain;
@property(readwrite, nonatomic, strong) NSString* weihao;
@property(readwrite, nonatomic, strong) NSString* gender;
@property(readwrite, nonatomic, strong) NSString* followersCount;
@property(readwrite, nonatomic, strong) NSString* friendsCount;
@property(readwrite, nonatomic, strong) NSString* pageFriendsCount;
@property(readwrite, nonatomic, strong) NSString* statusesCount;
@property(readwrite, nonatomic, strong) NSString* favouritesCount;
@property(readwrite, nonatomic, strong) NSString* createdTime;
@property(readwrite, nonatomic, assign) BOOL isFollowingMe;
@property(readwrite, nonatomic, assign) BOOL isFollowingByMe;
@property(readwrite, nonatomic, assign) BOOL isAllowAllActMsg;
@property(readwrite, nonatomic, assign) BOOL isAllowAllComment;
@property(readwrite, nonatomic, assign) BOOL isGeoEnabled;
@property(readwrite, nonatomic, assign) BOOL isVerified;
@property(readwrite, nonatomic, strong) NSString* verifiedType;
@property(readwrite, nonatomic, strong) NSString* remark;
@property(readwrite, nonatomic, strong) NSString* statusID;
@property(readwrite, nonatomic, strong) NSString* ptype;
@property(readwrite, nonatomic, strong) NSString* avatarLargeUrl;
@property(readwrite, nonatomic, strong) NSString* avatarHDUrl;
@property(readwrite, nonatomic, strong) NSString* verifiedReason;
@property(readwrite, nonatomic, strong) NSString* verifiedTrade;
@property(readwrite, nonatomic, strong) NSString* verifiedReasonUrl;
@property(readwrite, nonatomic, strong) NSString* verifiedSource;
@property(readwrite, nonatomic, strong) NSString* verifiedSourceUrl;
@property(readwrite, nonatomic, strong) NSString* verifiedState;
@property(readwrite, nonatomic, strong) NSString* verifiedLevel;
@property(readwrite, nonatomic, strong) NSString* onlineStatus;
@property(readwrite, nonatomic, strong) NSString* biFollowersCount;
@property(readwrite, nonatomic, strong) NSString* language;
@property(readwrite, nonatomic, strong) NSString* star;
@property(readwrite, nonatomic, strong) NSString* mbtype;
@property(readwrite, nonatomic, strong) NSString* mbrank;
@property(readwrite, nonatomic, strong) NSString* block_word;
@property(readwrite, nonatomic, strong) NSString* block_app;
@property(readwrite, nonatomic, strong) NSString* credit_score;
@property(readwrite, nonatomic, strong) NSDictionary* originParaDict;

@end
