//
//  MinhaViewController.swift
//  JogoDoAviaozinho
//
//  Created by Edwy Lugo on 24/02/20.
//  Copyright © 2020 Edwy Lugo. All rights reserved.
//



import UIKit
import SpriteKit

class MinhaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.landscape)

        let minhaView: SKView = SKView(frame: self.view.frame)
        self.view = minhaView
        
        let minhaCena: MinhaCena = MinhaCena(size: minhaView.frame.size)
        minhaView.contentMode = .scaleAspectFill
        minhaView.presentScene(minhaCena)
        minhaView.ignoresSiblingOrder = false
        minhaView.showsFPS = true
        minhaView.showsNodeCount = true
        minhaView.showsPhysics = false
    }
    
}


struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation, forKey: "orientation")
    }
}
