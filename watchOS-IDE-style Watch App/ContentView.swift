//
//  ContentView.swift
//  watchOS-IDE-style Watch App
//
//  Created by 최은성 on 2024/02/03.
//

/*
 [ToDo]
 타이머 최적화 필요
 */

import SwiftUI
import WatchKit
import SceneKit

struct ContentView: View {
    @State private var date = ""
    @State private var time = ""
    @State private var batteryLevel = ""
    @State private var day = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()  // 1초마다 업데이트
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    changeColor("date","VariableColor")
                    changeColor(" = ", "EqualColor")
                    changeColor("\(date);", "ValueColor")
                }
                
                HStack(spacing: 0) {
                    changeColor("time","VariableColor")
                    changeColor(" = ", "EqualColor")
                    changeColor("\(time);", "ValueColor")
                }
                .onAppear {
                    time = getTime()
                }
                .onReceive(timer) { _ in
                    time = getTime()
                }
                
                HStack(spacing: 0) {
                    changeColor("batteryLevel","VariableColor")
                    changeColor(" = ", "EqualColor")
//                    changeColor("100%;", "ValueColor")    // simulator에서는 batteryLevel은 항상 -1을 리턴하므로 더미 데이터 표시
                    changeColor("\(batteryLevel)%;", "ValueColor")
                }
                
                HStack(spacing: 0) {
                    changeColor("♥","VariableColor")
                    changeColor(" = ", "EqualColor")
                    changeColor("\(day)일;", "ValueColor")
                }
                .onAppear {
                    day = getDay()
                }
                .onReceive(timer) { _ in
                    day = getDay()
                }
            }
            .onAppear {
                // 현재 날짜 가져오기
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M월 d일(E)"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                date = dateFormatter.string(from: Date())
                
                // 배터리 상태 가져오기
                let device = WKInterfaceDevice.current()
                device.isBatteryMonitoringEnabled = true
                batteryLevel = String(format: "%.0f", device.batteryLevel * 100)
                
                
            }
        }
    }
    
    private func getTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        return timeFormatter.string(from: Date())
    }
    
    private func getDay() -> Int {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 11, day: 11))!
        let endDate = Date()
        let componenets = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return componenets.day! + 1
    }
    
    private func changeColor(_ text: String, _ color: String) -> Text {
        return Text(text).foregroundColor(Color(color))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
