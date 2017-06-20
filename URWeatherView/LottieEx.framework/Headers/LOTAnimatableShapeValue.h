//
//  LOTAnimatableShapeValue.h
//  LottieAnimator
//
//  Created by brandon_withrow on 6/23/16.
//  Copyright © 2016 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOTAnimatableValue.h"
#import "TargetConditionals.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

#else

#import "LOTPlatformCompat.h"

#endif

@interface LOTAnimatableShapeValue : NSObject <LOTAnimatableValue>

- (instancetype)initWithShapeValues:(NSDictionary *)shapeValues frameRate:(NSNumber *)frameRate closed:(BOOL)closed;

@property (nonatomic, readonly) UIBezierPath *initialShape;

@end
