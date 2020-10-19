// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Xoshiro256: Equatable {
    public typealias State = (
        UInt64, UInt64, UInt64, UInt64
    )

    internal static var invalidState: State {
        (0, 0, 0, 0)
    }

    internal static func isValid(state s: State) -> Bool {
        let sum = s.0 + s.1 + s.2 + s.3
        return sum > 0
    }
}
