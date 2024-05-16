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

protocol GameDelegate: AnyObject {
    func gameOver()
    func updateScore()
    func updateHeart(heart: Int)
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
    
    var bgPosition = CGPoint(x: 525, y: 0)
    var userPosition = CGPoint(x: -200, y: 0)
    
    var red1Position = CGPoint(x: 160, y: -400)
    var red2Position = CGPoint(x: 160, y: -50)
    var red3Position = CGPoint(x: 160, y: 300)
    var red4Position = CGPoint(x: 550, y: -300)
    var red5Position = CGPoint(x: 550, y: 100)
    var red6Position = CGPoint(x: 950, y: -400)
    var red7Position = CGPoint(x: 950, y: -50)
    var red8Position = CGPoint(x: 950, y: 300)
    var isStop = false
    
    var ballState = 0
    var heart = 5
    
    let moveSound = SKAction.playSoundFileNamed("move", waitForCompletion: false)
    let pickupBallSound = SKAction.playSoundFileNamed("pickUpBall", waitForCompletion: false)
    let heartLostSound = SKAction.playSoundFileNamed("heartLost", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("gameOver", waitForCompletion: false)
    
    var timer = Timer()
    
    weak var gameDelegate: GameDelegate?
    
    override func didMove(to view: SKView) {
        self.bg = SKSpriteNode(imageNamed: "ic_game_bg")
        bg.size = CGSize(width: 1800, height: 1334)
        bg.position = CGPoint(x: 525, y: 0)
        bg.zPosition = -2
        addChild(bg)
        
        self.actor = SKSpriteNode(imageNamed: "ic_blue_team_small")
        actor.position = CGPoint(x: -200, y: 0)
        actor.physicsBody = SKPhysicsBody(rectangleOf: actor.size)
        actor.physicsBody?.isDynamic = true
        actor.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        actor.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        addChild(actor)
        
        self.up = SKSpriteNode(imageNamed: "ic_game_up")
        up.position = CGPoint(x: -300, y: -500)
        up.size = CGSize(width: 90, height: 90)
        up.zPosition = 5
        addChild(up)
        
        self.down = SKSpriteNode(imageNamed: "ic_game_down")
        down.position = CGPoint(x: -300, y: -600)
        down.size = CGSize(width: 90, height: 90)
        up.zPosition = 2
        addChild(down)
        
        self.left = SKSpriteNode(imageNamed: "ic_game_left")
        left.position = CGPoint(x: 150, y: -600)
        left.size = CGSize(width: 90, height: 90)
        up.zPosition = 2
        addChild(left)
        
        self.right = SKSpriteNode(imageNamed: "ic_game_right")
        right.position = CGPoint(x: 250, y: -600)
        right.size = CGSize(width: 90, height: 90)
        up.zPosition = 2
        addChild(right)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        addRedTeam()
        addBall()
        redTeam4HaveBall = true
        
        ballState = Int(random(min: 1, max: 8))
        
        let maxAspectRatio: CGFloat = 16 / 9
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(replay),
                                               name: .replay,
                                               object: nil)
    }
    
    @objc func replay() {
        resetGame()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        isStop = false
    }
    
    private func addBall() {
        ball = SKSpriteNode(imageNamed: "ic_ball")
        ball.size = CGSize(width: 70, height: 60)
        ball.zPosition = -1
        addChild(ball)
    }
    
    private func addRedTeam() {
        redTeam1 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam1, position: red1Position)
        redTeam2 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam2, position: red2Position)
        redTeam3 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam3, position: red3Position)
        redTeam4 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam4, position: red4Position)
        redTeam5 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam5, position: red5Position)
        redTeam6 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam6, position: red6Position)
        redTeam7 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam7, position: red7Position)
        redTeam8 = SKSpriteNode(imageNamed: "ic_red_team_small")
        setUpRedTeam(node: redTeam8, position: red8Position)
    }
 
    private func setUpRedTeam(node: SKSpriteNode, position: CGPoint) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.monster
        node.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
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
            if AppStorage.isOnMusic {
                actor.run(moveSound)
            }
            
            let rotate = SKAction.rotate(toAngle: -.pi / 2, duration: 0.1)
            actor.run(rotate)
            
            if bg.position.x >= 520 {
                let actionMove = SKAction.move(by: CGVector(dx: -movePoint, dy: 0), duration: 0.5)
                actor.run(actionMove)
            } else {
                let actionMove = SKAction.moveBy(x: movePoint, y: 0, duration: 0.5)
                let redAction = SKAction.move(by: CGVector(dx: movePoint, dy: 0), duration: 0.5)
                bg.run(actionMove)
                [redTeam1, redTeam2, redTeam3, redTeam4, redTeam5, redTeam6, redTeam7, redTeam8].forEach { $0.run(redAction) }
            }
          
        }
        
        if touchedNode.position == right.position {
            if AppStorage.isOnMusic {
                actor.run(moveSound)
            }
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
            if AppStorage.isOnMusic {
                actor.run(moveSound)
            }
            let rotate = SKAction.rotate(toAngle: .pi, duration: 0.1)
            let actionMove = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
            actor.run(SKAction.sequence([rotate, actionMove]))
        }
        
        if touchedNode.position == down.position {
            if AppStorage.isOnMusic {
                actor.run(moveSound)
            }
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
        print("ACTOR position x: ", actor.position.x)
        if bg.position.x > 520 {
            bg.position.x = 520
        }
        if actor.position.x < -200 {
            actor.position.x = -200
        }
        if actor.position.x > 250, ballState == 0 {
            AppStorage.scores += 1
            
            if AppStorage.isOnMusic {
                actor.run(gameOverSound)
            }
            gameDelegate?.gameOver()
            isStop = false
        }
        
        if ballState == 0 {
            ball.position.x = actor.position.x + 60
            ball.position.y = actor.position.y + 20
        }
        if ballState == 1 {
            ball.position.x = redTeam1.position.x + 60
            ball.position.y = redTeam1.position.y + 20
        }
        if ballState == 2 {
            ball.position.x = redTeam2.position.x + 60
            ball.position.y = redTeam2.position.y + 20
        }
        if ballState == 3 {
            ball.position.x = redTeam3.position.x + 60
            ball.position.y = redTeam3.position.y + 20
        }
        if ballState == 4 {
            ball.position.x = redTeam4.position.x + 60
            ball.position.y = redTeam4.position.y + 20
        }
        if ballState == 5 {
            ball.position.x = redTeam5.position.x + 60
            ball.position.y = redTeam5.position.y + 20
        }
        if ballState == 6 {
            ball.position.x = redTeam6.position.x + 60
            ball.position.y = redTeam6.position.y + 20
        }
        if ballState == 7 {
            ball.position.x = redTeam7.position.x + 60
            ball.position.y = redTeam7.position.y + 20
        }
        if ballState == 8 {
            ball.position.x = redTeam8.position.x + 60
            ball.position.y = redTeam8.position.y + 20
        }
    }
    
    private func gameOver() {
        if let controller = self.view?.window?.rootViewController as? GameViewController {
            controller.showEndGame()
        }
    }
    
    private func resetGame() {
        ballState = Int(random(min: 1, max: 8))
        bg.position = bgPosition
        actor.position = userPosition
        redTeam1.position.x = red1Position.x
        redTeam2.position.x = red2Position.x
        redTeam3.position = red3Position
        redTeam4.position = red4Position
        redTeam5.position = red5Position
        redTeam6.position = red6Position
        redTeam7.position = red7Position
        redTeam8.position = red8Position
        
        print("RED 8 position", redTeam8.position.x)
    }
    
    private func pauseAll() {
        actor.isPaused = true
        redTeam1.isPaused = true
        redTeam2.isPaused = true
        redTeam3.isPaused = true
        redTeam4.isPaused = true
        redTeam5.isPaused = true
        redTeam6.isPaused = true
        redTeam7.isPaused = true
        redTeam8.isPaused = true
    }
    
    private func unPausedAll() {
        actor.isPaused = false
        redTeam1.isPaused = false
        redTeam2.isPaused = false
        redTeam3.isPaused = false
        redTeam4.isPaused = false
        redTeam5.isPaused = false
        redTeam6.isPaused = false
        redTeam7.isPaused = false
        redTeam8.isPaused = false
    }
    
    private func handleTouch() {
        if AppStorage.isOnMusic {
            actor.run(heartLostSound)
        }
        if heart == 1 {
            gameDelegate?.gameOver()
            if AppStorage.isOnMusic {
                actor.run(gameOverSound)
            }
           
        } else {
            heart -= 1
            resetGame()
            gameDelegate?.updateHeart(heart: heart)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if !isStop {
            print("didBegin ")
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            // 2
            if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
                if let monster = firstBody.node as? SKSpriteNode,
                   let projectile = secondBody.node as? SKSpriteNode {
                    isStop = true
                    runTimer()
                    handleBall(node: monster)
                }
            }

        }
    }
}

extension GameScene {
    func handleBall(node: SKSpriteNode) {
        switch node {
        case redTeam1:
            if ballState == 1 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam2:
            if ballState == 2 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam3:
            if ballState == 3 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam4:
            if ballState == 4 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam5:
            if ballState == 5 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam6:
            if ballState == 6 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam7:
            if ballState == 7 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        case redTeam8:
            if ballState == 8 {
                ballState = 0
                redTeam1.run(pickupBallSound)
            } else {
                handleTouch()
            }
        default:
            break
        }
    }
}
