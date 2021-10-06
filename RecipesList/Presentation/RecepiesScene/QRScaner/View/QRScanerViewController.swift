//
//  QRScanerViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 29.09.2021.
//

import UIKit
import InjectPropertyWrapper
import AVFoundation

class QRScanerViewController: UIViewController {
    
    @Inject var viewModel: QRScanerViewModel
    weak var delegate: QRScanerDelegate?
    
    lazy var horizontalInset: CGFloat = { self.view.frame.width * 0.2 }()
    lazy var maskRectWidth: CGFloat = { self.view.frame.width - horizontalInset }()
    lazy var topInset: CGFloat = { (self.view.frame.height - maskRectWidth) / 2 }()
    
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    
    static func create(delegate: QRScanerDelegate) -> QRScanerViewController {
        let view = QRScanerViewController()
        view.delegate = delegate
        return view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var maskView: CAShapeLayer = {
        let view = CAShapeLayer()
        view.fillRule = .evenOdd
        view.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    private lazy var closeButtonView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = UIImage(systemName: "multiply.circle.fill")
        view.tintColor = .white
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Сканировать"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Наведите камеру на QR код с рецептом"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var buttonDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "или введите вручную id рецепта"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var manualIdButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 67 / 255, green: 174 / 255, blue: 54 / 255, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var manualIdButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Ввести id вручную"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        setupViews()
        startCapture()
        setupCameraViewMask()
    }
    
    func setupViews() {
        self.view.addSubview(cameraView)
        setupCameraViewConstraints()
        
        self.view.addSubview(closeButtonView)
        settupCloseButtonViewConstraints()
        addCloseButtonGesture()
        
        self.view.addSubview(mainLabel)
        settupMainLabelConstraints()
        
        self.view.addSubview(descriptionLabel)
        setupDescriptionLabelConstraints()
        
        self.view.addSubview(manualIdButton)
        setupManualIdButtonConstraints()
        addManualIdButtonGesture()
        
        self.manualIdButton.addSubview(manualIdButtonLabel)
        setupManualIdButtonLabelConstraints()
        
        self.view.addSubview(buttonDescriptionLabel)
        setupButtonDescriptionLabel()
        
    }
    
    func addCloseButtonGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapCloseButton(_:)))
        gesture.minimumPressDuration = 0
        closeButtonView.addGestureRecognizer(gesture)
    }
    
    func addManualIdButtonGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapManualIdButton(_:)))
        gesture.minimumPressDuration = 0
        manualIdButton.addGestureRecognizer(gesture)
    }
    
    @objc func tapCloseButton(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            closeButtonView.tintColor = .systemGray5
        case .ended:
            guard let senderView = sender.view else { return }
            let lastLocation = sender.location(in: senderView)
            guard senderView.bounds.contains(lastLocation) else {
                closeButtonView.tintColor = .white
                return
            }
            navigationController?.popToRootViewController(animated: true)
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
        @unknown default:
            return
        }
    }
    
    @objc func tapManualIdButton(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            manualIdButton.backgroundColor = .systemGray5
        case .ended:
            guard let senderView = sender.view else { return }
            let lastLocation = sender.location(in: senderView)
            guard senderView.bounds.contains(lastLocation) else {
                manualIdButton.backgroundColor = UIColor(displayP3Red: 67 / 255, green: 174 / 255, blue: 54 / 255, alpha: 1.0)
                return
            }
            let vc = viewModel.creaateManualRecipeIdViewController(delegate: delegate as! QRScanerDelegate)
            navigationController?.pushViewController(vc, animated: true)
            manualIdButton.backgroundColor = UIColor(displayP3Red: 67 / 255, green: 174 / 255, blue: 54 / 255, alpha: 1.0)
            
            
        @unknown default:
            return
        }
    }
    
    func setupCameraViewMask() {
        let path = CGMutablePath()
        path.addRect(self.view.bounds)
        let rect = CGRect(x: horizontalInset / 2, y: topInset, width: maskRectWidth, height: maskRectWidth)
        let rectCornerRadius = CGFloat(45)
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: rectCornerRadius).cgPath
        path.addPath(clipPath)
        maskView.path = path
        cameraView.layer.addSublayer(maskView)
    }
    
    func setupCameraViewConstraints() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func settupCloseButtonViewConstraints() {
        closeButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButtonView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            closeButtonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32),
            closeButtonView.heightAnchor.constraint(equalToConstant: 40),
            closeButtonView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func settupMainLabelConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
        ])
    }
    
    func setupDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16)
        ])
    }
    
    func setupManualIdButtonConstraints() {
        manualIdButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            manualIdButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            manualIdButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            manualIdButton.widthAnchor.constraint(equalToConstant: maskRectWidth),
            manualIdButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupManualIdButtonLabelConstraints() {
        manualIdButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            manualIdButtonLabel.centerXAnchor.constraint(equalTo: manualIdButton.centerXAnchor),
            manualIdButtonLabel.centerYAnchor.constraint(equalTo: manualIdButton.centerYAnchor)
        ])
    }
    
    func setupButtonDescriptionLabel() {
        buttonDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonDescriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonDescriptionLabel.bottomAnchor.constraint(equalTo: manualIdButton.topAnchor, constant: -24)
        ])
    }
}

extension QRScanerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func startCapture() {
        session.sessionPreset = AVCaptureSession.Preset.high
        guard let device = AVCaptureDevice
                .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                         for: .video,
                         position: AVCaptureDevice.Position.back) else { return }
        captureDevice = device
        beginSession()
    }
    
    func beginSession() {
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }
            
            if self.session.canAddInput(deviceInput) {
                self.session.addInput(deviceInput)
            }

            let metadataOutput = AVCaptureMetadataOutput()
            
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                print("failed")
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            
            let rootLayer :CALayer = self.cameraView.layer
            rootLayer.masksToBounds = true
            previewLayer.frame = self.view.layer.bounds
            rootLayer.addSublayer(self.previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let resultId = RouteParser(route: code)
        switch resultId {
        case .recipe(let string):
            let vc = self.viewModel.creaateDetailViewController(id: string)
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            self.dismiss(animated: true)
            self.delegate?.showDetailRecipe(id: string)
        case .error:
            self.showQRAlert()
        }
    }
    
    func showQRAlert() {
        let alert = UIAlertView(title: "Ошибка", message: "Отсутствуют данные о рецепте", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
}
