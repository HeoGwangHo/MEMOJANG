//
//  Memo.swift
//  MEMOJANG
//
//  Created by Gwang_Ho on 2020/03/31.
//  Copyright © 2020 Gwang-Ho Heo. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class Memo: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var title: String? = nil // 제목
    dynamic var content: String? = nil // 내용
    dynamic var imageURL: String? = nil // 이미지
    
    // 기본키 설정
    override static func primaryKey() -> String? {
        return "id"
    }
}
