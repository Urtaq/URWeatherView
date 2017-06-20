//
//  LOTLayerView.h
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

#else

#import "LOTPlatformCompat.h"

#endif
#import "LOTAnimatableLayer.h"

#import "LOTModels.h"

extern const NSString *kLOTAssetImageName;
extern const NSString *kLOTImageSolidLayer;

@interface LOTLayerView : LOTAnimatableLayer

- (instancetype)initWithModel:(LOTLayer *)model inLayerGroup:(LOTLayerGroup *)layerGroup;

- (void)LOT_addChildLayer:(CALayer *)childLayer;

@property (nonatomic, readonly) LOTLayer *layerModel;
@property (nonatomic, assign) BOOL debugModeOn;

@property (nonatomic, readonly) NSDictionary<NSString *, CALayer *> *imageSolidLayer;

@end
