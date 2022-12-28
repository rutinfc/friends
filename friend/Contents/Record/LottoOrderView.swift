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
                    
                    pathTop.stroke(Color("OrderLine"), lineWidth: 2)
                    
                    let pathBottom = Path { path in
                        path.move(to: CGPoint(x: 1, y: frame.maxY - 15 ))
                        path.addLine(to: CGPoint(x: 1, y: frame.maxY - 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: frame.maxY - 1))
                        path.addLine(to: CGPoint(x: frame.maxX - 1, y: frame.maxY - 15))
                    }
                    
                    pathBottom.stroke(Color("OrderLine"), lineWidth: 2)
                    
                    if self.selected {
                        Capsule()
                            .fill(Color("OrderMark"))
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    Text("\(number)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(self.selected ? Color("OrderNumberMark") : Color("OrderLine"))
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
    
    @Binding var item: LottoRecordItem
    
    @State var roundButtonSelect: Bool = false
    @State var roundText: String = ""
    
    @State var selectedMap = [Int:Bool]()
    @State var round: Int = 1
    
    private func binding(key:Int) -> Binding<Bool> {
        return Binding(
            get: {return self.selectedMap[key] ?? false},
            set: {
                if $0 == true, self.selectedMap.values.filter({$0}).count >= 6 {
                    return
                }
                self.selectedMap[key] = $0
            })
    }
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing:0) {
                        
                        HStack(spacing: 0) {
                            Spacer()
                            if self.roundButtonSelect == false {
                                Button {
                                    self.roundButtonSelect = true
                                } label: {
                                    Text("\(self.roundText)회")
                                }
                            } else {
                                VStack(alignment: .center) {
                                    TextField("\(round)", text: $roundText)
                                        .focused($focusField)
                                        .multilineTextAlignment(.center)
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
                                            self.focusField = false
                                            self.roundButtonSelect = false
                                        })
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button {
                                                    self.focusField = false
                                                    self.roundButtonSelect = false
                                                } label : {
                                                    
                                                    Text("Done")
                                                }
                                            }
                                        }
                                    Rectangle().frame(height:1).foregroundColor(Color("RowLine"))
                                }
                                .onAppear {
                                    self.focusField = true
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .frame(height: 60)
                        
                        ZStack {
                            Rectangle()
                                .strokeBorder(Color("OrderLine"), lineWidth: 2)
                            
                            HStack(alignment: .center, spacing:0) {
                                VStack(alignment: .leading, spacing:0) {
                                    ForEach(0..<Grid.row, id:\.self) { row in
                                        HStack(alignment: .center, spacing:0) {
                                            ForEach(1...Grid.col, id:\.self) { column in
                                                
                                                let number = (row * Grid.col) + column
                                                
                                                if number < 46 {
                                                    LottoOrderNumberButton(selected: binding(key: number), number: number)
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
                        .padding(.bottom, 40)
                        .fixedSize()
                    }
                    
                }
                .scrollDismissesKeyboard(.immediately)
                .onAppear {
                    self.reloadNumbers()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                Rectangle()
                    .foregroundColor(Color("RowLine"))
                    .frame(height: 1)
                
                VStack(spacing: 0) {
                    Button {
                        
                        guard let round = Int(self.roundText) else {
                            return
                        }
                        
                        let numbers = (self.selectedMap.filter({$1 == true}).keys.compactMap({$0}) as [Int]).sorted(by: {$0 < $1})
                        
                        let item = LottoRecordItem(id: self.item.id, round: round, numbers: numbers, fixed: self.item.fixed, date: Date())
                        
                        self.handler.modify(item: item)
                        
                        self.dismiss()
                        
                    } label: {
                        ZStack {
                            Color.blue
                            Text("save".localized).foregroundColor(.white)
                        }.cornerRadius(8)
                    }
                    .frame(height: 40)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    Button {
                        
                        self.reloadNumbers()
                        
                    } label: {
                        ZStack {
                            Color.blue
                            Text("clear".localized).foregroundColor(.white)
                        }.cornerRadius(8)
                    }
                    .frame(height:40)
                    .padding(.bottom, 20)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
        }
        
    }
    
    private func reloadNumbers() {
        self.selectedMap.removeAll()
        self.roundText = String(self.item.round)
        self.item.numbers.forEach { number in
            self.selectedMap[number] = true
        }
    }
}

struct LottoOrderView_Previews: PreviewProvider {
    
    @State static var item = LottoRecordItem.sampleItem()
    @State static var selected: Bool = true
    
    static var previews: some View {
        
        Group {
            LottoOrderNumberButton(selected: $selected, number: 1).frame(width: 30, height:46)
            LottoOrderView(item:$item)
        }
    }
}
