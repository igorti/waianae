//
//  AppDelegate.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/10/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import "AppDelegate.h"
#import "GridViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    GridViewController *gridView = [[GridViewController alloc] initWithCollectionViewLayout:flowLayout];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:gridView];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
