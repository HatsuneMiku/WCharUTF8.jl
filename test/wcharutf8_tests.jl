# -*- coding: utf-8 -*-
# wcharutf8_tests.jl

import WCharUTF8
using Base.Test

println("test WCharUTF8")
w = Array{UInt16, 1}([0x0077, 0x0077, 0x006c, 0x8868, 0x793a, 0x7533, 0])
e = Array{UInt8, 1}([
  0x77,0x77,0x6c,0xe8,0xa1,0xa8,0xe7,0xa4,0xba,0xe7,0x94,0xb3,0x00])
u = WCharUTF8.WCStoUTF8(w)
println(u)
println(@sprintf "[%s]" bytestring(u)) # "[wwl表示申.]"
@test u == e
@test WCharUTF8.WCStoUTF8(w; eos=true) == [e; [0x00]]

v = WCharUTF8.UTF8toWCS("t漢表申能")
println(v)
@test v == Array{UInt16, 1}([0x0074, 0x6f22, 0x8868, 0x7533, 0x80fd])
vt = WCharUTF8.UTF8toWCS("t漢表申能"; eos=true)
@test vt == Array{UInt16, 1}([0x0074, 0x6f22, 0x8868, 0x7533, 0x80fd, 0x0000])

println("test MBCS")
a = hex2bytes("748ABF955C905C945C") # "t漢表申能" in cp932
println(a)
# @test v == WCharUTF8.MBCStoWCS(bytestring(a))
@test v == WCharUTF8.MBCStoWCS(bytestring(a), 932)
@test [v; [0x0000]] == WCharUTF8.MBCStoWCS(bytestring(a), 932, true)

@test a == WCharUTF8.WCStoMBCS(v, 932)
# @test a == WCharUTF8.WCStoMBCS(WCharUTF8.MBCStoWCS(bytestring(a)))
@test a == WCharUTF8.WCStoMBCS(WCharUTF8.MBCStoWCS(bytestring(a), 932), 932)

b = [a; [0x00]]
# @test b == WCharUTF8.WCStoMBCS(v, 0, true)
@test b == WCharUTF8.WCStoMBCS(v, 932, true)
println(b)

c = [a; [0x00, 0x00]]
# @test c == WCharUTF8.WCStoMBCS(vt, 0, true)
@test c == WCharUTF8.WCStoMBCS(vt, 932, true)
println(c)
