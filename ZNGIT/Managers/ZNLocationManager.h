//
//  ZNLocationManager.h
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZNLocationManager : NSObject <CLLocationManagerDelegate>

+ (ZNLocationManager*)sharedInstance;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;
@property (nonatomic, strong) CLLocation *currentLocation;  // iPhone current location
@property (nonatomic, strong) NSDictionary *selectedCity; // selected location on app

- (void)startLocationService;
- (CLLocation*)getCurrentLocation;
- (CLPlacemark*)getCurrentPlacemark;
- (NSDictionary*)getSelectedCity;
- (NSDictionary*)getDefaultCity;

- (NSArray*)getSuggestedCities;
- (void)getLocationFromAddress:(NSString*)address completion:(void (^)(CLLocation*location))handler;
@end
