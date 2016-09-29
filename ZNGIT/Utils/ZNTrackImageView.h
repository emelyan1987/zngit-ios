//
//  ZNTrackImageView.h
//  ZNGIT
//
//  Created by LionStar on 3/8/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZNTrackImageViewDelegate <NSObject>

- (void)beginTrackAtPoint:(CGPoint)point;
- (void)moveTrackerToPoint:(CGPoint)point;
- (void)endTrack:(BOOL)success;

@end
@interface ZNTrackImageView : UIImageView

@property (nonatomic, strong) id<ZNTrackImageViewDelegate>delegate;

@property (nonatomic, strong) UIBezierPath *trackPath;
@property (nonatomic, strong) NSArray *boneLines;
@property (nonatomic, assign) CGPoint trackStartPoint;
@end
