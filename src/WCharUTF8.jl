# WCharUTF8.jl

VERSION >= v"0.4.0-dev+6521" && __precompile__()
module WCharUTF8

import Base
export MBCStoWCS, WCStoMBCS
export UTF8toWCS, WCStoUTF8
export MultiByteToWideChar, WideCharToMultiByte

const _CP_UTF8 = 65001
const _CP_ACP = 0

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

function UTF8toWCS(UTF8::AbstractString; eos::Bool=false, cp=_CP_UTF8) # expect UTF8String
  u8len = sizeof(UTF8.data)
  wclen = MultiByteToWideChar(cp, 0, UTF8, u8len, C_NULL, 0)
  wcs = Array(UInt16, wclen + 1)
  wclen = MultiByteToWideChar(cp, 0, UTF8, u8len, wcs, wclen + 1) # + 1
  if eos
    wcs[wclen + 1] = 0
    return wcs
  else
    return wcs[1:wclen]
  end
end

function WCStoUTF8(WCS::Array{UInt16, 1}; eos::Bool=false, cp=_CP_UTF8)
  wclen = length(WCS)
  mblen = WideCharToMultiByte(cp, 0, WCS, wclen, C_NULL, 0, C_NULL, C_NULL)
  mbs = Array(Int8, mblen + 1)
  mblen = WideCharToMultiByte(cp, 0, WCS, wclen, mbs, mblen, C_NULL, C_NULL)
  if eos
    mbs[mblen + 1] = 0
    # return map(x -> UInt8(x & 0x0ff), mbs)
    return [UInt8(c & 0x0ff) for c in mbs]
  else
    return [UInt8(c & 0x0ff) for c in mbs[1:mblen]]
  end
end

MBCStoWCS(mbcs::AbstractString, cp=_CP_ACP, eos::Bool=false) = UTF8toWCS(mbcs; eos=eos, cp=cp)
WCStoMBCS(wcs::Array{UInt16, 1}, cp=_CP_ACP, eos::Bool=false) = WCStoUTF8(wcs; eos=eos, cp=cp)

end
