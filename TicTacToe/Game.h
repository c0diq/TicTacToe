//
//  Game.h
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Player;

@interface Game : NSObject

@property (nonatomic, readonly) Player *player1;
@property (nonatomic, readonly) Player *player2;
@property (nonatomic, readonly) Player *curPlayer;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *winningPositions;
@property (nonatomic, readonly) NSUInteger numberEmptyPositions;

// Set new board size, resetting current one
@property (nonatomic) NSUInteger boardSize;

// Return which player is at the given index path. Nil if not
// currently occupied.
- (nullable Player *)playerAtIndexPath:(NSIndexPath *)indexPath;

// Set current player play. Returns an array of positions if it's a win
- (BOOL)playAtIndexPath:(NSIndexPath *)indexPath;

// Reset both player scores
- (void)resetScores;

@end

NS_ASSUME_NONNULL_END
