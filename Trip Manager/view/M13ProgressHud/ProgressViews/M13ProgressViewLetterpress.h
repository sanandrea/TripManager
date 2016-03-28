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
//  M13ProgressViewLetterpress.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 4/28/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewLetterpressPointShapeSquare,
    M13ProgressViewLetterpressPointShapeCircle
} M13ProgressViewLetterpressPointShape;

@interface M13ProgressViewLetterpress : M13ProgressView
/**@name Properties*/
/**
 The number of grid points in each direction.
 */
@property (nonatomic, assign) CGPoint numberOfGridPoints;
/**
 The shape of the grid points.
 */
@property (nonatomic, assign) M13ProgressViewLetterpressPointShape pointShape;
/**
 The amount of space between the grid points, as a percentage of the point's size.
 */
@property (nonatomic, assign) CGFloat pointSpacing;
/**
 The size of the notch to carve out on one side.
 */
@property (nonatomic, assign) CGSize notchSize;
/**
 The spring constant that defines the amount of "spring" the progress view has in its animation.
 */
@property (nonatomic, assign) CGFloat springConstant;
/**
 The constant that determines how long the progress view "bounces" for.
 */
@property (nonatomic, assign) CGFloat dampingCoefficient;
/**
 The constant that determines how much the springConstant and dampingCoefficent affect the animation.
 */
@property (nonatomic, assign) CGFloat mass;

@end
