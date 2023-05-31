//
//  ChatViewController.swift
//  iChat
//
//  Created by Armando Cáceres on 28/5/23.
//

import UIKit
import Firebase


class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self //For trigger the delegate
        title = K.appName
        navigationItem.hidesBackButton = true
        
        //Link to our MessageCell.Nib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.messages = [] //NO DUPLICATE MESSAGES
                
                if let e = error {
                    print("There was an issue retriving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let meessageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: meessageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath =  IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("There was an issue saving data to Firestore \(e)")
                } else {
                    print("Sucessully saved data")
                    
                    DispatchQueue.main.async {
                        self.messageField.text = ""
                    }
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        
        do {
            try Auth.auth().signOut()
            //Go to the Root VC (WelcomeVC)
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
    }
    
}

//Protocolo which needs to know HOW MANY CELL IT NEEDS and WHAT TO DISPLAY IN THE TableView
extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        //We can use cell.label from our MessageCell afetr "as! MessageCell"
        cell.label.text = message.body
        
        //This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            
        } else {//This is a message from the another person
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.blue)
        }
        
        return cell
    }
}
