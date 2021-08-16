//
//  FileReaderViewController.swift
//  barcodereader
//
//  Created by Roberto Luiz Veiga Junior on 16/08/21.
//

import UIKit

class FileReaderViewController: UIViewController {
    
    @IBOutlet weak var viewDocument: BarcodeScannerView! {
        didSet {
            viewDocument.delegate = self
        }
    }
    @IBOutlet weak var labelBarcodeReader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension FileReaderViewController: BarcodeScannerViewDelegate {
    func barcodeScanningDidFail() {
        print("Falhou")
    }
    
    func barcodeScanningSucceededWithCode(_ str: String?) {
        self.labelBarcodeReader.text = str
    }
    
    func barcodeScanningDidStop() {
        print("Parou")
    }
}
