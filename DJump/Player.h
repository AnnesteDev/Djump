//
//  Player.h
//  DJump
//
//  Created by Dmitry Volevodz on 31.12.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (assign, nonatomic) int velocity;
@property (assign, nonatomic) float xVelocity;

- (void) jump;


@end
