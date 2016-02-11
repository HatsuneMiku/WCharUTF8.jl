WCharUTF8
=========

[WCharUTF8](https://github.com/HatsuneMiku/WCharUTF8.jl)

WCharUTF8 converts AbstractString UTF8 to wchar_t or wchar_t to UTF8.


# UTF8toWCS

```julia
UTF8toWCS(UTF8::AbstractString) # Array{UInt16, 1}
```


# WCStoUTF8

```julia
WCStoUTF8(WCS::Array{UInt16, 1}) # Array{UInt8, 1} (UTF8String)
```


# Acknowledgements

now supports 32bit


# see also

[W32API](https://github.com/HatsuneMiku/W32API.jl)

# status

[![Build Status](https://travis-ci.org/HatsuneMiku/WCharUTF8.jl.svg?branch=master)](https://travis-ci.org/HatsuneMiku/WCharUTF8.jl)
