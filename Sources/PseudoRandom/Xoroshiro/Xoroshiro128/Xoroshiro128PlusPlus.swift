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

/// Implementation of [Xoroshiro128++](http://prng.di.unimi.it/xoshiro256plus.c)
/// ([Paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf))
///
/// # Original documentation:
///
/// > This is `xoroshiro128++` 1.0, one of our all-purpose, rock-solid,
/// > small-state generators. It is extremely (sub-ns) fast and it passes all
/// > tests we are aware of, but its state space is large enough only for
/// > mild parallelism.
/// >
/// > For generating just floating-point numbers, `xoroshiro128+` is even
/// > faster (but it has a very mild bias, see notes in the comments).
/// >
/// > The `state` must be seeded so that it is not everywhere zero. If you have
/// > a 64-bit seed, we suggest to seed a `splitmix64` generator and use its
/// > output to fill `state`.
public struct Xoroshiro128PlusPlus {
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

extension Xoroshiro128PlusPlus: Stateful {}

extension Xoroshiro128PlusPlus: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        self.next { s in
            let s0 = s.0
            var s1 = s.1
            let result = rotl(s0 &+ s1, 17) &+ s0

            s1 ^= s0
            s.0 = rotl(s0, 49) ^ s1 ^ (s1 << 21) // a, b
            s.1 = rotl(s1, 28) // c

            return result
        }
    }
}
