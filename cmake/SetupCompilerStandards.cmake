# Copyright (c) 2017-2022, Lawrence Livermore National Security, LLC and
# other BLT Project Developers. See the top-level LICENSE file for details
# 
# SPDX-License-Identifier: (BSD-3-Clause)

if(NOT DEFINED CMAKE_CXX_EXTENSIONS)
    message(STATUS "Setting CMAKE_CXX_EXTENSIONS to Off")
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(BLT_CXX_STD "" CACHE STRING "Version of C++ standard")
set_property(CACHE BLT_CXX_STD PROPERTY STRINGS c++98 c++11 c++14 c++17 c++20)

if (BLT_CXX_STD)
    if( BLT_CXX_STD STREQUAL c++98 ) 
        set(CMAKE_CXX_STANDARD 98)
    elseif( BLT_CXX_STD STREQUAL c++11 )
        set(CMAKE_CXX_STANDARD 11)
        blt_append_custom_compiler_flag(
            FLAGS_VAR CMAKE_CXX_FLAGS
            DEFAULT " "
            XL "-std=c++11"
            PGI "--c++11")
    elseif( BLT_CXX_STD STREQUAL c++14)
        set(CMAKE_CXX_STANDARD 14)
        blt_append_custom_compiler_flag(
            FLAGS_VAR CMAKE_CXX_FLAGS
            DEFAULT " "
            XL "-std=c++14"
            PGI "--c++14")
    elseif( BLT_CXX_STD STREQUAL c++17)
        # Error out on what does not support C++17
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "XL")
            message(FATAL_ERROR "XL does not support C++17.")
        endif()
        if (ENABLE_CUDA AND (NOT DEFINED CMAKE_CUDA_COMPILE_FEATURES OR (NOT "cuda_std_17" IN_LIST CMAKE_CUDA_COMPILE_FEATURES)))
            message(FATAL_ERROR "CMake's CUDA_STANDARD does not support C++17.")
        endif()

        set(CMAKE_CXX_STANDARD 17)
        blt_append_custom_compiler_flag(
            FLAGS_VAR CMAKE_CXX_FLAGS
            DEFAULT " "
            PGI "--c++17")
    elseif( BLT_CXX_STD STREQUAL c++20)
        # Error out on what does not support C++20
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "XL")
            message(FATAL_ERROR "XL does not support C++20.")
        endif()
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "PGI")
            message(FATAL_ERROR "PGI is not yet supported using C++20.")
        endif()
        if (ENABLE_CUDA AND (NOT DEFINED CMAKE_CUDA_COMPILE_FEATURES OR (NOT "cuda_std_20" IN_LIST CMAKE_CUDA_COMPILE_FEATURES)))
            message(FATAL_ERROR "CMake's CUDA_STANDARD does not support C++20.")
        endif()

        set(CMAKE_CXX_STANDARD 20)
    else()
        message(FATAL_ERROR "${BLT_CXX_STD} is an invalid entry for BLT_CXX_STD. "
                            "Valid Options are ( c++98, c++11, c++14, c++17, c++20 )")
    endif()

    message(STATUS "Standard C++${CMAKE_CXX_STANDARD} selected")

    if (ENABLE_CUDA)
       if (NOT DEFINED CMAKE_CUDA_STANDARD)
          set(CMAKE_CUDA_STANDARD ${CMAKE_CXX_STANDARD})
       endif()

       message(STATUS "Standard C++${CMAKE_CUDA_STANDARD} selected for CUDA")
    endif()
endif()