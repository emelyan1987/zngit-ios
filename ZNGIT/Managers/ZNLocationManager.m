//
//  ZNLocationManager.m
//  ZNGIT
//
//  Created by LionStar on 3/11/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNLocationManager.h"


@implementation ZNLocationManager

+ (ZNLocationManager*)sharedInstance
{
    static ZNLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZNLocationManager new];
    });
    return instance;
}

- (void)startLocationService
{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             
             CLPlacemark *placemark = [placemarks firstObject];
             
             
             
             NSString *city = [[NSString alloc]initWithString:placemark.locality];
             NSString *country = [[NSString alloc]initWithString:placemark.country];
             NSString *countryCode = [[NSString alloc]initWithString:placemark.ISOcountryCode];
             //NSString *name = [NSString stringWithFormat:@"%@, %@", city, country];
             
             DLog(@"Current Location Info:%@, %@, %@", city, country, countryCode);
             
             _currentLocation = placemark.location;
             _currentPlacemark = placemark;
             
             [_locationManager stopUpdatingLocation];
             

             //[self setSelectedCity:[self getClosetSuggestedCityFromLocation:_currentLocation]];
             
         }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (CLLocation*)getCurrentLocation
{
    return _currentLocation;
}

- (CLPlacemark*)getCurrentPlacemark
{
    return _currentPlacemark;
}

- (NSArray*)getSuggestedCities
{
    /*NSArray *cityNames = @[@"Phoenix", @"Boston", @"Chicago", @"New York", @"San Francisco", @"Washington DC", @"Philadelphia"];
     
     for(NSString *name in cityNames)
     {
     CLGeocoder* gc = [[CLGeocoder alloc] init];
     [gc geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError *error)
     {
     if ([placemarks count]>0)
     {
     // get the first one
     CLPlacemark* placemark = (CLPlacemark*)[placemarks objectAtIndex:0];
     double lat = placemark.location.coordinate.latitude;
     double lng = placemark.location.coordinate.longitude;
     
     DLog(@"%@:%f,%f", [[NSString alloc]initWithString:placemark.locality], lat, lng);
     }
     }];
     }*/
    
    return @[
             @{@"name":@"San Diego", @"suggested":@(YES), @"location":@{@"lat":@(32.8244745),@"lng":@(-117.2352443)}},
             @{@"name":@"La Jolla", @"suggested":@(YES), @"location":@{@"lat":@(32.8725163),@"lng":@(-117.2835913)}},
             @{@"name":@"Laguna Beach", @"suggested":@(YES), @"location":@{@"lat":@(33.5482782),@"lng":@(-117.8097723)}},
             @{@"name":@"Newport", @"suggested":@(YES), @"location":@{@"lat":@(41.4861087),@"lng":@(-71.3422778)}},
             @{@"name":@"Huntington", @"suggested":@(YES), @"location":@{@"lat":@(38.4076653),@"lng":@(-82.4769551)}},
             @{@"name":@"Redondo Beach", @"suggested":@(YES), @"location":@{@"lat":@(33.8546327),@"lng":@(-118.3946516)}},
             @{@"name":@"Manhattan Beach", @"suggested":@(YES), @"location":@{@"lat":@(33.8894941),@"lng":@(-118.4097863)}},
             @{@"name":@"Santa Monica", @"suggested":@(YES), @"location":@{@"lat":@(34.0218616),@"lng":@(-118.4979302)}},
             @{@"name":@"Santa Barbara", @"suggested":@(YES), @"location":@{@"lat":@(34.4281888),@"lng":@(-119.7370862)}},
             @{@"name":@"Big Bear", @"suggested":@(YES), @"location":@{@"lat":@(34.2447613),@"lng":@(-116.9376232)}},
             @{@"name":@"Wrightwood (Mountain High Resort)", @"suggested":@(YES), @"location":@{@"lat":@(34.3769123),@"lng":@(-117.6938053)}},
             @{@"name":@"San Francisco", @"suggested":@(YES), @"location":@{@"lat":@(37.7576948),@"lng":@(-122.4726192)}},
             @{@"name":@"Nevada", @"suggested":@(YES), @"location":@{@"lat":@(38.4806503),@"lng":@(-119.2654455)}},
             @{@"name":@"Lake Tahoe", @"suggested":@(YES), @"location":@{@"lat":@(39.0927811),@"lng":@(-120.1150078)}},
             @{@"name":@"South Tahoe City", @"suggested":@(YES), @"location":@{@"lat":@(38.9227214),@"lng":@(-119.9960241 )}},
             @{@"name":@"Tahoe City", @"suggested":@(YES), @"location":@{@"lat":@(39.1555087),@"lng":@(-120.18275)}},
             @{@"name":@"Stateline", @"suggested":@(YES), @"location":@{@"lat":@(38.9663277),@"lng":@(-119.947561)}}
             ];
}

- (NSDictionary*)getClosetSuggestedCityFromLocation:(CLLocation*)location
{
    NSDictionary *closetCity;
    NSArray *cities = [self getSuggestedCities];
    
    double min = 99999999;
    for(NSDictionary *city in cities)
    {
        double lat = [city[@"location"][@"lat"] doubleValue]; double lng = [city[@"location"][@"lng"] doubleValue];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        
        double dist = [location distanceFromLocation:loc]/100;
        
        if(dist<min)
        {
            min = dist;
            closetCity = city;
        }
    }
    
    return closetCity;
}

- (NSDictionary*)getDefaultCity
{
    return [self getSuggestedCities][0];
}

- (NSDictionary*)getSelectedCity
{
    return _selectedCity?_selectedCity:[self getSuggestedCities][0];
}

- (void)setSelectedCity:(NSDictionary *)selectedCity
{
    if(!selectedCity[@"location"])
    {
        [self getLocationFromAddress:selectedCity[@"name"] completion:^(CLLocation *location) {
            if(location)
            {
                NSMutableDictionary *cityItem = [NSMutableDictionary dictionaryWithDictionary:selectedCity];
                [cityItem setObject:@{@"lat":@(location.coordinate.latitude),@"lng":@(location.coordinate.longitude)} forKey:@"location"];
                
                _selectedCity = cityItem;
            }
            else
            {
                _selectedCity = selectedCity;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_SELECTED_CITY_UPDATED object:nil];
        }];
    }
    else
    {
        _selectedCity = selectedCity;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZN_NOTIFICATION_SELECTED_CITY_UPDATED object:nil];
    }
}

- (void)getLocationFromAddress:(NSString *)address completion:(void (^)(CLLocation *))handler
{
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    [gc geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLLocation *location = nil;
         if ([placemarks count]>0)
         {
             // get the first one
             CLPlacemark* placemark = (CLPlacemark*)[placemarks objectAtIndex:0];
             double lat = placemark.location.coordinate.latitude;
             double lng = placemark.location.coordinate.longitude;
             
             DLog(@"%@:%f,%f", [[NSString alloc]initWithString:placemark.locality], lat, lng);
             location = placemark.location;
         }
         if(handler) handler(location);
         
     }];
}
@end
