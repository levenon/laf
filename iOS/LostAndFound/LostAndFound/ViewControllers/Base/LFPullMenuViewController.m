//
//  LFPullMenuViewController.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFPullMenuViewController.h"

NSString *const kNoitficationPullMenuViewControllerWillOpen  = @"kNoitficationPullMenuViewControllerWillOpen";
NSString *const kNoitficationPullMenuViewControllerDidClose  = @"kNoitficationPullMenuViewControllerDidClose";
NSString *const kNoitficationPullMenuViewControllerDidSwip   = @"kNoitficationPullMenuViewControllerDidSwip";

typedef NS_ENUM(NSUInteger, LFPullMenuViewControllerState){
    
    LFPullMenuViewControllerStateClosed = 0,
    LFPullMenuViewControllerStateOpening,
};

@interface LFPullMenuViewController ()

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property(nonatomic, strong, readwrite) IBOutlet UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *rightViewController;
@property(nonatomic, strong, readwrite) IBOutlet UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *centerViewController;

@property(nonatomic, strong) UIView *rightView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, assign) CGPoint panGestureStartLocation;
@property(nonatomic, assign) LFPullMenuViewControllerState drawerState;

@property(nonatomic, assign) CGFloat menuControllerRightViewInitialOffset;
@property(nonatomic, assign) CGFloat menuControllerOpeningAnimationSpringDamping;
@property(nonatomic, assign) CGFloat menuControllerClosingAnimationSpringDamping;
@property(nonatomic, assign) CGFloat menuControllerOpeningAnimationSpringInitialVelocity;
@property(nonatomic, assign) CGFloat menuControllerClosingAnimationSpringInitialVelocity;
@property(nonatomic, assign) NSTimeInterval menuControllerAnimationDuration;

@end

@implementation LFPullMenuViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self config];
}

- (id)initWithRightViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)rightViewController
            centerViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)centerViewController{
    
    self = [super init];
    if (self) {
        [self setRightViewController:rightViewController];
        [self setCenterViewController:centerViewController];
        
        [self config];
    }
    return self;
}

- (void)config{
    
    NSParameterAssert([self rightViewController]);
    NSParameterAssert([self centerViewController]);
    
    if ([[self rightViewController] respondsToSelector:@selector(setMenu:)]) {
        [[self rightViewController] setMenu:self];
    }
    if ([[self centerViewController] respondsToSelector:@selector(setMenu:)]) {
        [[self centerViewController] setMenu:self];
    }
    
    self.enablePull = YES;
    self.menuControllerRightViewInitialOffset = 150.0f;
    self.menuControllerOpeningAnimationSpringDamping = 0.9f;
    self.menuControllerClosingAnimationSpringDamping = 1.0f;
    self.menuControllerOpeningAnimationSpringInitialVelocity = 5.f;
    self.menuControllerClosingAnimationSpringInitialVelocity = 0.5f;
    self.menuControllerAnimationDuration = 0.5;
}

- (CGFloat)menuControllerDrawerDepthScale{
    
    return 450/640.0f;
}

- (void)addCenterViewController{
    
    NSParameterAssert(self.centerViewController);
    NSParameterAssert(self.centerView);
    
    [self addChildViewController:self.centerViewController];
    self.centerViewController.view.frame = self.centerView.bounds;
    self.centerViewController.view.autoresizingMask = self.view.autoresizingMask;
    [self.centerView addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
}
#pragma mark - Managing the view
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //    [[self view] setTranslatesAutoresizingMaskIntoConstraints:YES];
    [[self view] setAutoresizingMask:UIViewAutoresizingFlexibleAll];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"img_root_background"] scaleToSize:[[self view] bounds].size stretch:YES]]];
    //    [[self view] setBackgroundColor:[UIColor redColor]];
    
    // Initialize right and center view containers
    [self setRightView:[[UIView alloc] initWithFrame:[self rightViewInitialFrame:CGRectGetSize([[self view] bounds])]]];
    [self setCenterView:[[UIView alloc] initWithFrame:[self centerViewInitialFrame:CGRectGetSize([[self view] bounds])]]];
    
    [[self rightView] setBackgroundColor:[UIColor clearColor]];
    [[self centerView] setBackgroundColor:[UIColor clearColor]];
    
    // Add the center view container
    [[self view] addSubview:[self centerView]];
    // Add the center view controller to the container
    [self addCenterViewController];
    [self setupGestureRecognizers];
}
#pragma mark - Configuring the view’s layout behavior
- (UIViewController *)childViewControllerForStatusBarHidden{
    
    NSParameterAssert(self.rightViewController);
    NSParameterAssert(self.centerViewController);
    
    if (self.drawerState == LFPullMenuViewControllerStateOpening) {
        return self.rightViewController;
    }
    return self.centerViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    NSParameterAssert(self.rightViewController);
    NSParameterAssert(self.centerViewController);
    
    if (self.drawerState == LFPullMenuViewControllerStateOpening) {
        
        return self.rightViewController;
    }
    return self.centerViewController;
}

- (CGRect)rightViewInitialFrame:(CGSize)size{
    
    return CGRectMake(0, 0, self.menuControllerDrawerDepthScale * size.width, size.height);
}

- (CGRect)centerViewInitialFrame:(CGSize)size{
    
    return CGRectMakeXYS(0, 0, size);
}

#pragma mark - Gesture recognizers
- (void)setupGestureRecognizers{
    
    NSParameterAssert(self.centerView);
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    
    [self.centerView addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark Pan to open/close the drawer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    if ([self enablePull] && self.drawerState == LFPullMenuViewControllerStateClosed && velocity.x < 0.0f) {
        
        return YES;// && [[self centerViewController] menuEnable];
    }
    else if ([self enablePull] && self.drawerState == LFPullMenuViewControllerStateOpening && velocity.x > 0.0f) {
        
        return YES;// && [[self rightViewController] menuEnable];
    }
    
    return NO;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    NSParameterAssert(self.rightView);
    NSParameterAssert(self.centerView);
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            if (self.drawerState == LFPullMenuViewControllerStateClosed) {
                
                [self willOpen];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == LFPullMenuViewControllerStateOpening) {
                delta = self.panGestureStartLocation.x - location.x;
            }
            delta = MAX(delta, 0);
            
            CGFloat initalOffset = self.menuControllerRightViewInitialOffset;
    
            CGFloat offset = sqrt(initalOffset * delta / 3);
            
            offset = MIN(offset, self.menuControllerRightViewInitialOffset);
            offset = MAX(offset, 0);
            
            self.rightView.frame = CGRectMake(self.view.bounds.size.width - offset, 0, initalOffset, self.view.bounds.size.height);
            self.centerView.frame = CGRectMake(-offset, 0, self.view.bounds.size.width , self.view.bounds.size.height);
            
            if (delta - initalOffset > 0) {
                [self swip:delta - initalOffset];
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            
            [self animateClosing];
            break;
            
        default:
            break;
    }
}

- (void)swip:(CGFloat)progress{
    
    self.pullProgress = progress;
    
    if ([self rightViewController] && [[self rightViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
        [[self rightViewController] menuControllerDidSwip:self progress:progress];
    }
    if ([self centerViewController] && [[self centerViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
        [[self centerViewController] menuControllerDidSwip:self progress:progress];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationPullMenuViewControllerDidSwip object:self];
}

#pragma mark Closing animation
- (void)animateClosing{
    
    if ((self.drawerState != LFPullMenuViewControllerStateOpening)) {
        
        return ;
    }
    NSParameterAssert(self.rightView);
    NSParameterAssert(self.centerView);
    
    [UIView animateWithDuration:self.menuControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:self.menuControllerClosingAnimationSpringDamping
          initialSpringVelocity:self.menuControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.rightView.frame = CGRectMake(self.view.bounds.size.width, 0, self.menuControllerRightViewInitialOffset, self.view.bounds.size.height);
                         self.centerView.frame = self.view.bounds;
                         
                         self.pullProgress = 0;
                     }
                     completion:^(BOOL finished) {
                         [self didClose];
                     }];
}
#pragma mark - Opening the drawer

- (void)willOpen{
    
    if ((self.drawerState != LFPullMenuViewControllerStateClosed)) {
        
        return ;
    }
    //    NSParameterAssert(self.drawerState == LFPullMenuViewControllerStateClosed);
    NSParameterAssert(self.rightView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.rightViewController);
    NSParameterAssert(self.centerViewController);
    
    // Keep track that the drawer is opening
    self.drawerState = LFPullMenuViewControllerStateOpening;
    
    // Start adding the right view controller to the container
    [self addChildViewController:self.rightViewController];
    self.rightViewController.view.frame = self.rightView.bounds;
    self.rightViewController.view.autoresizingMask = self.view.autoresizingMask;
    
    [self.rightView addSubview:self.rightViewController.view];
    // Add the right view to the view hierarchy
    [self.view insertSubview:self.rightView belowSubview:self.centerView];
    
    // Position the right view
    self.rightView.frame = CGRectMake(self.view.bounds.size.width, 0, self.menuControllerRightViewInitialOffset, self.view.bounds.size.height);
    
    // Notify the child view controllers that the drawer is about to open
    if ([self.rightViewController respondsToSelector:@selector(menuControllerWillOpen:)]) {
        [self.rightViewController menuControllerWillOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerWillOpen:)]) {
        [self.centerViewController menuControllerWillOpen:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationPullMenuViewControllerWillOpen object:self];
}

#pragma mark - Closing the drawer
- (void)close{
    
    if ((self.drawerState != LFPullMenuViewControllerStateOpening)) {
        
        return ;
    }
    //    NSParameterAssert(self.drawerState == LFPullMenuViewControllerStateOpen);
    [self animateClosing];
}

- (void)didClose{
    
    if ((self.drawerState != LFPullMenuViewControllerStateOpening)) {
        
        return ;
    }
    //    NSParameterAssert(self.drawerState == LFPullMenuViewControllerStateClosing);
    NSParameterAssert(self.rightView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.rightViewController);
    NSParameterAssert(self.centerViewController);
    
    // Complete removing the right view controller from the container
    [self.rightViewController.view removeFromSuperview];
    [self.rightViewController removeFromParentViewController];
    
    // Remove the right view from the view hierarchy
    [self.rightView removeFromSuperview];
    
    // Keep track that the drawer is closed
    self.drawerState = LFPullMenuViewControllerStateClosed;
    
    // Notify the child view controllers that the drawer is closed
    if ([self.rightViewController respondsToSelector:@selector(menuControllerDidClose:)]) {
        [self.rightViewController menuControllerDidClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerDidClose:)]) {
        [self.centerViewController menuControllerDidClose:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationPullMenuViewControllerDidClose object:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [[self rightView] setTransform:CGAffineTransformIdentity];
    [[self rightView] setFrame:[self rightViewInitialFrame:size]];
    
    [[self centerView] setTransform:CGAffineTransformIdentity];
    [[self centerView] setFrame:[self centerViewInitialFrame:size]];
    
    if ([self drawerState] == LFPullMenuViewControllerStateClosed) {
        
        [[self rightView] setFrame:CGRectMake(self.view.bounds.size.width, 0, self.menuControllerRightViewInitialOffset, self.view.bounds.size.height)];
        [[self centerView] setFrame:self.view.bounds];
    }
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self didClose];
}

- (BOOL)shouldAutorotate{
    
    if ([self drawerState] == LFPullMenuViewControllerStateOpening) {
        
        return NO;
    }
    return [[self evVisibleViewController] shouldAutorotate];
}

@end

@implementation LFPullMenuViewController(VisibleViewController)

- (UIViewController*)evVisibleViewController;{
    
    if ([[self centerViewController] respondsToSelector:@selector(evVisibleViewController)]) {
        
        return [[self centerViewController] evVisibleViewController];
    }
    else if ([[self rightViewController] respondsToSelector:@selector(evVisibleViewController)]){
        
        return [[self rightViewController] evVisibleViewController];
    }
    return self;
}

@end
