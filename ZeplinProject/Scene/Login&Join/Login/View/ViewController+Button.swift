//
//  ViewController+Button.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/09.
//

import Foundation
import UIKit

extension ViewController{
    
    func createChatButton(){
        let testButton = UIButton()
        testButton.setTitle("채팅방 입장", for: .normal)
        testButton.backgroundColor = .purple
        testButton.translatesAutoresizingMaskIntoConstraints = false
                
        view.addSubview(testButton)
                
        let safeArea = view.safeAreaLayoutGuide
                
        testButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        testButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        testButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        
        testButton.addTarget(self, action: #selector(openChat), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    @objc func openChat(){
        if loading {return}
        print("채팅방 입장~")
        
        //let socket = SocketIOManager.shared
        //socket.establishConnection()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
//            socket.reqRoomEnter()
//        }
        

        
        guard let chatVC = self.chatSB.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {return}
        chatVC.modalPresentationStyle = .overFullScreen
        self.present(chatVC, animated: true,completion: {
            chatVC.socketManager.establishConnection()
            chatVC.socketManager.socket.on(clientEvent: .connect) {dataArray, ack in
                print(dataArray)
                print(ack)
                /*let ackk = */chatVC.socketManager.reqRoomEnter()
                //print("ackk@@@@")
                //print(ackk)
            }
        })
        
    }
}
