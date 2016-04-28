//
//  LFCategoryMenuVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFCategoryMenuVC.h"

#import "LFCategoryManager.h"

@interface LFCategoryMenuVC ()<UITableViewDelegate, UITableViewDataSource, LFHttpRequestManagerProtocol>

@property(nonatomic, assign) id<LFCategoryMenuVCDelegate> evDelegate;

@property(nonatomic, strong) UITableView *evtbvContainer;

@property(nonatomic, strong) NSMutableArray<LFCategory *> *evCategories;

@property(nonatomic, strong) LFCategory *evSelectedCategory;

@end

@implementation LFCategoryMenuVC

- (instancetype)initWithDelegate:(id<LFCategoryMenuVCDelegate>)delegate;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"类别"];
        [self setEvDelegate:delegate];
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setUserInteractionEnabled:NO];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:[self evtbvContainer]];
    [[self evtbvContainer] setTableFooterView:[UIView emptyFrameView]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [LFCategoryManagerRef efFetchCategories:[self _efFetchCategoriesCallback]];
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
        [[ws evCategories] addObject:[LFCategory modelWithAttributes:@{@"name":@"全部"}]];
        [[ws evCategories] addObjectsFromArray:categories];
        
        [ws _efFetchCategoriesEnd];
    };
}

- (void)_efFetchCategoriesEnd{
    
    [[self evtbvContainer] reloadData];
    
    [[self evtbvContainer] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

    [self setEvSelectedCategory:[[self evCategories] firstObject]];
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

- (void)menuControllerDidSwip:(LFPullMenuViewController *)menuController progress:(CGFloat)progress;{
    
    NSIndexPath *etSelectedIndexPath = [[self evtbvContainer] indexPathForSelectedRow];
    
    CGFloat etOffsetPerCell = (SCREEN_WIDTH - CGRectGetWidth([[self view] bounds])) / [[self evCategories] count];
    
    etOffsetPerCell = MIN(etOffsetPerCell, 30);
    
    NSInteger etWillSelectedIndex = MIN((int)progress/etOffsetPerCell, [[self evtbvContainer] numberOfRowsInSection:0] - 1);
    
    if ((!etSelectedIndexPath || (etSelectedIndexPath && [etSelectedIndexPath row] != etWillSelectedIndex)) && etWillSelectedIndex >= 0 && etWillSelectedIndex < [[self evCategories] count]) {
        
        [[self evtbvContainer] selectRowAtIndexPath:[NSIndexPath indexPathForRow:etWillSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self setEvSelectedCategory:[[self evCategories] objectAtIndex:etWillSelectedIndex]];
    }
}

- (void)menuControllerDidClose:(LFPullMenuViewController *)menuController;{
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epMenuVC:didSelectedCategory:)]) {
        
        [[self evDelegate] epMenuVC:self didSelectedCategory:[self evSelectedCategory]];
    }
}

@end
