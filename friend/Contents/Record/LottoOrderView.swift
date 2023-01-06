//
//  LottoOrderView.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/28.
//

import SwiftUI
import Combine

struct LottoOrderNumberButton: View {
    
    @Binding var selected: Bool
    
    var number: Int
    var lineColor: Color
    
    var body: some View {
        
        Button {
            self.selected.toggle()
        } label: {
            
            GeometryReader { reader in
                
                ZStack {
                    
                    let frame = reader.frame(in: .local)
                    
                    let pathTop = Path { path in
                        path.move(to: CGPoint(x: 1, y: 15))
                        path.addLine(to: CGPoint(x: 1, y: 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: 15))
                    }
                    
                    pathTop.stroke(self.lineColor, lineWidth: 2)
                    
                    let pathBottom = Path { path in
                        path.move(to: CGPoint(x: 1, y: frame.maxY - 15 ))
                        path.addLine(to: CGPoint(x: 1, y: frame.maxY - 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: frame.maxY - 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: frame.maxY - 15))
                    }
                    
                    pathBottom.stroke(self.lineColor, lineWidth: 2)
                    
                    if self.selected {
                        Capsule()
                            .fill(Color.Order.mark)
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    Text("\(number)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(self.selected ? Color.Order.numberMark : self.lineColor)
                }
            }
        }
    }
}

struct LottoOrderView: View {
    
    private struct Grid {
        static let row = 7
        static let col = 7
    }
    
    enum Field {
        case round
    }
    
    @EnvironmentObject var handler: LottoListHandler
    
    @FocusState var focusField: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State var roundButtonSelect: Bool = false
    @State var roundText: String = ""
        
    @State var selectedMap = [Int:Bool]()
    @State var keyboardHeight: CGFloat = 0
    
    private var bottomSpacing: CGFloat {
        let safeBottom = UIApplication.shared.firstWindows?.safeAreaInsets.bottom ?? 0
        let height = max(self.keyboardHeight, 0)
        
        if height == 0 {
            return safeBottom
        }
        return height + 16
    }
    
    private var selectedNumbers: [Int] {
        return Array(self.selectedMap.filter({$0.value}).keys).sorted(by: {$0 < $1})
    }
    
    private var isEqualInitRound: Bool {
        return Int(roundText) == self.handler.selection.round
    }
    
    private var isDefault: Bool {
        return self.isEqualInitRound && self.selectedNumbers == self.handler.selection.numbers
    }
    
    private var enableChange: Bool {
        
        if self.selectedNumbers.count < 6 {
            return false
        }
        
        if self.isDefault {
            return false
        }
        return true
    }
    
    private var lineColor: Color {
        
        if self.selectedNumbers.count == 6 || self.isDefault {
            return Color.Button.disable
        }
        
        return Color.Order.line
    }
    
    private var titleRoundView: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 16) {
                Text("round".localized)
                    .font(.title)
                TextField("", text: $roundText)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .keyboardType(.numberPad)
                    .onReceive(Just(self.roundText), perform: { result in
                        if let number = Int(result) {
                            if number < 10000 {
                                self.roundText = result
                            } else {
                                self.roundText = "9999"
                            }
                        } else {
                            self.roundText = ""
                        }
                    })
                    .onSubmit({
                        self.reloadRoundButton()
                    })
                
            }
            .padding(.bottom, 8)
        }.padding(.leading, 24)
        .frame(height: 60)
    }
    
    private var orderNumberView: some View {
        ZStack {
            Rectangle()
                .strokeBorder(self.lineColor, lineWidth: 2)
            
            HStack(alignment: .center, spacing:0) {
                VStack(alignment: .leading, spacing:0) {
                    ForEach(0..<Grid.row, id:\.self) { row in
                        HStack(alignment: .center, spacing:0) {
                            ForEach(1...Grid.col, id:\.self) { column in
                                
                                let number = (row * Grid.col) + column
                                
                                if number < 46 {
                                    LottoOrderNumberButton(selected: binding(key: number),
                                                           number: number,
                                                           lineColor: self.lineColor)
                                        .frame(width: 30, height:46)
                                    
                                    if column < Grid.col {
                                        Spacer().frame(minWidth: 14).fixedSize()
                                    }
                                }
                            }
                            
                        }.frame(height:46)
                        
                        if row < Grid.row - 1 {
                            Spacer().frame(minHeight: 0).fixedSize()
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
        }
        .fixedSize()
    }
    
    private var lineView: some View {
        
        Rectangle()
            .foregroundColor(Color.List.rowLine)
            .frame(height: 1)

    }
    
    private var bottomButtonView: some View {
        VStack(spacing: 8) {
            Button {
                
                guard let round = Int(self.roundText) else {
                    return
                }
                
                let numbers = (self.selectedMap.filter({$1 == true})
                    .keys.compactMap({$0}) as [Int])
                    .sorted(by: {$0 < $1})
                
                self.handler.modifySelection(round: round, numbers: numbers)
                
                self.dismiss()
                
            } label: {
                ZStack {
                    (self.enableChange) ? Color.Common.point : Color.Button.disable
                    Text("save".localized).foregroundColor(Color.Button.text)
                }.cornerRadius(8)
            }
            .disabled(self.enableChange == false)
            .frame(height: 40)
            
            Button {
                self.reloadNumbers()
            } label: {
                ZStack {
                    Color.Common.point
                    Text("clear".localized).foregroundColor(Color.Button.text)
                }.cornerRadius(8)
            }
            .frame(height:40)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    private var axes: Axis.Set {
        return self.roundButtonSelect == false ? .vertical : []
    }
    
    private func binding(key:Int) -> Binding<Bool> {
        return Binding(
            get: {return self.selectedMap[key] ?? false},
            set: {
                if $0 == true, self.selectedNumbers.count >= 6 {
                    return
                }
                self.selectedMap[key] = $0
            })
    }
    
    var body: some View {

        VStack(spacing: 0) {
            Spacer()
            self.titleRoundView
            self.lineView
            ScrollView {
                Spacer(minLength: 16)
                HStack {
                    Spacer(minLength: 8)
                    self.orderNumberView
                    Spacer(minLength: 8)
                }
                
                Spacer()
            }
            .scrollDismissesKeyboard(.immediately)
            self.lineView
            Spacer(minLength: 16)
            self.bottomButtonView
                .padding(.bottom, self.bottomSpacing) // bottomSpacing을 임의로 지정하여 하단 여백을 조절함
        }
        .ignoresSafeArea(.all) // safe edge inset을 무시함
        .onAppear {
            self.reloadNumbers()
        }
        .keyboard(height: $keyboardHeight.onChange(changeKeyboardHeight))
    }
    
    private func reloadNumbers() {
        self.selectedMap.removeAll()
        self.roundText = String(self.handler.selection.round)
        self.handler.selection.numbers.forEach { number in
            self.selectedMap[number] = true
        }
    }
    
    private func changeKeyboardHeight(height:CGFloat) {
        if height == 0 {
            self.reloadRoundButton()
        }
    }
    
    private func reloadRoundButton() {
        self.focusField = false
        self.roundButtonSelect = false
    }
}

struct LottoOrderView_Previews: PreviewProvider {
    
    @State static var selected: Bool = true
    
    static var previews: some View {
        
        Group {
            LottoOrderNumberButton(selected: $selected, number: 1, lineColor:Color.Order.line).frame(width: 30, height:46)
            LottoOrderView().environmentObject(LottoListHandler())
        }
    }
}
