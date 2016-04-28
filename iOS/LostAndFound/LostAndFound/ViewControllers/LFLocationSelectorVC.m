//
//  LFLocationSelectorVC.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLocationSelectorVC.h"

#import "LFMapView.h"

#import "LFLocationManager.h"

#import "LFLocation.h"

#import "LFAddressSelectorVC.h"

@interface LFLocationSelectorVC ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate, UITextFieldDelegate>

@property(nonatomic, copy  ) void (^evblcCompletionCallback)(LFLocationSelectorVC *locationSelector, LFLocation *location);

@property(nonatomic, strong) UIBarButtonItem *evbbiConfirm;

@property(nonatomic, strong) LFMapView *evvMapContainer;

@property(nonatomic, strong) BMKGeoCodeSearch *evGeoCodeSearcher;

@property(nonatomic, strong) LFLocation *evLocation;

@property(nonatomic, strong) UIImageView *evimgvLocation;

@property(nonatomic, strong) UITextField *evtxfAddress;

@property(nonatomic, strong) UIButton *evbtnCurrentLocation;

@property(nonatomic, copy  ) NSString *evCityName;

@end

@implementation LFLocationSelectorVC

- (instancetype)initWithCompletionCallback:(void (^)(LFLocationSelectorVC *locationSelector, LFLocation *location))completionCallback;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"选择地址"];
        [self setEvblcCompletionCallback:completionCallback];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiConfirm] type:XLFNavButtonTypeRight];
    [[self view] addSubview:[self evvMapContainer]];
    [[self view] addSubview:[self evtxfAddress]];
    [[self view] addSubview:[self evimgvLocation]];
    [[self view] addSubview:[self evbtnCurrentLocation]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self evvMapContainer] setDelegate:self];
    [[self evvMapContainer] viewWillAppear];
    
    Weakself(ws);
    [LFLocationManagerRef efAddLocationWithTag:NSStringFromClass([self class])
                                      callback:^(BMKUserLocation * _Nullable userLocation, NSError * _Nullable error)
     {
         [[ws evLocation] setCoordinate:[[userLocation location] coordinate]];
         [[ws evvMapContainer] setCenterCoordinate:[[userLocation location] coordinate] animated:NO];
         
         [ws _efSearchAddressByLocation:[[userLocation location] coordinate]];
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![[self evvMapContainer] delegate]) {
        
        [[self evvMapContainer] setDelegate:self];
        [[self evvMapContainer] viewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self evvMapContainer] viewWillDisappear];
    [[self evvMapContainer] setDelegate:nil];
    
    [self _efDestroyPoiSearcher];
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiConfirm{
    
    if (!_evbbiConfirm) {
        
        _evbbiConfirm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                      target:self
                                                                      action:@selector(didClickConfirm:)];
    }
    return _evbbiConfirm;
}

- (LFMapView *)evvMapContainer{
    
    if (!_evvMapContainer) {
        
        _evvMapContainer = [LFMapView emptyFrameView];
        
        [_evvMapContainer setZoomLevel:19];
        [_evvMapContainer setMinZoomLevel:10];
        [_evvMapContainer setMaxZoomLevel:20];
        [_evvMapContainer setShowMapScaleBar:YES];
        [_evvMapContainer setShowsUserLocation:YES];
        [_evvMapContainer setMapScaleBarPosition:CGPointMake(16, CGRectGetHeight([[self view] bounds]) - 40)];
    }
    return _evvMapContainer;
}

- (LFLocation *)evLocation{
    
    if (!_evLocation) {
        
        _evLocation = [LFLocation model];
    }
    return _evLocation;
}

- (UIImageView *)evimgvLocation{
    
    if (!_evimgvLocation) {
        
        _evimgvLocation = [UIImageView emptyFrameView];
        [_evimgvLocation setImage:[UIImage imageNamed:@"img_located_pin"]];
    }
    return _evimgvLocation;
}

- (UITextField *)evtxfAddress{
    
    if (!_evtxfAddress) {
        
        _evtxfAddress = [UITextField emptyFrameView];
        
        [_evtxfAddress setDelegate:self];
        [_evtxfAddress setPlaceholder:@"未选择地址"];
        [_evtxfAddress setFont:[UIFont systemFontOfSize:13]];
        [_evtxfAddress setTextAlignment:NSTextAlignmentCenter];
        [_evtxfAddress setBackgroundColor:[UIColor whiteColor]];
        [_evtxfAddress setBorderStyle:UITextBorderStyleRoundedRect];
        [_evtxfAddress setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
    }
    return _evtxfAddress;
}

- (UIButton *)evbtnCurrentLocation{
    
    if (!_evbtnCurrentLocation) {
        
        _evbtnCurrentLocation = [UIButton emptyFrameView];
        [_evbtnCurrentLocation setImage:[UIImage imageNamed:@"btn_location_my_normal"] forState:UIControlStateNormal];
        [_evbtnCurrentLocation setImage:[UIImage imageNamed:@"btn_location_my_highlighted"] forState:UIControlStateHighlighted];
        [_evbtnCurrentLocation addTarget:self action:@selector(didClickLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnCurrentLocation;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evvMapContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
    
    [[self evtxfAddress] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.evvMapContainer.mas_top).offset(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + 30);
        make.left.equalTo(ws.evvMapContainer.mas_left).offset(80);
        make.right.equalTo(ws.evvMapContainer.mas_right).offset(-80);
        make.height.equalTo(@40);
    }];
    
    [[self evimgvLocation] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.evvMapContainer.mas_centerX).offset(0);
        make.centerY.equalTo(ws.evvMapContainer.mas_centerY).offset(0);
    }];
    
    [[self evbtnCurrentLocation] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.view.mas_right).offset(-20);
        make.bottom.equalTo(ws.view.mas_bottom).offset(-20);
    }];
}

- (void)_efSearchAddressByLocation:(CLLocationCoordinate2D)location;{
    
    if ([self evGeoCodeSearcher]) {
        return;
    }
    
    NIF_DEBUG(@"准备开始检索当前地址", nil);
    
    [self setEvGeoCodeSearcher:[[BMKGeoCodeSearch alloc] init]];
    [[self evGeoCodeSearcher] setDelegate:self];
    
    BMKReverseGeoCodeOption *etReverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    [etReverseGeoCodeSearchOption setReverseGeoPoint:location];
    
    BOOL etSuccess = [[self evGeoCodeSearcher] reverseGeoCode:etReverseGeoCodeSearchOption];
    
    NIF_DEBUG(@"反geo检索发送%@", select(etSuccess, @"成功", @"失败"));
}

- (void)_efDestroyPoiSearcher{
    
    if ([self evGeoCodeSearcher]){
        [[self evGeoCodeSearcher] setDelegate:nil];
    }
    [self setEvGeoCodeSearcher:nil];
}

- (LFLocation *)_efAddressFromPoiInfo:(BMKPoiInfo *)pointInfo{
    
    LFLocation *etAddress = [LFLocation model];
    
    [etAddress setName:[pointInfo name]];
    [etAddress setAddress:[pointInfo address]];
    [etAddress setLatitude:[pointInfo pt].latitude];
    [etAddress setLongitude:[pointInfo pt].longitude];
    
    return etAddress;
}

- (void)_efLocateUserCoordinate{
    
    Weakself(ws);
    [LFLocationManagerRef efAddLocationWithTag:NSStringFromClass([self class])
                                      callback:^(BMKUserLocation * _Nullable userLocation, NSError * _Nullable error)
     {
         [[ws evvMapContainer] setCenterCoordinate:[[userLocation location] coordinate] animated:YES];

         [ws _efSearchAddressByLocation:[[userLocation location] coordinate]];
     }];
}

- (void)_efUpdateViewDisplay{
    
    [[self evtxfAddress] setText:[[self evLocation] name]];
    [[self evvMapContainer] setCenterCoordinate:[[self evLocation] coordinate] animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    [textField resignFirstResponder];
    
    LFAddressSelectorVC *etAddressSelectorVC = [[LFAddressSelectorVC alloc] initWithCityName:[self evCityName]
                                                                              defaultKeyword:[[self evLocation] name]
                                                                          completionCallback:[self _efAddressSelectorCallback]];
    
    [[self navigationController] pushViewController:etAddressSelectorVC animated:YES];
}

#pragma mark -

- (void (^)(LFAddressSelectorVC *addressSelector, LFLocation *address))_efAddressSelectorCallback{
    
    Weakself(ws);
    return ^(LFAddressSelectorVC *addressSelector, LFLocation *address){
        
        [ws setEvLocation:address];
        [ws _efUpdateViewDisplay];
        
        [[addressSelector navigationController] popViewControllerAnimated:YES];
    };
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error;{
    [searcher setDelegate:nil];
    
    if (BMK_SEARCH_NO_ERROR == error) {
        
        [self setEvCityName:[[result addressDetail] city]];
        
        [self setEvLocation:[LFLocation locationWithGeoCodeResult:result]];
        
        [self _efUpdateViewDisplay];
        
        [self _efDestroyPoiSearcher];
    }
}

#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;{
    
    [[self evLocation] setCoordinate:[mapView centerCoordinate]];
    
    if (!animated) {
        [self _efSearchAddressByLocation:[mapView centerCoordinate]];
    }
}

#pragma mark - actions

- (IBAction)didClickConfirm:(id)sender{
    
    if ([self evLocation] &&
        [[[self evLocation] name] length] &&
        [[[self evLocation] address] length] &&
        [self evblcCompletionCallback]) {
        
        self.evblcCompletionCallback(self, [self evLocation]);
    }
}

- (IBAction)didClickLocation:(UIBarButtonItem *)sender{
    
    [self _efLocateUserCoordinate];
}

@end
