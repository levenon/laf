//
//  LFLocation
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLocation.h"

@implementation LFLocation

- (NSString *)title{
    
    return [self name];
}

- (NSString *)subtitle{
    
    return [self address];
}

- (CLLocationCoordinate2D)coordinate{
    
    return CLLocationCoordinate2DMake([self latitude], [self longitude]);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    
    [self setLatitude:coordinate.latitude];
    [self setLongitude:coordinate.longitude];
}

+ (id)locationWithGeoCodeResult:(BMKReverseGeoCodeResult *)geoCodeResult;{
    return [[[self class] alloc] initWithGeoCodeResult:geoCodeResult];
}

- (id)initWithGeoCodeResult:(BMKReverseGeoCodeResult *)geoCodeResult;{
    
    self = [super init];
    if (self) {
        
        [self setCoordinate:[geoCodeResult location]];
        
        if ([geoCodeResult poiList] && [[geoCodeResult poiList] count]) {
            
            BMKPoiInfo *etPointInfo = [[geoCodeResult poiList] firstObject];
            
            [self setName:[etPointInfo name]];
            [self setAddress:[etPointInfo address]];
        }
        else{
            
            [self setName:[geoCodeResult address]];
            [self setAddress:[geoCodeResult address]];
        }
    }
    return self;
}

@end
