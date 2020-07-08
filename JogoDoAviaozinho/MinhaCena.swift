//
//  MinhaCena.swift
//  JogoDoAviaozinho
//
//  Created by Edwy Lugo on 24/02/20.
//  Copyright © 2020 Edwy Lugo. All rights reserved.
//

import SpriteKit

var pontos:Int = 0
var comecou:Bool = false
var acabou:Bool = false
var podeReiniciar = false
var idFelpudo:UInt32 = 1
var idInimigo:UInt32 = 2
var idItem:UInt32 = 3
var somPick = SKAction.playSoundFileNamed("PLIN.mp3",
                                          waitForCompletion: false)
var somHit = SKAction.playSoundFileNamed("QUEBRA.mp3",
                                         waitForCompletion: false)
class MinhaCena: SKScene, SKPhysicsContactDelegate {
    
    var felpudo:ObjetoAnimado = ObjetoAnimado("aviao")
    var listaInimigos:[ObjetoAnimado] = []
    let textoPontos = SKLabelNode(fontNamed: "True Crimes")
    let textoGame = SKLabelNode(fontNamed: "True Crimes")
    var intervaloItens:TimeInterval = 1.0
    let objetoDummy = SKNode()
    
    override func didMove(to view: SKView) {
        
        SKAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.5
        SKAudio.sharedInstance().playBackgroundMusic("MUSICA.mp3")
        
        self.backgroundColor = .black
        var imagemFundo:SKSpriteNode = SKSpriteNode()
        
        let moveFundo = SKAction.moveBy(x: -self.size.width,y: 0, duration: 5)
        let reposicionaFundo = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let repete = SKAction.repeatForever(SKAction.sequence([moveFundo,
                                                               reposicionaFundo]))
        
        for i in 0..<2 {
            imagemFundo = SKSpriteNode(imageNamed: "imagem_fundo")
            imagemFundo.anchorPoint = CGPoint(x: 0, y: 0)
            
            imagemFundo.size.width = self.size.width
            imagemFundo.position = CGPoint(x: self.size.width * CGFloat(i), y: 0)
            imagemFundo.run(repete)
            
            imagemFundo.size.height = self.size.height
            
            imagemFundo.zPosition = -1
            objetoDummy.addChild(imagemFundo)
        }
        objetoDummy.speed = 1
        self.addChild(objetoDummy)
        
        self.physicsWorld.contactDelegate = self
        
        // let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // borderBody.friction = 0
        // self.physicsBody = borderBody
        
        textoGame.text = "Toque para Iniciar"
        textoPontos.text = "Score: \(pontos)"
        
        textoPontos.horizontalAlignmentMode = .right
        textoPontos.verticalAlignmentMode = .top
        
        textoPontos.color = .white
        textoGame.color = .yellow
        
        textoPontos.position = CGPoint(x:frame.maxX-10 ,y:frame.maxY-10)
        textoGame.position = CGPoint(x:frame.midX,y:frame.midY)
        
        felpudo = ObjetoAnimado("aviao")
        felpudo.position = CGPoint(x:frame.maxX*0.2,y:frame.midY)
        felpudo.setScale(0.75)
        
        self.addChild(felpudo)
        self.addChild(textoPontos)
        self.addChild(textoGame)
        
        let acaoSorteiaItem = SKAction.run {
            if(!acabou && comecou){
                let sorteio = Int.random(in:0..<20)
                self.intervaloItens =
                    TimeInterval(Float.random(in:0..<3.0))
                if (sorteio<5){
                    self.adicionaInimigoA()
                }else if (sorteio>4 && sorteio < 9){
                    self.adicionaInimigoB()
                }else if(sorteio == 9){
                    self.criaPeninhaDourada()
                }
                self.criaPeninhaDourada()
            }
        }
        
        
        self.run(SKAction.repeatForever(SKAction.sequence([acaoSorteiaItem,SKAction.wait(forDuration: intervaloItens)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with
        event: UIEvent?) {
        
        if(!comecou){
            felpudo.physicsBody =
                SKPhysicsBody(circleOfRadius: felpudo.size.height/2.5, center:
                    CGPoint(x: 10, y: 0))
            felpudo.physicsBody?.isDynamic = true
            felpudo.physicsBody?.allowsRotation = false
            
            felpudo.physicsBody?.categoryBitMask = idFelpudo
            felpudo.physicsBody?.collisionBitMask = 0
            felpudo.physicsBody?.contactTestBitMask = idInimigo | idItem
            
            comecou = true
            pontos = 0
            textoPontos.text = "Score: \(pontos)"
            
            SKAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.5
            textoGame.isHidden = true
            
            self.felpudo.physicsBody?.applyImpulse(CGVector(dx: 0, dy:
                75))
            
        } else if(comecou && !acabou){
            
            self.felpudo.physicsBody?.velocity = CGVector.zero
            
            self.felpudo.physicsBody?.applyImpulse(CGVector(dx: 0, dy:
                75))
            
            // criaParticulasPenas(CGPoint(x: self.felpudo.frame.midX, y: self.felpudo.frame.midY))
            criaExplosao(CGPoint(x: self.felpudo.frame.midX,
            y: self.felpudo.frame.midY))
            for touch in (touches) {
                _ = touch.location(in: self)
                // print("PosX: \(location.x) PosY: \(location.y)")
                //
            }
        }
        
        if(podeReiniciar){
            self.felpudo.position =
                CGPoint(x:frame.maxX*0.2,y:frame.midY)
            self.felpudo.physicsBody?.velocity = CGVector.zero
            self.felpudo.physicsBody?.isDynamic = false
            self.felpudo.zRotation = 0
            comecou = false
            acabou = false
            podeReiniciar = false
            textoGame.isHidden = true
            objetoDummy.speed = 1
        }
    }
    
    func criaExplosao(_ pos:CGPoint)
    {
        let explosao = ObjetoAnimado("explosao")
        explosao.position = CGPoint(x: pos.x, y: pos.y);
        explosao.run(SKAction.move(by: CGVector(dx: -10, dy:
            5), duration: 1.0))
        explosao.run(SKAction.fadeOut(withDuration: 1.0))
        self.addChild(explosao)
    }
    
    func criaParticulasPenas(_ pos:CGPoint)
    {
        let peninha:SKTexture = SKTexture(imageNamed:
            "estrela")
        let minhaParticula:SKEmitterNode = SKEmitterNode()
        minhaParticula.particleTexture = peninha
        minhaParticula.position = pos
        minhaParticula.particleSize = CGSize(width: 8, height:
            8)
        minhaParticula.particleBirthRate = 25
        minhaParticula.numParticlesToEmit = 10;
        minhaParticula.particleLifetime = 0.5
        minhaParticula.particleTexture?.filteringMode
            = .nearest
        minhaParticula.xAcceleration = 0
        minhaParticula.yAcceleration = 0
        minhaParticula.particleSpeed = 200
        minhaParticula.particleSpeedRange = 100
        minhaParticula.particleRotationSpeed = -3
        minhaParticula.particleRotationRange = 3
        minhaParticula.emissionAngle = CGFloat(Double.pi*2)
        minhaParticula.emissionAngleRange =
            CGFloat(Double.pi*2)
        minhaParticula.particleColorAlphaSpeed = 0.1
        minhaParticula.particleColorAlphaRange = 1
        minhaParticula.particleAlphaSequence =
            SKKeyframeSequence(keyframeValues: [1,0], times: [0,1])
        minhaParticula.particleScaleSequence =
            SKKeyframeSequence(keyframeValues: [3,0.5], times: [0,1])
        self.addChild(minhaParticula)
        minhaParticula.run(SKAction.move(by: CGVector(dx: -10,
                                                      dy: 5), duration: 1.0))
        
        minhaParticula.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
    }
    
    override func didSimulatePhysics() {
        if(comecou){
            self.felpudo.zRotation =
                (self.felpudo.physicsBody?.velocity.dy)!*0.0005
        }
    }
    
    func adicionaInimigoA(){
        let px =
            self.frame.size.width+CGFloat(Float.random(in:0..<200.0))
        let py = self.frame.size.height/2+CGFloat(Float.random(in:0..<300.0))-150
        let tempo = TimeInterval(Float.random(in:12..<17.0))
        
        let bugado = ObjetoAnimado("bugado")
        bugado.position = CGPoint(x:px, y:py)
        bugado.setScale(0.7)
        bugado.name = "ENEMY"
        bugado.physicsBody?.categoryBitMask = idInimigo
        self.addChild(bugado)
        listaInimigos.append(bugado)
        
        bugado.physicsBody = SKPhysicsBody(rectangleOf:
            CGSize(width: bugado.size.width-30, height: 50), center:
            CGPoint(x:-10,y:-bugado.size.height/2+25))
        bugado.physicsBody?.isDynamic = false
        bugado.physicsBody?.allowsRotation = false
        bugado.run(SKAction.sequence([SKAction.moveTo(x: -self.frame.size.width-200, duration: tempo),
                                      SKAction.removeFromParent(),SKAction.run {
                                        self.listaInimigos.remove(at: 0)
            }]))
    }
    
    func adicionaInimigoB(){
        let px =
            self.frame.size.width+CGFloat(Float.random(in:0..<200.0))
        let py = CGFloat(Float.random(in:0..<30.0)+10)
        let tempo = TimeInterval(Float.random(in:12..<17.0))
        
        let lesmo = ObjetoAnimado("lesmo")
        lesmo.position = CGPoint(x:px, y:py)
        lesmo.setScale(0.7)
        lesmo.name = "ENEMY"
        lesmo.physicsBody?.categoryBitMask = idInimigo
        lesmo.physicsBody = SKPhysicsBody(rectangleOf:
            CGSize(width: lesmo.size.width-10, height: 30), center:
            CGPoint(x:0,y:-lesmo.size.height/2+25))
        lesmo.physicsBody?.isDynamic = false
        lesmo.physicsBody?.allowsRotation = false
        lesmo.isProxy()
        lesmo.run(SKAction.sequence([SKAction.moveTo(x:-self.frame.size.width-200, duration: tempo), SKAction.removeFromParent()]))
        
        self.addChild(lesmo)
    }
    
    func criaPeninhaDourada(){
        let px =
            self.frame.size.width+CGFloat(Float.random(in:0..<200.0))
        let py = CGFloat(Float.random(in:0..<250.0)+50)
        // let tempo = TimeInterval(Float.random(in: 12..<17.0))
        let tempo = TimeInterval(5.0)
        
        let peninha = ObjetoAnimado("pena_dourada")
        peninha.name = "GOLD"
        peninha.position = CGPoint(x:px, y:py)
        peninha.setScale(0.7)
        
        peninha.physicsBody?.categoryBitMask = idItem
        
        peninha.physicsBody = SKPhysicsBody(rectangleOf:
            CGSize(width: peninha.size.width-10, height: 30), center:
            CGPoint(x:0,y:-peninha.size.height/2+25))
        peninha.physicsBody?.isDynamic = false
        peninha.physicsBody?.isProxy()
        peninha.physicsBody?.allowsRotation = false
        peninha.run(SKAction.sequence([SKAction.moveTo(x: -self.frame.size.width-200, duration: tempo),
                                       SKAction.removeFromParent()]))
        
        self.addChild(peninha)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for e in listaInimigos {
            e.atualizaSenoide()
        }
        
        if( (felpudo.position.y < (felpudo.size.height/2+10))
            && !acabou){
            fimDeJogo()
        }
        
        if( (felpudo.position.y > (self.size.height+10)) && !acabou){
            fimDeJogo()
        }
    }
    
    
    func fimDeJogo(){
        self.run(somHit)
        felpudo.physicsBody?.applyImpulse(CGVector(dx: -80,
                                                   dy: 50))
        acabou = true
        SKAudio.sharedInstance().backgroundMusicPlayer?.volume
            = 0.1
        textoGame.fontColor = .yellow
        textoGame.text = "Game Over"
        textoGame.fontSize = 55
        textoGame.isHidden = false
        textoGame.zPosition = 1
        
        objetoDummy.speed = 0
        
        self.run(SKAction.sequence([SKAction.wait(forDuration:
            1), SKAction.run({
                
                self.textoGame.text = "Toque para Reiniciar"
                podeReiniciar = true;
                
                let children = self.children
                for child in children {
                    if(child.name != nil){
                        if((child.name! == "GOLD") || (child.name!
                            == "ENEMY")){
                            child.removeFromParent()
                        }
                    }
                    
                }
                
                
            })]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if(contact.bodyA.node?.name == "GOLD"){
            
            let px = CGFloat(contact.bodyA.node?.position.x ??
                0)
            let py = CGFloat(contact.bodyA.node?.position.y ??
                0)
            contact.bodyA.node?.removeFromParent()
            criaParticulasPenas(CGPoint(x: px, y:py))
            
            self.run(somPick)
            pontos += 1
            textoPontos.text = "Score: \(pontos)"
        }
        if(contact.bodyA.node?.name == "ENEMY"){
            let px = CGFloat(contact.bodyA.node?.position.x ??
                0)
            let py = CGFloat(contact.bodyA.node?.position.y ??
                0)
            self.criaExplosao(CGPoint(x: px, y:py))
            contact.bodyA.node?.removeFromParent()
            
            fimDeJogo()
        }
    }
}

