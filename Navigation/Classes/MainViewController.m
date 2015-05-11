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

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define CENTER_TAG 1
#define LEFT_TAG 2

@interface MainViewController () <CenterViewControllerDelegate>
@property (nonatomic,strong) CenterViewController *centerVC;
@property (nonatomic,strong) LeftPanelViewController *leftVC;
@property (nonatomic,assign) BOOL showingLeftPanel;
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
    [self.centerVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.centerVC.view.tag = CENTER_TAG;
    self.centerVC.delegate = self;
    
    [self.view addSubview:self.centerVC.view];
    [self addChildViewController:_centerVC]; // access iVar
    
    [_centerVC didMoveToParentViewController:self];
    
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value) {
        [_centerVC.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerVC.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerVC.view.layer setShadowOpacity:0.8];
        [_centerVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    } else {
        [_centerVC.view.layer setCornerRadius:0.0f];
        [_centerVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)resetMainView
{
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
        
        _leftVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftVC.view;
    return view;
}

- (UIView *)getRightView
{     
    UIView *view = nil;
    return view;
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
}

-(void)movePanel:(id)sender
{
}

#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelLeft // to show right panel
{
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        _centerVC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _centerVC.leftButton.tag = 0;
        }
    }];
}

- (void)movePanelToOriginalPosition
{    
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
