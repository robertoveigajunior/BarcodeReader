//
//  InicialViewController.swift
//  barcodereader
//
//  Created by Roberto Luiz Veiga Junior on 15/08/21.
//

import UIKit

class InicialTableViewController: UITableViewController {
    
    var menuItems = ["Camera","Arquivo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Leitor de codigo de barras"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController
        switch indexPath.row {
            case 0:
                vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BarcodeScannerViewController") as? BarcodeScannerViewController)!
            case 1:
                vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileReaderViewController") as? FileReaderViewController)!
            default:
                return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
 
