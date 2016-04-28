//
//  LFLocationDistributeVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFMapView.h"

#import "LFLocationDistributeVC.h"

#import "LFLocationManager.h"

@interface LFLocationDistributeVC ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property(nonatomic, strong) UIBarButtonItem *evbbiLocation;

@property(nonatomic, strong) LFMapView *evvMapContainer;

@property(nonatomic, strong) LFLocation *evLocation;

@property(nonatomic, strong) NSArray<LFLocation *> *evLocations;

@end

@implementation LFLocationDistributeVC

- (instancetype)initWithTitle:(NSString *)title location:(LFLocation *)location locations:(NSArray<LFLocation *> *)locations;{
    self = [super init];
    if (self) {
        
        [self setTitle:nstodefault(title, @"地图")];

        [self setEvLocation:location];
        [self setEvLocations:locations];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiLocation] type:XLFNavButtonTypeRight];
    
    [[self view] addSubview:[self evvMapContainer]];
    
    [self _efInstallConstraints];
    
    [[self evvMapContainer] setDelegate:self];
    [[self evvMapContainer] viewWillAppear];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self evvMapContainer] addAnnotations:[self evAllLocations]];
    [[self evvMapContainer] setCenterCoordinate:[[self evLocation] coordinate] animated:NO];
    [[self evvMapContainer] selectAnnotation:[self evLocation] animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![[self evvMapContainer] delegate]) {
        [[self evvMapContainer] setDelegate:self];
        [[self evvMapContainer] viewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self evvMapContainer] viewWillDisappear];
    [[self evvMapContainer] setDelegate:nil];
}

- (void)efRegisterNotification{
    [super efRegisterNotification];
    
//    [[LFLocationManager shareLocationManager] efAddLocationDelegate:self];
}

- (void)efDeregisterNotification{
    [super efDeregisterNotification];

    [[LFLocationManager shareLocationManager] efRemoveLocationDelegate:self];
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiLocation{
    
    if (!_evbbiLocation) {
        
        _evbbiLocation = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_icon_location_fixed"]
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(didClickLocation:)];
    }
    return _evbbiLocation;
}

- (LFMapView *)evvMapContainer{
    
    if (!_evvMapContainer) {
        
        _evvMapContainer = [LFMapView emptyFrameView];
        [_evvMapContainer setMinZoomLevel:10];
        [_evvMapContainer setMaxZoomLevel:20];
        [_evvMapContainer setZoomLevel:19];
        [_evvMapContainer setShowsUserLocation:YES];
        [_evvMapContainer setShowMapScaleBar:YES];
        [_evvMapContainer setMapScaleBarPosition:CGPointMake(16, CGRectGetHeight([[self view] bounds]) - 40)];
    }
    return _evvMapContainer;
}

- (NSArray *)evLocations{
    
    if (!_evLocations) {
        
        _evLocations = @[];
    }
    return _evLocations;
}

- (NSArray<LFLocation *> *)evAllLocations{
    
    NSMutableArray<LFLocation *> *allLocations = [NSMutableArray array];
    
    if ([self evLocation]) {
       [allLocations addObject:[self evLocation]];
    }
    
    [allLocations addObjectsFromArray:[self evLocations]];

    return allLocations;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evvMapContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (CLLocationCoordinate2D)_efCaculateCenterLocation{
    
    CGFloat etMaxLatitude = [[self evLocation] latitude];
    CGFloat etMaxLongitude = [[self evLocation] longitude];
    CGFloat etMinLatitude = [[self evLocation] latitude];
    CGFloat etMinLongitude = [[self evLocation] longitude];
    
    for (LFLocation *etLocation in [self evLocations]) {
        
        if ([etLocation latitude] > etMaxLatitude) {
            etMaxLatitude = [etLocation latitude];
        }
        
        if ([etLocation longitude] > etMaxLongitude) {
            etMaxLongitude = [etLocation longitude];
        }
        
        if ([etLocation latitude] < etMinLatitude) {
            etMinLatitude = [etLocation latitude];
        }
        
        if ([etLocation longitude] < etMinLongitude) {
            etMinLongitude = [etLocation longitude];
        }
    }
    
    return CLLocationCoordinate2DMake((etMaxLatitude + etMinLatitude) / 2., (etMaxLongitude + etMinLongitude) / 2.);
}

#pragma mark - actions

- (IBAction)didClickLocation:(UIBarButtonItem *)sender{
    
    [sender setEnabled:NO];
    
    BMKUserTrackingMode etLastUserTrackingMode = [[self evvMapContainer] userTrackingMode];
    BMKUserTrackingMode etUserTrackingMode = etLastUserTrackingMode;
    
    etUserTrackingMode = (etUserTrackingMode + 1) % 3;
    
    switch (etUserTrackingMode) {
        case BMKUserTrackingModeFollow:
        case BMKUserTrackingModeFollowWithHeading:
        {
            if (!etLastUserTrackingMode) {
                
                Weakself(ws);
                
                [[LFLocationManager shareLocationManager] efAddLocationWithTag:NSStringFromClass([self class]) callback:^(BMKUserLocation * _Nullable userLocation, NSError * _Nullable error) {
                    
                    if (!error) {
                        
                        NSInteger etNumberOfDelay = 0;
                        
                        CGFloat etDistance = BMKBMKMetersBetweenCoordinates([[ws evvMapContainer] centerCoordinate], [[userLocation location] coordinate]);
                        
                        if (etDistance > 500 && [[ws evvMapContainer] zoomLevel] != 15) {
                            
                            [[ws evvMapContainer] setZoomLevel:15];
                            etNumberOfDelay++;
                        }
                        
                        if (!BMKCoordinateEqaulToCoordinate([[ws evvMapContainer] centerCoordinate], [[userLocation location] coordinate])) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [[ws evvMapContainer] setCenterCoordinate:[[userLocation location] coordinate] animated:YES];
                            });
                            etNumberOfDelay++;
                        }
                        
                        if (etDistance > 500 && [[ws evvMapContainer] zoomLevel] != 20) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [[ws evvMapContainer] updateLocationData:userLocation];
                                [[ws evvMapContainer] setZoomLevel:20];
                            });
                            etNumberOfDelay++;
                        }
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.4 * etNumberOfDelay) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [[ws evvMapContainer] setUserTrackingMode:etUserTrackingMode];
                            [[ws evvMapContainer] updateLocationData:userLocation];
                            [[LFLocationManager shareLocationManager] efAddLocationDelegate:ws];
                            
                            [sender setEnabled:YES];
                        });
                    }
                    else {
                        
                        [MBProgressHUD showWithStatus:[error domain]];
                        [sender setEnabled:YES];
                    }
                }];
            }
            else{
                
                [[self evvMapContainer] setUserTrackingMode:etUserTrackingMode];
                [[LFLocationManager shareLocationManager] efAddLocationDelegate:self];
                [sender setEnabled:YES];
            }
        }
            break;
            
        default:
        {
            
            [[LFLocationManager shareLocationManager] efRemoveLocationDelegate:self];
            [[self evvMapContainer] setUserTrackingMode:etUserTrackingMode];
            
            NSInteger etNumberOfDelay = 0;
            
            if ([[self evvMapContainer] overlooking] != 0) {
                
                [[self evvMapContainer] setOverlooking:0];
                etNumberOfDelay++;
            }
            
            Weakself(ws);
            if ([[ws evvMapContainer] rotation]) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[ws evvMapContainer] setRotation:0];
                });
                etNumberOfDelay++;
            }
            
            if ([[self evvMapContainer] zoomLevel] != 15) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[ws evvMapContainer] setZoomLevel:15];
                });
                etNumberOfDelay++;
            }
            
            if (!BMKCoordinateEqaulToCoordinate([[self evvMapContainer] centerCoordinate], [[ws evLocation] coordinate])) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[ws evvMapContainer] setCenterCoordinate:[self _efCaculateCenterLocation] animated:NO];
                });
                etNumberOfDelay++;
            }
            
            if ([[ws evvMapContainer] zoomLevel] != 19) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * etNumberOfDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[ws evvMapContainer] setZoomLevel:19];
                    [sender setEnabled:YES];
                });
            }
            else{
                
                [sender setEnabled:YES];
            }
            
        }
            break;
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    BMKPinAnnotationView *etvAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([BMKPinAnnotationView class])];
    
    [etvAnnotation setPinColor:annotation != [self evLocation]];
    
    return etvAnnotation;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation;{
    
    [[self evvMapContainer] updateLocationData:userLocation];
    [[self evvMapContainer] setCenterCoordinate:[[userLocation location] coordinate] animated:YES];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;{
    
    [[self evvMapContainer] updateLocationData:userLocation];
    [[self evvMapContainer] setCenterCoordinate:[[userLocation location] coordinate] animated:YES];
}

@end
