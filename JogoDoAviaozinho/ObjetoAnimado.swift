//
//  ObjetoAnimado.swift
//  JogoDoAviaozinho
//
//  Created by Edwy Lugo on 24/02/20.
//  Copyright © 2020 Edwy Lugo. All rights reserved.
//

import UIKit
import SpriteKit


class ObjetoAnimado: SKSpriteNode {

    var nome: String?
    var sinOffSet = CGFloat(Float.random(in: 0..<360.0))
    
    init(_ nome:String) {
        self.nome = nome
        let textura = SKTexture(imageNamed: "\(nome)1")
        super.init(texture: textura, color: .red, size: textura.size())
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        var imagens:[SKTexture] = []
        let atlas: SKTextureAtlas = SKTextureAtlas(named: nome!)
      
        for i in 1...atlas.textureNames.count {
            imagens.append(SKTexture(imageNamed: "\(self.nome!)\(i)"))
        }
        
        let animacao:SKAction = SKAction.animate(with: imagens, timePerFrame: 0.1, resize: true, restore: true)
        
        
        
        self.run(SKAction.repeatForever(animacao))
        
        
    }
    
    public func atualizaSenoide() {
        let py = CGFloat((sin(self.position.x*0.01)*100)+50+sinOffSet)
        self.position = CGPoint(x: self.position.x, y: py)
    }
    
}
