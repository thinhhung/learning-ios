//
//  ViewController.h
//  MapSample
//
//  Created by Thinh Hung on 1/24/15.
//  Copyright (c) 2015 Thinh Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;
@end
