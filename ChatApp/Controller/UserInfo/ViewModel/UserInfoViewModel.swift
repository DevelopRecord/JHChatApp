//
//  UserInfoViewModel.swift
//  ChatApp
//
//  Created by LeeJaeHyeok on 2022/04/16.
//

import Foundation

var userData: User?

enum UserInfoViewModel: Int, CaseIterable {
    case fullname
    case nickname
    case email

    var description: String {
        switch self {
        case .fullname: return "이름"
        case .nickname: return "닉네임"
        case .email: return "이메일"
        }
    }
    
    var userInfo: String {
        switch self {
        case .fullname: return userData?.fullname ?? ""
        case .nickname: return userData?.nickname ?? ""
        case .email: return userData?.email ?? ""
        }
    }
    
    var iconName: String {
        switch self {
        case .fullname: return "person.circle"
        case .nickname: return "person.circle"
        case .email: return "envelope"
        }
    }
}
