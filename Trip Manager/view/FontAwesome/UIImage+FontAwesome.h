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
//  UIImage+UIImage_FontAwesome.h
//  FontAwesome-iOS Demo
//
//  Created by Pedro Piñera Buendía on 22/08/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FontAwesome)
/**
 *	This method generates an UIImage with a given FontAwesomeIcon and format parameters
 *
 *	@param	identifier	NSString that identifies the icon
 *	@param	bgColor     UIColor for background image Color
 *	@param	iconColor   UIColor for icon color
 *	@param	scale       Scale factor between the image size and the icon size
 *	@param	size        Size of the image to be generated
 *
 *	@return	Image to be used wherever you want
 */
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor andSize:(CGSize)size;
/**
 *	This method generates an UIImage with a given FontAwesomeIcon and format parameters
 *
 *	@param	identifier	NSString that identifies the icon
 *	@param	bgColor     UIColor for background image Color
 *	@param	iconColor	UIColor for icon color
 *	@param	scale       Scale factor between the image size and the icon size
 *	@param	fontSize	Font size used to be generate the image
 *
 *	@return	Image to be used wherever you want
 */
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor fontSize:(int)fontSize;
@end
