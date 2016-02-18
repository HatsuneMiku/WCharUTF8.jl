# -*- coding: utf-8 -*-
# wcharutf8_tests.jl

import WCharUTF8
using Base.Test

println("test WCharUTF8")
w = Array{UInt16, 1}([0x0077, 0x0077, 0x006c, 0x8868, 0x793a, 0x7533, 0])
e = Array{UInt8, 1}([
  0x77,0x77,0x6c,0xe8,0xa1,0xa8,0xe7,0xa4,0xba,0xe7,0x94,0xb3,0x00,0x00])
u = WCharUTF8.WCStoUTF8(w)
println(u)
println(@sprintf "[%s]" bytestring(u)) # "[wwl表示申..]"
@test u == e
v = WCharUTF8.UTF8toWCS("t漢表申能")
println(v)
@test v == Array{UInt16, 1}([0x0074, 0x6f22, 0x8868, 0x7533, 0x80fd, 0x0000])

println("test MBCS")
a = hex2bytes("748ABF955C905C945C") # "t漢表申能" in cp932
println(a)
# @test v == WCharUTF8.MBCStoWCS(bytestring(a), 0)
@test v == WCharUTF8.MBCStoWCS(bytestring(a), 932)
b = [a; [0x00, 0x00]]
@test b == WCharUTF8.WCStoMBCS(v, 932)
# @test b == WCharUTF8.WCStoMBCS(WCharUTF8.MBCStoWCS(bytestring(a), 0), 0)
@test b == WCharUTF8.WCStoMBCS(WCharUTF8.MBCStoWCS(bytestring(a), 932), 932)
println(b)
