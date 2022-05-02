//
//  JoinView+Birthday.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/28.
//

import Foundation
import UIKit

extension JoinView: UIPickerViewDelegate,UIPickerViewDataSource{
    //생년월일 뷰 클릭
    func pickBirth(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.createPickerView))
        birthdayView.addGestureRecognizer(tap)
    }
    
    //pickerView생성
    @objc func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.frame = CGRect(x: self.frame.origin.x, y: self.frame.height * 0.7 , width: self.frame.width, height: self.frame.height * 0.3 )
        pickerView.backgroundColor = .white
        pickerView.tag = 100
        
        pickerView.delegate = self
        
        //피커뷰 초기값 -> 오늘 날짜
        let today = today()
        pickerView.selectRow(today.month!-1, inComponent: 1, animated: true)
        pickerView.selectRow(today.day!-1, inComponent: 2, animated: true)
        

        let chooseBtn = UIButton(frame: CGRect(x: self.frame.origin.x, y: (self.frame.height * 0.7)-35, width: self.frame.width, height: 35 ))
        chooseBtn.setTitle("선택", for: .normal)
        chooseBtn.backgroundColor = UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 1)
        chooseBtn.cornerRadius = 10
        chooseBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        chooseBtn.tag = 200
        chooseBtn.addTarget(self, action: #selector(onPickDone), for: .touchUpInside)

        self.addSubview(chooseBtn)
        self.addSubview(pickerView)
        
    }
    
    
    //확인 클릭
    @objc func onPickDone() {
        viewWithTag(200)?.removeFromSuperview()
        viewWithTag(100)?.removeFromSuperview()
    }
        
    //나이 반환
    func age() -> Int{
        let today = today()
        let age : Int = today.year! - Int(selectYear!)! + 1
        
        return age
    }
    
    //오늘 날짜 반환
    func today() -> DateComponents{
        let date = Date()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        return components
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearArray.count
        }else if component == 1 {
            return monthArray.count
        }else if component == 2{
            return dayArray.count
        }
        return 0
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(yearArray[row])"
        }else if component == 1 {
            return "\(monthArray[row])"
        }else if component == 2{
            return "\(dayArray[row])"
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            selectYear = "\(yearArray[row])"
            self.yearLabel.text = selectYear
        }else if component == 1 {
            selectMonth = "\(monthArray[row])"
            self.monthLabel.text = selectMonth
            self.monthLabel.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        }else if component == 2{
            selectDay = "\(dayArray[row])"
            self.dayLabel.text = selectDay
            self.dayLabel.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        }
        
    }


}
