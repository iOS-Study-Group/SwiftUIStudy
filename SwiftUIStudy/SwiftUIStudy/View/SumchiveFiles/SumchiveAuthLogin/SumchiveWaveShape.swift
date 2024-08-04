
//
//  SumchiveWaveShape.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 8/1/24.
//

import SwiftUI

//블로그 보고 따라 만들어보기
//어렵네요..
struct WaveShape: Shape {
    
    //물결
    var amplitude: CGFloat = 20 //파형의 진폭
    var frequency: CGFloat = 2 //파형의 주기
    
    //주어진 물결 파형으로 도형 그리는 함수
    func path(in rect: CGRect) -> Path {
        var path = Path() //path객체 생성
        let midHeight = rect.height / 2 //rect의 중간높이 계산
        let width = rect.width // 너비
        let height = rect.height // 높이
        
        //경로의 시작점을 왼쪽 중앙으로 설정(0,중간높이)
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        // 너비 기준으로 1씩 반복하며 물결 생성
        for x in stride(from: 0, through: Double(width), by: 1) {
            let relativeX = CGFloat(x) / width //x좌표
            let y = midHeight + amplitude * sin(relativeX * .pi * frequency) //y좌표
            path.addLine(to: CGPoint(x: CGFloat(x), y: y)) //위에서 계산한 x,y 좌표를 path에 추가
        }
        
        path.addLine(to: CGPoint(x: width, y: height)) //path의 끝부분을 오른쪽 하단으로 설정
        path.addLine(to: CGPoint(x: 0, y: height)) // path의 끝부분을 왼쪽 하단으로 설정
        path.closeSubpath() //path 닫기
        
        return path //path 반환
    }
}

