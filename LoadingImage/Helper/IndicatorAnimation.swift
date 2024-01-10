//
//  IndicatorAnimation.swift
//  LoadingImage
//
//  Created by kimleak on 1/9/24.
//

import Foundation
import UIKit

///Protocol for animations. Can bu used with classes only.
public protocol ANActivityIndicatorAnimation : AnyObject {
    func setUpAnimation(in layer:CALayer, size: CGSize, color: UIColor)
    init()
}
///Animation type enum with feature for adding custom types.
///To add custom types, take a look at docs.
public struct ANActivityIndicatorAnimationType{
    
    private var animation : ANActivityIndicatorAnimation.Type
    public static let ballSpinFadeLoader = ANActivityIndicatorAnimationType(animation: ANActivityIndicatorAnimationBallSpinFadeLoader.self)
    
    public init(animation : ANActivityIndicatorAnimation.Type){
        self.animation = animation
    }
    
    internal func toAnimation() -> ANActivityIndicatorAnimation{
        return animation.init()
    }
}

class ANActivityIndicatorAnimationBallSpinFadeLoader: ANActivityIndicatorAnimation {
    required init() {
        
    }
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for i in 0 ..< 8 {
            let circle = circleAt(angle: CGFloat(Double.pi/4 * Double(i)),
                                  size: circleSize,
                                  origin: CGPoint(x: x, y: y),
                                  containerSize: size,
                                  color: color)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: nil)
            layer.addSublayer(circle)
        }
    }
    
    func circleAt(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle = ANActivityIndicatorShape.circle.layerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size)
        
        circle.frame = frame
        
        return circle
    }
}

///Shapes used in ANActivityIndicatorView.
public enum ANActivityIndicatorShape {
    case circle
    case image
    
    ///Creates layer from shape enum
    /// - parameter size : Size of the shape
    /// - parameter color : Color of the shape
    public func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        switch self {
        case .circle:
            //TODO: -//Draw circle for loading
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false);
            layer.fillColor = color.cgColor
            layer.backgroundColor = nil
            layer.path = path.cgPath
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
        case .image :
            //TODO: -//Use image for loading
            layer.fillColor = color.cgColor
            let myImage = UIImage(named: "roundImg")?.cgImage
            layer.contents = myImage
            layer.backgroundColor = nil
            layer.path = path.cgPath
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        return layer
    }
}
