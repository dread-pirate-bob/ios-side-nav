//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "MainViewController.h"
#import "CenterViewController.h"

#define CENTER_TAG 1

@interface MainViewController () <CenterViewControllerDelegate>
@property (nonatomic,strong) CenterViewController *centerVC;
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
    [self.centerVC.view setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.centerVC.view.tag = CENTER_TAG;
    self.centerVC.delegate = self;
    
    [self.view addSubview:self.centerVC.view];
    [self addChildViewController:_centerVC]; // access iVar
    
    [_centerVC didMoveToParentViewController:self];
    
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
}

- (void)resetMainView
{
}

- (UIView *)getLeftView
{    
    UIView *view = nil;
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
