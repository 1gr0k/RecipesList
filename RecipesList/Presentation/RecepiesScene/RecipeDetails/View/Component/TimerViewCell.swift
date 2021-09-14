//
//  TimerViewCell.swift
//  TimerViewCell
//
//  Created by Андрей Калямин on 14.09.2021.
//

import Foundation
import UIKit

@IBDesignable
class TimerViewCell: UIView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    var proxyView: TimerViewCell?
    var titleLabelText: String?
    
    @IBInspectable var TitleForLabel: String {
        get { proxyView?.titleLabelText ?? ""}
        set {titleLabelText = newValue}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = self.loadNib()
        view.frame = self.bounds
        self.proxyView = view
        addSubview(proxyView!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        guard let proxyView = proxyView else { return }

        proxyView.frame = self.bounds
        proxyView.layer.cornerRadius = 15
        proxyView.backgroundColor = .white
        proxyView.layer.shadowColor = UIColor.black.cgColor
        proxyView.layer.shadowRadius = 5
        proxyView.layer.shadowOpacity = 0.2
        proxyView.layer.shadowOffset = CGSize(width: 4, height: 4)
        proxyView.titleLabel.text = proxyView.titleLabelText
    }
    
    private func loadNib() -> TimerViewCell {
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: nil, options: nil)?.first as! TimerViewCell
        return view
    }
}
