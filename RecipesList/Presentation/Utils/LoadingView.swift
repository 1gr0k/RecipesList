//
//  LoadingView.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import UIKit

public class LoadingView {
    internal static var spinner: UIActivityIndicatorView?
    internal static var blurView: UIVisualEffectView?
    
    public static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            if spinner == nil, let window = UIApplication.shared.keyWindow {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = .large
                let blur = UIBlurEffect(style: .light)
                let blurView = UIVisualEffectView(effect: blur)
                blurView.frame = frame
                blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurView.contentView.addSubview(spinner)
                window.addSubview(blurView)
                
                spinner.startAnimating()
                self.spinner = spinner
                self.blurView = blurView
            }
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            guard let _ = spinner else { return }
            spinner?.stopAnimating()
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
                blurView?.effect = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                blurView?.removeFromSuperview()
                self.spinner = nil
                self.blurView = nil
            }
            
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}
