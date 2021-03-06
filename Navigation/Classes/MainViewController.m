//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define CENTER_TAG 1
#define LEFT_TAG 2
#define RIGHT_TAG 3

@interface MainViewController () <CenterViewControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,strong) CenterViewController *centerVC;
@property (nonatomic,strong) LeftPanelViewController *leftVC;
@property (nonatomic,assign) BOOL showingLeftPanel;
@property (nonatomic,strong) RightPanelViewController *rightVC;
@property (nonatomic,assign) BOOL showingRightPanel;
@property (nonatomic,assign) BOOL showPanel;
@property (nonatomic,assign) CGPoint preVelocity;
@end

@implementation MainViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

- (void)setupView
{
    // setup center view
    self.centerVC = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    [self.centerVC.view setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    self.centerVC.view.tag = CENTER_TAG;
    self.centerVC.delegate = self;
    
    [self.containerView addSubview:self.centerVC.view];
    [self addChildViewController:_centerVC]; // access iVar
    
    [_centerVC didMoveToParentViewController:self];
    
    [self setupGestures];
    
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value) {
        [self.mainView.layer setCornerRadius:CORNER_RADIUS];
        [self.mainView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainView.layer setShadowOpacity:0.8];
        [self.mainView.layer setShadowOffset:CGSizeMake(offset, offset)];
    } else {
        [self.mainView.layer setCornerRadius:0.0f];
        [self.mainView.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)resetMainView
{
    // remove left view and reset variables if needed
    if (_leftVC != nil) {
        [self.leftVC.view removeFromSuperview];
        self.leftVC = nil;
        
        self.leftButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    if (_rightVC != nil) {
        [self.rightVC.view removeFromSuperview];
        self.rightVC = nil;
        
        self.rightButton.tag = 1;
        self.showingRightPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{    
    if (_leftVC == nil) {
        self.leftVC = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftVC.view.tag = LEFT_TAG;
        self.leftVC.delegate = _centerVC;
        
        // VC containment methods
        [self.view addSubview:self.leftVC.view];
        [self addChildViewController:_leftVC];
        [_leftVC didMoveToParentViewController:self];
        
        _leftVC.view.frame = CGRectMake(-self.view.frame.size.width+PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftVC.view;
    return view;
}

- (UIView *)getRightView
{     
    if (_rightVC == nil) {
        self.rightVC = [[RightPanelViewController alloc] initWithNibName:@"RightPanelViewController" bundle:nil];
        self.rightVC.view.tag = RIGHT_TAG;
        self.rightVC.delegate = _centerVC;
        
        // vc containment
        [self.view addSubview:self.rightVC.view];
        [self addChildViewController:self.rightVC];
        [_rightVC didMoveToParentViewController:self];
        
        _rightVC.view.frame = CGRectMake(self.view.frame.size.width-PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingRightPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.rightVC.view;
    return view;
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    // TODO view or mainView?
    // view might allow in-panel swipes?
    // probably has to be consistent with usages below...
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender
{
    UIPanGestureRecognizer *panGesture = sender;
    [[[panGesture view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [panGesture translationInView:self.view];
    CGPoint velocity = [panGesture velocityInView:[panGesture view]];
    
    if ([panGesture state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        // TODO small threshold on velocity?
        if (velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        } else {
            if (!_showingLeftPanel) {
                childView = [self getRightView];
            }
        }
        
        [self.view sendSubviewToBack:childView];
//        [[sender view] bringSubviewToFront:[panGesture view]];
    }
    
    if ([panGesture state] == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            // gesture went right
        } else {
            // gesture went left
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            } else if (_showingRightPanel) {
                [self movePanelLeft];
            }
        }
    }
    
    if ([panGesture state] == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0) {
            // gesture right
        } else {
            // gesture left
        }
        
        // more than halfway?  if so, show panel when done dragging by setting to YES(1)
        _showPanel = abs([panGesture view].center.x - _centerVC.view.frame.size.width / 2) > self.view.frame.size.width / 2;
        
        // allow dragging only in x-coords by only updating x-coord with translation
        [panGesture view].center = CGPointMake([panGesture view].center.x + translatedPoint.x, [panGesture view].center.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
        // to check for a change in direction, use this code
        if (velocity.x * _preVelocity.x + velocity.y * _preVelocity.y > 0) {
            // same direction
        } else {
            // opposite direction
        }
        
        _preVelocity = velocity;
    }
}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelLeft // to show right panel
{
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        self.view.frame = CGRectMake(-self.view.frame.size.width+PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.rightButton.tag = 0;
        }
    }];
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        self.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.leftButton.tag = 0;
        }
    }];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self resetMainView];
        }
    }];
}


#pragma mark - Button Taps

- (IBAction)leftButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self movePanelToOriginalPosition];
            break;
        case 1:
            [self movePanelRight];
            break;
        default:
            break;
    }
}

- (IBAction)rightButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self movePanelToOriginalPosition];
            break;
        case 1:
            [self movePanelLeft];
        default:
            break;
    }
}


#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
