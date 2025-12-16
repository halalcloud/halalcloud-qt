## 
## PROJECT:    Mouri Internal Library Essentials
## FILE:       Mile.Windows.UniCrt.cmake
## PURPOSE:    CMake script file for Mile.Windows.UniCrt
## 
## LICENSE:    The MIT License
## 
## MAINTAINER: MouriNaruto (Kenji.Mouri@outlook.com)
## 

if(NOT MILE_WINDOWS_UNICRT_INCLUDED)
    set(MILE_WINDOWS_UNICRT_INCLUDED TRUE CACHE INTERNAL "")
    message(STATUS "Trying to configure Mile.Windows.UniCrt...")

    if(MSVC)
        unset(CMAKE_MSVC_RUNTIME_LIBRARY)
        unset(CMAKE_MSVC_RUNTIME_LIBRARY CACHE)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)

        if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
            set(MILE_UNICRT_LIBRARY_PLATFORM "x86")
        elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
            set(MILE_UNICRT_LIBRARY_PLATFORM "x64")
        elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
            set(MILE_UNICRT_LIBRARY_PLATFORM "arm64")
        else()
            include(CheckSymbolExists)
            check_symbol_exists("_M_IX86" "" MILE_UNICRT_MSVC_TARGET_X86)
            check_symbol_exists("_M_AMD64" "" MILE_UNICRT_MSVC_TARGET_X64)
            check_symbol_exists("_M_ARM64" "" MILE_UNICRT_MSVC_TARGET_ARM64)
            if(MILE_UNICRT_MSVC_TARGET_X86)
                set(MILE_UNICRT_LIBRARY_PLATFORM "x86")
            elseif(MILE_UNICRT_MSVC_TARGET_X64)
                set(MILE_UNICRT_LIBRARY_PLATFORM "x64")
            elseif(MILE_UNICRT_MSVC_TARGET_ARM64)
                set(MILE_UNICRT_LIBRARY_PLATFORM "arm64")
            else()
                message(FATAL_ERROR "Unsupported MSVC target architecture for Mile.Windows.UniCrt")
            endif()
        endif()

        get_filename_component(
            MILE_UNICRT_LIBRARY
            "${CMAKE_CURRENT_LIST_DIR}/${MILE_UNICRT_LIBRARY_PLATFORM}"
            ABSOLUTE)

        if(NOT IS_DIRECTORY "${MILE_UNICRT_LIBRARY}")
            message(FATAL_ERROR
                "Mile.Windows.UniCrt library not found at ${MILE_UNICRT_LIBRARY}")
        endif()

        link_directories("${MILE_UNICRT_LIBRARY}")
        add_link_options(
            "/DEFAULTLIB:ucrt$<$<CONFIG:Debug>:d>.lib"
            "/NODEFAULTLIB:libucrt$<$<CONFIG:Debug>:d>.lib"
        )

        message(STATUS "Mile.Windows.UniCrt configured successfully.")
    endif()

endif()
