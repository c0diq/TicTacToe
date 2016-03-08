//
//  UILabel+AutoAdjustFont.m
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import "UILabel+AutoAdjustFont.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UILabel (AutoAdjustFont)

- (NSInteger)fontSizeWithMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize
{
	if (maxFontSize < minFontSize) {
		return 0;
	}

	UIFont *font = [UIFont fontWithName:self.font.fontName size:maxFontSize];
	CGFloat lineHeight = [font lineHeight];
	CGSize constraintSize = CGSizeMake(MAXFLOAT, lineHeight);
	CGRect rect = [self.text boundingRectWithSize:constraintSize
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:@{ NSFontAttributeName: font }
										  context:nil];

	CGFloat labelSqr = self.frame.size.width * self.frame.size.height;
	CGFloat stringSqr = rect.size.width/self.frame.size.width * (lineHeight + font.pointSize) * self.frame.size.width;

	CGFloat multiplyer = labelSqr/stringSqr;

	if (multiplyer > 1) {
		multiplyer = 1 / multiplyer;
	}

	// leave a bit of breathing room
	multiplyer *= 0.8;

	if (minFontSize < maxFontSize*multiplyer) {
		return maxFontSize * multiplyer;
	} else {
		return minFontSize;
	}
}

@end

NS_ASSUME_NONNULL_END
