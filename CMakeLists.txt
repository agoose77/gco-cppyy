cmake_minimum_required(VERSION 3.12)

project(gco_cppyy_cmake_build
        LANGUAGES CXX 
        VERSION 0.1 
        HOMEPAGE_URL "https://github.com/agoose77/gco-cppyy"
        DESCRIPTION "cppyy-generated bindings for gco")

if(DEFINED ENV{CONDA_PREFIX})
    message(STATUS "Building in a conda environment.")
    set(CONDA_ACTIVE TRUE)
    set(CMAKE_INSTALL_PREFIX "$ENV{CONDA_PREFIX}")
    set(CMAKE_PREFIX_PATH "$ENV{CONDA_PREFIX}")
    set(CMAKE_INCLUDE_PATH "$ENV{CONDA_PREFIX}/include")
    #include_directories($ENV{CONDA_PREFIX}/include)
    set(CMAKE_LIBRARY_PATH "$ENV{CONDA_PREFIX}/lib")
endif()

set(CMAKE_INCLUDE_DIRECTORIES_BEFORE ON)

#
# Add our project's cmake dir the the module path. This gives us the
# Cppyy commands and targets.
#
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)
find_package(Cppyy)

#
# Make the default build us c++11 and "RELEASE" (-O3)
#
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
if(NOT CMAKE_BUILD_TYPE) 
    set(CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_BUILD_TYPE)

# headers and sources are listed in a cmake file.
include(GNUInstallDirs)

#
# Set up the knn shared lib
#
add_subdirectory(gco)

#
# Set up the Cppyy bindings generation. This is a customized version defined
# in boink's cmake/ dir; it uses genreflex rather than calling rootcling directly.
# I did this because I couldn't get rootcling to properly include/exclude classes
# via the LinkDef header, and I wanted to be able to use the better syntax in
# the genreflex selection XML anyhow. Also, I think this is now the recommended /
# more modern way anyhow? Code was modified from the versions cppyy distributes.
#

# headers are listed in a cmake file.
include(${CMAKE_SOURCE_DIR}/manifest.cmake)

cppyy_add_bindings(
   "gco_cppyy" "${PROJECT_VERSION}" "Angus Hollands" "goosey15@gmail.com"
   LICENSE "MIT"
   LANGUAGE_STANDARD "11"
   SELECTION_XML  ${CMAKE_SOURCE_DIR}/selection.xml
   INTERFACE_FILE ${CMAKE_SOURCE_DIR}/interface.hh
   HEADERS        ${LIB_HEADERS} 
   INCLUDE_DIRS   ${CMAKE_SOURCE_DIR}/gco/include
   LINK_LIBRARIES gco
   NAMESPACES     GCO
)

install(CODE "execute_process(COMMAND pip install ${PY_WHEEL_FILE})")
