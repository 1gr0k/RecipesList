//
//  ApiErrorView.swift
//  ApiErrorView
//
//  Created by Андрей Калямин on 14.09.2021.
//

import Foundation
import UIKit

class ApiErrorViewController:UIViewController, UITextViewDelegate {
    
    private var viewModel: ApiErrorViewModel?
    weak var delegate: ApiErrorDelegate?
    
    private let screenRatio = 0.3
    private lazy var maxTextFieldHeight:CGFloat = {
        round(UIScreen.main.bounds.height * self.screenRatio)
    }()
    
    private var isOkButtonActive = false
    private var isPlaceholderActive = true
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = delegate?.error.value
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var currentUserApiKeyValueLabel: UILabel = {
        let label = UILabel()
        let currentUserApiKey = UserDefaults.standard.value(forKey: "api") as? String
        label.text = "текущий пользовательский Api Key: \(currentUserApiKey ?? "")"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var okButton: UIView = {
        let button = UIView()
        button.layer.cornerRadius = 21
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGray5
        return button
    }()
    
    private lazy var okButtonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let startColor = UIColor(displayP3Red: 238 / 255, green: 164 / 255, blue: 206 / 255, alpha: 1)
        let endColor = UIColor(displayP3Red: 197 / 255, green: 139 / 255, blue: 242 / 255, alpha: 1)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        return gradient
    }()
    
    private lazy var okButtonLabel: UILabel = {
        let label  = UILabel()
        label.text = "OK"
        label.textColor = .white
        return label
    }()
    
    private lazy var apiTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0.9686274528503418, green: 0.9725490212440491, blue: 0.9725490212440491, alpha: 1.0)
        view.layer.cornerRadius = 14
        return view
    }()
    
    private lazy var apiTextfieldImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.up.arrow.down")
        image.tintColor = UIColor(displayP3Red: 0.482352941176471, green: 0.435294117647059, blue: 0.447058823529412, alpha: 1)
        return image
    }()
    
    private lazy var apiTextfield: UITextView = {
        let textField = UITextView()
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "Введите новый API ключ spoonacular.com"
        textField.textColor = .lightGray
        textField.isScrollEnabled = false
        return textField
    }()
    
    override func viewDidLoad() {
        setupViews()
    }
    
    static func create(with viewModel: ApiErrorViewModel, delegate: ApiErrorDelegate) -> ApiErrorViewController {
        let view = ApiErrorViewController()
        view.viewModel = viewModel
        view.delegate = delegate
        return view
    }
    
    private func setupViews() {
        okButton.addSubview(okButtonLabel)
        mainView.addSubview(okButton)
        mainView.addSubview(titleLabel)
        mainView.addSubview(currentUserApiKeyValueLabel)
        mainView.addSubview(apiTextfieldView)
        apiTextfieldView.addSubview(apiTextfieldImage)
        apiTextfieldView.addSubview(apiTextfield)
        blurView.contentView.addSubview(mainView)
        self.view.addSubview(blurView)
        setupConstraints()
    }
    
    private func addGestureForOkButton() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(okButtonPressed(_:)))
        gesture.minimumPressDuration = 0
        okButton.addGestureRecognizer(gesture)
        okButton.layer.insertSublayer(okButtonGradient, at: 0)
    }
    
    @objc private func okButtonPressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            okButton.layer.sublayers![0].removeFromSuperlayer()
            okButton.backgroundColor = .systemGray5
            apiTextfield.endEditing(false)
        case .ended:
            viewModel?.setApi(api: apiTextfield.text)
            self.dismiss(animated: true)
            self.delegate?.update()
        case .failed, .cancelled:
            okButton.layer.insertSublayer(okButtonGradient, at: 0)
        @unknown default:
            return
        }
    }
    
    private func setupConstraints() {
        setupMainViewConstrants()
        setupOkButtonConstraints()
        setupTitleLabelConstraints()
        setupApiKeyValueLabel()
        setupTextfieldViewConstraints()
        setupApiTextfieldImageConstraints()
        setupApiTextFieldConstraints()
    }
    
    private func setupMainViewConstrants() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            mainView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32),
            mainView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 1.0, constant: -500)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -100)
        ])
    }
    
    private func setupApiKeyValueLabel() {
        currentUserApiKeyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentUserApiKeyValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            currentUserApiKeyValueLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 32),
            currentUserApiKeyValueLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -150)
        ])
    }
    
    private func setupOkButtonConstraints() {
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -32),
            okButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -32),
            okButton.widthAnchor.constraint(equalToConstant: 75),
            okButton.heightAnchor.constraint(equalToConstant: 75),
            okButtonLabel.centerXAnchor.constraint(equalTo: okButton.centerXAnchor),
            okButtonLabel.centerYAnchor.constraint(equalTo: okButton.centerYAnchor)
        ])
    }
    
    private func setupTextfieldViewConstraints() {
        apiTextfieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiTextfieldView.topAnchor.constraint(equalTo: currentUserApiKeyValueLabel.bottomAnchor, constant: 16),
            apiTextfieldView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -32),
            apiTextfieldView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 32),
            apiTextfieldView.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -16)
        ])
    }
    
    private func setupApiTextfieldImageConstraints() {
        apiTextfieldImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiTextfieldImage.topAnchor.constraint(equalTo: apiTextfieldView.topAnchor, constant: 16),
            apiTextfieldImage.leadingAnchor.constraint(equalTo: apiTextfieldView.leadingAnchor, constant: 16),
            apiTextfieldImage.widthAnchor.constraint(equalToConstant: 25),
            apiTextfieldImage.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func makeOkButtonActive() {
        addGestureForOkButton()
        isOkButtonActive.toggle()
    }
    
    func makeOkButtonInactive() {
        isOkButtonActive.toggle()
        okButton.layer.sublayers![0].removeFromSuperlayer()
        okButton.backgroundColor = .systemGray5
        okButton.gestureRecognizers?.removeAll()
        
    }
    
    private func setupApiTextFieldConstraints() {
        apiTextfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiTextfield.topAnchor.constraint(equalTo: apiTextfieldView.topAnchor, constant: 16),
            apiTextfield.bottomAnchor.constraint(equalTo: apiTextfieldView.bottomAnchor, constant: -16),
            apiTextfield.leadingAnchor.constraint(equalTo: apiTextfieldImage.trailingAnchor, constant: 16),
            apiTextfield.trailingAnchor.constraint(equalTo: apiTextfieldView.trailingAnchor, constant: -32),
            apiTextfield.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            apiTextfield.heightAnchor.constraint(lessThanOrEqualToConstant: maxTextFieldHeight)
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive {
            isPlaceholderActive.toggle()
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 10, !isOkButtonActive {
            makeOkButtonActive()
        } else if textView.text.count < 10, isOkButtonActive {
            makeOkButtonInactive()
        }
        
        if textView.contentSize.height == CGFloat(maxTextFieldHeight) {
            textView.isScrollEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            textView.text = ""
        }
    }
}
