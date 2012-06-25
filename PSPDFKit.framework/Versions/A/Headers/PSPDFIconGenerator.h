//
//  PSPDFIconGenerator.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSPDFIconType) {
    PSPDFIconTypeOutline,
    PSPDFIconTypePage,
    PSPDFIconTypeThumbnails,
    PSPDFIconTypeBackArrow,
    PSPDFIconTypeBackArrowSmall,
    PSPDFIconTypeForwardArrow,
    PSPDFIconTypePrint,
    PSPDFIconTypeEmail
};

/// Generates various Icons on the fly and caches them for later use.
@interface PSPDFIconGenerator : NSObject

/// Access singleton. Note: can be overridden with changing global kPSPDFIconGeneratorClassName.
+ (PSPDFIconGenerator *)sharedGenerator;

/// Generates in-code images on the fly. Cached, Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType;

@end
