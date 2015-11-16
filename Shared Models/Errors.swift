//
//  Errors.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/16/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

enum TextImportError: ErrorType {
    case FileNotFound
    case BadParse
    case UnknownError
    case NoInstrumentsFound
    case EncodingError
}

enum InstrumentError: ErrorType {
    case DeviceTypeNotFound
    case PropertyStringUnrecognized
    case AmbiguousLocation
    case UnrecognizedCoordinate
}

enum LengthFormatterError: ErrorType {
    case UnexpectedCharacter
    case StringToNumber
    case FractionalFormattingError
}