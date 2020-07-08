import AVFoundation

open class SKAudio {
    open var backgroundMusicPlayer: AVAudioPlayer?
    open var soundEffectPlayer: AVAudioPlayer?
    open class func sharedInstance() -> SKAudio {
        return SKAudioInstance
    }
    open func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(forResource: filename,
                                  withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        var error: NSError? = nil
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf:
                url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if let player = backgroundMusicPlayer {
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
    open func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    open func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    open func playSoundEffect(_ filename: String) {
        let url = Bundle.main.url(forResource: filename,
                                  withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        var error: NSError? = nil
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch let error1 as NSError {
            error = error1
            soundEffectPlayer = nil
        }
        if let player = soundEffectPlayer {
            player.numberOfLoops = 0
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
}
private let SKAudioInstance = SKAudio()
