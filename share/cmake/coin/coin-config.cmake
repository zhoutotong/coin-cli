# - Config file for the Project package
# It defines the following variables
#  coin_INCLUDE_DIRS - include directories for Project
#  coin_LIBRARIES    - libraries to link against
#  coin_EXECUTABLE   - the bar executable

# import coin cmake utils
include("$ENV{COIN_ROOT}/share/cmake/coin/coin.cmake")
include("$ENV{COIN_ROOT}/share/cmake/coin/coin-config-version.cmake")

if (CMAKE_VERSION VERSION_LESS 3.12.0)
    coin_fatal("coin requires at least CMake VERSION 3.12.0")
endif()

# read gcc version info
execute_process(
    COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
    OUTPUT_VARIABLE GCC_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

coin_info("GCC version: ${GCC_VERSION}")
# check g++ version
if (NOT GCC_VERSION VERSION_GREATER_EQUAL 9.0)
    coin_warn("Using GCC 9.0 or newer")
endif ()

set(coin_FOUND True)

if("${coin_FIND_VERSION}" VERSION_GREATER_EQUAL ${PACKAGE_VERSION})
    if (NOT coin_FIND_COMPONENTS)
        set(coin_NOT_FOUND_MESSAGE "The coin package requires at least one component")
    endif(NOT coin_FIND_COMPONENTS)
else()
    coin_warn("current version of coin is: ${PACKAGE_VERSION}, but ${coin_FIND_VERSION} is required")
endif()

set(_coin_FIND_PARTS_REQUIRED)
if (coin_FIND_REQUIRED)
    set(_coin_FIND_PARTS_REQUIRED REQUIRED)
endif()
set(_coin_FIND_PARTS_QUIET)
if (coin_FIND_QUIETLY)
    set(_coin_FIND_PARTS_QUIET QUIET)
endif()

if(NOT ${coin_NOT_FOUND_MESSAGE} STREQUAL "")
    coin_fatal("${coin_NOT_FOUND_MESSAGE}")
endif()

# clear cmake variables
unset(coin_INCLUDE_DIRS)
unset(coin_LIBRARIES)
unset(coin_EXECUTABLE)

unset(COIN_INCLUDE_DIRS)
unset(COIN_LIBRARIES)
unset(COIN_EXECUTABLE)


set(_coin_NOTFOUND_MESSAGE)

list(APPEND ${PROJECT_NAME}_DEPENDENT_LIST ${coin_FIND_COMPONENTS})

option(COIN_SKIP_DEPENDENT_CHECK OFF)

if(NOT COIN_SKIP_DEPENDENT_CHECK)
    # 向服务器拉取依赖清单
    execute_process(
        COMMAND coin assist resolve package ${coin_FIND_COMPONENTS}
    )
endif(NOT COIN_SKIP_DEPENDENT_CHECK)

foreach(module ${coin_FIND_COMPONENTS})
    coin_info("load component: ${module}")

#     if(${module} MATCHES "^.+::[0-9a-zA-Z_-]+$")

#         # 无版本信息，使用当前版本
#         list(APPEND WORK_DIR_LIST "runner")

#         string(REGEX MATCH "^.+::" _category ${module})
#         string(REPLACE "::" "" _category ${_category} )
#         string(REGEX MATCH "::.+$" _module ${module})
#         string(REPLACE "::" "" _module ${_module} )
        
#         set(category "")
#         foreach(WORK_DIR ${WORK_DIR_LIST})
            
#             if(EXISTS $ENV{coin_ROOT}/${WORK_DIR}/${_category}/${_module})
#                 set(MOD_FIND_DIR $ENV{coin_ROOT}/${WORK_DIR}/${_category}/${_module}/cmake)
#                 set(category ${_category})
#                 set(module ${_module})
#                 list(APPEND ${PROJECT_NAME}_COIN_DEPENDENTS ${WORK_DIR}/${_category}/${_module})
#             endif()
                
#         endforeach()

#     elseif(${module} MATCHES "^.+::[0-9a-zA-Z_-]+@[vV0-9.latest]+$")

#         # 有版本信息，校验版本
#         string(REGEX MATCH "^.+::" _category ${module})
#         string(REPLACE "::" "" _category ${_category} )
#         string(REGEX MATCH "::.+@" _module ${module})
#         string(REPLACE "::" "" _module ${_module} )
#         string(REPLACE "@" "" _module ${_module} )
#         string(REGEX MATCH "@[vV0-9.latest]+$" _version ${module})
#         string(REPLACE "@" "" _version ${_version} )

#         list(APPEND WORK_DIR_LIST "runner")
#         set(category "")
#         foreach(WORK_DIR ${WORK_DIR_LIST})
            
#             if(EXISTS $ENV{coin_ROOT}/${WORK_DIR}/${_category}/${_module})
#                 set(MOD_FIND_DIR $ENV{coin_ROOT}/${WORK_DIR}/${_category}/${_module}/cmake)
#                 set(category ${_category})
#                 set(module ${_module})
#                 list(APPEND ${PROJECT_NAME}_COIN_DEPENDENTS ${WORK_DIR}/${_category}/${_module})
#             endif()
                
#         endforeach()
        
#     else()

#         set(MOD_FIND_DIR $ENV{coin_ROOT}/cmd/${module}/cmake/${module})
#         set(category "cmd")
#         list(APPEND ${PROJECT_NAME}_COIN_DEPENDENTS cmd/${module})

#     endif()

#     # clear duplicate
#     list(REMOVE_DUPLICATES ${PROJECT_NAME}_COIN_DEPENDENTS)

#     find_package(${module}
#         ${_coin_FIND_PARTS_QUIET}
#         ${_coin_FIND_PARTS_REQUIRED}
#         PATHS "$ENV{coin_ROOT}" ${MOD_FIND_DIR} NO_DEFAULT_PATH
#     )

#     # 设置相关宏定义
#     string(TOUPPER ${module} upper_mod)
#     add_definitions( -DMODULE_${upper_mod} )
#     unset(upper_mod)

#     unset(MOD_FIND_DIR)


#     if (NOT ${module}_FOUND)
#         set(_coin_NOTFOUND_MESSAGE "${_coin_NOTFOUND_MESSAGE}Failed to find coin component \"${module}\" config file\"\n")

#     else()
#         # For backward compatibility set the LIBRARIES variable
#         list(APPEND coin_LIBRARIES "${${module}_LIBRARIES}")
#         list(APPEND coin_INCLUDE_DIRS "${${module}_INCLUDE_DIRS}")
#         link_directories(${${module}_LINK_DIRS})
#     endif()
    
endforeach()

if(NOT ${_coin_NOTFOUND_MESSAGE} STREQUAL "")
    coin_warn("${_coin_NOTFOUND_MESSAGE}")
endif()

link_directories(
    "$ENV{coin_ROOT}/lib"
    "${COIN_CROSS_COMPILE_LINK_DIRS}"
)

list(APPEND coin_INCLUDE_DIRS "$ENV{coin_ROOT}/include")
list(APPEND coin_INCLUDE_DIRS "${COIN_CROSS_COMPILE_INCLUDE_DIRS}")
