//
//  PMNetworkManager.m
//  planckMailiOS
//
//  Created by admin on 8/25/15.
//  Copyright (c) 2015 LHlozhyk. All rights reserved.
//

#import "ZNNetworkManager.h"


@implementation ZNNetworkManager

+ (ZNNetworkManager *)sharedInstance
{
    static ZNNetworkManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
}

@end
