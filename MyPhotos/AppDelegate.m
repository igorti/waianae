//
//  AppDelegate.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/10/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import "AppDelegate.h"
#import "PSTCollectionViewFlowLayout.h"
#import "GridViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    GridViewController *grid = [[GridViewController alloc] initWithCollectionViewLayout:[PSUICollectionViewFlowLayout new]];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:grid];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
