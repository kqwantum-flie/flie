require 'ffi'

module CRS
  extend FFI::Library
  ffi_lib Rails.root.join("ffi/libcrs.so")
  attach_function :hello, [], :string
end
