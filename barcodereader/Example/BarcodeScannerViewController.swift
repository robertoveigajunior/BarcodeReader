//
//  BarcodeScannerViewController.swift
//  barcodereader
//
//  Created by Roberto Luiz Veiga Junior on 15/08/21.
//

import UIKit

class BarcodeScannerViewController: UIViewController {
    
    @IBOutlet weak var scannerView: BarcodeScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    @IBOutlet weak var labelBarcodeReader: UILabel!
    
    var qrData: BarcodeData? = nil {
        didSet {
            if qrData != nil {
                //TODO - caso queira usar
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        labelBarcodeReader.text = str
        print(str ?? "Ops, tente novamente")
    }
}

