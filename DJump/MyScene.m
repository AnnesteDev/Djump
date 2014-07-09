//
//  MyScene.m
//  DJump
//
//  Created by Dmitry Volevodz on 31.12.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

@import CoreMotion;

#import "MyScene.h"
#import "Player.h"

#define GRAVITY -1000

@interface MyScene ()

@property (strong, nonatomic) NSMutableArray *platforms;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) SKNode *backgroundNode;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
//        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        
//        [self addChild:myLabel];
        
        self.platforms = [[NSMutableArray alloc] init];
        
        self.backgroundNode = [[SKNode alloc] init];
        [self addChild:self.backgroundNode];
        
        [self setupPlatforms];
        [self setupPlayer];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.2;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [self outputAccelerometerData:accelerometerData.acceleration];
        }];
    
    }
    return self;
}

- (void) outputAccelerometerData:(CMAcceleration)acceleration
{
    //self.player.xVelocity = acceleration.x;
    
//    static CGFloat x0 = 0.1;
//    
//    const NSTimeInterval dt = (1.0 / 20);
//    const double RC = 0.3;
//    const double alpha = dt / (RC + dt);
//    
//    CMAcceleration smoothed;
//    smoothed.x = (alpha * acceleration.x) + (1.0 - alpha) * x0;
//    
    float k = 0.8;
    self.player.xVelocity = k * self.player.xVelocity + (1.0 - k) * acceleration.x;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
    
}

- (void) setupPlayer
{
    self.player = [[Player alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50)];
    [self addChild:self.player];
    self.player.position = CGPointMake(500, 600);
}

- (void) setupPlatforms
{
    for (int i = 0; i < 5; i++) {
        
        SKSpriteNode *platform = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(200, 50)];
        
        int xOffset = 100 + arc4random() % 550;
        int yOffset = i * 200;
        
        [self.backgroundNode addChild:platform];
        platform.position = CGPointMake(xOffset, yOffset);
        
        [self.platforms addObject:platform];
    }
    
}


-(void)update:(CFTimeInterval)currentTime
{
//    NSLog(@"velocity: %d", self.player.velocity);
//    NSLog(@"platforms: %@", self.platforms);
//    NSLog(@"self.player: %@", self.player);
    
    if (self.player.velocity < 0) {
        for (SKSpriteNode *node in self.platforms) {
            
            if ([node intersectsNode:self.player]) {
                [self.player jump];
               // NSLog(@"COLLIDED");
            }
        }
    }
    
    self.player.velocity = self.player.velocity + GRAVITY * 0.0166;
    self.player.position = CGPointMake(self.player.position.x + self.player.xVelocity * 60, self.player.position.y + self.player.velocity * 0.0166);
    
    if (self.player.position.x > 768) {
        self.player.position = CGPointMake(self.player.position.x - 768, self.player.position.y);
    } else if (self.player.position.x < 0) {
        self.player.position = CGPointMake(768 - self.player.position.x, self.player.position.y);
    }
    
    
    if (self.player.position.y > 700) {
        self.player.position = CGPointMake(self.player.position.x, 700);
        
        for (SKNode *platform in self.platforms) {
           
            platform.position = CGPointMake(platform.position.x, platform.position.y - self.player.velocity * 0.0166);

        }
    }
    
    for (SKSpriteNode *platform in self.platforms) {
        if (platform.position.y < - 50) {
           
            int xOffset = 100 + arc4random() % 550;
            int yOffset = 1200;
            platform.position = CGPointMake(xOffset, yOffset);
        }
    }
    
}

@end
