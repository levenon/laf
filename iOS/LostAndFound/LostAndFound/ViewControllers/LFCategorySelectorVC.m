//
//  LFCategorySelectorVC.m
//  LostAndFound
//
//  Created by Marike Jave on 16/1/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFCategorySelectorVC.h"

#import "LFCategoryManager.h"

@interface LFCategorySelectorVC ()<UITableViewDelegate, UITableViewDataSource, LFHttpRequestManagerProtocol>

@property(nonatomic, assign) id<LFCategorySelectorVCDelegate> evDelegate;

@property(nonatomic, strong) UITableView *evtbvContainer;

@property(nonatomic, strong) NSMutableArray<LFCategory *> *evCategories;

@property(nonatomic, strong) LFCategory *evSelectedCategory;

@end

@implementation LFCategorySelectorVC

- (instancetype)initWithDelegate:(id<LFCategorySelectorVCDelegate>)delegate;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"类别"];
        [self setEvDelegate:delegate];
        [LFCategoryManagerRef efFetchCategories:[self _efFetchCategoriesCallback]];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] addSubview:[self evtbvContainer]];
    [[self evtbvContainer] setTableFooterView:[UIView emptyFrameView]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self evtbvContainer] reloadData];
}

#pragma mark - accessory

- (UITableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_evtbvContainer setDelegate:self];
        [_evtbvContainer setDataSource:self];
        [_evtbvContainer setBackgroundColor:[UIColor clearColor]];
        [_evtbvContainer setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _evtbvContainer;
}

- (NSMutableArray<LFCategory *> *)evCategories{
    
    if (!_evCategories) {
        
        _evCategories = [NSMutableArray array];
        
        //        [_evCategories addObject:[LFCategory modelWithAttributes:@{@"id":@1, @"name":@"距离最近"}]];
        //        [_evCategories addObject:[LFCategory modelWithAttributes:@{@"id":@2, @"name":@"发布最新"}]];
    }
    return _evCategories;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void (^)(NSArray<LFCategory *> *categories))_efFetchCategoriesCallback{
    
    Weakself(ws);
    return ^(NSArray<LFCategory *> *categories){
        
        [[ws evCategories] removeAllObjects];
        [[ws evCategories] addObjectsFromArray:categories];
        
        [ws _efFetchCategoriesEnd];
    };
}

- (void)_efFetchCategoriesEnd{
    
    if ([self isViewLoaded]) {
        
        [[self evtbvContainer] reloadData];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self evCategories] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFCategory *etCategory = [[self evCategories] objectAtIndex:[indexPath row]];
    
    UITableViewCell *etTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!etTableViewCell) {
        
        etTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    [etTableViewCell setBackgroundColor:[UIColor clearColor]];
    [[etTableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    [[etTableViewCell textLabel] setTextColor:[UIColor grayColor]];
    
    [[etTableViewCell textLabel] setText:[etCategory name]];
    
    return etTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFCategory *etCategory = [[self evCategories] objectAtIndex:[indexPath row]];
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epCategorySelectorVC:didSelectedCategory:)]) {
        [[self evDelegate] epCategorySelectorVC:self didSelectedCategory:etCategory];
    }
}

@end
