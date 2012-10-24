//
//  PhotoViewController.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/22/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoViewController.h"

@interface PhotoViewController (){
    NSArray *photoLibrary;
    NSInteger currentImageIndex;
    UIImageView *imageView;
}
@end

@implementation PhotoViewController


-(PhotoViewController*) initWithImages:(NSArray*)images andIndex:(NSInteger) index;
{
    photoLibrary = images;
    currentImageIndex = index;
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [[UIImage alloc] initWithCGImage:((ALAsset*)[photoLibrary objectAtIndex:currentImageIndex]).defaultRepresentation.fullResolutionImage];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    
    [self.view addSubview:imageView];
}

-(void)handleSwipe: (UISwipeGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight && currentImageIndex > 0) {
        currentImageIndex--;
    }
    else if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft && currentImageIndex < photoLibrary.count-1){
        currentImageIndex++;
    }
    
    imageView.image = [[UIImage alloc] initWithCGImage:((ALAsset*)[photoLibrary objectAtIndex:currentImageIndex]).defaultRepresentation.fullResolutionImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}

@end
