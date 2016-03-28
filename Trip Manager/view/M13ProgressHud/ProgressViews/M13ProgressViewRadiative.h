// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//
//  Copyright © 2016 Andi Palo
//  This file is part of project: TripManager
//
//
//  M13ProgressViewRadiative.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/13/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewRadiativeShapeCircle,
    M13ProgressViewRadiativeShapeSquare
} M13ProgressViewRadiativeShape;

/**A progress view that displays progress via "Radiative" rings around a central point.*/
@interface M13ProgressViewRadiative : M13ProgressView

/**@name Appearance*/
/**The point where the wave fronts originate from. The point is defined in percentages, top left being {0, 0}, and the bottom right being {1, 1}.*/
@property (nonatomic, assign) CGPoint originationPoint;
/**The distance of the last ripple from the origination point.*/
@property (nonatomic, assign) CGFloat ripplesRadius;
/**The width of the ripples.*/
@property (nonatomic, assign) CGFloat rippleWidth;
/**The shape of the radiative ripples*/
@property (nonatomic, assign) M13ProgressViewRadiativeShape shape;
/**The number of ripples the progress view displays.*/
@property (nonatomic, assign) NSUInteger numberOfRipples;
/**The number of ripples the indeterminate pulse animation is.*/
@property (nonatomic, assign) NSUInteger pulseWidth;
/**The direction of the progress. If set to yes, the progress will be outward, of set to no, it will be inwards.*/
@property (nonatomic, assign) BOOL progressOutwards;

@end
