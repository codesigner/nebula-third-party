# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.

set(name wangle)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/facebook/wangle/archive/refs/tags/v2021.11.29.00.tar.gz
    URL_HASH MD5=b17946086b602a5d565c5a084eb2c337
    DOWNLOAD_NAME wangle-2021-11-29.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make -s -j${BUILDING_JOBS_NUM} -C wangle
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND make -s -j${BUILDING_JOBS_NUM} install -C wangle
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

ExternalProject_Add_Step(${name} mannual-configure
    DEPENDEES download update patch
    DEPENDERS build
    COMMAND ${CMAKE_COMMAND}
        ${common_cmake_args}
        -DBoost_NO_SYSTEM_PATHS=OFF
        -DBoost_NO_BOOST_CMAKE=ON
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_TESTS=OFF
        -DCMAKE_EXE_LINKER_FLAGS=-latomic
        -DCMAKE_SHARED_LINKER_FLAGS=-latomic
        -D_OPENSSL_LIBDIR=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}
        .
    WORKING_DIRECTORY <SOURCE_DIR>/wangle
)

ExternalProject_Add_Step(${name} clean
    EXCLUDE_FROM_MAIN TRUE
    ALWAYS TRUE
    DEPENDEES configure
    COMMAND make clean -j
    COMMAND rm -f ${BUILD_INFO_DIR}/${name}-build
    WORKING_DIRECTORY <SOURCE_DIR>/wangle
)

ExternalProject_Add_StepTargets(${name} clean)
