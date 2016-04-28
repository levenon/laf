//
//  LFCommonImagesSelectorVC.m
//  ImageAndFound
//
//  Created by Marike Jave on 16/2/21.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFCommonImagesSelectorVC.h"

#import "LFCommonImageCell.h"

@interface LFCommonImagesSelectorVC ()

@property(nonatomic, copy  ) void (^evImageSelectCallback)(LFCommonImagesSelectorVC *commonImagesSelectorVC, LFPhoto *photo);

@property(nonatomic, strong) NSMutableArray<LFImage *> *evImages;

@end

@implementation LFCommonImagesSelectorVC

- (id)initWithImageSelectCallback:(void (^)(LFCommonImagesSelectorVC *commonImagesSelectorVC, LFPhoto *photo))imageSelectCallback;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"常用图片"];
        [self setEvImageSelectCallback:imageSelectCallback];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self tableView] setRowHeight:SCREEN_WIDTH * 0.7 + 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tableView] registerClass:[LFCommonImageCell class] forCellReuseIdentifier:NSStringFromClass([LFCommonImageCell class])];
    [[self tableView] setTableFooterView:[UIView emptyFrameView]];
    
    [self _efLoadImages:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (NSMutableArray<LFImage *> *)evImages{
    
    if (!_evImages) {
        
        _evImages = [NSMutableArray array];
    }
    return _evImages;
}

#pragma mark - private

- (void)_efLoadImages:(BOOL)loadMore{
    
    [self setEvLoadMore:loadMore];
    
    LFHttpRequest *etreqLoadImages = [self efGetCommonImagesWithPage:select(loadMore, [self evCurrentPage] + 1, 0)
                                                                size:5
                                                             success:[self _efLoadImagesSuccess]
                                                             failure:[self _efLoadImagesFailed]];
    
    [etreqLoadImages startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efLoadImagesSuccess{
    
    Weakself(ws);
    
    return ^(id request, id result, NSArray<LFImage *> *images){
        
        if (images && [images count]) {
            
            if (![ws evLoadMore]) {
                
                [ws _efRefreshImages:images];
            }
            else{
                
                [ws _efLoadMoreImages:images];
            }
        }
        [ws _efTriggerEnd];
    };
}

- (XLFFailedBlock)_efLoadImagesFailed{
    
    Weakself(ws);
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        [ws _efTriggerEnd];
    };
}

- (void)_efRefreshImages:(NSArray <LFImage *>*)images{
    
    [[self tableView] beginUpdates];
    
    [[self evImages] insertObjects:images atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [images count])]];
    [[self tableView] insertRowsAtIndexPaths:[NSIndexPath indexPathsFromIndex:0 count:[images count]]
                            withRowAnimation:UITableViewRowAnimationFade];
    
    [[self tableView] endUpdates];
}

- (void)_efLoadMoreImages:(NSArray <LFImage *>*)images{
    
    NSArray *etIndexPaths = [NSIndexPath indexPathsFromIndex:[[self evImages] count]
                                                       count:[images count]];
    
    [[self tableView] beginUpdates];
    
    [[self evImages] addObjectsFromArray:images];
    [[self tableView] insertRowsAtIndexPaths:etIndexPaths
                            withRowAnimation:UITableViewRowAnimationFade];
    
    [[self tableView] endUpdates];
}

- (void)_efTriggerEnd{
    
    if ([self evLoadMore]) {
        self.evCurrentPage++;
    }
    else{
        [self setEvCurrentPage:0];
    }
    [self setEvLoadMore:NO];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self evImages] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(LFCommonImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFImage *etImage = [[self evImages] objectAtIndex:[indexPath row]];
    
    [cell setEvImage:etImage];
    
    if ([indexPath row] == [[self evImages] count] - 1) {
        
        [self _efLoadImages:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFCommonImageCell *commonImageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LFCommonImageCell class])];
    
    return commonImageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LFImage *etImage = [[self evImages] objectAtIndex:[indexPath row]];
    
    LFPhoto *etPhoto = [LFPhoto modelWithAttributes:[etImage dictionary]];
    
    if ([self evImageSelectCallback]) {
        self.evImageSelectCallback(self, etPhoto);
    }

}

@end
