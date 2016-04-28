//
//  LFLocation
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "LFBaseModel.h"

@interface LFLocation : LFBaseModel<BMKAnnotation>

@property(nonatomic, copy) NSString *noticeId;
@property(nonatomic, copy) NSString *regionId;

@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;
@property(nonatomic, copy  ) NSString *address;
@property(nonatomic, copy  ) NSString *name;
@property(nonatomic, copy  ) NSString *aliss;

@property(nonatomic, copy  , readonly) NSString *title;
@property(nonatomic, copy  , readonly) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (id)locationWithGeoCodeResult:(BMKReverseGeoCodeResult *)geoCodeResult;
- (id)initWithGeoCodeResult:(BMKReverseGeoCodeResult *)geoCodeResult;

@end
