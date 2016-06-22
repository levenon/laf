//
//  LFLocationManager
//  LostAndFound
//
//  Created by Marike Jave on 15/9/22.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLocationManager.h"

NSString * const LFLocationManagerLocationInfoArchive = @"com.archive.location";

//@implementation BMKAddressComponent (Private)
//
//- (NSString *)city{
//
//    return @"温州市";
//}
//
//@end

@interface LFLocationBlock : NSObject

@property(nonatomic, copy  , nonnull) void (^ evblcAfterLocation)(BMKUserLocation * _Nullable userLoaction, NSError * _Nullable error);

@property(nonatomic, copy  , nonnull) NSString *evTag;

- (id)initWithLocationBlock:(void (^ _Nonnull)(BMKUserLocation * _Nullable userLoaction, NSError * _Nullable error))blcAfterLocation
                        tag:(NSString * _Nonnull)tag;

@end

@implementation LFLocationBlock

- (void)dealloc{
    
    [self setEvblcAfterLocation:nil];
}

- (id)initWithLocationBlock:(void (^ _Nonnull)(BMKUserLocation * _Nullable userLoaction, NSError * _Nullable error))blcAfterLocation
                        tag:(NSString * _Nonnull)tag;{
    
    self = [super init];
    
    if (self) {
        
        [self setEvTag:tag];
        [self setEvblcAfterLocation:blcAfterLocation];
    }
    return self;
}

@end


@interface LFSearchAddressBlock : NSObject

@property(nonatomic, copy  , nonnull) void (^ evblcAfterGeoSearch)(BMKReverseGeoCodeResult * _Nullable localAddress, NSError * _Nullable error);

@property(nonatomic, copy  , nonnull) NSString * evTag;

- (id)initWithGeoSearchBlock:(void (^ _Nonnull)(BMKReverseGeoCodeResult * _Nullable localAddress, NSError * _Nullable error))blcAfterGeoSearch
                         tag:(NSString * _Nonnull)tag;

@end

@implementation LFSearchAddressBlock

- (void)dealloc{
    
    [self setEvblcAfterGeoSearch:nil];
}

- (id)initWithGeoSearchBlock:(void (^ _Nonnull)(BMKReverseGeoCodeResult * _Nullable localAddress, NSError * _Nullable error))blcAfterGeoSearch
                         tag:(NSString * _Nonnull)tag;{
    
    self = [super init];
    
    if (self) {
        
        [self setEvTag:tag];
        [self setEvblcAfterGeoSearch:blcAfterGeoSearch];
    }
    return self;
}

@end

@interface XLFMulticastDelegate (BMKLocationServiceDelegate)<BMKLocationServiceDelegate>

@end

@interface LFLocationManager ()<BMKLocationServiceDelegate, BMKGeneralDelegate, BMKGeoCodeSearchDelegate>

@property(nonatomic, strong, nonnull) BMKMapManager *evMapManager;

@property(nonatomic, strong, nonnull) BMKLocationService *evLocationService;

@property(nonatomic, strong, nonnull) BMKGeoCodeSearch *evGeoSearcher;

@property(nonatomic, strong, nonnull) XLFMulticastDelegate<BMKLocationServiceDelegate> *evDelegate;

@property(nonatomic, strong, nullable) BMKReverseGeoCodeResult *evLocalAddress;

@property(nonatomic, strong, nullable) BMKUserLocation *evUserLoaction;

@property(nonatomic, strong, nonnull) NSMutableArray *evblcLocationBlocks;

@property(nonatomic, strong, nonnull) NSMutableArray *evblcSearchAddressBlocks;

@property(nonatomic, strong, nullable) NSTimer *evLocationSleepTimer;

@property(nonatomic, strong, nullable) NSTimer *evLocationNotRepsponseDelayTimer;

@property(nonatomic, assign) BOOL evHasSearchLocalAddress;

@property(nonatomic, assign) CLLocationCoordinate2D evLastGeoCoordinate;
@property(nonatomic, assign) CLLocationCoordinate2D evLastestUserCoordinate;

@property(nonatomic, strong, nullable) NSDate *evLastestLocationDate;
@property(nonatomic, copy  , nullable) NSString *evCityName;

@end

@implementation LFLocationManager

- (void)dealloc{
    
    [self _efDestroyLocationSleepTimer];
    
    [[self evGeoSearcher] setDelegate:nil];
    
    [self efStopUserLocationService];
    
    [self setEvLocationService:nil];
    
    [self setEvUserLoaction:nil];
    
    [self setEvDelegate:nil];
    
    [self setEvGeoSearcher:nil];
    [self setEvCityName:nil];
    [self setEvLastestLocationDate:nil];
}

#pragma mark - public

+ (_Nonnull id)shareLocationManager;{
    
    static LFLocationManager *etLocationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        etLocationManager = [[LFLocationManager alloc] init];
    });
    return etLocationManager;
}

- (id)init{
    self = [super init];
    
    if (self) {
        
        [self setEvEnableLocateAddree:YES];
        [self setEvNotResponseDelay:2];
        [self setEvLocationSleepDelayIntervel:5];
        [self setEvLastestLocationValidIntervel:20];
    }
    return self;
}

+ (void)efConfigurate;{
    
    [[self shareLocationManager] _efConfigurate];
}

- (void)efStartUserLocationService;{
    
    [[self evLocationService] startUserLocationService];
}

- (void)efStopUserLocationService;{
    
    [[self evLocationService] stopUserLocationService];
}

- (void)efAddLocationWithTag:(NSString *)tag
                    callback:(void (^)(BMKUserLocation *userLocation, NSError * _Nullable error))callback;{
    
    if ([self evUserLoaction] && [[NSDate date] timeIntervalSinceDate:[self evLastestLocationDate]] < [self evLastestLocationValidIntervel]) {
        
        NIF_DEBUG(@"已存在已知的位置，更新时间小于有效时间间隔，准备回调", nil);
        callback([self evUserLoaction], nil);
    }
    else{
        
        [self _efDestroyLocationSleepTimer];
        
        [self efStartUserLocationService];
        
        if (![self _efFindLocationBlockWithTag:tag]) {
            
            [[self evblcLocationBlocks] addObject:[[LFLocationBlock alloc] initWithLocationBlock:callback tag:tag]];
        }
        
        if (![self evLocationNotRepsponseDelayTimer]) {
            
            [self _efScheduleNotRepsponseDelayTimer];
        }
    }
}

- (void)efAddGeoSearchWithTag:(NSString *)tag
                     callback:(void (^)(BMKReverseGeoCodeResult * _Nullable localAddress, NSError * _Nullable error))callback;{
    
    CLLocationDistance etDistanceOffset = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate([self evLastestUserCoordinate]), BMKMapPointForCoordinate([self evLastGeoCoordinate]));
    
    if ([self evLocalAddress] &&  etDistanceOffset < 10 && [[NSDate date] timeIntervalSinceDate:[self evLastestLocationDate]] < [self evLastestLocationValidIntervel]) {
        
        NIF_DEBUG(@"已存在已知的地址信息，并且位置偏移小于10米，更新时间小于有效时间间隔，准备回调", nil);
        callback([self evLocalAddress], nil);
    }
    else{
        
        [self _efDestroyLocationSleepTimer];
        
        [self efStartUserLocationService];
        
        if (![self _efFindGeoSearchBlockWithTag:tag]) {
            
            [[self evblcSearchAddressBlocks] addObject:[[LFSearchAddressBlock alloc] initWithGeoSearchBlock:callback tag:tag]];
            
            if (![self _efFindLocationBlockWithTag:NSStringFromClass([self class])]) {
                
                Weakself(ws);
                
                [self efAddLocationWithTag:NSStringFromClass([self class])
                                  callback:^(BMKUserLocation *userLocation, NSError * _Nullable error) {
                                      
                                      if (!error) {
                                          
                                          [ws _efSearchAddressByLocation:[[userLocation location] coordinate]];
                                      }
                                  }];
            }
        }
    }
}

- (void)efAddLocationDelegate:(id<BMKLocationServiceDelegate>)delegate;{
    
    [[self evDelegate] removeDelegate:delegate];
    [[self evDelegate] addDelegate:delegate];
    
    [self _efDestroyLocationSleepTimer];
    
    [self efStartUserLocationService];
}

- (void)efRemoveLocationDelegate:(id<BMKLocationServiceDelegate>)delegate;{
    
    [[self evDelegate] removeDelegate:delegate];
}

- (void)efRemoveBlockWithTag:(NSString * _Nonnull)tag;{
    
    [self efRemoveLocationBlockWithTag:tag];
    [self efRemoveGeoSearchBlockWithTag:tag];
}

- (void)efRemoveLocationBlockWithTag:(NSString * _Nonnull)tag;{
    
    LFLocationBlock *etLocationBlock = [self _efFindLocationBlockWithTag:tag];
    
    if (etLocationBlock) {
        
        [[self evblcLocationBlocks] removeObject:etLocationBlock];
    }
}

- (void)efRemoveGeoSearchBlockWithTag:(NSString * _Nonnull)tag;{
    
    LFSearchAddressBlock *etSearchAddressBlock = [self _efFindGeoSearchBlockWithTag:tag];
    
    if (etSearchAddressBlock) {
        
        [[self evblcSearchAddressBlocks] removeObject:etSearchAddressBlock];
    }
}

#pragma mark - accessory

- (BMKMapManager *)evMapManager{
    
    if (!_evMapManager) {
        
        _evMapManager = [[BMKMapManager alloc] init];
    }
    return _evMapManager;
}

- (XLFMulticastDelegate *)evDelegate{
    
    if (!_evDelegate) {
        
        _evDelegate = [[XLFMulticastDelegate alloc] init];
    }
    return _evDelegate;
}

- (BMKLocationService *)evLocationService{
    
    if (!_evLocationService) {
        
        _evLocationService = [[BMKLocationService alloc] init];
        [_evLocationService setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_evLocationService setDistanceFilter:20];
        [_evLocationService setDelegate:self];
    }
    return _evLocationService;
}

- (BMKGeoCodeSearch *)evGeoSearcher{
    
    if (!_evGeoSearcher) {
        
        _evGeoSearcher = [[BMKGeoCodeSearch alloc] init];
    }
    return _evGeoSearcher;
}

- (NSMutableArray *)evblcLocationBlocks{
    
    if (!_evblcLocationBlocks) {
        
        _evblcLocationBlocks = [NSMutableArray array];
    }
    return _evblcLocationBlocks;
}

- (NSMutableArray *)evblcSearchAddressBlocks{
    
    if (!_evblcSearchAddressBlocks) {
        
        _evblcSearchAddressBlocks = [NSMutableArray array];
    }
    return _evblcSearchAddressBlocks;
}

- (void)setEvUserLoaction:(BMKUserLocation *)evUserLoaction{
    
    if (_evUserLoaction != evUserLoaction) {
        
        _evUserLoaction = evUserLoaction;
    }
}

#pragma mark - private

- (void)_efConfigurate;{
    
    [self _efInitFromDisk];
    
    BOOL etSuccess = [[self evMapManager] start:egBaiduAppKey generalDelegate:self];
    NIF_DEBUG(@"BMKMapManager appKey : %@, start result : %@", egBaiduAppKey, @(etSuccess));
    
    if (etSuccess) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didNotificateNetworkStatusChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        if ([self evEnableLocateAddree]) {
            [self _efAddLocalAddressLocation];
        }
        
        [self efStartUserLocationService];
    }
}

- (void)_efAddLocalAddressLocation{
    
    Weakself(ws);
    
    [self efAddLocationWithTag:NSStringFromClass([self class])
                      callback:^(BMKUserLocation *userLocation, NSError * _Nullable error)
     {
         if (!error) {
             
             [ws _efSearchAddressByLocation:[[userLocation location] coordinate]];
         }
         else{
             
             [MBProgressHUD showWithStatus:@"获取当前位置失败"];
         }
     }];
}

- (void)_efExecuteLocationBlock:(NSError * _Nullable)error;{
    
    NIF_CONDITION([[self evblcLocationBlocks] count], NIF_DEBUG(@"开始执行定位回调Block", nil));
    
    for (LFLocationBlock *etblcLocation in [self evblcLocationBlocks]) {
        
        NIF_DEBUG(@"准备执行定位回调Block ： %@", etblcLocation);
        etblcLocation.evblcAfterLocation([self evUserLoaction], error);
    }
    [[self evblcLocationBlocks] removeAllObjects];
}

- (void)_efExecuteSearchAddressBlock:(NSError * _Nullable)error;{
    
    NIF_CONDITION([[self evblcSearchAddressBlocks] count], NIF_DEBUG(@"开始执行地址检索回调Block", nil));
    
    for (LFSearchAddressBlock *etblcSearchAddress in [self evblcSearchAddressBlocks]) {
        
        etblcSearchAddress.evblcAfterGeoSearch([self evLocalAddress], error);
        
        NIF_DEBUG(@"准备执行地址检索回调Block ： %@", etblcSearchAddress);
    }
    [[self evblcSearchAddressBlocks] removeAllObjects];
}

- (void)_efSearchAddressByLocation:(CLLocationCoordinate2D)location;{
    
    NIF_DEBUG(@"准备开始检索当前地址", nil);
    
    [[self evGeoSearcher] setDelegate:self];
    
    BMKReverseGeoCodeOption *etReverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    [etReverseGeoCodeSearchOption setReverseGeoPoint:location];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        BOOL etSuccess = [[self evGeoSearcher] reverseGeoCode:etReverseGeoCodeSearchOption];
        
        NIF_DEBUG(@"反geo检索发送%@", select(etSuccess, @"成功", @"失败"));
    });
}

- (void)_efInitFromDisk{
    
    NSDictionary *etUserLocationInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:SDArchiverFolder(LFLocationManagerLocationInfoArchive)];
    
    if (etUserLocationInfo) {
        
        CLLocationCoordinate2D etCoordinate = CLLocationCoordinate2DMake([[etUserLocationInfo objectForKey:@"latitude"] floatValue],
                                                                         [[etUserLocationInfo objectForKey:@"longitude"] floatValue]);
        
        [self setEvLastestUserCoordinate:etCoordinate];
        [self setEvCityName:[etUserLocationInfo objectForKey:@"city"]];
        [self setEvLastestLocationDate:[NSDate dateFromString:[etUserLocationInfo objectForKey:@"lastestLocationDate"] format:@"yyyy-MM-dd HH:mm:ss.fff"]];
    }
}

- (void)_efUpdateToDisk{
    
    NSDictionary *etUserLocationInfo = @{@"latitude":ftos([self evLastestUserCoordinate].latitude),
                                         @"longitude":ftos([self evLastestUserCoordinate].longitude),
                                         @"city":ntoe([self evCityName]),
                                         @"lastestLocationDate":ntoe([[self evLastestLocationDate] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss.fff"])};
    
    [NSKeyedArchiver archiveRootObject:etUserLocationInfo toFile:SDArchiverFolder(LFLocationManagerLocationInfoArchive)];
}

- (LFLocationBlock *)_efFindLocationBlockWithTag:(NSString *)tag{
    
    __block LFLocationBlock * etLocationBlock = nil;
    [[self evblcLocationBlocks] enumerateObjectsUsingBlock:^(LFLocationBlock * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj evTag] isEqualToString:tag]) {
            
            etLocationBlock = obj;
            *stop = YES;
        }
    }];
    return etLocationBlock;
}

- (LFSearchAddressBlock *)_efFindGeoSearchBlockWithTag:(NSString *)tag{
    
    __block LFSearchAddressBlock * etGeoSearchBlock = nil;
    [[self evblcSearchAddressBlocks] enumerateObjectsUsingBlock:^(LFSearchAddressBlock * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj evTag] isEqualToString:tag]) {
            
            etGeoSearchBlock = obj;
            *stop = YES;
        }
    }];
    return etGeoSearchBlock;
}

- (void)_efScheduleLocationSleepTimer{
    
    [self _efDestroyLocationSleepTimer];
    
    [self setEvLocationSleepTimer:[NSTimer scheduledTimerWithTimeInterval:[self evLocationSleepDelayIntervel]
                                                                   target:self selector:@selector(didTriggerLocationSleepTimer:)
                                                                 userInfo:nil
                                                                  repeats:NO]];
}

- (void)_efDestroyLocationSleepTimer{
    
    if ([self evLocationSleepTimer]) {
        [[self evLocationSleepTimer] invalidate];
    }
    [self setEvLocationSleepTimer:nil];
}

- (BOOL)_efShouldStopLocationService{
    
    return ![[self evDelegate] count] && ![[self evblcLocationBlocks] count];
}


- (void)_efScheduleNotRepsponseDelayTimer{
    
    [self _efDestroyLocationNotRepsponseDelayTimer];
    
    [self setEvLocationNotRepsponseDelayTimer:[NSTimer scheduledTimerWithTimeInterval:[self evNotResponseDelay]
                                                                               target:self selector:@selector(didTriggerLocationNotRepsponseDelayTimer:)
                                                                             userInfo:nil
                                                                              repeats:NO]];
}

- (void)_efDestroyLocationNotRepsponseDelayTimer{
    
    if ([self evLocationNotRepsponseDelayTimer]) {
        [[self evLocationNotRepsponseDelayTimer] invalidate];
    }
    [self setEvLocationNotRepsponseDelayTimer:nil];
}

#pragma mark - BMKLocationServiceDelegate

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser;{
    
    NIF_DEBUG(@"即将开始定位服务", nil);
    
    if ([[self evDelegate] hasDelegateThatRespondsToSelector:@selector(willStartLocatingUser)]) {
        
        [[self evDelegate] willStartLocatingUser];
    }
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser;{
    
    NIF_DEBUG(@"已关闭定位服务", nil);
    if ([[self evDelegate] hasDelegateThatRespondsToSelector:@selector(didStopLocatingUser)]) {
        
        [[self evDelegate] didStopLocatingUser];
    }
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation;{
    
    NIF_INFO(@"定位成功，用户位置方向发生改变", nil);
    
    [self setEvUserLoaction:userLocation];
    
    if ([[self evDelegate] hasDelegateThatRespondsToSelector:@selector(didUpdateUserHeading:)]) {
        
        [[self evDelegate] didUpdateUserHeading:userLocation];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;{
    
    if(BMKCoordinateIsZero([[userLocation location] coordinate])){
        return;
    }
    
    NIF_INFO(@"定位成功，用户位置经纬度发生改变", nil);
    
    [self setEvUserLoaction:userLocation];
    [self setEvLastestLocationDate:[NSDate date]];
    [self setEvLastestUserCoordinate:[[userLocation location] coordinate]];
    
    [self _efUpdateToDisk];
    
    [self _efDestroyLocationNotRepsponseDelayTimer];
    [self _efExecuteLocationBlock:nil];
    
    if ([[self evDelegate] hasDelegateThatRespondsToSelector:@selector(didUpdateBMKUserLocation:)]) {
        [[self evDelegate] didUpdateBMKUserLocation:userLocation];
    }
    
    if ([self _efShouldStopLocationService]) {
        [self _efScheduleLocationSleepTimer];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error;{
    
    NIF_ERROR(@"定位失败 : %@", error);
    
    [self _efExecuteLocationBlock:error];
    
    if ([[self evDelegate] hasDelegateThatRespondsToSelector:@selector(didFailToLocateUserWithError:)]) {
        
        [[self evDelegate] didFailToLocateUserWithError:error];
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;{
    [searcher setDelegate:nil];
    
    NSError *etError = nil;
    
    if (BMK_SEARCH_NO_ERROR == error) {
        
        NIF_DEBUG(@"根据当前经纬度获取地址已完成, 当前地址：%@, 当前城市：%@", [result address], [[result addressDetail] city]);
        
        [self setEvLocalAddress:result];
        [self setEvHasSearchLocalAddress:YES];
        [self setEvCityName:[[result addressDetail] city]];
        [self setEvLastGeoCoordinate:[result location]];
        
        [self _efUpdateToDisk];
    }
    else{
        
        etError = [NSError errorWithDomain:@"com.udriving.user.test.LFLocationManager" code:error userInfo:nil];
        
        NIF_ERROR(@"获取当前地址失败 : %@", etError);
    }
    
    [self _efExecuteSearchAddressBlock:etError];
}

#pragma mark - BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError;{
    
}

- (void)onGetPermissionState:(int)iError;{
    
}

#pragma mark - actions

- (IBAction)didTriggerLocationSleepTimer:(id)sender{
    
    [self _efDestroyLocationSleepTimer];
    
    if ([self _efShouldStopLocationService]) {
        
        [self efStopUserLocationService];
    }
}

- (IBAction)didTriggerLocationNotRepsponseDelayTimer:(id)sender{
    
    [self _efDestroyLocationNotRepsponseDelayTimer];
    
    if ([self evUserLoaction]) {
        
        [self _efExecuteLocationBlock:nil];
    }
}

- (IBAction)didNotificateNetworkStatusChanged:(NSNotification *)sender{
    
    Reachability *etReachablity = [sender object];
    
    if ([etReachablity isReachable] && ![self evHasSearchLocalAddress]) {
        
        [self _efAddLocalAddressLocation];
        [self efStartUserLocationService];
    }
}

@end

CGFloat BMKZoomLevelFromDistance(CLLocationDistance distance, int scaleBarSize){
    
    static int SCALE[] = {0, 1,     20,    50,    100,    200,    500,    1000,    2000,    5000,    10000,
        20000, 25000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, INT_MAX };
    
    if (!scaleBarSize) {
        scaleBarSize = 1;
    }
    distance /= scaleBarSize;
    
    for (int nIndex = 1; nIndex < 21; nIndex++) {
        
        if (distance < SCALE[nIndex]) {
            
            CGFloat etZoomIndex = nIndex + (distance - SCALE[nIndex - 1]) / (SCALE[nIndex] - SCALE[nIndex - 1]);
            
            return 21 - MAX(0, etZoomIndex - 1);
        }
    }
    
    return 19;
}

BOOL BMKCoordinateIsZero(CLLocationCoordinate2D coordinate){
    
    return coordinate.longitude == 0 && coordinate.latitude == 0;
}

BOOL BMKCoordinateEqaulToCoordinate(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2){
    
    return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude;
}

CGPoint BMKPointMakeWithCoordinate(CLLocationCoordinate2D coordinate){
    
    return CGPointMake(coordinate.longitude, coordinate.latitude);
}

CGFloat BMKBMKMetersBetweenCoordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2){
    
    return BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coordinate1), BMKMapPointForCoordinate(coordinate2));
}
