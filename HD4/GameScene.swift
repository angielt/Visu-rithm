//
//  GameScene.swift
//  HD4
//
//  Created by Angie Ta on 1/21/17.
//  Copyright © 2017 Angie Ta. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics
import UIKit



class SpriteButtons: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 50, height: 50))
        isUserInteractionEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Did touch Player sprite")
    }
    
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    //var arraySprites: [SKNodeStruct] = [SKNodeStruct]()
    var flag:Int = 1
    var currentIndex:Int = 0
    var searching = true
    var movableNode:SKNode?
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    


    var array: [SKSpriteNode] = [SKSpriteNode]()
    
    //var head:SKNodeStruct = SKNodeStruct()
    
    /*
    class SKNodeStruct {
        var value = 0
        var spritenode:SKSpriteNode = SKSpriteNode()
        
        
        var leftNode:SKNodeStruct = SKNodeStruct()
        var rightNode:SKNodeStruct = SKNodeStruct()
        
    }*/
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        let screenWidthDivide = screenWidth/4
        let screenHeightDivide = screenHeight/2
        // begin insertion sort
        
        var i:Int = 7
        var screenStart = (0 - screenWidth) + screenWidthDivide
        
        while (i != 0){
           // var random:Int = Int(arc4random_uniform(10) + 1)
            let node = SKSpriteNode(imageNamed: String(i))
            node.name = String(i)
            node.position = CGPoint(x: screenStart , y: 0)
            node.setScale(0.25)
            
            array.append(node)
            self.addChild(node)
            i -= 1
            
            screenStart += screenWidthDivide
        }
    }
    

    func touchMoved(toPoint pos : CGPoint) {
        
        
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    func getToBeSorted() -> String {
        
        if currentIndex == 0 {
            currentIndex += 1
            return (array[1].name! as NSString) as String
        } else {
            return (array[currentIndex].name! as NSString) as String
        }
        
    }
    
    func getCorrectPlacement() -> String {
        
        var indexOfInterest = currentIndex
        var temp:SKSpriteNode = SKSpriteNode()
        // find out where the next element should go
        var IOItemp = indexOfInterest
        var CItemp = currentIndex
        
        
        while(indexOfInterest > 0 && Int((array[indexOfInterest].name! as NSString) as String)! < Int((array[indexOfInterest - 1].name! as NSString) as String)!) {
            temp = array[indexOfInterest]
            array[indexOfInterest] = array[indexOfInterest - 1]
            array[indexOfInterest - 1] = temp
            indexOfInterest -= 1
        }
        
        
        return String(indexOfInterest)
    }
    
    func updateDisplay() {
        
        //self.removeChildren(in: SKScene)
        
        let screenWidthDivide = screenWidth/4
        let screenHeightDivide = screenHeight/2
        var screenStart = (0 - screenWidth) + screenWidthDivide

        self.removeAllChildren()

        for node in array{
            // var random:Int = Int(arc4random_uniform(10) + 1)
            let newNode = SKSpriteNode(imageNamed: node.name!)
            newNode.name = node.name

            node.position = CGPoint(x: screenStart , y: 0)
            node.setScale(0.25)
        
            self.addChild(node)
            screenStart += screenWidthDivide

        }
    }
    
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
        if flag == 1 {
            for t in touches {
                self.touchDown(atPoint: t.location(in: self))
            }
            flag = 2
        } else {
            
            // is the user is looking for the correct element to sort
            if(searching) {
            
                let toBeSorted = getToBeSorted()
            
                if let touch = touches.first {
                    let location = touch.location(in: self)
                    for object in array {
                        
                        // if a user touched a button
                        if object.contains(location){
                        
                            // if the button is the node to be sorted
                            if String(object.name!) == toBeSorted {
                                print("You Clicked the right one!")
                                searching = false;
                                
                                if let wnd = self.view{
                                    
                                    var v = UIView(frame: wnd.bounds)
                                    v.backgroundColor = UIColor.green
                                    v.alpha = 0.5
                                    
                                    wnd.addSubview(v)
                                    UIView.animate(withDuration: 1, animations: {
                                        v.alpha = 0.0
                                        }, completion: {(finished:Bool) in
                                            print("inside")
                                            v.removeFromSuperview()
                                    })
                                }
                                
                                
                            } else {
                                if let wnd = self.view{
                                    
                                    var v = UIView(frame: wnd.bounds)
                                    v.backgroundColor = UIColor.red
                                    v.alpha = 0.5
                                    
                                    wnd.addSubview(v)
                                    UIView.animate(withDuration: 1, animations: {
                                        v.alpha = 0.0
                                        }, completion: {(finished:Bool) in
                                            print("inside")
                                            v.removeFromSuperview()
                                    })
                                }
                            }
                        }
                    }
                }
            }
            
            if(!searching) {
                        
                // user chose the correct node, now have them choose where to sort it
                var correctPlacement = getCorrectPlacement()
                
                if let touch2 = touches.first {
                let location2 = touch2.location(in: self)
                                
                    for object2 in array {
                                    
                        // if the user has touched a sprite
                        if object2.contains(location2) {
                            // if the sprite is the node to be swaped out
                            if(String(object2.name!) == ((array[Int(correctPlacement)!].name! as NSString) as String)) {
                                print("Yayyyy!!! You sorted it")
                                updateDisplay()
                                currentIndex += 1
                                searching = true

                                // FLASH FLASH
                                if let wnd = self.view{
                                    
                                    var v = UIView(frame: wnd.bounds)
                                    v.backgroundColor = UIColor.green
                                    v.alpha = 0.5
                                    
                                    wnd.addSubview(v)
                                    UIView.animate(withDuration: 1, animations: {
                                        v.alpha = 0.0
                                        }, completion: {(finished:Bool) in
                                            print("inside")
                                            v.removeFromSuperview()
                                    })
                                }
                                
                            } else {
                                
                                // FLASH FLASH
                                if let wnd = self.view{
                                    
                                    var v = UIView(frame: wnd.bounds)
                                    v.backgroundColor = UIColor.red
                                    v.alpha = 0.5
                                    
                                    wnd.addSubview(v)
                                    UIView.animate(withDuration: 1, animations: {
                                        v.alpha = 0.0
                                        }, completion: {(finished:Bool) in
                                            print("inside")
                                            v.removeFromSuperview()
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }

    }
    
 /*   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
   */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
