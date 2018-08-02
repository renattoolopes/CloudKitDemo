//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Renato Lopes on 01/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textType: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    let container: CKContainer = CKContainer.default()
    var privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
    
    var listPlayers: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListPlayers()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //retorna o total de registros que tem no array de players
        if listPlayers.count > 0 {
            return listPlayers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !listPlayers.isEmpty
        {
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            let cell = UITableViewCell()
            print(indexPath.row)
            print(listPlayers[indexPath.row].nick!)
            cell.textLabel?.text = listPlayers[indexPath.row].nick!
            return cell
        }
        
        return UITableViewCell()
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
            
            records?.forEach({ (record) in
                let nickPlayer = record.value(forKey: "nick")
                let typePlayer = record.value(forKey: "typePlayer")
                
                if typePlayer != nil && nickPlayer != nil {
                    let player = Player(nick: nickPlayer! as! String, type: typePlayer! as! String)
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
            let player = Player(nick: textName.text!, type: textType.text!)
            let record = CKRecord(recordType: "Players")
            
            record.setValue(player.nick!, forKey: "nick")
            record.setValue(player.typePlayer, forKey: "typePlayer")
            privateDB.save(record) { (record, error) in
                guard error == nil else{
                    return print(error?.localizedDescription ?? "ERROE")
                }
                self.getListPlayers()
            }
        }
    }
    
    
    
}

