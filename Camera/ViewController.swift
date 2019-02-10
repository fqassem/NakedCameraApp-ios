import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        try! captureDevice!.lockForConfiguration()
        captureDevice!.focusMode = AVCaptureFocusMode.autoFocus
        captureDevice!.unlockForConfiguration()
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.videoPreviewLayer?.frame = view.layer.bounds
            
            previewView.layer.addSublayer(videoPreviewLayer!)

            captureSession?.startRunning()
        } catch {
            print(error)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCameraOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setCameraOrientation()
    }
    
    @objc func setCameraOrientation() {
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                let o: AVCaptureVideoOrientation
                switch (orientation) {
                case .portrait: o = .portrait
                case .landscapeRight: o = .landscapeLeft
                case .landscapeLeft: o = .landscapeRight
                case .portraitUpsideDown: o = .portraitUpsideDown
                default: o = .portrait
                }
                
                previewLayerConnection.videoOrientation = o
                videoPreviewLayer!.frame = self.view.bounds
            }
        }
    }
}

