//
//  Utils.swift
//  JoyConSwift
//
//  Created by magicien on 2019/06/16.
//  Copyright © 2019 DarkHorse. All rights reserved.
//

import Foundation

func ReadInt16(from ptr: UnsafePointer<UInt8>) -> Int16 {
    return Int16(bitPattern: UInt16(ptr[0]) | (UInt16(ptr[1]) << 8))
}

func ReadUInt16(from ptr: UnsafePointer<UInt8>) -> UInt16 {
    return UInt16(ptr[0]) | (UInt16(ptr[1]) << 8)
}

func ReadInt32(from ptr: UnsafePointer<UInt8>) -> Int32 {
    return Int32(bitPattern: UInt32(ptr[0]) | (UInt32(ptr[1]) << 8) | (UInt32(ptr[2]) << 16) | (UInt32(ptr[3]) << 24))
}

func ReadUInt32(from ptr: UnsafePointer<UInt8>) -> UInt32 {
    return UInt32(ptr[0]) | (UInt32(ptr[1]) << 8) | (UInt32(ptr[2]) << 16) | (UInt32(ptr[3]) << 24)
}
