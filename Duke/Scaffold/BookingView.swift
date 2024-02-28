//
//  BookingView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/6/23.
//

import SwiftUI

struct BookingView: View {
    @Environment(\.dismiss) var dismiss

    @State var gradient: [Color] = [Color("backgroundColor2").opacity(0), Color("backgroundColor2"), Color("backgroundColor2"), Color("backgroundColor2")]
    
    @State var selectedDate: Bool = false
    @State var selectedHour: Bool = false
    @State var bindingSelection: Bool = false
    @State var showSeats: Bool = false
    
    var day : String {
        let currentDate = Date()
        let dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE"
            return formatter
        }()
        return dayFormatter.string(from: currentDate)
    }
    
    var dateNumber: String {
        let currentDate = Date()
        let dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter
        }()
        return dayFormatter.string(from: currentDate)
    }
    
    var currentTime: String {
        let currentDate = Date()
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        return timeFormatter.string(from: roundTimeToNextTwoHours(date: currentDate))
    }
    
    func roundTimeToNextTwoHours(date: Date) -> Date {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let nextTwoHours = (currentHour + 2) % 24
        let roundedUpDate = calendar.date(bySettingHour: nextTwoHours, minute: 0, second: 0, of: date) ?? date
        return roundedUpDate
    }
    
    func getDateTime(_ timeHour: Int = 0) -> (String, String, String) {
        let calendar = Calendar.current
        let currentDate = Date()
        let dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE"
            return formatter
        }()
        let numDayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter
        }()
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        
        let currentHour = calendar.component(.hour, from: currentDate)
        let nextTimeInterval = (currentHour + 2) % 24
        
        let nextDate: Date
        if nextTimeInterval >= 20 {
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            nextDate = calendar.date(bySettingHour: 9 + timeHour, minute: 0, second: 0, of: tomorrow)!
        } else if nextTimeInterval < 9 {
            nextDate = calendar.date(bySettingHour: 9 + timeHour, minute: 0, second: 0, of: currentDate)!
        } else {
            nextDate = calendar.date(bySettingHour: nextTimeInterval + timeHour, minute: 0, second: 0, of: currentDate)!
        }
        
        return (dayFormatter.string(from: nextDate), numDayFormatter.string(from: nextDate), timeFormatter.string(from: nextDate))
    }
    
    var body: some View {
            ZStack {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    LinearGradient(gradient: Gradient(colors: gradient), startPoint: .top, endPoint: .bottom)
                        .frame(height: 600)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                VStack(spacing: 0.0) {
                    HStack {
                        CircleButton(image: "arrow.left", action: {
                            dismiss()
                        })
                        
                        Spacer()
                        
                        CircleButton(image: "ellipsis", action: {})
                    }
                    .padding(EdgeInsets(top: 46, leading: 20, bottom: 0, trailing: 20))
                    
                    Text("")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 200)
                    
                    Text("")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Text("")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(30)
                    
                    Text("Select date and time")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    HStack(alignment: .top, spacing: 20.0) {
                        DateButton(weekDay: getDateTime().0, numDay: getDateTime().1, isSelected: $bindingSelection, foregroundColour: .gray)
                            .padding(.top, 90)
                        
                        DateButton(weekDay: getDateTime().0, numDay:getDateTime().1, isSelected: $bindingSelection, foregroundColour: .gray)
                            .padding(.top, 70)
                        
                        DateButton(weekDay: getDateTime().0, numDay: getDateTime().1, width: 70, height: 100, isSelected: $selectedDate, action: {
                            withAnimation(.spring()) {
                                selectedDate.toggle()
                            }
                        })
                        .padding(.top, 30)
                        
                        DateButton(weekDay: getDateTime().0, numDay: getDateTime().1, isSelected: $bindingSelection)
                            .padding(.top, 70)
                        
                        DateButton(weekDay: getDateTime().0, numDay: getDateTime().1, isSelected: $bindingSelection)
                            .padding(.top, 90)
                    }
                    
                    HStack(alignment: .top, spacing: 20.0) {
                        TimeButton(hour: getDateTime(-2).2, isSelected: $bindingSelection, foregroundColour: .gray)
                            .padding(.top, 20)
                        
                        TimeButton(hour: getDateTime(-1).2, isSelected: $bindingSelection, foregroundColour: .gray)
                        
                        TimeButton(hour: getDateTime().2, width: 70, height: 40, isSelected: $selectedHour, action: {
                            withAnimation(.spring()) {
                                selectedHour.toggle()
                            }
                        })
                        .padding(.top, -20)
                        
                        TimeButton(hour: getDateTime(1).2, isSelected: $bindingSelection)
                        
                        TimeButton(hour: getDateTime(2).2, isSelected: $bindingSelection)
                            .padding(.top, 20)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                GradientButton(buttonTitle: "Purchase Membership") { //ADD PRICE FROM FAVOURITE RESTAURANT CARD
                    showSeats = true
                }
                .padding(20)
                .offset(y: selectedDate && selectedHour ? 300 : 2000)
                
                if showSeats {
                    SeatsView()
                }
            }
            .background(Color("backgroundColor2"))
            .ignoresSafeArea()
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}

struct DateButton: View {
    @State var weekDay: String = "Sat"
    @State var numDay: String = "23"
    
    @State var width: CGFloat = 50
    @State var height: CGFloat = 80
    
    @Binding var isSelected: Bool
    @State var action: () -> Void = {}
    var foregroundColour: Color = .white
    var currentDate = Date()
    
    var currentBorderColors: [Color] = [Color("cyan"), Color("cyan").opacity(0), Color("cyan").opacity(0)]
    var currentGradient: [Color] = [Color("backgroundColor-1"), Color("grey")]
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    var selectedGradient: [Color] = [Color("majenta"), Color("backgroundColor-1")]
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(weekDay)
                
                Text(numDay)
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            .foregroundColor(foregroundColour)
            .frame(width: width, height: height)
            .background(LinearGradient(colors: isSelected ? selectedGradient : currentGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(colors: isSelected ? selectedBorderColors : currentBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
                    .frame(width: width - 1, height: height - 1)
            }
        }
    }
}

struct TimeButton: View {
    @State var hour: String = "18:00"
    
    @State var width: CGFloat = 50
    @State var height: CGFloat = 40
    
    @Binding var isSelected: Bool
    @State var action: () -> Void = {}
    
    var currentBorderColors: [Color] = [Color("cyan"), Color("cyan").opacity(0), Color("cyan").opacity(0)]
    var currentGradient: [Color] = [Color("backgroundColor-1"), Color("grey")]
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    var selectedGradient: [Color] = [Color("majenta"), Color("backgroundColor-1")]
    var foregroundColour: Color = .white
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(hour)
            }
            .font(.subheadline)
            .foregroundColor(foregroundColour)
            .frame(width: width, height: height)
            .background(LinearGradient(colors: isSelected ? selectedGradient : currentGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(colors: isSelected ? selectedBorderColors : currentBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
                    .frame(width: width - 1, height: height - 1)
            }
        }
    }
}

