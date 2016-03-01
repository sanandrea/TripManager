//
//  PdfCreator.m
//  Trip Manager
//
//  Created by Andi Palo on 29/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "PdfCreator.h"
#import <CoreText/CoreText.h>


const int A4_WIDTH = 612;
const int A4_HEIGHT = 792;
const int TRIP_ROW_HEIGHT = 99;

const int DESTINATION_TAG = 10;
const int COMMENT_TAG = 11;
const int START_DATE_TAG = 12;
const int END_DATE_TAG = 13;

@interface PdfCreator()

@property (nonatomic, assign) int counter;
@property (strong, nonatomic) UIView *template;


@end

@implementation PdfCreator
+ (NSString*) objectKeyForTag:(NSInteger)tag{
    switch (tag) {
        case DESTINATION_TAG:
            return @"destination";
        case COMMENT_TAG:
            return @"comment";
        case START_DATE_TAG:
            return @"startdate";
        case END_DATE_TAG:
            return @"enddate";
        default:
            return @"";
    }
}

- (void) createPdfWithName:(NSString*)name{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:nil options:nil];
    
    self.template = [objects objectAtIndex:0];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(name, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, A4_WIDTH, A4_HEIGHT), nil);
    
    self.counter = 0;
}
- (void) printTrip:(Trip*) trip{

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    NSString* textToDraw = @"Hello World";
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    //http://stackoverflow.com/questions/6988498
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                        framesetter, /* Framesetter */
                                                                        CFRangeMake(0, textToDraw.length), /* String range (entire string) */
                                                                        NULL, /* Frame attributes */
                                                                        CGSizeMake(A4_WIDTH, CGFLOAT_MAX), /* Constraints (CGFLOAT_MAX indicates unconstrained) */
                                                                        NULL /* Gives the range of string that fits into the constraints, doesn't matter in your situation */
                                                                        );
    
    CGRect frameRect = CGRectMake(0, 0, suggestedSize.width, suggestedSize.height);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    
    
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
}


- (void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2 + frameRect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, -frameRect.origin.y*2 -frameRect.size.height);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}

- (void)drawLabelsForTrip:(Trip*)trip
{
    for (UIView* view in [self.template subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            NSString *key = [PdfCreator objectKeyForTag:view.tag];
            
            [self drawText:[trip valueForKey:key] inFrame:label.frame];
        }
    }
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, 0, TRIP_ROW_HEIGHT);
    self.counter++;
    if (self.counter % 8 == 0) {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, A4_WIDTH, A4_HEIGHT), nil);
    }
    
    
}

- (void) endFile{
    UIGraphicsEndPDFContext();
}



@end
