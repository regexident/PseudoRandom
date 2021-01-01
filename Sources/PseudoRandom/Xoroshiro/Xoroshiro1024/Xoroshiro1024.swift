// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Xoroshiro1024: Equatable {
    public typealias Param = Int
    public typealias State = [UInt64]

    internal static var invalidState: State {
        Array(repeating: 0, count: 16)
    }

    internal static var paramRange: Range<Param> {
        0..<16
    }

    internal static func isValid(param: Param) -> Bool {
        (0..<16).contains(param)
    }

    internal static func isValid(state: State) -> Bool {
        state != Self.invalidState
    }
}
