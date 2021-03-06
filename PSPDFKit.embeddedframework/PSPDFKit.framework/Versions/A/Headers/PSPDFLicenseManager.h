//
//  PSPDFLicenseManager.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

typedef NS_OPTIONS(NSUInteger, PSPDFFeatureMask) {
    PSPDFFeatureMaskNone              = 0,
    PSPDFFeatureMaskPDFViewer         = 1 << 0,
    PSPDFFeatureMaskTextSelection     = 1 << 1,
    PSPDFFeatureMaskStrongEncryption  = 1 << 2, // Not available in the demo.
    PSPDFFeatureMaskPDFCreation       = 1 << 3,
    PSPDFFeatureMaskAnnotationEditing = 1 << 4,
    PSPDFFeatureMaskAcroForms         = 1 << 5,
    PSPDFFeatureMaskIndexedFTS        = 1 << 6,
    PSPDFFeatureMaskAll               = UINT_MAX,
};

#ifdef __cplusplus
extern "C" {
#endif

/// Should be set directly in `application:didFinishLaunchingWithOptions:` to enable PSPDFKit, or at latest before any PSPDF* classes are used. Call from the main thread.
/// @return the features available for the give license key.
extern PSPDFFeatureMask PSPDFSetLicenseKey(const char *licenseKey);

#ifdef __cplusplus
}
#endif
