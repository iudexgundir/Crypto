//
//  Home.swift
//  Crypto
//
//  Created by Эрхаан Говоров on 25.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentCoin: String = "BTC"
    @Namespace var animation
    @State var currentPrice: String = "0"
    @StateObject var appModel: AppViewModel = AppViewModel()
    var body: some View {
        VStack {
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                // MARK: UI
                HStack(spacing: 15) {
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(coin.name)")
                            .font(.callout)
                            .fontWeight(.bold)
                        Text("\(coin.symbol.uppercased())")
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                    }
                   // .frame(alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.body.bold())
                        .foregroundColor(coin.price_change < 0 ? .red : .green )
                        .padding(.horizontal, 5)
                       
                }
                .frame(maxWidth: .infinity, alignment: .leading)
             
            
            GraphView(coin: coin)
            CustomControl(coins: coins)
            Controls()
            }
             else {
                ProgressView()
                    .tint(Color.red)
            } 
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: SEGMENTED CONTROL
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(coins) {
                    coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color.red)
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                                
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation { currentCoin = coin.symbol.uppercased() }
                        }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.vertical)
    }
}

    // MARK: Controls
    @ViewBuilder
    func Controls() -> some View {
        
            Button {
                
            } label: {
                Text("Convert")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        
                       Capsule()
                            .stroke(Color.gray)
                    }
            }
    }



    // MARK: LineGraph
    @ViewBuilder
func GraphView(coin: CryptoModel) -> some View {
        GeometryReader {_ in
            LineGraph(data: coin.last_7days_price.price)
        }
}




struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

// MARK: Converting Double to Currency
extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
