//
//  PSCFormExamples.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFormExamples.h"
#import "PSCAppDelegate.h"

static void PSPDFFormExampleAddTrustedCertificates() {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSData *cert = [NSData dataWithContentsOfFile:[[samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"] path]];
    [PSPDFDigitalSignatureManager.sharedManager addCertificate:cert error:nil];
}

static PSPDFViewController *PSPDFFormExampleInvokeWithFilename(NSString *filename) {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:filename]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:PDFData];
    return [[PSPDFViewController alloc] initWithDocument:document];
    
}

@interface PSCFormExampleSignatureDelegate : NSObject <PSPDFDigitalSignatureRevisionDelegate, PSPDFDigitalSignatureSigningDelegate>
+ (PSCFormExampleSignatureDelegate *)sharedDelegate;
@end

// Use a singleton to control reactions to signature related events.
@implementation PSCFormExampleSignatureDelegate
+ (PSCFormExampleSignatureDelegate *)sharedDelegate {
    static PSCFormExampleSignatureDelegate *delegate = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{delegate = [PSCFormExampleSignatureDelegate new];});
    return delegate;
}
- (void)pdfRevisionRequested:(PSPDFDocument *)pdf verificationHandler:(id<PSPDFDigitalSignatureVerificationHandler>)handler {
    NSString *date = [NSDateFormatter localizedStringFromDate:handler.signature.timeSigned dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *title = [NSString stringWithFormat:@"%@ (%@ - %@)", handler.documentProvider.document.title, date, handler.signature.name];
    [self showDocument:pdf withTitle:title];
}
- (void)pdfSigned:(PSPDFDocument *)pdf signingHandler:(id<PSPDFDigitalSignatureSigningHandler>)handler {
    
}
- (void)showDocument:(PSPDFDocument *)document withTitle:(NSString *)title {
    PSPDFViewController *controller = [self viewControllerForDocument:document];
    controller.rightBarButtonItems = @[controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    
    if (title) document.title = title;
    
    PSCAppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    [appDelegate.catalog pushViewController:controller animated:YES];
}
- (PSPDFViewController *)viewControllerForDocument:(PSPDFDocument *)document {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    return pdfController;
}
@end

static void PSPDFFormExampleRegisterForCallbacks() {
    [PSPDFDigitalSignatureManager.sharedManager registerForReceivingRequestsToViewRevisions:PSCFormExampleSignatureDelegate.sharedDelegate];
    [PSPDFDigitalSignatureManager.sharedManager registerForReceivingSignedDocuments:PSCFormExampleSignatureDelegate.sharedDelegate];
}

static void PSPDFFormExampleDeregisterForCallbacks() {
    [PSPDFDigitalSignatureManager.sharedManager deregisterFromReceivingRequestsToViewRevisions:PSCFormExampleSignatureDelegate.sharedDelegate];
    [PSPDFDigitalSignatureManager.sharedManager deregisterFromReceivingSignedDocuments:PSCFormExampleSignatureDelegate.sharedDelegate];
}

@implementation PSCFormExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
        PSPDFFormExampleAddTrustedCertificates();
        PSPDFFormExampleRegisterForCallbacks();
    }
    return self;
}

- (void)dealloc {
    PSPDFFormExampleDeregisterForCallbacks();
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example.pdf");
}
@end


@implementation PSCFormDigitallySignedModifiedExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.category = PSCExampleCategoryForms;
        self.priority = 10;
        PSPDFFormExampleAddTrustedCertificates();
        PSPDFFormExampleRegisterForCallbacks();
    }
    return self;
}

- (void)dealloc {
    PSPDFFormExampleDeregisterForCallbacks();
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example_signed.pdf");
}

@end
