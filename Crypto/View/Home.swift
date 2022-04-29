//
//  Home.swift
//  Crypto
//
//  Created by Эрхаан Говоров on 25.04.2022.
//

import SwiftUI

struct Home: View {
    @State var currentCoin: String = "BTC"
    @Namespace var animation
    @State var currentPrice: String = "0"
    
    var body: some View {
        VStack {
            // MARK: UI
            HStack(spacing: 15) {
                Circle()
                    .fill(.red)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Bitcoin")
                        .font(.callout)
                        .fontWeight(.bold)
                    Text("BTC")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
               // .frame(alignment: .leading)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
        GraphView()
        CustomControl()
        Controls()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: SEGMENTED CONTROL
    @ViewBuilder
    func CustomControl() -> some View {
        // Data
        let coins = ["BTC", "ETH", "SOL", "DOGE", "ADA", "NEAR", "TRX"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(coins, id: \.self) {
                    coin in
                    Text(coin)
                        .foregroundColor(currentCoin == coin ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin {
                                Rectangle()
                                    .fill(Color.red)
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                                
                            }
                        }
                        .onTapGesture {
                            withAnimation { currentCoin = coin }
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
    func GraphView() -> some View {
        GeometryReader {_ in
            
        }
}




struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
