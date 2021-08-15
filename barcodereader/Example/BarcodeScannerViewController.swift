//
//  BarcodeScannerViewController.swift
//  barcodereader
//
//  Created by Roberto Luiz Veiga Junior on 15/08/21.
//

import UIKit

class BarcodeScannerViewController: UIViewController {
    
    var selectItems = UIImagePickerController();
    var alert = UIAlertController(title: "Escolha uma das opções abaixo", message: nil,
                                  preferredStyle: .actionSheet)
    var retornSelect : ((UIImage) -> ())?;
    
    @IBOutlet weak var scannerView: BarcodeScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var qrData: BarcodeData? = nil {
        didSet {
            if qrData != nil {
                //TODO
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
}

extension BarcodeScannerViewController: BarcodeScannerViewDelegate {
    func barcodeScanningDidFail() {
        print("Ocorreu um erro de leitura, por favor tente novamente.")
    }
    
    func barcodeScanningDidStop() {
        print("O scanner parou a leitura")
    }
    
    func barcodeScanningSucceededWithCode(_ str: String?) {
        self.qrData = BarcodeData(stringCode: str)
        scannerView.startScanning()
        print(str ?? "Ops, tente novamente")
    }
}

extension BarcodeScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func selecionadorImagem(_ viewController: UIViewController,
                            _ retorn: @escaping ((UIImage) -> ())) {
        retornSelect = retorn;
        
        let camera = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            if !self.scannerView.isRunning {
                self.scannerView.startScanning()
            }
        }
        
        let photoLibrary = UIAlertAction(title: "Galeria", style: .default){
            UIAlertAction in
            self.openPhotoLibrary()
        }

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel){
            UIAlertAction in
        }
        
        selectItems.delegate = self
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(){
        alert.dismiss(animated: true, completion: nil)
        selectItems.sourceType = .photoLibrary
        self.present(selectItems, animated: true, completion: nil)
    }

}

