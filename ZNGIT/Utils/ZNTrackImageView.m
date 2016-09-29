//
//  ZNTrackImageView.m
//  ZNGIT
//
//  Created by LionStar on 3/8/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#import "ZNTrackImageView.h"
#define RADIAS1 25
#define RADIAS 15
#define AROUND_RADIAS 30

@interface ZNTrackImageView()
@property BOOL tracking;
@property NSArray *keyPoints;
@property NSMutableDictionary *keyPointsPassedStatus;

@property CGPoint prevPoint;


@property NSMutableArray *trackedRects;
@property NSMutableArray *trackedAroundRects;

@end
@implementation ZNTrackImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTrackStartPoint:(CGPoint)trackStartPoint
{
    _trackedAroundRects = [NSMutableArray new];
    
    CGRect aroundRect = CGRectMake(trackStartPoint.x-RADIAS1, self.frame.size.height - trackStartPoint.y-RADIAS1, 2*RADIAS1, 2*RADIAS1);
    
    [_trackedAroundRects addObject:[NSValue valueWithCGRect:aroundRect]];
}
- (void)setBoneLines:(NSArray *)boneLines
{
    _boneLines = boneLines;
    _keyPoints = [self getKeyPoints];
    
    _keyPointsPassedStatus = [NSMutableDictionary new];
    
    _prevPoint = CGPointMake(-1, -1);
    
    _trackedRects = [NSMutableArray new];
}

#pragma mark - Touch event handler
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[_keyPointsPassedStatus removeAllObjects];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:touch.view];
    CGPoint reversePoint = CGPointMake(point.x, self.frame.size.height-point.y);
    
    _tracking = YES;
    
    if([_trackPath containsPoint:reversePoint] && [self.delegate respondsToSelector:@selector(beginTrackAtPoint:)])
    {
        CGPoint calculatedPoint = [self getBonePoint:reversePoint];
        if(calculatedPoint.x>-1 && calculatedPoint.y>-1)
            [self.delegate beginTrackAtPoint:CGPointMake(calculatedPoint.x, self.frame.size.height-calculatedPoint.y)];
    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _tracking = NO;
    
    if([self.delegate respondsToSelector:@selector(endTrack:)])
    {
        [self.delegate endTrack:[self checkPassedKeyPoints]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if (_tracking) {
        
        CGPoint curPoint = [touch locationInView:touch.view];
        curPoint = CGPointMake(curPoint.x, self.frame.size.height-curPoint.y);
        
        CGPoint prevPoint = [touch previousLocationInView:touch.view];
        prevPoint = CGPointMake(prevPoint.x, self.frame.size.height-prevPoint.y);
        
        
        for(CGFloat x=prevPoint.x; (curPoint.x>=prevPoint.x)?x<=curPoint.x:x>=curPoint.x; (curPoint.x>=prevPoint.x)?(x+=3):(x-=3))
        {
            CGFloat y = (curPoint.y-prevPoint.y) * (x-prevPoint.x) / (curPoint.x-prevPoint.x) + prevPoint.y;
            
            CGPoint calculatedPoint = [self getBonePoint:CGPointMake(x, y)];
            
            if(calculatedPoint.x>-1 && calculatedPoint.y>-1)
            {
                NSValue *lastAroundRectValue = [_trackedAroundRects lastObject];
                CGRect lastAroundRect = [lastAroundRectValue CGRectValue];
                CGPoint lastAroundCenterPoint = CGPointMake(lastAroundRect.origin.x+RADIAS1, lastAroundRect.origin.y+RADIAS1);
                
                UIBezierPath *aroundPath = [UIBezierPath bezierPathWithOvalInRect:lastAroundRect];
                if([aroundPath containsPoint:calculatedPoint])
                {
                    if((fabs(calculatedPoint.y-lastAroundCenterPoint.y)<4 && calculatedPoint.x-lastAroundCenterPoint.x>0) || (calculatedPoint.y<lastAroundCenterPoint.y && lastAroundCenterPoint.x-calculatedPoint.x>0))
                    {
                        [self.delegate moveTrackerToPoint:CGPointMake(calculatedPoint.x, self.frame.size.height-calculatedPoint.y)];
                        
                        //if(_prevPoint.x != -1 && _prevPoint.y != -1)
                        {
                            [_trackedAroundRects addObject:[NSValue valueWithCGRect:CGRectMake(calculatedPoint.x-RADIAS1, calculatedPoint.y-RADIAS1, 2*RADIAS1, 2*RADIAS1)]];
                            
                            [self drawTrack:calculatedPoint];
                        }
                        
                        _prevPoint = calculatedPoint;
                    }
                }
            }
        }
        
        
    }
}

- (CGPoint)getPrevKeyPoint:(CGPoint)point
{
    CGPoint closetPrevKeyPoint = [_keyPoints[0] CGPointValue];
    for(NSValue *value in _keyPoints)
    {
        CGPoint keyPoint = [value CGPointValue];
        
        CGFloat closetPrevKeyPointValue = closetPrevKeyPoint.x + (self.frame.size.height - closetPrevKeyPoint.y) * self.frame.size.width;
        CGFloat keyPointValue = keyPoint.x + (self.frame.size.height - keyPoint.y) * self.frame.size.width;
        CGFloat pointValue = point.x + (self.frame.size.height - point.y) * self.frame.size.width;
        
        if(pointValue > keyPointValue && pointValue-closetPrevKeyPointValue > pointValue-keyPointValue)
        {
            closetPrevKeyPoint = keyPoint;
        }
    }
    
    return closetPrevKeyPoint;
}
/**
 *
 *
 */
- (CGPoint)getBonePoint:(CGPoint)point
{
    CGPoint calculatedPoint = CGPointMake(-1, -1);
    if(_boneLines==nil || _boneLines.count==0) return calculatedPoint;
    
    
    
    CGFloat dy = 100;
    for(NSArray *points in _boneLines)
    {
        if(points==nil || points.count!=2) continue;
        
        NSValue *value1 = points[0];
        NSValue *value2 = points[1];
        CGPoint p1 = [value1 CGPointValue];
        CGPoint p2 = [value2 CGPointValue];
        
        if(p1.x>p2.x && (point.x<p2.x || point.x>p1.x))
            continue;
        else if(p1.x<p2.x && (point.x<p1.x || point.x>p2.x))
            continue;
        
            
        CGFloat y = (p2.y-p1.y) * (point.x-p1.x) / (p2.x-p1.x) + p1.y;
        
        if(fabs(y-point.y)<dy)
        {
            dy = y-point.y;
            calculatedPoint = CGPointMake(floorf(point.x), floorf(y));
        }
    }
    
    
    [self setPassedKeyPoints:calculatedPoint];
    return calculatedPoint;
}

- (void)setPassedKeyPoints:(CGPoint)point
{
    for(NSValue *value in _keyPoints)
    {
        CGPoint keyPoint = [value CGPointValue];
        CGFloat distance = DistanceBetweenTwoPoints(keyPoint, point);
        
        
        if(distance < 8){
            [_keyPointsPassedStatus setObject:@(YES) forKey:value];
        }
    }
}

- (BOOL)checkPassedKeyPoints
{
    for(NSValue *value in _keyPoints)
    {
        if (![[_keyPointsPassedStatus objectForKey:value] boolValue]) {
            return NO;
        }
    }
    return YES;
}

- (NSArray*)getKeyPoints
{
    NSMutableArray *keyPoints = [NSMutableArray new];
    
    for(NSArray *points in _boneLines)
    {
        if(points==nil || points.count!=2) continue;
        
        NSValue *value1 = points[0];
        NSValue *value2 = points[1];
        //CGPoint p1 = [value1 CGPointValue];
        //CGPoint p2 = [value2 CGPointValue];
        
        BOOL bFind1 = NO, bFind2 = NO;
        for(NSValue *value in keyPoints)
        {
//            CGPoint p = [value CGPointValue];
//            if(p1.x == p.x && p1.y == p.y)
//                bFind1 = YES;
//            if(p2.x == p.x && p2.y == p.y)
//                bFind2 = YES;
            
            if([value isEqualToValue:value1])
                bFind1 = YES;
            if([value isEqualToValue:value2])
                bFind2 = YES;
        }
        
        if(!bFind1)
            [keyPoints addObject:value1];
        
        if(!bFind2)
            [keyPoints addObject:value2];
    }
    
    return keyPoints;
}

- (BOOL)inAroundKeyPoint:(CGPoint)point
{
    //DLog(@"CenterPoint:%f,%f",point.x,point.y);
    for(NSValue *keyPointValue in _keyPoints)
    {
        CGPoint keyPoint = [keyPointValue CGPointValue];
        //DLog(@"KeyPoint:%f,%f",keyPoint.x,keyPoint.y);
        if(DistanceBetweenTwoPoints(point, keyPoint)<16)
            return YES;
    }
    
    return NO;
}
CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};


- (void)drawTrack:(CGPoint)curPoint
{
    
    UIImage *source = [UIImage imageNamed:@"Z"];
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [[UIColorFromRGB(0x00BCB6) colorWithAlphaComponent:0.5] setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    //CGContextAddPath(context, _trackPath.CGPath);
    
    //if(_trackedAroundRects.count>5)
    {
        
        for(NSInteger index=0; index<_trackedAroundRects.count; index++)
        {
            NSValue *aroundRectValue = _trackedAroundRects[index];
            CGRect aroundRect = [aroundRectValue CGRectValue];
            
            //if(aroundRect.origin.x+aroundRect.size.width < curPoint.x || aroundRect.origin.y > curPoint.y)
            CGPoint aroundCenterPoint = CGPointMake(aroundRect.origin.x+aroundRect.size.width/2, aroundRect.origin.y+aroundRect.size.height/2);
            
            BOOL bDraw = NO;
            
            if(curPoint.y == aroundCenterPoint.y)
            {
                if(curPoint.x-aroundCenterPoint.x > RADIAS/2)
                {
                    bDraw = YES;
                }
            }
            else if(curPoint.y < aroundCenterPoint.y)
            {
                if((curPoint.x-aroundCenterPoint.x)*(curPoint.x-aroundCenterPoint.x)+(curPoint.y-aroundCenterPoint.y)*(curPoint.y-aroundCenterPoint.y) > RADIAS*RADIAS/4)
                {
                    bDraw = YES;
                }
            }
            
            if(bDraw)
            {
                if([self inAroundKeyPoint:aroundCenterPoint])
                {
                    if(aroundCenterPoint.x>50)
                        CGContextAddRect(context, CGRectMake(aroundCenterPoint.x, aroundCenterPoint.y-RADIAS, 2*AROUND_RADIAS, 2*RADIAS));
                    else
                        CGContextAddRect(context, CGRectMake(aroundCenterPoint.x-2*AROUND_RADIAS, aroundCenterPoint.y-RADIAS, 2*AROUND_RADIAS, 2*RADIAS));
                        
                }
                else
                {
                    CGContextAddEllipseInRect(context, CGRectMake(aroundCenterPoint.x-RADIAS, aroundCenterPoint.y-RADIAS, 2*RADIAS, 2*RADIAS));
                }
            }
        }
    }
    
    
    
    
    CGContextDrawPath(context, kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *dest = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = dest;
}

@end
