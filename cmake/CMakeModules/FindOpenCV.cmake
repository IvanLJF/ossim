#---
# File:  FindOpenCV.cmake
# 
# Locate OPENCV
#
# The cmake variable space is referenced for $OPENCV_HOME first before the 
# standard install locations to perit sandbox installations of OpenCV.
#
# This module defines:
#
# OPENCV_INCLUDE_DIR
#
# OPENCV_FOUND, 
# OPENCV_CORE_FOUND 
# OPENCV_HIGHGUI_FOUND
# OPENCV_IMGPROC_FOUND
# OPENCV_LEGACY_FOUND
# OPENCV_ML_FOUND 
#
# OPENCV_CORE_LIBRARY
# OPENCV_HIGHGUI_LIBRARY
# OPENCV_IMGPROC_LIBRARY
# OPENCV_LEGACY_LIBRARY
# OPENCV_ML_LIBRARY
# OPENCV_LIBRARIES
#
# Created by Garrett Potts.
#
# $Id$

# Find include path:
find_path(OPENCV_INCLUDE_DIR opencv/cv.hpp  PATHS ${OPENCV_HOME}/include)

macro(FIND_OPENCV_LIBRARY MYLIBRARY MYLIBRARYNAME)
   find_library( ${MYLIBRARY}
        NAMES "${MYLIBRARYNAME}${OPENCV_RELEASE_POSTFIX}"
   	  PATHS ${OPENCV_HOME}/lib ${OPENCV_HOME}/share/OpenCV/3rdparty/lib )
endmacro(FIND_OPENCV_LIBRARY MYLIBRARY MYLIBRARYNAME)

# Required
FIND_OPENCV_LIBRARY(OPENCV_CORE_LIBRARY opencv_core)
FIND_OPENCV_LIBRARY(OPENCV_FEATURES2D_LIBRARY opencv_features2d)
FIND_OPENCV_LIBRARY(OPENCV_FLANN_LIBRARY opencv_flann)
FIND_OPENCV_LIBRARY(OPENCV_IMGPROC_LIBRARY opencv_imgproc)
FIND_OPENCV_LIBRARY(OPENCV_ML_LIBRARY opencv_ml)
FIND_OPENCV_LIBRARY(OPENCV_OBJDETECT_LIBRARY opencv_objdetect)
FIND_OPENCV_LIBRARY(OPENCV_XFEATURES2D_LIBRARY opencv_xfeatures2d)
FIND_OPENCV_LIBRARY(OPENCV_PHOTO_LIBRARY opencv_photo)
FIND_OPENCV_LIBRARY(OPENCV_VIDEO_LIBRARY opencv_video)

set(OPENCV_LIBRARIES ${OPENCV_OBJDETECT_LIBRARY}
        ${OPENCV_VIDEO_LIBRARY}
        ${OPENCV_PHOTO_LIBRARY}
        ${OPENCV_ML_LIBRARY}
        ${OPENCV_IMGPROC_LIBRARY}
        ${OPENCV_FLANN_LIBRARY}
        ${OPENCV_FEATURES2D_LIBRARY}
        ${OPENCV_XFEATURES2D_LIBRARY}
        ${OPENCV_CORE_LIBRARY}
        )

set(OPENCV_FOUND "NO")
if ( OPENCV_INCLUDE_DIR AND
        OPENCV_CORE_LIBRARY AND
        OPENCV_FEATURES2D_LIBRARY AND
        OPENCV_XFEATURES2D_LIBRARY AND
        OPENCV_FLANN_LIBRARY AND
        OPENCV_IMGPROC_LIBRARY AND
        OPENCV_ML_LIBRARY AND
        OPENCV_OBJDETECT_LIBRARY AND
        OPENCV_PHOTO_LIBRARY AND
        OPENCV_VIDEO_LIBRARY)
    set(OPENCV_FOUND "YES")
else()
    message( WARNING "Could not find all OpenCV libraries. Check the list for NOTFOUND:" )
    message( "${OPENCV_LIBRARIES}" )
endif()

if (OPENCV_FOUND)
    # Present in the case of static build. Note, a custom OpenCV build script performs a copy of these
    # libraries from $OPENCV_HOME/share/OpenCV/3rdparty/lib to $OPENCV_HOME/lib. EDIT: added share dir
    # to search path so copy not necessary.
    FIND_OPENCV_LIBRARY(OPENCV_IPPICV_LIBRARY ippicv)
    FIND_OPENCV_LIBRARY(OPENCV_ILMIMF_LIBRARY IlmImf)
    FIND_OPENCV_LIBRARY(OPENCV_LIBTIFF_LIBRARY libtiff)
    if (    OPENCV_IPPICV_LIBRARY  AND
            OPENCV_ILMIMF_LIBRARY  AND
            OPENCV_LIBTIFF_LIBRARY )
        set( OPENCV_LIBRARIES ${OPENCV_LIBRARIES}
                ${OPENCV_IPPICV_LIBRARY}
                ${OPENCV_ILMIMF_LIBRARY}
                ${OPENCV_LIBTIFF_LIBRARY} )
    endif()

    # Optional
    FIND_OPENCV_LIBRARY(OPENCV_IMGCODECS_LIBRARY opencv_imgcodecs)
    FIND_OPENCV_LIBRARY(OPENCV_CUDAARITHM_LIBRARY opencv_cudaarithm)
    FIND_OPENCV_LIBRARY(OPENCV_CUDAIMGPROC_LIBRARY opencv_cudaimgproc)
    FIND_OPENCV_LIBRARY(OPENCV_CUDEV_LIBRARY opencv_cudev)
    FIND_OPENCV_LIBRARY(OPENCV_HIGHGUI_LIBRARY opencv_highgui)

    set(OPENCV_GPU_FOUND "NO")
    if (  OPENCV_CUDAARITHM_LIBRARY AND OPENCV_CUDAIMGPROC_LIBRARY AND OPENCV_CUDEV_LIBRARY)
        set(OPENCV_GPU_FOUND "YES")
        set(OPENCV_LIBRARIES ${OPENCV_LIBRARIES}
                ${OPENCV_CUDAARITHM_LIBRARY}
                ${OPENCV_CUDAIMGPROC_LIBRARY}
                ${OPENCV_CUDEV_LIBRARY} )
    else()
        message( "Could not find optional OpenCV GPU (CUDA) Libraries. " )
    endif()

    set(OPENCV_IMGCODECS_FOUND "NO")
    if(OPENCV_IMGCODECS_LIBRARY)
        set(OPENCV_IMGCODECS_FOUND "YES")
        set(OPENCV_LIBRARIES ${OPENCV_LIBRARIES} ${OPENCV_IMGCODECS_LIBRARY})
    else()
        message( "Could not find optional OpenCV Image Codecs Library" )
    endif()

    set(OPENCV_HIGHGUI_FOUND 0)
    if(OPENCV_HIGHGUI_LIBRARY)
        set(OPENCV_HIGHGUI_FOUND 1)
        set(OPENCV_LIBRARIES ${OPENCV_LIBRARIES} ${OPENCV_HIGHGUI_LIBRARY})
    else()
        message( "Could not find optional OpenCV HighGui Library" )
    endif()

    # Unfortunately, OpenCV inter-library dependency is so complicated, we just list the libs twice:
    set(OPENCV_LIBRARIES ${OPENCV_LIBRARIES} ${OPENCV_LIBRARIES} )
endif()

if(OPENCV_FOUND)
   message( STATUS "OPENCV_INCLUDE_DIR = ${OPENCV_INCLUDE_DIR}" )
   message( STATUS "OPENCV_LIBRARIES   = ${OPENCV_LIBRARIES}" )
endif()

