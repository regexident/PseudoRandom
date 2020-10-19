// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Xoshiro512: Equatable {
    public typealias State = (
        UInt64, UInt64, UInt64, UInt64,
        UInt64, UInt64, UInt64, UInt64
    )

    internal static var invalidState: State {
        (
            0, 0, 0, 0,
            0, 0, 0, 0
        )
    }

    internal static func isValid(state s: State) -> Bool {
        let sum0 = s.0 + s.1 + s.2 + s.3
        let sum1 = s.4 + s.5 + s.6 + s.7
        let sum = sum0 + sum1
        return sum > 0
    }
}
