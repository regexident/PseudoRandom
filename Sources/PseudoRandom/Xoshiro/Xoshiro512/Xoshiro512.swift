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

    internal static func isValid(state: State) -> Bool {
        let invalidState = self.invalidState

        guard state.0 == invalidState.0 else {
            return true
        }
        guard state.1 == invalidState.1 else {
            return true
        }
        guard state.2 == invalidState.2 else {
            return true
        }
        guard state.3 == invalidState.3 else {
            return true
        }
        guard state.4 == invalidState.4 else {
            return true
        }
        guard state.5 == invalidState.5 else {
            return true
        }
        guard state.6 == invalidState.6 else {
            return true
        }
        guard state.7 == invalidState.7 else {
            return true
        }
        
        return false
    }
}
