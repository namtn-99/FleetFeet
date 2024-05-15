//
//  GameScene.swift
//  FleetFeet
//
//  Created by NamTrinh on 11/05/2024.
//

import SpriteKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

class GameScene: SKScene {
    
    var playableRect: CGRect = .zero
    
    struct PhysicsCategory {
      static let none      : UInt32 = 0
      static let all       : UInt32 = UInt32.max
      static let monster   : UInt32 = 0b1       // 1
      static let projectile: UInt32 = 0b10      // 2
    }
    
    private var actor: SKSpriteNode = SKSpriteNode()
    private var up = SKSpriteNode()
    private var down = SKSpriteNode()
    private var left = SKSpriteNode()
    private var right = SKSpriteNode()
    private var throwBall = SKSpriteNode()
    private var bg = SKSpriteNode()
    
    private var redTeam1 = SKSpriteNode()
    private var redTeam2 = SKSpriteNode()
    private var redTeam3 = SKSpriteNode()
    private var redTeam4 = SKSpriteNode()
    private var redTeam5 = SKSpriteNode()
    private var redTeam6 = SKSpriteNode()
    private var redTeam7 = SKSpriteNode()
    private var redTeam8 = SKSpriteNode()
    private var ball = SKSpriteNode()
    
    var playerHaveBall = false
    var redTeam1HaveBall = false
    var redTeam2HaveBall = false
    var redTeam3HaveBall = false
    var redTeam4HaveBall = false
    var redTeam5HaveBall = false
    var redTeam6HaveBall = false
    var redTeam7HaveBall = false
    var redTeam8HaveBall = false
    
    
    override func didMove(to view: SKView) {
        self.bg = SKSpriteNode(imageNamed: "ic_game_bg")
        bg.size = CGSize(width: 1800, height: 1334)
        bg.position = CGPoint(x: 525, y: 0)
        bg.zPosition = -2
        addChild(bg)
        self.actor = SKSpriteNode(imageNamed: "ic_blue_team_small")
        actor.position = CGPoint(x: -200, y: 0)
        addChild(actor)
        
        self.up = SKSpriteNode(imageNamed: "ic_game_up")
        up.position = CGPoint(x: -300, y: -500)
        up.size = CGSize(width: 90, height: 90)
        addChild(up)
        
        self.down = SKSpriteNode(imageNamed: "ic_game_down")
        down.position = CGPoint(x: -300, y: -600)
        down.size = CGSize(width: 90, height: 90)
        addChild(down)
        
        self.left = SKSpriteNode(imageNamed: "ic_game_left")
        left.position = CGPoint(x: 150, y: -600)
        left.size = CGSize(width: 90, height: 90)
        addChild(left)
        
        self.right = SKSpriteNode(imageNamed: "ic_game_right")
        right.position = CGPoint(x: 250, y: -600)
        right.size = CGSize(width: 90, height: 90)
        addChild(right)
        
        self.throwBall = SKSpriteNode(imageNamed: "ic_game_up")
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        addRedTeam()
        addBall()
        redTeam4HaveBall = true
        
        let maxAspectRatio: CGFloat = 16 / 9
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    private func addBall() {
        ball = SKSpriteNode(imageNamed: "ic_ball")
        ball.size = CGSize(width: 70, height: 60)
        ball.zPosition = -1
        addChild(ball)
    }
    
    private func addRedTeam() {
        redTeam1 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam1, position: CGPoint(x: 160, y: -400))
        redTeam2 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam2, position: CGPoint(x: 160, y: -50))
        redTeam3 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam3, position: CGPoint(x: 160, y: 300))
        redTeam4 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam4, position: CGPoint(x: 550, y: -300))
        redTeam5 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam5, position: CGPoint(x: 550, y: 100))
        redTeam6 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam6, position: CGPoint(x: 950, y: -400))
        redTeam7 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam7, position: CGPoint(x: 950, y: -50))
        redTeam8 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam8, position: CGPoint(x: 950, y: 300))
    }
    
    private func boundsCheckPlayer() {
        let bottomLeft = CGPoint(x: 0, y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: size.width, y: CGRectGetMaxY(playableRect))
        
        if actor.position.x <= bottomLeft.x {
            actor.position.x = bottomLeft.x
        }
        if actor.position.x >= topRight.x {
            actor.position.x = topRight.x
        }
        if actor.position.y <= bottomLeft.y {
            actor.position.y = bottomLeft.y
        }
        if actor.position.y >= topRight.y {
            actor.position.y = topRight.y
        }
     }
    
    private func setUpRedTeam(node: SKSpriteNode, position: CGPoint) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.monster
        node.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        node.physicsBody?.collisionBitMask = PhysicsCategory.none
        node.position = position
        addChild(node)

        let actionMove = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
        let rotate = SKAction.rotate(byAngle: .pi, duration: 0.5)
        let actionForward = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 1)
        node.run(
            SKAction.repeatForever(SKAction.sequence([rotate, actionMove, rotate, actionForward]))
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        let movePoint: CGFloat = 80
        
        if touchedNode.position == left.position {
            print("BG x", bg.position.x)
            print("Actor x", actor.position.x)
            let rotate = SKAction.rotate(toAngle: -.pi / 2, duration: 0.1)
            actor.run(rotate)
            
            if bg.position.x < 525 {
                let actionMove = SKAction.moveBy(x: movePoint, y: 0, duration: 0.5)
                let redAction = SKAction.move(by: CGVector(dx: movePoint, dy: 0), duration: 0.5)
                bg.run(SKAction.sequence([actionMove]))
                [redTeam1, redTeam2, redTeam3, redTeam4, redTeam5, redTeam6, redTeam7, redTeam8].forEach { $0.run(redAction) }
            } else if actor.position.x > -200 {
                let actionMove = SKAction.move(by: CGVector(dx: -movePoint, dy: 0), duration: 0.5)
                actor.run(actionMove)
            }
          
        }
        
        if touchedNode.position == right.position {
            print("BG x", bg.position.x)
            print("Actor x", actor.position.x)
            let rotate = SKAction.rotate(toAngle: .pi / 2, duration: 0.1)
            actor.run(SKAction.sequence([rotate]))

            if bg.position.x <= -400 {
                let actionMove = SKAction.move(by: CGVector(dx: movePoint, dy: 0), duration: 0.5)
                actor.run(actionMove)
            } else {
                let actionMove = SKAction.moveBy(x: -movePoint, y: 0, duration: 0.5)
                let redAction = SKAction.move(by: CGVector(dx: -movePoint, dy: 0), duration: 0.5)
                bg.run(SKAction.sequence([actionMove]))
                [redTeam1, redTeam2, redTeam3, redTeam4, redTeam5, redTeam6, redTeam7, redTeam8].forEach { $0.run(redAction) }
            }
           
           
            
        }
        
        if touchedNode.position == up.position {
            let rotate = SKAction.rotate(toAngle: .pi, duration: 0.1)
            let actionMove = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
        }
        
        if touchedNode.position == down.position {
            let rotate = SKAction.rotate(toAngle: 0, duration: 0.1)
            let actionMove = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
        }
    }
    
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    override func update(_ currentTime: TimeInterval) {
        if actor.position.x > 600 {
            gameOver()
        }
        if playerHaveBall {
            ball.position.x = actor.position.x + 60
            ball.position.y = actor.position.y + 20
        }
        if redTeam1HaveBall {
            ball.position.x = redTeam1.position.x + 60
            ball.position.y = redTeam1.position.y + 20
        }
        if redTeam2HaveBall {
            ball.position.x = redTeam2.position.x + 60
            ball.position.y = redTeam2.position.y + 20
        }
        if redTeam3HaveBall {
            ball.position.x = redTeam3.position.x + 60
            ball.position.y = redTeam3.position.y + 20
        }
        if redTeam4HaveBall {
            ball.position.x = redTeam4.position.x + 60
            ball.position.y = redTeam4.position.y + 20
        }
        if redTeam5HaveBall {
            ball.position.x = redTeam5.position.x + 60
            ball.position.y = redTeam5.position.y + 20
        }
        if redTeam6HaveBall {
            ball.position.x = redTeam6.position.x + 60
            ball.position.y = redTeam6.position.y + 20
        }
        if redTeam7HaveBall {
            ball.position.x = redTeam7.position.x + 60
            ball.position.y = redTeam7.position.y + 20
        }
        if redTeam8HaveBall {
            ball.position.x = redTeam8.position.x + 60
            ball.position.y = redTeam8.position.y + 20
        }
    }
    
    private func gameOver() {
        if let controller = self.view?.window?.rootViewController as? GameViewController {
           controller.showEndGame()
        }
    }
    
    func addRedTeam(at position: CGPoint) {
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
