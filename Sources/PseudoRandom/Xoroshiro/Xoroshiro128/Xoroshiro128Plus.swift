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

/// Implementation of [Xoshiro256+](http://prng.di.unimi.it/xoshiro256plus.c)
/// ([Paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf))
///
/// # Original documentation:
///
/// > This is `xoroshiro128+` 1.0, our best and fastest small-state generator
/// > for floating-point numbers. We suggest to use its upper bits for
/// > floating-point generation, as it is slightly faster than
/// > `xoroshiro128++`/`xoroshiro128**`. It passes all tests we are aware of
/// > except for the four lower bits, which might fail linearity tests (and
/// > just those), so if low linear complexity is not considered an issue (as
/// > it is usually the case) it can be used to generate 64-bit outputs, too;
/// > moreover, this generator has a very mild Hamming-weight dependency
/// > making our test (http://prng.di.unimi.it/hwd.php) fail after 5 TB of
/// > output; we believe this slight bias cannot affect any application. If
/// > you are concerned, use `xoroshiro128++`, `xoroshiro128**` or `xoshiro256+`.
/// >
/// > We suggest to use a sign test to extract a random Boolean value, and
/// > right shifts to extract subsets of bits.
/// >
/// > The state must be seeded so that it is not everywhere zero. If you have
/// > a 64-bit seed, we suggest to seed a `splitmix64` generator and use its
/// > output to fill `state`.
/// >
/// > NOTE: the parameters `(a=24, b=16, b=37)` of this version give slightly
/// > better results in our test than the 2016 version `(a=55, b=14, c=36)`.
public struct Xoroshiro128Plus {
    public typealias State = Xoroshiro128.State

    public internal(set) var s: State

    /// Creates a randomly seeded generator.
    public init() {
        var generator = SystemRandomNumberGenerator()
        let seed = generator.next()
        self.init(seed: seed)
    }

    /// Creates a seeded generator.
    /// - Parameter seed: The initial seed
    public init(seed: UInt64) {
        var generator = SplitMix64(state: seed)

        var state: State = Xoroshiro128.invalidState
        repeat {
            state = (
                generator.next(),
                generator.next()
            )
        } while !Xoroshiro128.isValid(state: state)

        self.init(state: state)
    }

    /// Creates a seeded generator.
    ///
    /// - Important:
    ///   The value of `state` must not be `(0, 0)`.
    ///
    /// - Parameter state: The initial seed
    public init(state: State) {
        precondition(
            Xoroshiro128.isValid(state: state),
            "The state must not be all zeros"
        )
        self.s = state
    }
}

extension Xoroshiro128Plus: Stateful {}

extension Xoroshiro128Plus: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        self.next { s in
            let s0 = s.0
            var s1 = s.1

            let result = s0 &+ s1

            s1 ^= s0;
            s.0 = rotl(s0, 24) ^ s1 ^ (s1 << 16) // a, b
            s.1 = rotl(s1, 37) // c

            return result
        }
    }
}
