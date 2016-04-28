//
//  LFLocationManager
//  LostAndFound
//
//  Created by Marike Jave on 15/9/22.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface LFLocationManager : LFBaseModel

/**
 *  是否允许获取当前地址信息，默认为 YES
 */
@property(nonatomic, assign) BOOL evEnableLocateAddree;

/**
 *  定位睡眠延迟间隔
 *  当没有任何回调或者代理需要执行时，定位服务会继续执行该时间间隔，直到时间截止后，关闭定位服务
 *  默认为5秒钟
 */
@property(nonatomic, assign) NSTimeInterval evLocationSleepDelayIntervel;

/**
 *  位置更新的有效时间，如果距上次更新的时间超过该时间，则需要重新启动定位服务, 默认为20秒
 */
@property(nonatomic, assign) NSTimeInterval evLastestLocationValidIntervel;

/**
 *  最长未响应时间，如时间内没有对回调进行响应，则以上一次的信息来响应，默认2秒
 */
@property(nonatomic, assign) NSTimeInterval evNotResponseDelay;

/**
 *  位置最近更新的时间
 */
@property(nonatomic, strong, readonly, nullable) NSDate *evLastestLocationDate;

/**
 *  当前定位到的用户位置信息
 */
@property(nonatomic, strong, readonly, nullable) BMKUserLocation * evUserLoaction;

/**
 *  用户最新定位到的位置, 默认为用户上一次定位的位置信息
 */
@property(nonatomic, assign, readonly) CLLocationCoordinate2D evLastestUserCoordinate;

/**
 *  当前位置的地址信息，当evEnableLocateAddree是YES时有效
 */
@property(nonatomic, strong, readonly, nullable) BMKReverseGeoCodeResult *evLocalAddress;
/**
 *  用户最新检索到的城市名称, 默认为用户上一次检索到的城市名称
 */
@property(nonatomic, copy  , readonly, nullable) NSString * evCityName;

+ (_Nonnull id)shareLocationManager;

+ (void)efConfigurate;

/**
 *  启动定位服务
 */
- (void)efStartUserLocationService;

/**
 *  关闭定位服务
 */
- (void)efStopUserLocationService;

/**
 *  添加定位代理，永久执行
 *
 *  @param delegate 代理
 */
- (void)efAddLocationDelegate:(id<BMKLocationServiceDelegate> _Nonnull)delegate;

/**
 *  移除定位代理
 *
 *  @param delegate 代理
 */
- (void)efRemoveLocationDelegate:(id<BMKLocationServiceDelegate> _Nonnull)delegate;

/**
 *  添加定位回调block，只执行一次
 *
 *  @param tag      标签，确定回调唯一性
 *  @param callback 回调
 */
- (void)efAddLocationWithTag:(NSString  * _Nonnull)tag
                    callback:(void (^ _Nonnull)(BMKUserLocation * _Nullable userLocation, NSError * _Nullable error) )callback;

/**
 *  添加地址检索回调block，只执行一次
 *
 *  @param tag      标签，确定回调唯一性
 *  @param callback 回调
 */
- (void)efAddGeoSearchWithTag:(NSString * _Nonnull)tag
                     callback:(void (^ _Nonnull)(BMKReverseGeoCodeResult * _Nullable localAddress, NSError * _Nullable error))callback;

/**
 *  移除标记为tag的所有block
 *
 *  @param tag 标记
 */
- (void)efRemoveBlockWithTag:(NSString * _Nonnull)tag;

/**
 *  移除标记为tag的定位block
 *
 *  @param tag 标记
 */
- (void)efRemoveLocationBlockWithTag:(NSString * _Nonnull)tag;

/**
 *  移除标记为tag的地址检索block
 *
 *  @param tag 标记
 */
- (void)efRemoveGeoSearchBlockWithTag:(NSString * _Nonnull)tag;

//- (void)efAddCitySearchWithTag:(NSString *)tag
//                     callback:(void (^)(NSString *city))callback;

@end

#define LFLocationManagerRef       [LFLocationManager shareLocationManager]   

/**
 *  根据距离（米）和比例尺长度（厘米）来确定当前地图的显示级别
 *
 *  @param distance     距离
 *  @param scaleBarSize 比例尺长度
 *
 *  @return 地图显示级别
 */
UIKIT_EXTERN CGFloat BMKZoomLevelFromDistance(CLLocationDistance distance, int scaleBarSize);

/**
 *  CLLocationCoordinate2D 转换成 CGPoint
 *
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return CGPoint
 */
UIKIT_EXTERN CGPoint BMKPointMakeWithCoordinate(CLLocationCoordinate2D coordinate);

/**
 *  判断 CLLocationCoordinate2D 是否为空
 *
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return 是否为空
 */
UIKIT_EXTERN BOOL BMKCoordinateIsZero(CLLocationCoordinate2D coordinate);

/**
 *  判断两个CLLocationCoordinate2D是否相等
 *
 *  @param coordinate1 CLLocationCoordinate2D
 *  @param coordinate2 CLLocationCoordinate2D
 *
 *  @return 是否相等
 */
UIKIT_EXTERN BOOL BMKCoordinateEqaulToCoordinate(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

/**
 *  取得两个经纬度之间的距离
 *
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return
 */
UIKIT_EXTERN CGFloat BMKBMKMetersBetweenCoordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

