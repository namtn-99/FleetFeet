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
    private var up: SKLabelNode?
    private var down: SKLabelNode?
    private var left: SKLabelNode?
    private var right: SKLabelNode?
    private var throwBall: SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.actor = SKSpriteNode(imageNamed: "ic_blue_team_small")
        actor.position = CGPoint(x: 100, y: 0)
        addChild(actor)
        self.up = self.childNode(withName: "//up") as? SKLabelNode
        self.down = self.childNode(withName: "//down") as? SKLabelNode
        self.left = self.childNode(withName: "//left") as? SKLabelNode
        self.right = self.childNode(withName: "//right") as? SKLabelNode
        self.throwBall = self.childNode(withName: "//throw") as? SKLabelNode
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        addRedTeam(at: CGPoint(x: 160, y: -400))
        addRedTeam(at: CGPoint(x: 160, y: -50))
        addRedTeam(at: CGPoint(x: 160, y: 300))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)

        if touchedNode.name == "left" {
            let rotate = SKAction.rotate(toAngle: -.pi / 2, duration: 0.1)
            let actionMove = SKAction.moveBy(x: -100, y: 0, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
            camera?.position.x -= 50
        }
        if touchedNode.name == "right" {
            let rotate = SKAction.rotate(toAngle: .pi / 2, duration: 0.1)
            let actionMove = SKAction.moveBy(x: 100, y: 0, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
            camera?.position.x += 50
        }
        if touchedNode.name == "up" {
            let rotate = SKAction.rotate(toAngle: .pi, duration: 0.1)
            let actionMove = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
        }
        if touchedNode.name == "down" {
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
    
    func addRedTeam(at position: CGPoint) {
        let redTeam = SKSpriteNode(imageNamed: "ic_red_team_small")
        redTeam.physicsBody = SKPhysicsBody(rectangleOf: redTeam.size)
        redTeam.physicsBody?.isDynamic = true
        redTeam.physicsBody?.categoryBitMask = PhysicsCategory.monster
        redTeam.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        redTeam.physicsBody?.collisionBitMask = PhysicsCategory.none
        redTeam.position = position
        addChild(redTeam)

        let actionMove = SKAction.move(to: CGPoint(x: position.x, y: position.y + 250), duration: TimeInterval(1))
        let rotate = SKAction.rotate(byAngle: .pi, duration: 0.5)
        let actionForward = SKAction.move(to: position, duration: TimeInterval(1))

        redTeam.run(
            SKAction.repeatForever(SKAction.sequence([rotate, actionMove, rotate, actionForward]))
        )
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
