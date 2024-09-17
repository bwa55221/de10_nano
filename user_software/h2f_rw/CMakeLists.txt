cmake_policy(SET CMP0048 NEW)
project(de10_nano_hdmi VERSION 1.0.0)
cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#############################################################################
######### adding stuff for cross compile -- brandon -- ######################
#############################################################################
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html

# the name of the target operating system
set(CMAKE_SYSTEM_NAME Generic)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER /home/brandon/work/de10_nano/linux/build/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER /home/brandon/work/de10_nano/linux/build/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-g++)

#############################################################################
######### adding stuff for cross compile -- brandon -- ######################
#############################################################################

string(TIMESTAMP BUILD_DATE)
add_definitions(-DBUILD_DATE="${BUILD_DATE}")

add_definitions(-DVERSION="${CMAKE_PROJECT_VERSION}")

add_executable(${PROJECT_NAME}
    configure_adv7513.c
    main.cpp
)

include_directories(inc)

include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
