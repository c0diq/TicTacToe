//
//  Game_Private.h
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import "Game.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game (Private)

- (nullable NSArray<NSIndexPath *> *)setPlayer:(Player *)player atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
