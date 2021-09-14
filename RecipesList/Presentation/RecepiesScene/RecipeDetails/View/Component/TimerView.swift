//
//  TimerView.swift
//  TimerView
//
//  Created by Андрей Калямин on 08.09.2021.
//

import UIKit
import SwiftUI

@IBDesignable
class TimerView: UIView {
    
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var minutesLabel: UILabel!
    
    private var proxyView: TimerView?
    private let insideGradientLayer = CAGradientLayer()
    private var strokeGradientLayer = CAGradientLayer()
    private let strokeLineLayer = CAShapeLayer()
    private var readyInPercents: Double?
    
    private var lineWidth = 25.0
    private var firstColorForInsideGradient = UIColor(displayP3Red: 0.572549045085907, green: 0.6392157077789307, blue: 0.9921568632125854, alpha: 1)
    private var secondColorForInsideGradient = UIColor(displayP3Red: 0.615686297416687, green: 0.8078431487083435, blue: 1, alpha: 1)
    
    @IBInspectable var FirstColorForGradient: UIColor {
        get {
            firstColorForInsideGradient
        }
        set {
            firstColorForInsideGradient = newValue}
    }
    
    @IBInspectable var SecondColorForGradient: UIColor {
        get {
            secondColorForInsideGradient
        }
        set {
            secondColorForInsideGradient = newValue}
    }
    
    @IBInspectable var LineWidth: Int {
        get {
            Int(lineWidth)
        }
        set {
            lineWidth = Double(newValue)
        }
    }
    
    private var circleMask: CAShapeLayer = {
        let mask = CAShapeLayer()
        mask.backgroundColor = UIColor.white.cgColor
        mask.fillColor = UIColor.white.cgColor
        mask.strokeColor = UIColor.black.withAlphaComponent(1.0).cgColor
        return mask
    }()
    
    private let radius = CGFloat(62)
    private lazy var frameSide = {
        return radius * 2 + 10
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = self.loadNib()
        view.frame = self.bounds
        self.proxyView = view
        self.addSubview(self.proxyView!)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(self.outsideView.bounds)
    }
    
    override func layoutSubviews() {
        guard readyInPercents != nil, let _ = self.proxyView else { return }
        insideGradientLayer.frame = self.bounds
    }
    
    private func setupViews() {
        self.proxyView?.backgroundColor = .clear
        self.proxyView?.insideView.layer.masksToBounds = true
        self.proxyView?.insideView.layer.insertSublayer(insideGradientLayer, at: 0)
        insideGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        insideGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        insideGradientLayer.backgroundColor = UIColor.clear.cgColor
        insideGradientLayer.colors = [UIColor(displayP3Red: 0.615686297416687, green: 0.8078431487083435, blue: 1, alpha: 1).cgColor, UIColor(displayP3Red: 0.572549045085907, green: 0.6392157077789307, blue: 0.9921568632125854, alpha: 1).cgColor]
        let cornerRadius = self.proxyView!.insideView.frame.height / 2.0 - (proxyView!.lineWidth) - 12
        self.proxyView?.insideView.layer.cornerRadius = CGFloat(cornerRadius)
        self.proxyView?.minutesLabel.textColor = .white
        self.proxyView?.minutesLabel.bringSubviewToFront(self.proxyView!.insideView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.proxyView?.outsideView.translatesAutoresizingMaskIntoConstraints = false
        self.proxyView?.insideView.translatesAutoresizingMaskIntoConstraints = false
        self.proxyView?.minutesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.proxyView!.outsideView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.proxyView!.outsideView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.proxyView!.outsideView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.proxyView!.outsideView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.proxyView!.insideView.topAnchor.constraint(equalTo: (self.proxyView?.outsideView.topAnchor)!, constant: 8 + proxyView!.lineWidth),
            self.proxyView!.insideView.bottomAnchor.constraint(equalTo: (self.proxyView?.outsideView.bottomAnchor)!, constant: -8 - proxyView!.lineWidth),
            self.proxyView!.insideView.leadingAnchor.constraint(equalTo: (self.proxyView?.outsideView.leadingAnchor)!, constant: 8 + proxyView!.lineWidth),
            self.proxyView!.insideView.trailingAnchor.constraint(equalTo: (self.proxyView?.outsideView.trailingAnchor)!, constant: -8 - proxyView!.lineWidth),
            self.proxyView!.minutesLabel.centerXAnchor.constraint(equalTo: self.proxyView!.insideView.centerXAnchor),
            self.proxyView!.minutesLabel.centerYAnchor.constraint(equalTo: self.proxyView!.insideView.centerYAnchor)
        ])
    }
    
    private func loadNib() -> TimerView {
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: nil, options: nil)?.first as! TimerView
        return view
    }
    
    public func setupMinutes(in minutes: Int) {
        self.proxyView?.minutesLabel.text = "\(minutes) мин"
        self.readyInPercents = 1 - Double(120 - minutes) / 120
        setupTimerCircle()
        startCircleAnimation()
    }
    
    private func setupTimerCircle() {
        self.proxyView!.outsideView.backgroundColor = UIColor.clear
        
        let center = CGPoint(x: radius + 5, y: radius + 5)
        
        
        let gradienOuterCircleMask = CAShapeLayer()
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.25 * 2 * .pi, endAngle: 0.75 * 2 * .pi, clockwise: true)
        gradienOuterCircleMask.path = path.cgPath
        
        strokeGradientLayer.frame = CGRect(x: 0, y: 0, width: frameSide, height: frameSide)
        strokeGradientLayer.colors = [proxyView!.secondColorForInsideGradient.cgColor, proxyView!.firstColorForInsideGradient.cgColor]
        strokeGradientLayer.type = .conic
        strokeGradientLayer.startPoint = CGPoint(x: 0.5 , y: 0.5)
        strokeGradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        strokeGradientLayer.mask = gradienOuterCircleMask
        
        let pathForMask = UIBezierPath(arcCenter: center, radius: radius - proxyView!.lineWidth, startAngle: -0.25 * 2 * .pi, endAngle: 0.75 * 2 * .pi, clockwise: true).reversing()
        circleMask.path = pathForMask.cgPath
        circleMask.lineWidth = lineWidth * 2.0
        strokeLineLayer.frame = CGRect(x: 0, y: 0, width: frameSide, height: frameSide)
        strokeLineLayer.backgroundColor = UIColor.white.cgColor
        strokeLineLayer.mask = circleMask
        self.proxyView?.outsideView.layer.insertSublayer(strokeGradientLayer, at: 0)
        self.proxyView?.outsideView.layer.insertSublayer(strokeLineLayer, at: 1)
    }
    
    private func startCircleAnimation() {
        
        guard let readyInPercents = readyInPercents else { return }
        
        let timeForAnimation = 1.0
        let strokePercent = 1 - readyInPercents

        self.strokeGradientLayer.transform = CATransform3DMakeRotation(.pi * 2 * readyInPercents, 0, 0, 1.0)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 * readyInPercents
        rotationAnimation.duration = timeForAnimation
        strokeGradientLayer.add(rotationAnimation, forKey: nil)
        
        circleMask.strokeEnd = strokePercent
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = strokePercent
        animation.duration = timeForAnimation
        circleMask.add(animation, forKey: nil)
    }
}
