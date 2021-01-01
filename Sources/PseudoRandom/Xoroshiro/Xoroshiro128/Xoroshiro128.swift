// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Xoroshiro128: Equatable {
    public typealias State = (
        UInt64, UInt64
    )

    internal static var invalidState: State {
        (0, 0)
    }

    internal static func isValid(state: State) -> Bool {
        state != Self.invalidState
    }
}
