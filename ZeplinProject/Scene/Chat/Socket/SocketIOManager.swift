//
//  SocketIOManager.swift
//  ZeplinProject
//
//  Created by inforex on 2021/08/11.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject{
    static let shared = SocketIOManager()
    
    //socket.io의 기본 클래스
    var manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!, config: [.reconnects(false)])
    var socket:SocketIOClient!
    
    var data : [Any]?
    
    //클라이언트 소켓 초기화
    override init(){
        super.init()
        
        socket = self.manager.socket(forNamespace: "/")
        
        print("소켓초기화 완료")
    }
    
    //소켓 연결 시도
    func establishConnection(){
        socket.connect()
        
        print("소켓 연결 시도")
    }
    
    //소켓 연결 종료
    func closeConnection(){
        socket.disconnect()
        
        print("소켓 연결 종료")
    }
    
    //채팅방 입장
    func reqRoomEnter() /*-> [Any]*/ {
        
        let userInfo = Email.shared
        
        let data : [String: Any] = [ "cmd" : "reqRoomEnter", "mem_id" : userInfo.email!, "chat_name" : userInfo.nick! , "mem_photo" : userInfo.profileImage!]
        print("data!!!!!!!!")
        print(data)
        //var ackk = [Any]()
        socket.emitWithAck("message", data).timingOut(after: 0) {ack in
            print("응답 >>> \(ack)")
            //ackk = ack
        }
        //return ackk
    }
    
    //채팅방 퇴장
    func reqRoomOut(){
        socket.emit("message", ["cmd":"reqRoomOut"])
    }
    
    
    //채팅메시지 보내기
    func sendChatMsg(_ text:String){
        let data : [String:String] = ["cmd" : "sendChatMsg", "msg":text]
        print("메시지 보내기 \(data)")
        
        socket.emit("message", data)
    }
    
    //좋아요 누르기
    func sendLike(){
        socket.emit("message", ["cmd" : "sendLike"])
    }
    
    //메시지 받기
    func rcvMsg()   {
        socket.on("message") { (dataArray, socketAck) -> Void in
            
            print("리시브데이터 \(dataArray)")
            
            self.data = dataArray
            
        }
        
        
    }

}
