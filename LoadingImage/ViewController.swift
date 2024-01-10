//
//  ViewController.swift
//  LoadingImage
//
//  Created by kimleak on 1/9/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var customAnimationView: UIView!
    
    ///Animation of the indicator. Set by animationType. Do not set manually.
    private var animation : ANActivityIndicatorAnimation = ANActivityIndicatorAnimationBallSpinFadeLoader()

    /// Animation type.
    public var animationType: ANActivityIndicatorAnimationType = .ballSpinFadeLoader {
      didSet{
        animation = animationType.toAnimation()
      }
    }
    
    var isStart = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func startAnimation(_ sender: Any) {
        
        if !isStart {
            self.isStart = true
            startSpinning()
        }
    }
    @IBAction func stopAnimation(_ sender: Any) {
        stopSpinning()
    }
    func startSpinning()  {
        rotateView()
        self.startCustomAnimation()
    }
    
    func stopSpinning()  {
        if isStart {
            self.isStart = false
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.loadingImage.layer.removeAllAnimations()
            }, completion: { _ in
                
            })
        }
    }
    
    // duration will helps to control rotation speed
    private func rotateView(duration: Double = 1.0) {
       
        if isStart {
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {
                self.loadingImage.transform = self.loadingImage.transform.rotated(by: .pi)
            }) { finished in
                
                self.rotateView(duration: duration)
            }
            
        }
    }
    
    private final func startCustomAnimation() {
        var animationRect = self.customAnimationView.frame.insetBy(dx: 0, dy: 0)
        let minEdge = min(animationRect.width, animationRect.height)
        self.animation = animationType.toAnimation()
        self.customAnimationView.layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: self.customAnimationView.layer, size: animationRect.size, color: .black)
    }
}

