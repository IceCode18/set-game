//
//  BouncingAnimation.swift
//  SetGame
//
//  Created by Kaiser19 on 6/16/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class BouncingAnimation: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.5
        behavior.resistance = -0.5
        return behavior
    }()
    
    private func toggleMove(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .continuous)
        push.angle = (CGFloat.pi*2).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        //push.action = { [unowned push, weak self] in
        //    self?.removeChildBehavior(push)
        //}
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        toggleMove(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
}


extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
