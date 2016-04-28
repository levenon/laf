//
//  LFTableHeaderViewStretch
//  LFTableHeaderViewStretch
//

#import "LFTableHeaderViewStretcher.h"

@interface LFTableHeaderViewStretcher()

@property(nonatomic,strong) UITableView*   tableView;
@property(nonatomic,strong) UIView*        headerView;

@property(nonatomic,assign) CGRect         initialFrame;
@property(nonatomic,assign) CGFloat        defaultViewHeight;
@property(nonatomic,assign) BOOL           didLoadView;

@end


@implementation LFTableHeaderViewStretcher

- (void)dealloc{
    [self setTableView:nil];
    [self setHeaderView:nil];
}

- (void)stretchHeaderView:(UIView*)headerView inTableView:(UITableView*)tableView;
{
    [self setTableView:tableView];
    [self setHeaderView:headerView];

    [self setInitialFrame:[[self headerView] frame]];
    [self setDefaultViewHeight:CGRectGetHeight([self initialFrame])];
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:[self initialFrame]];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [_tableView addSubview:[self headerView]];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([self didLoadView]) {
        
        CGRect f = [[self headerView] frame];
        f.size.width = CGRectGetWidth([scrollView frame]);
        [[self headerView] setFrame:f];

        if( scrollView.contentOffset.y < -scrollView.contentInset.top) {
            CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
            CGRect initialFrame = [self initialFrame];
            initialFrame.origin.y = offsetY * -1;
            initialFrame.size.height = [self defaultViewHeight] + offsetY;
            [[self headerView] setFrame:initialFrame];
            [self setInitialFrame:initialFrame];
        }
    }
}

- (void)resizeView{

    CGRect initialFrame = [self initialFrame];
    initialFrame.size.width = CGRectGetWidth([[self tableView] frame]);
    [[self headerView] setFrame:initialFrame];

    [self setInitialFrame:initialFrame];
    [self setDidLoadView:YES];
}


@end
