# WCharUTF8.jl

VERSION >= v"0.4.0-dev+6521" && __precompile__()
module WCharUTF8

import Base
export UTF8toWCS, WCStoUTF8, MultiByteToWideChar, WideCharToMultiByte

const _CP_UTF8 = 65001

function MultiByteToWideChar(
  CodePage, dwFlags,
  lpMultiByteStr, cchMultiByte,
  lpWideCharStr, cchWideChar)
  kernel32 = Base.Libdl.dlopen_e("kernel32.dll")
  _MultiByteToWideChar = Base.Libdl.dlsym(kernel32, :MultiByteToWideChar)
  err = ccall(_MultiByteToWideChar, stdcall,
    UInt32, (
      UInt32,           # UINT      CodePage
      UInt32,           # DWORD     dwFlags
      Ptr{Cchar},       # LPCSTR    lpMultiByteStr
      Int32,            # int       cchMultiByte
      Ptr{Cwchar_t},    # LPWSTR    lpWideCharStr
      Int32,            # int       cchWideChar
    ),
    CodePage, dwFlags,
    lpMultiByteStr, cchMultiByte,
    lpWideCharStr, cchWideChar
  )
  Base.Libdl.dlclose(kernel32)
  return err
end

function WideCharToMultiByte(
  CodePage, dwFlags,
  lpWideCharStr, cchWideChar,
  lpMultiByteStr, cchMultiByte,
  lpDefaultChar, lpUsedDefaultChar)
  kernel32 = Base.Libdl.dlopen_e("kernel32.dll")
  _WideCharToMultiByte = Base.Libdl.dlsym(kernel32, :WideCharToMultiByte)
  err = ccall(_WideCharToMultiByte, stdcall,
    UInt32, (
      UInt32,           # UINT      CodePage
      UInt32,           # DWORD     dwFlags
      Ptr{Cwchar_t},    # LPCWSTR   lpWideCharStr
      Int32,            # int       cchWideChar
      Ptr{Cchar},       # LPSTR     lpMultiByteStr
      Int32,            # int       cchMultiByte
      Ptr{Cchar},       # LPCSTR    lpDefaultChar
      Ptr{UInt32},      # LPBOOL    lpUsedDefaultChar
    ),
    CodePage, dwFlags,
    lpWideCharStr, cchWideChar,
    lpMultiByteStr, cchMultiByte,
    lpDefaultChar, lpUsedDefaultChar
  )
  Base.Libdl.dlclose(kernel32)
  return err
end

function UTF8toWCS(UTF8::AbstractString) # expect UTF8String
  u8len = length(UTF8.data)
  wclen = MultiByteToWideChar(_CP_UTF8, 0, UTF8, u8len, C_NULL, 0)
  wcs = Array(UInt16, wclen + 1)
  wclen = MultiByteToWideChar(_CP_UTF8, 0, UTF8, u8len, wcs, wclen + 1) # + 1
  wcs[wclen + 1] = 0
  return wcs
end

function WCStoUTF8(WCS::Array{UInt16, 1})
  mblen = WideCharToMultiByte(_CP_UTF8, 0, WCS, -1, C_NULL, 0, C_NULL, C_NULL)
  mbs = Array(Int8, mblen + 1)
  mblen = WideCharToMultiByte(_CP_UTF8, 0, WCS, -1, mbs, mblen, C_NULL, C_NULL)
  mbs[mblen + 1] = 0
  return map(x -> UInt8(x & 0x0ff), mbs)
end

end
