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
    
    var playerMovedRight = false
    var playerMovedLeft = false
    
    override func didMove(to view: SKView) {
        self.bg = SKSpriteNode(imageNamed: "ic_game_bg")
        bg.size = CGSize(width: 1800, height: 1334)
        bg.position = CGPoint(x: 525, y: 0)
        bg.zPosition = -1
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
//        addRedTeam(at: CGPoint(x: 160, y: -50))
//        addRedTeam(at: CGPoint(x: 160, y: 300))
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
    
    private func setUpRedTeam(node: SKSpriteNode, position: CGPoint) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.monster
        node.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        node.physicsBody?.collisionBitMask = PhysicsCategory.none
        node.position = position
        addChild(node)

        let actionMove = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
   //     let actionMove = SKAction.move(to: CGPoint(x: node.position.x, y: position.y + 250), duration: TimeInterval(1))
        let rotate = SKAction.rotate(byAngle: .pi, duration: 0.5)
  //      let actionForward = SKAction.move(to: CGPoint(x: node.position.x, y: position.y), duration: TimeInterval(1))

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
            let rotate = SKAction.rotate(toAngle: -.pi / 2, duration: 0.1)
            let actionMove = SKAction.moveBy(x: movePoint, y: 0, duration: 0.5)
            let redAction = SKAction.move(by: CGVector(dx: movePoint, dy: 0), duration: 0.5)
            actor.run(SKAction.sequence([rotate]))
            bg.run(SKAction.sequence([actionMove]))
            [redTeam1, redTeam2, redTeam3, redTeam4, redTeam5, redTeam6, redTeam7, redTeam8].forEach { $0.run(redAction) }
        }
        if touchedNode.position == right.position {
            let rotate = SKAction.rotate(toAngle: .pi / 2, duration: 0.1)
            let actionMove = SKAction.moveBy(x: -movePoint, y: 0, duration: 0.5)
            let redAction = SKAction.move(by: CGVector(dx: -movePoint, dy: 0), duration: 0.5)
            actor.run(SKAction.sequence([rotate]))
            bg.run(SKAction.sequence([actionMove]))
            [redTeam1, redTeam2, redTeam3, redTeam4, redTeam5, redTeam6, redTeam7, redTeam8].forEach { $0.run(redAction) }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched Ended")
    }
    
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    override func update(_ currentTime: TimeInterval) {
    
    }
    
    func addRedTeam(at position: CGPoint) {
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
