# wcharutf8_tests.jl

import WCharUTF8
using Formatting

println(format("[{:s}]", "test WCharUTF8"))
w = Array{UInt16, 1}([0x0077, 0x0077, 0x006c, 0x8868, 0x793a, 0x7533, 0])
println(format("[{:s}]", WCharUTF8.WCStoUTF8(w))) # "[wwl表示申]"
println(format("[{:s}]", WCharUTF8.UTF8toWCS("t漢表申能")))
# [UInt16[0x0074,0x6f22,0x8868,0x7533,0x80fd,0x0000]]
