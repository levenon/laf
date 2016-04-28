//
//  LFAddressSelectorVC
//  LFrivingCustomer
//
//  Created by Marike Jave on 15/8/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "LFAddressSelectorVC.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "LFAddressSelectorCell.h"

#import "LFLocationManager.h"

const CGFloat LFAddressSelectorCellHeight = 63;

NSString * const LFLocationSelectorVCHistoryAddressArchive = @"com.archive.historyAddress";

typedef NS_ENUM(NSInteger, LFLocationSelectorShowType) {
    
    LFLocationSelectorShowTypeHistory,
    LFLocationSelectorShowTypeSearchResult
};

@interface LFAddressSelectorVC ()< UISearchBarDelegate , UISearchDisplayDelegate , UITableViewDataSource , UITableViewDelegate, BMKPoiSearchDelegate>

@property(nonatomic, copy  ) void (^evblcCompletionCallback)(LFAddressSelectorVC *addressSelector, LFLocation *address);

@property(nonatomic, strong) UISearchBar *evSearchBar;

@property(nonatomic, strong) UIBarButtonItem *evbbiConfirm;

@property(nonatomic, strong) NSMutableArray *evHistoryAddresses;

@property(nonatomic, strong) NSArray *evAddresses;

@property(nonatomic, strong) UIButton *evbtnClearHistory;

@property(nonatomic, assign) LFLocationSelectorShowType evShowType;

@property(nonatomic, strong) BMKPoiSearch *evPoiSearcher;

@property(nonatomic, copy  ) NSString *evKeyword;

@property(nonatomic, copy  ) NSString *evCityName;

@end

@implementation LFAddressSelectorVC

- (void)dealloc{
    
    if ([self evPoiSearcher]) {
        [[self evPoiSearcher] setDelegate:nil];
    }
    
    [self setEvAddresses:nil];
    [self setEvSearchBar:nil];
    [self setEvbbiConfirm:nil];
    [self setEvHistoryAddresses:nil];
    [self setEvAddresses:nil];
    [self setEvPoiSearcher:nil];
}

- (instancetype)initWithCityName:(NSString *)cityName
                  defaultKeyword:(NSString *)defaultKeyword
              completionCallback:(void (^)(LFAddressSelectorVC *addressSelector, LFLocation *address))completionCallback;{

    self = [super init];
    if (self) {
        
        [self setEvCityName:cityName];
        [self setEvKeyword:defaultKeyword];
        [self setEvblcCompletionCallback:completionCallback];
        
        [self _efInitFromDisk];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self evSearchBar] setText:[self evKeyword]];
    
    [[self navigationItem] setTitleView:[self evSearchBar]];
    [[self tableView] setTableFooterView:[self evbtnClearHistory]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _efSearchAddressByKeyword:[self evKeyword]
                             inCity:[self evCityName]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self evSearchBar] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self evSearchBar] resignFirstResponder];
    
    [self _efDestroyPoiSearcher];
}

#pragma mark - accessory

- (UISearchBar *)evSearchBar{
    
    if (!_evSearchBar) {
        
        _evSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 30)];
        
        [_evSearchBar setDelegate:self];
        [_evSearchBar setPlaceholder:@"请输入地址"];
        [_evSearchBar setTintColor:[UIColor blueColor]];
    }
    return _evSearchBar;
}

- (NSArray *)evAddresses{
    
    if (!_evAddresses) {
        
        _evAddresses = @[];
    }
    return _evAddresses;
}

- (NSMutableArray *)evHistoryAddresses{
    
    if (!_evHistoryAddresses) {
        
        _evHistoryAddresses = [NSMutableArray array];
    }
    return _evHistoryAddresses;
}

- (UIButton *)evbtnClearHistory{
    
    if (!_evbtnClearHistory) {
        
        _evbtnClearHistory = [[UIButton alloc] initWithFrame:CGRectMakePWH(CGPointZero, 0, 80)];
        
        [_evbtnClearHistory setTitle:@"清除历史记录"
                            forState:UIControlStateNormal];
        [_evbtnClearHistory setTitleColor:[UIColor grayColor]
                                 forState:UIControlStateNormal];
        [_evbtnClearHistory addTarget:self
                               action:@selector(didClickClearHistory:)
                     forControlEvents:UIControlEventTouchUpInside];
        [[_evbtnClearHistory titleLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    }
    return _evbtnClearHistory;
}

- (void)setEvShowType:(LFLocationSelectorShowType)evShowType{
    
    _evShowType = evShowType;
    
    [[self evbtnClearHistory] setAlpha:!evShowType];
    [[self evbtnClearHistory] setEnabled:!evShowType];
}

#pragma mark - private

- (void)_efSearchAddressByKeyword:(NSString *)keyword inCity:(NSString*)city;{
    
    if ([self evPoiSearcher]) {
        return;
    }
    
    BMKCitySearchOption *etSearchOption = [[BMKCitySearchOption alloc]init];
    [etSearchOption setPageIndex:0];
    [etSearchOption setPageCapacity:20];
    [etSearchOption setKeyword:keyword];
    [etSearchOption setCity:city];
    
    [self setEvPoiSearcher:[[BMKPoiSearch alloc] init]];
    [[self evPoiSearcher] setDelegate:self];
    
    BOOL etSuccess = [[self evPoiSearcher] poiSearchInCity:etSearchOption];
    
    NIF_DEBUG(@"检索周边地址请求发送%@", select(etSuccess, @"成功", @"失败"));
}

- (LFLocation *)_efAddressFrom:(BMKReverseGeoCodeResult *)geoCodeResult;{
    
    if ([geoCodeResult poiList] && [[geoCodeResult poiList] count]) {
        return [self _efAddressFromPoiInfo:[[geoCodeResult poiList] firstObject]];
    }
    
    LFLocation *etAddress = [LFLocation model];
    [etAddress setLatitude:[geoCodeResult location].latitude];
    [etAddress setLongitude:[geoCodeResult location].longitude];
    
    if ([[geoCodeResult address] rangeOfString:[[geoCodeResult addressDetail] city]].length) {
        [etAddress setAddress:[geoCodeResult address]];
    }
    else{
        [etAddress setAddress:fmts(@"%@%@", [[geoCodeResult addressDetail] city], [geoCodeResult address])];
    }
    
    NSMutableString *etNameDescription = [NSMutableString stringWithFormat:@"%@%@",
                                          [[geoCodeResult addressDetail] streetName],
                                          [[geoCodeResult addressDetail] streetNumber]];
    
    NSMutableString *etAddressDescription = [NSMutableString string];
    
    [etAddressDescription appendString:[[geoCodeResult addressDetail] city]];
    [etAddressDescription appendString:[[geoCodeResult addressDetail] district]];
    [etAddressDescription appendString:[[geoCodeResult addressDetail] streetName]];
    [etAddressDescription appendString:[[geoCodeResult addressDetail] streetNumber]];
    
    [etAddress setName:etNameDescription];
    [etAddress setAddress:etAddressDescription];
    
    return etAddress;
}

- (NSArray *)_efAddressesFromPoiInfos:(NSArray *)pointInfos{
    
    NSMutableArray *etAddresses = [NSMutableArray array];
    
    for (BMKPoiInfo *etPointInfo in pointInfos) {
        [etAddresses addObject:[self _efAddressFromPoiInfo:etPointInfo]];
    }
    return etAddresses;
}

- (LFLocation *)_efAddressFromPoiInfo:(BMKPoiInfo *)pointInfo{
    
    LFLocation *etAddress = [LFLocation model];
    
    [etAddress setName:[pointInfo name]];
    [etAddress setAddress:[pointInfo address]];
    [etAddress setLatitude:[pointInfo pt].latitude];
    [etAddress setLongitude:[pointInfo pt].longitude];
    
    return etAddress;
}

- (void)_efAddHistoryAddress:(LFLocation *)address;{
    
    if ([[self evHistoryAddresses] containsObject:address]) {
        
        NSInteger etIndex = [[self evHistoryAddresses] indexOfObject:address];
        [[self evHistoryAddresses] removeObjectAtIndex:etIndex];
    }
    
    [[self evHistoryAddresses] insertObject:address atIndex:0];
    
    [[self tableView] reloadData];
    
    [self _efUpdateToDisk];
}

- (void)_efUpdateToDisk{
    
    [NSKeyedArchiver archiveRootObject:[self evHistoryAddresses] toFile:SDArchiverFolder(LFLocationSelectorVCHistoryAddressArchive)];
}

- (void)_efInitFromDisk{
    
    [self setEvHistoryAddresses:[NSKeyedUnarchiver unarchiveObjectWithFile:SDArchiverFolder(LFLocationSelectorVCHistoryAddressArchive)]];
}

- (void)_efReloadDataWithAddresses:(NSArray *)addresses{
    
    [self setEvShowType:LFLocationSelectorShowTypeSearchResult];
    
    [self setEvAddresses:addresses];
    
    [[self tableView] reloadData];
}

- (void)_efDestroyPoiSearcher{
    
    if ([self evPoiSearcher]){
        [[self evPoiSearcher] setDelegate:nil];
    }
    [self setEvPoiSearcher:nil];
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode;{
    
    NIF_DEBUG(@"检索周边地址 已完成， 错误码 ：%d", errorCode);
    
    if (BMK_SEARCH_NO_ERROR == errorCode) {
        
        NSArray *etAddresses = [self _efAddressesFromPoiInfos:[poiResult poiInfoList]];
        
        NIF_INFO(@"检索周边地址 已完成， 结果 ：%@", etAddresses);
        [self _efReloadDataWithAddresses:etAddresses];
    }
    else{
        
        NIF_ERROR(@"搜索附近位置信息失败，错误码：%d", errorCode);
    }
    
    [self _efDestroyPoiSearcher];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    
    if ([[searchBar text] length]) {
        
        [self _efSearchAddressByKeyword:[searchBar text] inCity:[self evCityName]];
    }
    else{
        
        [self setEvShowType:LFLocationSelectorShowTypeHistory];
        [[self tableView] reloadData];
    }
    
    [[self evbbiConfirm] setEnabled:[[searchBar text] length]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    
    [self _efSearchAddressByKeyword:[searchBar text] inCity:[self evCityName]];
}

#pragma mark - UITableViewDataSource , UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return select([self evShowType], [[self evAddresses] count], [[self evHistoryAddresses] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LFAddressSelectorCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFAddressSelectorCell *etAddressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LFAddressSelectorCell class])];
    if (!etAddressCell) {
        
        etAddressCell = [[LFAddressSelectorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([LFAddressSelectorCell class])];
    }
    
    LFLocation *etAddress = [select([self evShowType], [self evAddresses], [self evHistoryAddresses]) objectAtIndex:[indexPath row]];
    
    [etAddressCell setEvAddress:etAddress];
    
    return etAddressCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFLocation *etAddress = [select([self evShowType], [self evAddresses], [self evHistoryAddresses]) objectAtIndex:[indexPath row]];
    
    [self _efAddHistoryAddress:etAddress];
    
    if ([self evblcCompletionCallback]) {
        
        self.evblcCompletionCallback(self, etAddress);
    }
}

#pragma mark - actions

- (IBAction)didClickClearHistory:(id)sender{
    
    NSArray *etIndexPaths = [NSIndexPath indexPathsFromIndex:0 count:[[self evHistoryAddresses] count]];
    
    [[self tableView] beginUpdates];
    [[self evHistoryAddresses] removeAllObjects];
    
    [[self tableView] deleteRowsAtIndexPaths:etIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];
    
    [self _efUpdateToDisk];
}

@end
