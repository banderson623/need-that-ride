//
//  HelloWorldDetailViewController.h
//  ComeGetMe
//
//  Created by Brian Anderson on 7/13/12.
//  Copyright (c) 2012 Aeroflex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
                                                                // Says that it is the maps delegate
                                                                // need to implement a couple of methods - protocol == interface
@interface PresetContactDetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel* detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@end
