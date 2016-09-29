//
//  PMNetworkManager.h
//  planckMailiOS
//
//  Created by admin on 8/25/15.
//  Copyright (c) 2015 LHlozhyk. All rights reserved.
//

#import "AFNetworking.h"

@interface ZNNetworkManager : AFHTTPSessionManager

+ (ZNNetworkManager *)sharedInstance;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)setAccessToken:(NSString*)accessToken;

@property(nonatomic, copy) NSString *accessToken;

@end
