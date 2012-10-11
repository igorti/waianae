//
//  ViewController.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/10/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController (){
    AQGridView *gridView;
    NSMutableArray *images;
}

- (IBAction)didPressShowPhotosButton:(id)sender;

@end

@implementation ViewController

- (ALAssetsLibrary *) defaultLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    images = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [self defaultLibrary];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                   if(asset){
                                       UIImage *image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                                       [images addObject:image];
                                   }
                               }];
                               
                               [gridView reloadData];
                           }
                         failureBlock:^(NSError *error) {
                             NSLog(@"Failed to read assets");
                         }];
    
    
    
    gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    gridView.autoresizesSubviews = YES;
    gridView.backgroundColor = [UIColor greenColor];
    gridView.opaque = NO;
    gridView.leftContentInset = 0.0;
    gridView.dataSource = self;
    gridView.delegate = self;
    gridView.scrollEnabled = YES;
    
    
    [self.view addSubview:gridView];
    
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return images.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * CellIdentifier = @"CellIdentifier";
        static NSString * EmptyIdentifier = @"EmptyIdentifier";
    
    if ( index == NSNotFound )
    {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
        if ( hiddenCell == nil )
        {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 72.0)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }

    
    AQGridViewCell * cell = [gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 72.0) reuseIdentifier: CellIdentifier];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:index]];
    CALayer *layer = [imageView layer];
    [layer setBorderWidth:5];
    [imageView setContentMode:UIViewContentModeCenter];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
    [layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    [layer setShadowRadius:3.0];
    [layer setShadowOpacity:1.0];
    
    [cell.contentView addSubview:imageView];
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(192.0, 192.0) );
}

- (void) viewDidUnload
{
    gridView = nil;
}

@end
