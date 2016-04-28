//
//  LFEditablePhotoBrowserVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/26.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditablePhotoBrowserVC.h"

@interface LFPhotoBrowserVC (Private)<UIScrollViewDelegate>

@property(nonatomic, assign) id<LFPhotoBrowserDelegate> evDelegate;

@property(nonatomic, assign) NSInteger evCurrentIndex;

@property(nonatomic, assign) NSInteger evNumberOfVisibleItems;

@property(nonatomic, strong) NSMutableArray<LFImage *> *evMutablePhotos;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, LFPhotoContentView *> *evvPhotoContentItems;

@property(nonatomic, strong) UIScrollView *evscvContainer;

@property(nonatomic, strong) UITapGestureRecognizer *evtgrSingleTap;

@property(nonatomic, strong) NSTimer *evDoubleClickDelayTimer;

- (void)_efUpdateContentSize;
- (void)_efUpdateContentOffset;
- (void)_efUpdateItemsDisplay;
- (void)_efLoadItemViewAtIndex:(NSInteger)nIndex;

@end

@interface LFEditablePhotoBrowserVC ()

@property(nonatomic, strong) UIBarButtonItem *evbbiDelete;

@end

@implementation LFEditablePhotoBrowserVC

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiDelete] type:XLFNavButtonTypeRight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiDelete{
    
    if (!_evbbiDelete) {
        
        _evbbiDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didClickDelete:)];
    }
    return _evbbiDelete;
}

#pragma mark - private

- (void)_efDeleteItemViewAtIndex:(NSInteger)nIndex{
    
    __weak __block LFPhotoContentView * etvContent = [[self evvPhotoContentItems] objectForKey:@(nIndex)];
    
    Weakself(ws);
    
    if (!nIndex && [[self evMutablePhotos] count] == 1) {
        
        [self _efTransformItemViewAtIndex:nIndex
                            withAnimation:^{
                                
                                [etvContent setAlpha:0];
                            }
                               completion:nil];
    }
    else if (nIndex == [[self evMutablePhotos] count] - 1){
        
        [self _efTransformItemViewAtIndex:nIndex
                            withAnimation:^{
                                
                                [etvContent setAlpha:0];
                            }
                               completion:^{
                                   
                                   [ws setEvCurrentIndex:nIndex - 1];
                                   
                                   if (nIndex - 2 >= 0) {
                                       [ws _efLoadItemViewAtIndex:nIndex - 2];
                                   }
                               }];
    }
    else {
        
        NSInteger etNumberOfPhotos = [[self evPhotos] count];
        LFPhotoContentView * etvNextContent = [[ws evvPhotoContentItems] objectForKey:@(nIndex + 1)];

        [self _efTransformItemViewAtIndex:nIndex
                            withAnimation:^{
                                
                                [etvContent setAlpha:0];
                                [etvNextContent setFrame:CGRectMake(CGRectGetWidth([[ws view] bounds]) * (nIndex), 0,
                                                                    CGRectGetWidth([[ws view] bounds]), CGRectGetHeight([[ws view] bounds]))];
                            }
                               completion:^{
                                   
                                   [[ws evvPhotoContentItems] removeObjectForKey:@(nIndex+1)];
                                   [[ws evvPhotoContentItems] setObject:etvNextContent forKey:@(nIndex)];
                                   
                                   if (nIndex + 2 < etNumberOfPhotos) {
                                       [ws _efLoadItemViewAtIndex:nIndex + 1];
                                   }
                               }];
    }
}

- (void)_efTransformItemViewAtIndex:(NSInteger)nIndex withAnimation:(void (^)())animation completion:(void (^)())completion{
    
    LFPhotoContentView * etvContent = [[self evvPhotoContentItems] objectForKey:@(nIndex)];
    
    Weakself(ws);
    [UIView animateWithDuration:0.3
                     animations:animation
                     completion:^(BOOL finished) {
                         
                         [etvContent removeFromSuperview];
                         
                         [[ws evMutablePhotos] removeObjectAtIndex:nIndex];
                         [[ws evvPhotoContentItems] removeObjectForKey:@(nIndex)];
                         
                         if (completion) {
                             completion();
                         }
                         [ws _efUpdateContentSize];
                         [ws _efUpdateContentOffset];
                         [ws _efUpdateItemsDisplay];
                         
                         [ws _efItemViewDidDeleteAtIndex:nIndex];
                     }];
}

- (void)_efItemViewDidDeleteAtIndex:(NSInteger)nIndex{
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epEditablePhotoBrowserVC:didDeleteAtIndex:)]) {
        
        [(id<LFEditablePhotoBrowserDelegate>)[self evDelegate] epEditablePhotoBrowserVC:self didDeleteAtIndex:nIndex];
    }
}

#pragma mark - actions

- (IBAction)didClickDelete:(id)sender{
    
    [self _efDeleteItemViewAtIndex:[self evCurrentIndex]];
}

@end
