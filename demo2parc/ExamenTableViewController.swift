//
//  ExamenTableViewController.swift
//  demo2parc
//
//  Created by Adrian on 08/11/2018.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

class ExamenTableViewController: UITableViewController {

    let URLBASE = "https://www.dit.upm.es/santiago.examen/datos212.json"
    
    var items = [String]() // Creo un array vacío
    
    var imagesCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)

        // Configure the cell...

        let imgurl = items[indexPath.row]
        
        cell.textLabel?.text = items[indexPath.row] // Which items it mathc
        
        if let img = imagesCache[imgurl] {
             cell.imageView?.image = img
        } else {
            cell.imageView?.image = UIImage(named: "none") // pu a none image
            
            //donwload(imgurl, cell) // SI haog scroll se va a representar en ese cell con el indexPath row
            download(imgurl, for: indexPath) // For a certain path, instead of indexPath, an int: si se me ocurre secciones, no row
        }
        
        return cell
    }
    
    // Pick this string and download
    func download(_ urls: String, for indexPath: IndexPath){
        
        // As it is blocking block
        // DispatchQueue(label: "Cola Baja Foto").async { - not to create so many queue
        DispatchQueue.global().async {
            print("bajando", urls)
            if let url = URL(string: urls) {
                if let data = try? Data(contentsOf: url){
                    if let img = UIImage(data: data){
                        
                        DispatchQueue.main.async {
                            self.imagesCache[urls] = img
                            // Not to relaod all data, onlt the specicfic row
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                        
                    }
                }
            }
        }
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func download(){
        
        guard let url = URL(string: URLBASE) else {
            print("Bad Url")
            return
        }
        
        DispatchQueue.global().async {
            // COmo es bloqueante se lo hecho a un thread
            if let data = try? Data(contentsOf: url){
                // If bad, you give me a nil
                
                //JSON serialization
                
                if let itemsSerialized = (try? JSONSerialization.jsonObject(with: data)) as? [String]{
                    DispatchQueue.main.async{
                        self.items = itemsSerialized
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
        
}
