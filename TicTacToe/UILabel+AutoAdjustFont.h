//
//  UILabel+AutoAdjustFont.h
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AutoAdjustFont)

- (NSInteger)fontSizeWithMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize;

@end

NS_ASSUME_NONNULL_END
