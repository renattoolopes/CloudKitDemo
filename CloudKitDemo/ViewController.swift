//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Renato Lopes on 01/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CloudKit

class ViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{
    
 
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textType: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!

    let imgPick = UIImagePickerController()
    var imageURL: URL? = nil
    let container: CKContainer = CKContainer.default()
    var privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
    var listPlayers: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgPick.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imageView.layer.cornerRadius = 10.00
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        self.getListPlayers()
        
        self.tableView.register(CellCustom.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picked = info[UIImagePickerControllerOriginalImage] as! UIImage?{
            imageView.contentMode = .scaleToFill
            imageView.image = picked
        }
        
        let imgUrl = info[UIImagePickerControllerImageURL] as? URL
        imageURL = imgUrl!
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retorna o total de registros que tem no array de players
        if listPlayers.count > 0 {
            return listPlayers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CellCustom
        
        if !listPlayers.isEmpty
        {
//            let cell = UITableViewCell()
            customCell.message = listPlayers[indexPath.row].name!
            customCell.mainImage = convertURL(url: listPlayers[indexPath.row].photo)
            return customCell
        }else{
            customCell.mainImage = UIImage()
            customCell.message = ""
            return customCell

        }
        
    }
    func convertURL(url: URL) -> UIImage{
        var data: Data
        var image: UIImage = UIImage()
        do {
             data = try Data(contentsOf: url)
            image = UIImage(data: data)!

        }catch{
            print("Deu zica")
        }
        
        
        return image
    }
    
    func getListPlayers(){
        // Verificar o que é o predicate
        let query = CKQuery(recordType: "Players", predicate: NSPredicate(value: true))
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            // Function retorna records do tipo definido na query e em caso de erro, obter pelo error que pode ser nil
            guard error == nil else {
                //imprimir retorno do erro, obrigatorio ter um return
                return print(error?.localizedDescription ?? "ERROR IN CLOUDKIT - Players")
            }
            self.listPlayers = []

            records?.forEach({ (record) in
                let name = record.value(forKey: "name")
                let typePlayer = record.value(forKey: "type")
                let photoPlayer = record.value(forKey: "photo")
                let url  = photoPlayer as! CKAsset
                
                if typePlayer != nil && name != nil {
                    let player = Player(name: name! as! String, type: typePlayer! as! String, photo: url.fileURL )
                    
                    self.listPlayers.append(player)
                }
            })
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.tableView.isHidden = false
            })
        }
    }
    
    @IBAction func btnSavePlayer(_ sender: Any) {
        if !(textType.text?.isEmpty)! && !(textName.text?.isEmpty)!{
            let player = Player(name: textName.text!, type: textType.text!,photo: imageURL!)
            let record = CKRecord(recordType: "Players")

            record.setValue(player.name!, forKey: "name")
            record.setValue(player.type, forKey: "type")
            record.setValue(CKAsset(fileURL: imageURL!), forKey: "photo")

            privateDB.save(record) { (record, error) in

                guard error == nil else{
                    print("error")
                    return print(error?.localizedDescription ?? "ERROR")
                }
                OperationQueue.main.addOperation({
                    self.clearFilds()
                    self.getListPlayers()
                    self.tableView.isHidden = false
                })
            }
        }



    }
    
    @IBAction func refreshTable(_ sender: Any) {
        self.getListPlayers()
    }
    
    @IBAction func btnImage(_ sender: Any) {
        imgPick.allowsEditing = false
        imgPick.sourceType = .photoLibrary
        self.present(imgPick, animated: true, completion: nil)
        
    }
    
    func clearFilds(){
        textName.text = nil
        textType.text = nil
        imageView.image = nil
    }
    
}

