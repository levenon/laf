//
//  LFTableHeaderViewStretcher
//  LFTableHeaderViewStretcher
//

#import <Foundation/Foundation.h>
#import <XLFCommonKit/XLFCommonKit.h>

@interface LFTableHeaderViewStretcher : NSObject

- (void)stretchHeaderView:(UIView*)headerView inTableView:(UITableView*)tableView;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end
