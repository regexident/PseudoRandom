# PseudoRandom

A collection of PRNG implementations in Swift

## Algorithms

The **PseudoRandom** provides the following PRNG algorithms:

- [Xoshiro / Xoroshiro](http://prng.di.unimi.it/)
  - `Xoroshiro128`: `+` / `++` / `**`
  - `Xoshiro256`: `+` / `++` / `**`
  - `Xoshiro512`: `+` / `++` / `**`
  - `Xoroshiro1024`: `*` / `++` / `**`

- [SplitMix64](http://prng.di.unimi.it/)
  - `SplitMix64`

### 64-bit Generators

`xoshiro256++`/`xoshiro256**` (XOR/shift/rotate) are all-purpose generators (not cryptographically secure generators, though, like all PRNGs in this package). They have excellent (sub-ns) speed, a state space (256 bits) that is large enough for any parallel application, and they pass all tests the original authors are aware of. See the [paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf) for a discussion of their differences.

If, however, one has to generate only 64-bit floating-point numbers (by extracting the upper 53 bits) `xoshiro256+` is a slightly (≈15%) faster generator with analogous statistical properties. For general usage, one has to consider that its lowest bits have low linear complexity and will fail linearity tests; however, low linear complexity of the lowest bits can have hardly any impact in practice, and certainly has no impact at all if you generate floating-point numbers using the upper bits (the original authors computed a precise estimate of the linear complexity of the lowest bits).

If you are tight on space, `xoroshiro128++`/`xoroshiro128**` (XOR/rotate/shift/rotate) and `xoroshiro128+` have the same speed and use half of the space; the same comments apply. They are suitable only for low-scale parallel applications; moreover, `xoroshiro128+` exhibits a mild dependency in Hamming weights that generates a failure after 5 TB of output in the original author's test. Theu believe this slight bias cannot affect any application.

Finally, if for any reason (which reason?) you need more state, we provide in the same vein `xoshiro512++` / `xoshiro512**` / `xoshiro512+` and `xoroshiro1024++` / `xoroshiro1024**` / `xoroshiro1024*` (see the [paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf)).

The original authors suggest to use `SplitMix64` to initialize the state of the generators starting from a 64-bit seed, as research has shown that initialization must be performed with a generator radically different in nature from the one initialized to avoid correlation on similar seeds.

### 32-bit Generators

`xoshiro128++`/`xoshiro128**` are 32-bit all-purpose generators, whereas `xoshiro128+` is for floating-point generation. They are the 32-bit counterpart of `xoshiro256++`, `xoshiro256**` and `xoshiro256+`, so similar comments apply. Their state is too small for large-scale parallelism: their intended usage is inside embedded hardware or GPUs. For an even smaller scale, you can use `xoroshiro64**` and `xoroshiro64*`. The original authors do not believe at this point in time that 32-bit generator with a larger state can be of any use (but there are 32-bit `xoroshiro` generators of much larger size).

All 32-bit generators pass all tests the original authors are aware of, with the exception of linearity tests (binary rank and linear complexity) for `xoshiro128+` and `xoroshiro64*`: in this case, due to the smaller number of output bits the low linear complexity of the lowest bits is sufficient to trigger BigCrush tests when the output is bit-reversed. Analogously to the 64-bit case, generating 32-bit floating-point number using the upper bits will not use any of the bits with low linear complexity. 
