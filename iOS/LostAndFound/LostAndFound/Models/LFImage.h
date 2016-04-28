//
//  LFImage.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFImage : LFBaseModel

@property(nonatomic, copy  ) NSString *title;

@property(nonatomic, copy  ) NSString *noticeId;

@property(nonatomic, copy  ) NSString *remoteId;

@property(nonatomic, copy  ) NSString *remoteBinderId;

@property(nonatomic, strong) UIImage *image;

@property(nonatomic, copy  , readonly) NSString *defaultUrl;

@end
