//
//  Home.swift
//  ExpandableNavigation
//
//  Created by KARMANI Aziza on 29/04/2024.
//

import SwiftUI

struct Home: View {
    /// States::::
    @State var searchtext: String = ""
    @FocusState var isSearching: Bool
    @State var activeTab : Tab = .all
    @Environment(\.colorScheme) private var scheme
    @Namespace var animation
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing:10){
                DummyMessagesView()
            }
            .safeAreaPadding(10)
            .safeAreaInset(edge: .top, spacing: 0){
                ExpandableNavigation()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        } /// End ScrollView
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 190, for: .scrollIndicators)
    }
    
    
    /// Expandable Navigation ::::
    @ViewBuilder
    func ExpandableNavigation(_ title: String = "Messages" ) -> some View {
        GeometryReader { proxy in
            
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollViewHeight, 1), 0) * 0.5) : 1
            // the lower the value(70), the faster the scroll animation will be.
            let progress = isSearching ? 1 :  max(min(-minY / 80, 1), 0)
            
            VStack(spacing:10) {
                /// Title ::::
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                /// SearchBar ::::
                HStack(spacing:10)  {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Rechercher", text: $searchtext)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                        }){
                            Image(systemName: "xmark.circle")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                    
                } /// End HStack SearchBar
                .foregroundStyle(.gray)
                .padding(.vertical, 10)
                .padding(.horizontal, 12 - (progress * 12))
                .frame(height: 45)
                .clipShape(.capsule)
                .background{
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.7), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 60)
                        .padding(.horizontal, -progress * 12)
                }
                
                /// Custom Segmented Picker  :::::
                ScrollView(.horizontal) {
                    HStack(spacing:10) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy){
                                    activeTab = tab
                                }
                            }){
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : .primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background{
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        }
                                        else{
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 50)
            }
            .padding(.top, 20)
            .safeAreaPadding(.horizontal, 10)
            .offset(y: minY < 0  || isSearching ? -minY : 0)
            .offset(y: -progress * 60)
       
        }
        .frame(height: 190)
        .padding(.bottom, 15)
        .padding(.bottom, isSearching ? -60 : 0)
    }
    
    
    /// Dummy Messages ::::
    @ViewBuilder
    func DummyMessagesView() -> some View {
        ForEach(0..<20, id: \.self) { _ in
            HStack(spacing:10)  {
                Circle()
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading, spacing: 5) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    
                    Rectangle()
                        .frame(height: 8)
                    
                    Rectangle()
                        .frame(width: 80, height: 8)
                }
            }
            .foregroundStyle(.gray.opacity(0.5))
        }
        
    }
    
}

struct CustomScrollTargetBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            }else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    Home()
}
