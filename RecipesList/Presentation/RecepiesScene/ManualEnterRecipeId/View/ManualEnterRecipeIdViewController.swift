//
//  ManualEnterRecipeIdViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.09.2021.
//

import Foundation
import InjectPropertyWrapper
import InputMask

class ManualEnterRecipeIdViewController: UIViewController {
    
    @Inject private var viewModel: ManualEnterRecipeIdViewModel
    weak var delegate: QRScanerDelegate?
    
    private var isPlaceholderActive = true
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = .systemGray
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var maskTextField: MaskedTextViewDelegate = {
        let mask = MaskedTextViewDelegate()
        mask.delegate = self
        mask.affinityCalculationStrategy = .prefix
        mask.affineFormats = [
            "[09999999]"]
        return mask
    }()
    
    private lazy var mainInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    private lazy var idTextView: UITextView = {
        let textField = UITextView()
        textField.delegate = maskTextField
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "Введите id"
        textField.textColor = .lightGray
        textField.isScrollEnabled = false
        textField.layer.cornerRadius = 10
        return textField
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
    
    static func create(delegate: QRScanerDelegate) ->ManualEnterRecipeIdViewController {
        let view = ManualEnterRecipeIdViewController()
        view.delegate = delegate
        return view
    }
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(mainView)
        setupMainViewConstrants()
        
        mainView.addSubview(mainInputView)
        setupMainInputViewConstraints()
        
        mainInputView.addSubview(idTextView)
        setupidTextfieldConstraints()
        
        mainInputView.addSubview(okButton)
        okButton.addSubview(okButtonLabel)
        setupOkButtonConstraints()
        addGestureOkButtonForCancel()
    }
    
    private func addGestureOkButtonForCancel() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(okButtonPressedCancel(_:)))
        gesture.minimumPressDuration = 0
        okButton.addGestureRecognizer(gesture)
        okButton.layer.insertSublayer(okButtonGradient, at: 0)
    }
    
    @objc func okButtonPressedCancel(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            okButton.layer.sublayers![0].removeFromSuperlayer()
            okButton.backgroundColor = .systemGray5
        case .ended:
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            navigationController?.popToRootViewController(animated: true)
            self.delegate?.showDetailRecipe(id: idTextView.text)
        case .failed, .cancelled:
            okButton.layer.insertSublayer(okButtonGradient, at: 0)
        @unknown default:
            return
        }
    }
    
    func setupMainViewConstrants() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupMainInputViewConstraints() {
        mainInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInputView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            mainInputView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            mainInputView.widthAnchor.constraint(equalToConstant: mainView.frame.width - 32),
            mainInputView.heightAnchor.constraint(equalToConstant: mainView.frame.height - 600)
        ])
    }
    
    func setupidTextfieldConstraints() {
        idTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idTextView.centerXAnchor.constraint(equalTo: mainInputView.centerXAnchor),
            idTextView.topAnchor.constraint(equalTo: mainInputView.topAnchor, constant: 32),
            idTextView.heightAnchor.constraint(equalToConstant: 50),
            idTextView.leadingAnchor.constraint(equalTo: mainInputView.leadingAnchor, constant: 16),
            idTextView.trailingAnchor.constraint(equalTo: mainInputView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupOkButtonConstraints() {
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: mainInputView.bottomAnchor, constant: -32),
            okButton.centerXAnchor.constraint(equalTo: mainInputView.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 75),
            okButton.heightAnchor.constraint(equalToConstant: 75),
            okButtonLabel.centerXAnchor.constraint(equalTo: okButton.centerXAnchor),
            okButtonLabel.centerYAnchor.constraint(equalTo: okButton.centerYAnchor)
        ])
    }
}

extension ManualEnterRecipeIdViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive {
            isPlaceholderActive.toggle()
            textView.text = ""
            textView.textColor = .black
        }
    }
}

extension ManualEnterRecipeIdViewController: MaskedTextViewDelegateListener {
    func textView(_ textView: UITextView, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        print(value)
    }
}
