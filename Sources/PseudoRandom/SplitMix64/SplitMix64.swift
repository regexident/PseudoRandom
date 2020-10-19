// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Original license:
//
// > Written in 2018 by David Blackman and Sebastiano Vigna (vigna@acm.org)
// >
// > To the extent possible under law, the author has dedicated all copyright
// > and related and neighboring rights to this software to the public domain
// > worldwide. This software is distributed without any warranty.
// >
// > See <http://creativecommons.org/publicdomain/zero/1.0/>. */

/// Implementation of [SplitMix64](http://xorshift.di.unimi.it/splitmix64.c)
public struct SplitMix64 {
    public typealias State = UInt64

    public internal(set) var s: State

    public init(state: State) {
        self.s = state
    }
}

extension SplitMix64: Stateful {}

extension SplitMix64: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        self.next { s in
            s &+= 0x9e3779b97f4a7c15
            var z = s
            z = (z ^ (z &>> 30)) &* 0xbf58476d1ce4e5b9
            z = (z ^ (z &>> 27)) &* 0x94d049bb133111eb
            return z ^ (z &>> 31)
        }
    }
}
