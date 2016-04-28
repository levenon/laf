//
//  LFMenuController.m
//
//  Created by Vito Modena
//
//  Copyright (c) 2014 ice cream studios s.r.l. - http://icecreamstudios.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#import "LFMenuController.h"
#import "LFDropShadowView.h"

NSString *const kNoitficationMenuControllerWillOpen  = @"kNoitficationMenuControllerWillOpen";
NSString *const kNoitficationMenuControllerDidOpen   = @"kNoitficationMenuControllerDidOpen";
NSString *const kNoitficationMenuControllerWillClose = @"kNoitficationMenuControllerWillClose";
NSString *const kNoitficationMenuControllerDidClose  = @"kNoitficationMenuControllerDidClose";
NSString *const kNoitficationMenuControllerDidSwip   = @"kNoitficationMenuControllerDidSwip";
NSString *const kNoitficationMenuControllerWillTransform = @"kNoitficationMenuControllerWillTransform";
NSString *const kNoitficationMenuControllerDidTransform  = @"kNoitficationMenuControllerDidTransform";

typedef NS_ENUM(NSUInteger, LFMenuControllerState){

    LFMenuControllerStateClosed = 0,
    LFMenuControllerStateOpening,
    LFMenuControllerStateOpen,
    LFMenuControllerStateClosing,
    LFMenuControllerStateTransforming,
};

@interface LFMenuController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property(nonatomic, strong, readwrite) IBOutlet UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *leftViewController;
@property(nonatomic, strong, readwrite) IBOutlet UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *centerViewController;

@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) LFDropShadowView *centerView;
@property(nonatomic, assign) CGPoint panGestureStartLocation;
@property(nonatomic, assign) LFMenuControllerState drawerState;

@property(nonatomic, assign) CGFloat menuControllerDrawerDepthScale;
@property(nonatomic, assign) CGFloat menuControllerDrawerVerticalOffset;
@property(nonatomic, assign) CGFloat menuControllerLeftViewInitialOffset;
@property(nonatomic, assign) CGFloat menuControllerOpeningAnimationSpringDamping;
@property(nonatomic, assign) CGFloat menuControllerClosingAnimationSpringDamping;
@property(nonatomic, assign) CGFloat menuControllerOpeningAnimationSpringInitialVelocity;
@property(nonatomic, assign) CGFloat menuControllerClosingAnimationSpringInitialVelocity;
@property(nonatomic, assign) NSTimeInterval menuControllerAnimationDuration;

@end

@implementation LFMenuController

- (void)awakeFromNib{
    [super awakeFromNib];

    [self config];
}

- (id)initWithLeftViewController:(UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *)leftViewController
            centerViewController:(UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *)centerViewController{

    self = [super init];
    if (self) {
        [self setLeftViewController:leftViewController];
        [self setCenterViewController:centerViewController];

        [self config];
    }
    return self;
}

- (void)config{

    NSParameterAssert([self leftViewController]);
    NSParameterAssert([self centerViewController]);

    if ([[self leftViewController] respondsToSelector:@selector(setMenu:)]) {
        [[self leftViewController] setMenu:self];
    }
    if ([[self centerViewController] respondsToSelector:@selector(setMenu:)]) {
        [[self centerViewController] setMenu:self];
    }

    self.enableSwip = YES;
    self.menuControllerDrawerVerticalOffset  = 40.0f;
    self.menuControllerLeftViewInitialOffset = -60.0f;
    self.menuControllerOpeningAnimationSpringDamping = 0.9f;
    self.menuControllerClosingAnimationSpringDamping = 1.0f;
    self.menuControllerOpeningAnimationSpringInitialVelocity = 5.f;
    self.menuControllerClosingAnimationSpringInitialVelocity = 0.5f;
    self.menuControllerAnimationDuration = 0.5;
}

- (CGFloat)menuControllerDrawerDepthScale{

    return 350/640.0f;
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

    // Initialize left and center view containers
    [self setLeftView:[[UIView alloc] initWithFrame:[self leftViewInitialFrame:CGRectGetSize([[self view] bounds])]]];
    [self setCenterView:[[LFDropShadowView alloc] initWithFrame:[self centerViewInitialFrame:CGRectGetSize([[self view] bounds])]]];

    [[self leftView] setBackgroundColor:[UIColor clearColor]];
//    [[self leftView] setTranslatesAutoresizingMaskIntoConstraints:YES];
//    [[self leftView] setAutoresizingMask:[[self view] autoresizingMask]];

    [[self centerView] setBackgroundColor:[UIColor clearColor]];
//    [[self centerView] setTranslatesAutoresizingMaskIntoConstraints:YES];
//    [[self centerView] setAutoresizingMask:[[self view] autoresizingMask]];

    // Add the center view container
    [[self view] addSubview:[self centerView]];
    // Add the center view controller to the container
    [self addCenterViewController];
    [self setupGestureRecognizers];
}
#pragma mark - Configuring the view’s layout behavior
- (UIViewController *)childViewControllerForStatusBarHidden{

    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    if (self.drawerState == LFMenuControllerStateOpening) {
        return self.leftViewController;
    }
    return self.centerViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle{

    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    if (self.drawerState == LFMenuControllerStateOpening) {

        return self.leftViewController;
    }
    return self.centerViewController;
}

- (CGAffineTransform)leftViewCloseTransform:(CGSize)size{

    CGFloat scale = (size.height - self.menuControllerDrawerVerticalOffset * 2)/size.height;
    CGAffineTransform lScale =  CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    CGAffineTransform lmove = CGAffineTransformTranslate(lScale, self.menuControllerLeftViewInitialOffset, 0);

    return lmove;
}

- (CGAffineTransform)leftViewOpenTransform:(CGSize)size{

    return CGAffineTransformIdentity;
}

- (CGAffineTransform)centerViewCloseTransform:(CGSize)size{

    return CGAffineTransformIdentity;
}

- (CGAffineTransform)centerViewOpenTransform:(CGSize)size{

    CGFloat cscale = 1 - self.menuControllerDrawerVerticalOffset * 2 / size.height;
    CGAffineTransform cScale =  CGAffineTransformScale(CGAffineTransformIdentity, cscale, cscale);

    CGAffineTransform cmove = CGAffineTransformTranslate(cScale, self.menuControllerDrawerDepthScale * size.width + (1 - cscale) * self.menuControllerDrawerDepthScale * size.width / 2, 0);
    return cmove;
}


- (CGRect)leftViewInitialFrame:(CGSize)size{

    return CGRectMake(0, 0, self.menuControllerDrawerDepthScale * size.width, size.height);
}

- (CGRect)centerViewInitialFrame:(CGSize)size{

    return CGRectMakeXYS(0, 0, size);
}



#pragma mark - Gesture recognizers
- (void)setupGestureRecognizers{

    NSParameterAssert(self.centerView);

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;

    [self.centerView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)addClosingGestureRecognizers{

    NSParameterAssert(self.centerView);
    NSParameterAssert(self.panGestureRecognizer);

    [self.centerView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)removeClosingGestureRecognizers{

    NSParameterAssert(self.centerView);
    NSParameterAssert(self.panGestureRecognizer);
    [self.centerView removeGestureRecognizer:self.tapGestureRecognizer];
}
#pragma mark Tap to close the drawer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer{

    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {

        [self close];
    }
}
#pragma mark Pan to open/close the drawer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];

    if ([self enableSwip] && self.drawerState == LFMenuControllerStateClosed && velocity.x > 0.0f) {

        return YES;// && [[self centerViewController] menuEnable];
    }
    else if ([self enableSwip] && self.drawerState == LFMenuControllerStateOpen && velocity.x < 0.0f) {

        return YES;// && [[self leftViewController] menuEnable];
    }

    return NO;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer{

    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);

    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    CGFloat menuControllerDrawerDepth = self.menuControllerDrawerDepthScale * CGRectGetWidth([[self view] frame]);

    switch (state) {

        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            if (self.drawerState == LFMenuControllerStateClosed) {

                [self willOpen];
            }
            else {

                [self willClose];
            }
            break;

        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == LFMenuControllerStateOpening) {
                delta = location.x - self.panGestureStartLocation.x;
            }
            else if (self.drawerState == LFMenuControllerStateClosing) {
                delta = menuControllerDrawerDepth - (self.panGestureStartLocation.x - location.x);
            }

            CGFloat l;
            CGFloat c;

            CGFloat lscale  = 1.0f;
            CGFloat cscale  = 1.0f;

            if (delta >= menuControllerDrawerDepth) {

                l = 0.0f;
                c = menuControllerDrawerDepth;

                lscale = 1.0f;
                cscale = 1 - self.menuControllerDrawerVerticalOffset * 2 / CGRectGetHeight([[self view] bounds]) ;
            }
            else if (delta <= 0.0f) {

                l = -self.menuControllerLeftViewInitialOffset;
                c = 0.0f;

                lscale = CGRectGetHeight([[self view] bounds]) / (CGRectGetHeight([[self view] bounds])  -self.menuControllerDrawerVerticalOffset * 2);
                cscale = 1.0f;
            }
            else{

                // While the centerView can move up to menuControllerDrawerDepth points, to achieve a parallax effect
                // the leftView has move no more than self.menuControllerLeftViewInitialOffset points

                l = self.menuControllerLeftViewInitialOffset * (1 - delta/menuControllerDrawerDepth);
                c = delta;
                lscale = (CGRectGetHeight([[self view] bounds])  - (1- delta/menuControllerDrawerDepth) * self.menuControllerDrawerVerticalOffset * 2)/CGRectGetHeight([[self view] bounds]) ;
                cscale = (CGRectGetHeight([[self view] bounds])  - delta/menuControllerDrawerDepth * self.menuControllerDrawerVerticalOffset * 2)/CGRectGetHeight([[self view] bounds]) ;
            }

            CGAffineTransform lScale =  CGAffineTransformScale(CGAffineTransformIdentity, lscale, lscale);
            CGAffineTransform cScale =  CGAffineTransformScale(CGAffineTransformIdentity, cscale, cscale);

            CGAffineTransform lmove = CGAffineTransformTranslate(lScale, l, 0);
            CGAffineTransform cmove = CGAffineTransformTranslate(cScale, c + (1 - cscale) * menuControllerDrawerDepth / 2, 0);

            [[self leftView] setTransform:lmove];
            [[self centerView ] setTransform:cmove];
            [self setSwipProgress:delta/menuControllerDrawerDepth];

            if ([self leftViewController] && [[self leftViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
                [[self leftViewController] menuControllerDidSwip:self progress:delta/menuControllerDrawerDepth];
            }
            if ([self centerViewController] && [[self centerViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
                [[self centerViewController] menuControllerDidSwip:self progress:delta/menuControllerDrawerDepth];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerDidSwip object:self];

            break;
        }

        case UIGestureRecognizerStateEnded:
            if (self.drawerState == LFMenuControllerStateOpening) {

                CGFloat delta = location.x - self.panGestureStartLocation.x;

//                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (delta >= menuControllerDrawerDepth) {

                    // Open the drawer without animation, as it has already being dragged in its final position
//                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didOpen];
                }
                else if (delta > self.view.bounds.size.width / 3
                         && velocity.x > 0.0f) {

                    // Animate the drawer opening
                    [self animateOpening];
                }
                else {

                    // Animate the drawer closing, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
            }
            else if(self.drawerState == LFMenuControllerStateClosing) {

//                CGFloat delta = menuControllerDrawerDepth - (self.panGestureStartLocation.x - location.x);

                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation <= 0.0f) {

                    // Close the drawer without animation, as it has already being dragged in its final position
//                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didClose];
                }
                else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3
                         && velocity.x < 0.0f) {

                    // Animate the drawer closing
                    [self animateClosing];
                }
                else {

                    // Animate the drawer opening, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didClose];
                    // Here we save the current position for the leftView since
                    // we want the opening animation to start from the current position
                    // and not the one that is set in 'willOpen'
                    CGAffineTransform ltransform = self.leftView.transform;
                    [self willOpen];
                    self.leftView.transform = ltransform;

                    [self animateOpening];
                }
            }
            break;

        default:
            break;
    }
}
#pragma mark - Animations
#pragma mark Opening animation
- (void)animateOpening{

    if ((self.drawerState != LFMenuControllerStateOpening)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateOpening);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);

    // Calculate the final frames for the container views
//    CGRect leftViewFinalFrame = self.view.bounds;
//    CGRect centerViewFinalFrame = self.view.bounds;

//    leftViewFinalFrame.size.width = menuControllerDrawerDepth;
//    centerViewFinalFrame.origin.x = menuControllerDrawerDepth;
//
//
//    l = 0.0f;
//    c = menuControllerDrawerDepth;
//
//    lscale = 1.0f;
//    cscale = 1 - self.menuControllerDrawerVerticalOffset * 2 / CGRectGetHeight([[self view] bounds]) ;
//
//    CGFloat lscale = 1 - self.menuControllerDrawerVerticalOffset * 2 / CGRectGetHeight([[self view] bounds]) ;
    CGFloat cscale = 1 - self.menuControllerDrawerVerticalOffset * 2 / CGRectGetHeight([[self view] bounds]) ;

    CGAffineTransform cScale =  CGAffineTransformScale(CGAffineTransformIdentity, cscale, cscale);
    CGAffineTransform cmove = CGAffineTransformTranslate(cScale, self.menuControllerDrawerDepthScale * CGRectGetWidth([[self view] frame]) * (1.5 - cscale/2), 0.0f);

    [UIView animateWithDuration:self.menuControllerAnimationDuration
                          delay:0.0f
         usingSpringWithDamping:self.menuControllerOpeningAnimationSpringDamping
          initialSpringVelocity:self.menuControllerOpeningAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         self.leftView.transform = CGAffineTransformIdentity;
                         self.centerView.transform = cmove;
                         [self swip:1];
//                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {

                         [self didOpen];
                     }];
}

- (void)swip:(CGFloat)progress{

    self.swipProgress = progress;

    if ([self leftViewController] && [[self leftViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
        [[self leftViewController] menuControllerDidSwip:self progress:progress];
    }
    if ([self centerViewController] && [[self centerViewController] respondsToSelector:@selector(menuControllerDidSwip:progress:)]) {
        [[self centerViewController] menuControllerDidSwip:self progress:progress];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerDidSwip object:self];
}

#pragma mark Closing animation
- (void)animateClosing{

    if ((self.drawerState != LFMenuControllerStateClosing)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateClosing);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);

    // Calculate final frames for the container views
//    CGRect leftViewFinalFrame = self.leftView.frame;
//    leftViewFinalFrame.origin.x = self.menuControllerLeftViewInitialOffset;
//    leftViewFinalFrame.size.width = menuControllerDrawerDepth;
//    CGRect centerViewFinalFrame = self.view.bounds;

    CGFloat scale = (CGRectGetHeight([[self view] bounds])  -self.menuControllerDrawerVerticalOffset * 2) / CGRectGetHeight([[self view] bounds]) ;

    CGAffineTransform lScale =  CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    CGAffineTransform lmove = CGAffineTransformTranslate(lScale, self.menuControllerLeftViewInitialOffset, 0.0f);

    [UIView animateWithDuration:self.menuControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:self.menuControllerClosingAnimationSpringDamping
          initialSpringVelocity:self.menuControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         self.leftView.transform = lmove;
                         self.centerView.transform = CGAffineTransformIdentity;
                         [self swip:0];
//                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [self didClose];
                     }];
}
#pragma mark - Opening the drawer
- (void)open{

    if ((self.drawerState != LFMenuControllerStateClosed)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateClosed);
    [self willOpen];

    [self animateOpening];
}

- (void)willOpen{

    if ((self.drawerState != LFMenuControllerStateClosed)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateClosed);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    // Keep track that the drawer is opening
    self.drawerState = LFMenuControllerStateOpening;

    // Start adding the left view controller to the container
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.leftView.bounds;
    self.leftViewController.view.autoresizingMask = self.view.autoresizingMask;

    [self.leftView addSubview:self.leftViewController.view];
    // Add the left view to the view hierarchy
    [self.view insertSubview:self.leftView belowSubview:self.centerView];

    // Position the left view
    CGFloat scale = (CGRectGetHeight([[self view] bounds]) - self.menuControllerDrawerVerticalOffset * 2)/CGRectGetHeight([[self view] bounds]);
    CGAffineTransform lScale =  CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    CGAffineTransform lmove = CGAffineTransformTranslate(lScale, self.menuControllerLeftViewInitialOffset, 0);
    self.leftView.transform = lmove;

    // Notify the child view controllers that the drawer is about to open
    if ([self.leftViewController respondsToSelector:@selector(menuControllerWillOpen:)]) {
        [self.leftViewController menuControllerWillOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerWillOpen:)]) {
        [self.centerViewController menuControllerWillOpen:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerWillOpen object:self];
}

- (void)didOpen{

    if ((self.drawerState != LFMenuControllerStateOpening)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateOpening);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    // Complete adding the left controller to the container
    [self.leftViewController didMoveToParentViewController:self];

    [self addClosingGestureRecognizers];

    // Keep track that the drawer is open
    self.drawerState = LFMenuControllerStateOpen;

    // Notify the child view controllers that the drawer is open
    if ([self.leftViewController respondsToSelector:@selector(menuControllerDidOpen:)]) {
        [self.leftViewController menuControllerDidOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerDidOpen:)]) {
        [self.centerViewController menuControllerDidOpen:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerDidOpen object:self];
}
#pragma mark - Closing the drawer
- (void)close{

    if ((self.drawerState != LFMenuControllerStateOpen)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateOpen);
    [self willClose];
    [self animateClosing];
}

- (void)willClose{

    if ((self.drawerState != LFMenuControllerStateOpen)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateOpen);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    // Start removing the left controller from the container
    [self.leftViewController willMoveToParentViewController:nil];

    // Keep track that the drawer is closing
    self.drawerState = LFMenuControllerStateClosing;

    // Notify the child view controllers that the drawer is about to close
    if ([self.leftViewController respondsToSelector:@selector(menuControllerWillClose:)]) {
        [self.leftViewController menuControllerWillClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerWillClose:)]) {
        [self.centerViewController menuControllerWillClose:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerWillClose object:self];
}

- (void)didClose{

    if ((self.drawerState != LFMenuControllerStateClosing)) {

        return ;
    }
    //    NSParameterAssert(self.drawerState == LFMenuControllerStateClosing);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);

    // Complete removing the left view controller from the container
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];

    // Remove the left view from the view hierarchy
    [self.leftView removeFromSuperview];

    [self removeClosingGestureRecognizers];

    // Keep track that the drawer is closed
    self.drawerState = LFMenuControllerStateClosed;

    // Notify the child view controllers that the drawer is closed
    if ([self.leftViewController respondsToSelector:@selector(menuControllerDidClose:)]) {
        [self.leftViewController menuControllerDidClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(menuControllerDidClose:)]) {
        [self.centerViewController menuControllerDidClose:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerDidClose object:self];
}

- (void)willTransformCenterWhenMenuClosed{

    NSParameterAssert(self.drawerState == LFMenuControllerStateClosed);
    NSParameterAssert(self.centerViewController);

    // Start removing the left controller from the container
    [self.centerViewController willMoveToParentViewController:nil];

    // Keep track that the drawer is closing
    self.drawerState = LFMenuControllerStateTransforming;

    // Notify the child view controllers that the drawer is about to close
    if ([self.centerViewController respondsToSelector:@selector(menuControllerWillTransform:)]) {
        [self.centerViewController menuControllerWillTransform:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerWillTransform object:self];
}

#pragma mark - Reloading/Replacing the center view controller
//- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock{
//
//    if ((self.drawerState != LFMenuControllerStateOpen)) {
//
//        return ;
//    }
//    //    NSParameterAssert(self.drawerState == LFMenuControllerStateOpen);
//    NSParameterAssert(self.centerViewController);
//
//    [self willClose];
//
//    CGRect f = self.centerView.frame;
//    f.origin.x = self.view.bounds.size.width;
//
//    CGRect lf = self.leftView.frame;
//    lf.size.width = self.view.bounds.size.width;
//
//    [UIView animateWithDuration:self.menuControllerAnimationDuration / 2
//                     animations:^{
//
//                         self.centerView.frame = f;
//                         self.leftView.frame = lf;
//                     }
//                     completion:^(BOOL finished) {
//
//                         // The center view controller is now out of sight
//                         if (reloadBlock) {
//
//                             reloadBlock();
//                         }
//                         // Finally, close the drawer
//                         [self animateClosing];
//                     }];
//}

- (void)replaceCenterViewControllerWithViewController:(UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *)viewController{

    //      NSParameterAssert(self.drawerState == LFMenuControllerStateOpen);
    NSParameterAssert(viewController);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.centerViewController);

    if (self.drawerState == LFMenuControllerStateClosed) {

        [self transformCenterWhenMenuClose:viewController];
    }
    else if(self.drawerState == LFMenuControllerStateOpen){

        [self willClose];

//        CGRect f = self.centerView.frame;
//        f.origin.x = self.view.bounds.size.width;

//        CGRect lf = self.leftView.frame;
//        lf.size.width = self.view.bounds.size.width;

        CGAffineTransform cmove = CGAffineTransformTranslate(self.centerView.transform, 50, 0);

        [self.centerViewController willMoveToParentViewController:nil];
        [UIView animateWithDuration:self.menuControllerAnimationDuration / 2
                         animations:^{

//                             self.centerView.frame = f;
                             self.centerView.transform = cmove;
                         }
                         completion:^(BOOL finished) {

                             // The center view controller is now out of sight

                             // Remove the current center view controller from the container
                             if ([self.centerViewController respondsToSelector:@selector(setMenu:)]) {
                                 self.centerViewController.menu = nil;
                             }
                             [self.centerViewController.view removeFromSuperview];
                             [self.centerViewController removeFromParentViewController];

                             // Set the new center view controller
                             self.centerViewController = viewController;
                             if ([self.centerViewController respondsToSelector:@selector(setMenu:)]) {
                                 self.centerViewController.menu = self;
                             }

                             // Add the new center view controller to the container
                             [self addCenterViewController];

                             // Finally, close the drawer
                             [self animateClosing];
                         }];
    }
}

- (void)transformCenterWhenMenuClose:(UIViewController<LFMenuControllerChild, LFMenuControllerPresenting> *)viewController{

    [self willTransformCenterWhenMenuClosed];

    [viewController willMoveToParentViewController:nil];
    [self addChildViewController:viewController];

    LFDropShadowView *nextCenterView = [[LFDropShadowView alloc] initWithFrame:[self centerViewInitialFrame:CGRectGetSize([[self view] bounds])]];
//    [nextCenterView setAutoresizingMask:[[self view] autoresizingMask]];

    viewController.view.frame = nextCenterView.bounds;
    viewController.view.autoresizingMask = self.view.autoresizingMask;
    [nextCenterView addSubview:viewController.view];
    [self.view addSubview:nextCenterView];
    [viewController didMoveToParentViewController:self];

    // start
    CGRect nf = nextCenterView.frame;
    nf.origin.x = self.view.bounds.size.width;
    [nextCenterView setFrame:nf];

    // end
    CGRect f = self.centerView.frame;
    f.origin.x = -self.view.bounds.size.width;

    CGRect nfe = self.view.bounds;

    [UIView animateWithDuration:self.menuControllerAnimationDuration / 2
                     animations:^{

                         self.centerView.frame = f;
                         nextCenterView.frame = nfe;
                     }
                     completion:^(BOOL finished) {

                         // The center view controller is now out of sight

                         // Remove the current center view controller from the container
                         if ([self.centerViewController respondsToSelector:@selector(setMenu:)]) {
                             self.centerViewController.menu = nil;
                         }

                         // Finally, close the drawer
                         [self didTransformCenterWhenMenuClosed];

                         // Set the new center view controller
                         self.centerViewController = viewController;
                         [self setCenterView:nextCenterView];

                         if ([self.centerViewController respondsToSelector:@selector(setMenu:)]) {
                             self.centerViewController.menu = self;
                         }
                         [self.centerView addGestureRecognizer:self.tapGestureRecognizer];
                         [self.centerView addGestureRecognizer:self.panGestureRecognizer];
                     }];

}

- (void)didTransformCenterWhenMenuClosed{

    NSParameterAssert(self.drawerState == LFMenuControllerStateTransforming);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.centerViewController);

    // Complete removing the left view controller from the container
    [self.centerView  removeFromSuperview];
    [self.centerViewController.view removeFromSuperview];
    [self.centerViewController removeFromParentViewController];

    // Remove the left view from the view hierarchy
    [self.centerView removeFromSuperview];

    [self.centerView removeGestureRecognizer:self.tapGestureRecognizer];
    [self.centerView removeGestureRecognizer:self.panGestureRecognizer];

    // Keep track that the drawer is closed
    self.drawerState = LFMenuControllerStateClosed;
    
    // Notify the child view controllers that the drawer is closed
    if ([self.centerViewController respondsToSelector:@selector(menuControllerDidTransform:)]) {
        [self.centerViewController menuControllerDidTransform:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoitficationMenuControllerDidTransform object:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{

    [[self leftView] setTransform:CGAffineTransformIdentity];
    [[self leftView] setFrame:[self leftViewInitialFrame:size]];

    [[self centerView] setTransform:CGAffineTransformIdentity];
    [[self centerView] setFrame:[self centerViewInitialFrame:size]];

    if ([self drawerState] == LFMenuControllerStateOpen) {

        [[self leftView] setTransform:[self leftViewOpenTransform:size]];
        [[self centerView] setTransform:[self centerViewOpenTransform:size]];
    }

    if ([self drawerState] == LFMenuControllerStateClosed) {

        [[self leftView] setTransform:[self leftViewCloseTransform:size]];
        [[self centerView] setTransform:[self centerViewCloseTransform:size]];
    }
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)shouldAutorotate{

    if ([self drawerState] == LFMenuControllerStateClosing ||
        [self drawerState] == LFMenuControllerStateOpening ||
        [self drawerState] == LFMenuControllerStateTransforming) {

        return NO;
    }
    return [[self evVisibleViewController] shouldAutorotate];
}

@end

@implementation LFMenuController(VisibleViewController)

- (UIViewController*)evVisibleViewController;{
    
    if ([[self centerViewController] respondsToSelector:@selector(evVisibleViewController)]) {
        
        return [[self centerViewController] evVisibleViewController];
    }
    else if ([[self leftViewController] respondsToSelector:@selector(evVisibleViewController)]){
        
        return [[self leftViewController] evVisibleViewController];
    }
    return self;
}

@end

@implementation UIViewController(LFMenuController)

- (LFMenuController*)menuController;{
    
    UIViewController *parentViewController = self;
    
    while (parentViewController) {
        
        if ([parentViewController isKindOfClass:[LFMenuController class]]) {
            
            return (LFMenuController*)parentViewController;
        }
        
        parentViewController = [parentViewController parentViewController];
    }
    
    return nil;
}

@end